

import 'package:cinemapedia/presentation/screens/screens.dart';
import 'package:cinemapedia/presentation/widgets/shared/full_screen_loader.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _HomeView(),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  const _HomeView();

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {

  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();

  }

  @override
  Widget build(BuildContext context) {

    final initialLoading = ref.watch(initialLoadingProvider);

    if(initialLoading) return FullScreenLoader();

    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final moviesSlideShowProvider = ref.watch(moviesSlideshowProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);

    return CustomScrollView(
      slivers: [

        SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.all(0),
            title: CustomAppbar(),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Column(
        children: [
          // CustomAppbar(),
      
          MoviesSlideshow(movies: moviesSlideShowProvider),
      
          MovieHorizontalListview
          (movies: nowPlayingMovies, 
           title: 'En cines', 
           subTitle: 'Lunes 7',
           loadNextPage: (){
            ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
           },),
          MovieHorizontalListview
          (movies: topRatedMovies, 
           title: 'Top Rated', 
           loadNextPage: (){
            ref.read(topRatedMoviesProvider.notifier).loadNextPage();
           },),
          MovieHorizontalListview
          (movies: popularMovies, 
           title: 'Populares', 
           loadNextPage: (){
            ref.read(popularMoviesProvider.notifier).loadNextPage();
           },),
          MovieHorizontalListview
          (movies: upcomingMovies, 
           title: 'Upcoming', 
           loadNextPage: (){
            ref.read(upcomingMoviesProvider.notifier).loadNextPage();
           },)
      
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: nowPlayingMovies.length,
          //     itemBuilder: (context, index) {
          //       final movie = nowPlayingMovies[index];
          //       return ListTile(
          //         title: Text(movie.title),
          //   );
          //         },
          //       ),
          // )],
                ]
              );
            },
            childCount: 1
          )
        )

      ]
      
    );
  }
}