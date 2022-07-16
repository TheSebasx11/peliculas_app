import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/movies_provider.dart';

class CastingList extends StatelessWidget {
  final int movieID;
  const CastingList({
    Key? key,
    required this.movieID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MoviesProvider moviesProvider =
        Provider.of<MoviesProvider>(context, listen: false);
    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieID),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 180,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final List<Cast> cast = snapshot.data!;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          width: double.infinity,
          height: 200,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => _CastItem(actor: cast[index]),
            itemCount: cast.length,
            scrollDirection: Axis.horizontal,
          ),
        );
      },
    );
  }
}

class _CastItem extends StatelessWidget {
  final Cast actor;
  const _CastItem({
    Key? key,
    required this.actor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.blue,
      width: 150,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: FadeInImage(
              placeholderFit: BoxFit.cover,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
              placeholder: const AssetImage("assets/placeholder.gif"),
              image: NetworkImage(actor.fullProfilePath),
            ),
          ),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
