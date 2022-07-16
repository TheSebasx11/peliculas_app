import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:provider/provider.dart';
import '../providers/movies_provider.dart';

class MovieSlider extends StatefulWidget {
  final Function onNextPage;
  final List<Movie> movies;
  final String? title;
  const MovieSlider({
    Key? key,
    required this.movies,
    required this.onNextPage,
    this.title,
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController sc = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sc.addListener(() {
      if (sc.position.pixels >= sc.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return SizedBox(
      width: double.infinity,
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              "${widget.title}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: sc,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: moviesProvider.PopularMovies.length,
              itemBuilder: (_, int index) {
                final movie = moviesProvider.PopularMovies[index];
                return GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, "details", arguments: movie),
                  child: _MoviePoster(
                    movie: movie,
                    HeroID: "${movie.title}-$index-${movie.id}",
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final String HeroID;
  const _MoviePoster({Key? key, required this.movie, required this.HeroID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroId = HeroID;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      margin: const EdgeInsets.only(left: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      height: 200,
      width: 150,
      child: Column(
        children: [
          Expanded(
            child: Hero(
              tag: HeroID,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: FadeInImage(
                  height: 130,
                  width: 190,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage("assets/placeholder.gif"),
                  image: NetworkImage(movie.fullPoster),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
