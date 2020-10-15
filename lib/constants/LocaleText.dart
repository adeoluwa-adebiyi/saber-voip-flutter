abstract class LocaleText{
  String usernameHintText;
  String passwordHintText;
  String signBtnInText;
  String invalidUsernameError;
  String invalidPasswordError;
  String noMessagesCaptionText;
  String contactNameHint;
  String createContactAppBarTitle;
  String contactPhoneNumberHint;
  String emailContactHint;
  String noFavouritesCaptionText;
  String sipServerHintText;
}

class EnglishLocalText implements LocaleText{
  @override
  String passwordHintText = "your password";

  @override
  String usernameHintText = "ex: johndoe";

  @override
  String signBtnInText = "Login";

  @override
  String invalidPasswordError = "Invalid password. Password characters must contain only alphabets, numbers [\$, #, @, *]";

  @override
  String invalidUsernameError;

  @override
  String noMessagesCaptionText = "No messages.";

  @override
  String contactNameHint ="Name";

  @override
  String contactPhoneNumberHint = "Phone number";

  @override
  String createContactAppBarTitle = "Create Contact";

  @override
  String emailContactHint = "Email";

  @override
  String noFavouritesCaptionText = "No favourites";

  @override
  String sipServerHintText = "ex: sip1@sip.callinfinty.com";

}