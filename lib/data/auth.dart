import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

class Authentication {
  static OAuth2Client authClient =
      OAuth2Client(
          authorizeUrl: "https://api.imgur.com/oauth2/authorize",
          tokenUrl: "https://api.imgur.com/oauth2/token",
          redirectUri: null,
          customUriScheme: "com.eggman.imgsrc");

  static OAuth2Helper oauth2Helper =
    OAuth2Helper(authClient,
      grantType: OAuth2Helper.AUTHORIZATION_CODE,
      clientId: DotEnv().env['IMGUR_CLIENT_ID'],
      clientSecret: DotEnv().env['IMGUR_CLIENT_SECRET']);
}