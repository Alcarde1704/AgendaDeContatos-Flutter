import 'dart:io';

import 'package:flutter/material.dart';

import '../models/contact_model.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;
  
  ContactPage({this.contact});
  
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;
  Contact _editedContact;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.contact == null){
      _editedContact = Contact();
    } else{
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(_editedContact.name != null && _editedContact.phone != null && _editedContact.name.isNotEmpty && _editedContact.phone.isNotEmpty ){
              Navigator.pop(context, _editedContact);
            } else{
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
    
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              
                //  Container(
                //   width: 140.0,
                //   height: 140.0,
                //   decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       image: DecorationImage(
                //           image: _editedContact.img != null
                //               ? FileImage(File(_editedContact.img))
                //               : AssetImage("images/user.png"))),
                // ),
    
                SizedBox(height: 30,),
    
                Container(
                  width: 80.0,
                  height: 80.0,
                  child: CircleAvatar(
                    child: Text(_editedContact.name != null && _editedContact.name != "" ? _editedContact.name.substring(0,1).toUpperCase() : "?"),
                  ),
                ),            
    
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(
                  labelText: 'Nome'
                ),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
    
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail'
                ),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.email = text;
                },
              ),
    
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Telefone'
                ),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.phone = text;
                },
              )
    
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if(_userEdited){
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text('Descartar Alterações?'),
          content: Text("Se sair as alterações serão perdidas"),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text("Cancelar")),

            TextButton(onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }, child: Text("Sim"))
          ],
        );
      });
      return Future.value(false);
    } else{
      return Future.value(true);
    }
  }
}