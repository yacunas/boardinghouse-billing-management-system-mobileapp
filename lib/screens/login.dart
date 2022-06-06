import 'package:flutter/material.dart';
import 'package:billing_management/navigation/bottomNavBar.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Center(
                    child: Container(
                        width: 200,
                        height: 150,
                        /*decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50.0)),*/
                        child: Image.asset('assets/app_icon.png')),
                  ),
                ),
                Padding(
                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        // labelText: 'Username',
                        hintText: 'Username'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Username is Required';
                      }
                      if (value != 'admin') {
                        return ' ';
                      }
                    },
                    onSaved: (String value) {
                      this.username = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 85),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        // labelText: 'Password',
                        hintText: 'Password'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Password is Required';
                      }
                      if (value != 'admin') {
                        return 'Username or password is invalid';
                      }
                    },
                    onSaved: (String value) {
                      this.password = value;
                    },
                  ),
                ),
                Container(
                  height: 50,
                  width: 370,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();
                      validate();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validate() async {
    if (username == 'admin' && password == 'admin') {
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MyBottomNavigationBar();
      }));
    }
  }
}
