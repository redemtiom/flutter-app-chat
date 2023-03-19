import 'package:http/http.dart' as http;

import 'package:chat/globals/environment.dart';
import 'package:chat/services/auth_service.dart';

import 'package:chat/models/users_response.dart';

class UsersService {
  Future<List<User>> getUsers() async{
      try {
        final uri = Uri(scheme: 'https', host: Environment.host, path: '/api/users');
        final res = await http.get(uri, headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() ?? '',
        });
        print(res);

        final usersResponse = userResponseFromJson(res.body);

        return usersResponse.users;
      } catch (e) {
        print(e);
        return [];
      }
  }
}