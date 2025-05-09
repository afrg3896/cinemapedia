


import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MovieHorizontalListview extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final String? subTitle;
  final VoidCallback? loadNextPage;

  const MovieHorizontalListview({super.key, required this.movies, this.title, this.subTitle, this.loadNextPage});

  @override
  State<MovieHorizontalListview> createState() => _MovieHorizontalListviewState();
}

class _MovieHorizontalListviewState extends State<MovieHorizontalListview> {

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener((){
      if(widget.loadNextPage == null) return;

      if(scrollController.position.pixels + 200 >= scrollController.position.maxScrollExtent){
        widget.loadNextPage!();

      }

    });
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [

          if(widget.title != null || widget.subTitle != null)
            _Title(widget.title, widget.subTitle),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _Slide(widget.movies[index]);
              },
            )
          )
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;
  const _Slide(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if(loadingProgress != null){
                    return Padding(
                      padding: EdgeInsets.all(0.8),
                      child: Center(child:CircularProgressIndicator(strokeWidth: 2,)),
                    );
                  }
                  return GestureDetector(
                    onTap: () => context.push('/movie/${movie.id}'),
                    child: FadeIn(child: child),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 5,),

          SizedBox(
            width: 150,
            child: Text(movie.title, maxLines: 2, style: Theme.of(context).textTheme.titleSmall,),
          ),

          SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(Icons.star_half_outlined, color: Colors.yellow.shade800,),
                SizedBox(width: 3,),
                Text('${movie.voteAverage}', 
                style:Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.yellow.shade800) ,),
                Spacer(),
                //Text('${ movie.popularity}', style:Theme.of(context).textTheme.bodySmall)
                Text(HumanFormats.number( movie.popularity), style:Theme.of(context).textTheme.bodySmall)
              ],
            ),
          )
        ]
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String? title;
  final String? subtitle;

  const _Title(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          if(title != null)
            Text(title!, style: Theme.of(context).textTheme.headlineSmall,),
          Spacer(),

          if(subtitle != null)
            FilledButton.tonal(
              style:ButtonStyle(visualDensity: VisualDensity.compact),
               onPressed: (){}, 
               child: Text(subtitle!),),
        ],
      ),
    );
  }
}