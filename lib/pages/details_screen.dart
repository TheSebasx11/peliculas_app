import 'package:flutter/material.dart';
import 'package:peliculas_app/models/movie.dart';
import 'package:peliculas_app/widgets/casting_list.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Movie movie = ModalRoute.of(context)?.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _CustomAppBar(
            urlImg: movie.fullPoster,
            title: movie.title,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _PosterAndTitle(
                  title: movie.title,
                  avg: movie.voteAverage,
                  originalTitle: movie.originalTitle,
                  urlImg: movie.fullPoster,
                  id: movie.heroId!,
                ),
                _Overview(text: movie.overview),
                _Overview(text: movie.overview),
                _Overview(text: movie.overview),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Elenco",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                CastingList(movieID: movie.id),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final String title, urlImg;
  const _CustomAppBar({Key? key, required this.title, required this.urlImg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(title),
          width: double.infinity,
          height: double.maxFinite,
          alignment: Alignment.bottomCenter,
          color: Colors.black38,
        ),
        background: FadeInImage(
          placeholder: const AssetImage("assets/placeholder.gif"),
          fit: BoxFit.cover,
          image: NetworkImage(urlImg),
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final String title, urlImg, originalTitle;
  final double avg;
  final String id;
  const _PosterAndTitle(
      {Key? key,
      required this.title,
      required this.urlImg,
      required this.avg,
      required this.originalTitle,
      required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Hero(
            tag: id,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                height: 200,
                width: 100,
                placeholder: const AssetImage("assets/placeholder.gif"),
                fit: BoxFit.cover,
                image: NetworkImage(urlImg),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textStyle.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  originalTitle,
                  style: textStyle.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Row(
                  children: [
                    const Icon(Icons.star_outline,
                        size: 15, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      "$avg",
                      style: textStyle.bodyMedium,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final String text;
  const _Overview({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Text(text, textAlign: TextAlign.start),
    );
  }
}
