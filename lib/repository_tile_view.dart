import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_graphql_demo/constants.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RepositoryTileView extends StatefulWidget {
  final dynamic repository;

  const RepositoryTileView({Key? key, required this.repository})
      : super(key: key);

  @override
  State<RepositoryTileView> createState() => _RepositoryTileViewState();
}

class _RepositoryTileViewState extends State<RepositoryTileView> {
  final String addStar = Constants.addStar;

  final String removeStar = Constants.removeStar;

  @override
  Widget build(BuildContext context) {
    final repository = widget.repository;

    ValueNotifier<bool> hasStarred =
        ValueNotifier(repository['node']['viewerHasStarred'] as bool);

    return Card(
      elevation: 0.5,
      shadowColor: Colors.purple,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10,),
          ValueListenableBuilder(
            valueListenable: hasStarred,
            builder: (ctx, data, _) {
              bool starred = data as bool;
              return Row(
                children: <Widget>[
                  const Icon(Icons.book_outlined),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    repository['node']['name'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Mutation(
                    options: MutationOptions(
                      document:
                      (!starred) ? gql(addStar) : gql(removeStar),
                      update: (GraphQLDataProxy cache, QueryResult? result) {
                        return cache;
                      },
                      onCompleted: (Map<String, dynamic>? resultData) {
                        hasStarred.value = resultData?[
                        !starred ? 'addStar' : 'removeStar']
                        ['starrable']['viewerHasStarred'] as bool;

                        print(resultData);
                      },
                    ),
                    builder: (
                        RunMutation? runMutation,
                        QueryResult? result,
                        ) {
                      return GestureDetector(
                        onTap: () {
                          runMutation!({
                            'starrableId': repository['node']['id'],
                          });
                        },
                        child: Icon(!starred ? Icons.star_border : Icons.star,color: Colors.yellow,),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10,)
        ],
      ),
    );
  }
}
