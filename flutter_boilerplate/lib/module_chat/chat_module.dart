import 'package:yessoft/module_auth/service/auth_service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:inject/inject.dart';
import 'package:yessoft/abstracts/module/yes_module.dart';

import 'chat_routes.dart';
import 'ui/screens/chat_page/chat_page.dart';

@provide
class ChatModule extends YesModule {
  final ChatPage _chatPage;
  final AuthService _authService;

  ChatModule(this._chatPage, this._authService);

  @override
  Map<String, WidgetBuilder> getRoutes() {
    return {
      ChatRoutes.chatRoute: (context) =>
          _authService.isLoggedIn ? _chatPage : Scaffold()
    };
  }
}
