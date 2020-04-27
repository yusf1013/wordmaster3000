class LoginController {
  static User _thisUser = User(null);

  static bool isLoggedIn() {
    return _thisUser.account != null;
  }

  static void logOut() {
    _thisUser = User(null);
  }

  static void logIn() {
    _thisUser = User(Account());
  }
}

class User {
  Account account;

  User(this.account);
}

class Account {
  String username, email;
}
