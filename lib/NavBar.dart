import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Drawer(
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountEmail: Text("balala@email.com"),
                accountName: Text("Balala"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage("https://yt3.ggpht.com/a/AGF-l7-pLWHhqjLR5ZVoKzV9_eU6IjYrDyhvSLRjsw=s900-c-k-c0xffffffff-no-rj-mo"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              ListTile(
                title: Text("men"),
              ),
              ListTile(
                title: Text("women"),
              ),
              Divider(),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.cogs),
                    title: Text("Settings"),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
