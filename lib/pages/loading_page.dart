//import 'package:chat/pages/users_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          // if (snapshot.hasData) {
          //   print(snapshot.data);
          //   return Center(child: Text('${snapshot.data}'));
          // }
          // if (snapshot.hasError) {
          //   return Center(child: Text('${snapshot.error}'));
          // }
          // print(snapshot.data);
          return const Center(child: Text('Esperando....'));
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final auth = await authService.isLoggedIn();

    if (auth) {
      await socketService.connect();
      Navigator.pushReplacementNamed(context, 'users');
      
      //* if no transition navigation is required
      // Navigator.pushReplacement(
      //     context,
      //     PageRouteBuilder(
      //       pageBuilder: (_, __, ___) => UsersPage(),
      //       transitionDuration: Duration.zero
      //     ));
      
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }
}
