/*
  sample code that works...
    Reddit reddit = new Reddit(new Client());
    final clientId = DotEnv().env['REDDIT_CLIENT_ID'];
    final clientSecret = DotEnv().env['REDDIT_CLIENT_SECRET'];

    reddit.authSetup(clientId, clientSecret);
    await reddit.authFinish();
    reddit.searchSubreddits("funny").fetch().then((value) =>
      print(value["data"]["children"].first["data"]["url"])
    );
 */

