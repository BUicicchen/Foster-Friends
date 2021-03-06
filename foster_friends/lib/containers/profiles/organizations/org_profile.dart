import 'package:flutter/material.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:foster_friends/containers/grid/grid.dart';
import 'package:foster_friends/containers/authentication/authentication.dart';
import './uploadPet.dart';
import 'package:foster_friends/containers/profiles/organizations/edit_org_profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


String name;
String description;
String email;
String phoneNumber;
String photo;
String address;
List pets = [];
List<Map<String, dynamic>> petInfo = [];
Map<String, dynamic> orgInfo;


// Define a custom Form widget.
class OrgProfile extends StatefulWidget {
  final data;

  OrgProfile(this.data);

  @override
  OrgState createState() {
    return OrgState(this.data);
  }
}

class OrgState extends State<OrgProfile> {
  Map<String, dynamic> data;
  OrgState(this.data);

  @override
  void initState() {
    final data = store.state.userData;
    name = data['name'];
    description = data['description'];
    phoneNumber = data['phone number'];
    photo = data['photo'];
    pets = data['pets'];
    email = data['email'];
    address = data['address'];
    super.initState();
  }

  refresh() {
    setState(() {
      final data = store.state.userData;
      name = data['name'];
      description = data['description'];
      phoneNumber = data['phone number'];
      photo = data['photo'];
      pets = data['pets'];
      email = data['email'];
      address = data['address'];
    });
  }

  bool _anyAreNull() {
    final data = store.state.userData;
    return data['name'] == null ||
        data['description'] == null ||
        data['phone number'] == null ||
        data['photo'] == null ||
        data['pets'] == null ||
        data['email'] == null ||
        data['address'] == null;
  }

  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ProfileViewModel>(
        converter: _ProfileViewModel.fromStore,
        builder: (BuildContext context, _ProfileViewModel vm) {
          if (_anyAreNull()) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (store.state.userData == null){
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
                body: Center(
                    //margin: EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(photo),
                          ),
                        ),
                          SizedBox(height: 10,),
                          Text(name,
                              style: Theme.of(context).textTheme.headline6),
                          SizedBox(height: 10,),
                          Text("Email: "+data["email"],
                             style: TextStyle(fontFamily: 'roboto',
                                  fontSize: 15.0,letterSpacing: 1.5)),
                          SizedBox(height: 5,),
                          Text("Phone number: "+phoneNumber,
                               style: TextStyle(fontFamily: 'roboto',
                                  fontSize: 15.0,letterSpacing: 1.5)),
                          SizedBox(height: 5,),
                          Text("Address: "+address,
                             style: TextStyle(fontFamily: 'roboto',
                                  fontSize: 15.0,letterSpacing: 1.5)),
                          SizedBox(height: 5,),
                          Text("Description: "+description,
                              style: TextStyle(fontFamily: 'roboto',
                                  fontSize: 15.0,letterSpacing: 1.5)),
                        Row (
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: RaisedButton(
                            color: Theme.of(context).buttonColor,
                            child: Text("Edit Profile",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).backgroundColor)),
                            onPressed: () {
                              showDialog(context: context, builder: (BuildContext context) => EditOrgProfile(data,refresh));
                            })),
                          Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: IconButton(
                                  icon: Icon(FontAwesomeIcons.signOutAlt),
                                  color: Theme.of(context).buttonColor,
                                  onPressed: () {
                                    signOut();
                                  },
                                )),
                          ],),
                          
                          Divider(color: Colors.grey),
                          
                          Container(
                              margin: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).copyWith().size.width,
                              height: MediaQuery.of(context).copyWith().size.height - 580,
                              child: buildGrid(pets, context, data)),
                          ])),
                          
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) => new UploadPet()));
                            },
                            child: Icon(Icons.file_upload),
                            backgroundColor: Color(0xFFFEF53500),
                          ),
                        );
          }
        });
  }
}

class _ProfileViewModel {
  final String name;
  final String description;
  final String email;
  final String phoneNumber;
  final String photo;
  final String address;
  final List<Map<String, dynamic>> pets;

  _ProfileViewModel({this.pets, this.description, this.name, this.email, this.phoneNumber, this.photo, this.address});

  static _ProfileViewModel fromStore(Store<AppState> store) {
    return new _ProfileViewModel(
      name: store.state.userData["name"],
      description: store.state.userData["description"],
      email: store.state.userData["email"],
      phoneNumber: store.state.userData["phone number"],
      photo: store.state.userData["photo"],
      address: store.state.userData["address"],
      pets: store.state.userData['pets']
    );
  }
}