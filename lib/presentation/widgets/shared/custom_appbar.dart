

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:cinemapedia/presentation/providers/search/search_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.movie_outlined, color: colors.primary,),
              SizedBox(width: 5,),
              Text('CinemaPedia', style: TextStyle(color: colors.primary, fontSize: 20, fontWeight: FontWeight.bold),),
              Spacer(),
              IconButton(onPressed: () async{

                final searchedMovies = ref.read(searchedMoviesProvider);
                final searchQuery = ref.read(searchQueryProvider);
                
                showSearch<Movie?>(
                  query: searchQuery,
                  context: context, 
                  delegate: SearchMovieDelegate(
                    searchMovies: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery,
                    initialMovies: searchedMovies
                  )
                  
                ).then((movie){
                  if(movie != null && context.mounted) context.push('/movie/${movie.id}');
                });

              }, 
              icon: Icon(Icons.search))
            ],
          ),
      )
      
      
      ),
      
    );
  }
}