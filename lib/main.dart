import 'package:flutter/material.dart';
import 'package:flutter_graphql_demo/constants.dart';
import 'package:flutter_graphql_demo/profile_widget.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink('https://api.github.com/graphql');

  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer {YOUR_GITHUB_TOKEN}',
  );

  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  runApp(MyApp(
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  ValueNotifier<GraphQLClient> client;

  MyApp({Key? key, required this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String readRepositories = Constants.readRepositories;

  FetchMoreOptions fetchMoreData(Map<String, dynamic> pageInfo) {
    final String fetchMoreCursor = pageInfo['endCursor'];
    FetchMoreOptions opts = FetchMoreOptions(
      variables: {'cursor': fetchMoreCursor},
      updateQuery: (previousResultData, fetchMoreResultData) {
        final List<dynamic> repos = [
          ...previousResultData?['user']['repositories']['edges']
              as List<dynamic>,
          ...fetchMoreResultData?['user']['repositories']['edges']
              as List<dynamic>
        ];

        fetchMoreResultData?['user']['repositories']['edges'] = repos;

        return fetchMoreResultData;
      },
    );

    return opts;
  }

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('My Github Demo App');
  final TextEditingController userNameTextEditingController =
      TextEditingController(text: "Arunshaik2001");

  PreferredSizeWidget appBar(){
    return AppBar(
      title: customSearchBar,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              if (customIcon.icon == Icons.search) {
                customIcon = const Icon(Icons.cancel);
                customSearchBar = ListTile(
                  leading: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 28,
                  ),
                  title: TextFormField(
                      cursorColor: Colors.white,
                      controller: userNameTextEditingController,
                      decoration: const InputDecoration(
                        hintText: 'type userId...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      onEditingComplete: () {
                        setState(() {});
                      }),
                );
              } else {
                customIcon = const Icon(Icons.search);
                customSearchBar = const Text('My Github Demo App');
              }
            });
          },
          icon: customIcon,
        )
      ],
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: Query(
          options: QueryOptions(
            document: gql(readRepositories),
            variables: {
              'login': userNameTextEditingController.text.trim(),
            },
          ),
          builder: (QueryResult result,
              {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.isLoading) {
              return const Text('Loading');
            }

            print(result.data);

            final userDetails = result.data?['user'];
            List repositories = result.data?['user']['repositories']['edges'];

            return ProfileWidget(
              repositories: repositories,
              userDetails: userDetails,
              fetchMore: () {
                fetchMore!(fetchMoreData(
                    userDetails['repositories']['pageInfo']));
              },
            );
          },
        ),
      ),
    );
  }
}
