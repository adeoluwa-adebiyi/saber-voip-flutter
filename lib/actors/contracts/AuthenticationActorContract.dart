abstract class AuthenticationActorContract{

  Future<bool> login(String username, String password, String serverURI);

  Future<bool> logout();

}