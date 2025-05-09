


import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?>{

  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;

  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;
  
  SearchMovieDelegate({required this.searchMovies, required this.initialMovies})
                      :super(
                        searchFieldLabel: 'Buscar peliculas',
                      );

  void clearStraems(){
    debounceMovies.close();
  }

  void _onQueryChanged(String query) {
    isLoadingStream.add(true);

    if(_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 500), () async{

      // if(query.isEmpty){
      //   debounceMovies.add([]);
      //   return;
      // }

      final movies = await searchMovies(query);
      initialMovies = movies;
      debounceMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  Widget buildResultAndSuggestion() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _MovieItem(movie: movies[index], 
            onMovieSelected: (context, movie){
              clearStraems();
              close(context, movie);
            });
            // final movie = movies[index];
            // return ListTile(title: Text(movie.title),);
          },
        );
      }, );

  }

  @override
  String get searchFieldLabel => 'Buscar pélicula';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
        StreamBuilder(
          initialData: false,
          stream: isLoadingStream.stream, 
          builder: (context, snapshot) {
            if(snapshot.data ?? false){
              return  SpinPerfect(
                    duration: Duration(seconds: 20),
                    spins: 10,
                    infinite: true,
                    child: IconButton(onPressed: ()=>query = '', 
                    icon: Icon(Icons.refresh_rounded)),
                );
            }
            return FadeIn(
                    animate: query.isNotEmpty,
                    child: IconButton(onPressed: ()=>query = '', 
                    icon: Icon(Icons.clear)),
              );
          },
          ),
         

      
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStraems();
        close(context, null); 
      },
      icon: Icon(Icons.arrow_back_ios_new_outlined));
  }

  

  @override
  Widget buildResults(BuildContext context) {
    return buildResultAndSuggestion();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChanged(query);

    return buildResultAndSuggestion();

  }
  
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (){
        onMovieSelected(context,movie);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
      
            //Image
            SizedBox(width: size.width * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(movie.posterPath,loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),),
            ),
            ),
      
            SizedBox(width: 10,),
      
            //Descripcion
      
            SizedBox(width: size.width * 0.7,
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: textStyles.titleMedium,),
                (movie.overview.length > 100)
                  ? Text('${movie.overview.substring(0,100)}...')
                  : Text(movie.overview),
      
                Row(
                  children: [
                    Icon(Icons.star_half_rounded, color: Colors.yellow.shade800,),
                    SizedBox(width: 0.5,),
                    Text(HumanFormats.number(movie.voteAverage), style: textStyles.bodyMedium!.copyWith(color: Colors.yellow.shade900),)
                  ],
                )
      
              ],
             ),
            )
          ],
        ),
      ),
    ); 
  }
}