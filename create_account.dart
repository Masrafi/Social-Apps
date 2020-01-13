import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffold = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String username;

  submit(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      SnackBar snackBar = SnackBar(content: Text('Welcome $username'),);
      _scaffold.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 2),(){
        Navigator.pop(context, username);
      });

    }
  }
  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffold,
      appBar: header(context,titleText: 'Setup Your Profile'),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      'Create Your Username',
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: TextFormField(
                        validator: (val){
                          if(val.trim().length < 3 || val.isEmpty){
                            return 'Username is Too Short';
                          }else if(val.trim().length > 12){
                            return 'Username is Too Long';
                          }else{
                            return null;
                          }
                        },
                        onSaved: (val)=> username = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          hintText: 'Username',
                          labelStyle: TextStyle(fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.teal,
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
