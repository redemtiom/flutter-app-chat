import 'package:chat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final users = [
    User(online: true, email: 'maria@email.com', name: 'Maria', uid: '1'),
    User(uid: '2', online: false, email: 'melissa@email.com', name: 'Melissa'),
    User(uid: '3', online: true, email: 'roberto@email.com', name: 'Roberto'),
  ];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _refreshController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My name',
          style: TextStyle(color: Colors.black54),
        ),
        elevation: 1.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.black54,
          ),
          onPressed: () {},
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10.0),
            child: Icon(
              Icons.check_circle,
              color: Colors.blue.shade400,
            ),
            //child: Icon(Icons.offline_bolt, color: Colors.red,)
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        enablePullDown: true,
        header: WaterDropHeader(
          waterDropColor: Colors.blue,
          complete: Icon(
            Icons.check,
            color: Colors.blue.shade400,
          ),
        ),
        child: _listViewUsers(),
      ),
    );
  }

  _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    final int usersLng = users.length + 1;
    print('Algo sabrosano $usersLng');
    users.add(User(
        uid: '$usersLng',
        online: true,
        email: 'name$usersLng@mail.com',
        name: 'name'));
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  ListView _listViewUsers() => ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _UserListTile(user: users[i]),
      separatorBuilder: (_, index) => const Divider(),
      itemCount: users.length);
}

class _UserListTile extends StatelessWidget {
  const _UserListTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: Text(user.name.substring(0, 2)),
      ),
      trailing: Container(
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
            color: (user.online) ? Colors.green : Colors.red,
            shape: BoxShape.circle),
      ),
    );
  }
}
