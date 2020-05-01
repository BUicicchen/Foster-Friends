//import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foster_friends/no_signin.dart';
import 'package:foster_friends/user_profile.dart';
import 'package:foster_friends/org_profile.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:foster_friends/appState.dart';
import 'package:foster_friends/userState.dart';

// main application build
class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Foster Friends",
      home: SearchState(),
    );
  }
}

// building state
class SearchState extends StatefulWidget {
  SearchState({Key key}) : super(key: key); // have no idea what this is
  @override
  SearchStateUser createState() => SearchStateUser(null, "");
}

// This is the bottom bar body options
class SearchStateUser extends State<SearchState> {
  // FirebaseUser _user = store.state.user;
  FirebaseUser _user;
  String _userType;

  FirebaseUser get user => _user;
  String get userType => _userType;

  SearchStateUser(this._user, this._userType);

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[

        StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (_, state) {
            return new Text(
              '${state.user} and ${state.userType}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20.0),
            );
          },
    ),
    NoSignIn(),
    Text("User Profile"),
    OrgProfile()
    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _chooseWidget(index) {
    if(index == 0){
      return 0;
    }
    FirebaseUser u = store.state.user;
    if (u != null) {
      String type = store.state.userType;
      if(type == 'Individual'){
        return 2;
      }
      return 3;
    }
    print("returning 1");
    return index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foster Friends'), // top bar
      ),
      body: Center(
        child: _widgetOptions.elementAt(_chooseWidget(_selectedIndex)),
      ),
      // Contruction of navigation
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
