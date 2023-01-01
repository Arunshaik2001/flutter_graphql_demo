


class Constants{

  static const String readRepositories = """
    query GithubGraphQL(\$login: String!) {
  user(login: \$login) {
    avatarUrl(size: 200)
    name
    email
    login
    repositories(first: 10) {
      pageInfo {
        endCursor
        startCursor
      }
      totalCount
      edges {
        node {
          id
          name
          viewerHasStarred
        }
      }
    }
    followers {
      totalCount
    }
    following {
      totalCount
    }
  }
}
      """;

  static const String addStar = """
    mutation AddStar(\$starrableId: ID!) {
    addStar(input: {starrableId: \$starrableId}) {
      starrable {
        viewerHasStarred
      }
    }
  }
  """;

  static const String removeStar = """
    mutation RemoveStar(\$starrableId: ID!) {
    removeStar(input: {starrableId: \$starrableId}) {
      starrable {
        viewerHasStarred
      }
    }
  }
  """;
}