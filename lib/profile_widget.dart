import 'package:flutter/material.dart';
import 'package:flutter_graphql_demo/repository_tile_view.dart';

class ProfileWidget extends StatelessWidget {
  final dynamic userDetails;
  final List repositories;
  final VoidCallback? fetchMore;

  const ProfileWidget({Key? key,this.userDetails,required this.repositories,this.fetchMore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.deepPurple,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 2,
                    ),
                    ClipOval(
                      child: Image.network(
                        userDetails["avatarUrl"],
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                        height: 100.0,
                        width: 100.0,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      userDetails['name'],
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      userDetails['login'],
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.email,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          userDetails['email'] ?? 'Unknown',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 10.0, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                userDetails["followers"]['totalCount']
                                    .toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "Followers",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                userDetails["following"]['totalCount']
                                    .toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "Following",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                userDetails["repositories"]['totalCount']
                                    .toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "Repositories",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 2, left: 10),
                child: Text(
                  "All Repositories",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 300.0),
            child: NotificationListener<ScrollEndNotification>(
              onNotification: (scrollEnd) {
                final metrics = scrollEnd.metrics;
                if (metrics.atEdge) {
                  bool isTop = metrics.pixels == 0;
                  if (!isTop) {
                    fetchMore!();
                  }
                }
                return true;
              },
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: repositories.length,
                itemBuilder: (context, index) {
                  return RepositoryTileView(
                      repository: repositories[index]);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
