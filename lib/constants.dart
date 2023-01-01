


class Constants{

  static const String readRepositories = """
    query Flutter_Github_GraphQL(\$login: String!) {
  user(login: \$login) {
    avatarUrl(size: 200)
    location
    name
    url
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
          nameWithOwner
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