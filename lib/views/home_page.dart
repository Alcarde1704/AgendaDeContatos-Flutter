import 'dart:io';
import 'dart:math';

import 'package:contatos/models/contact_model.dart';
import 'package:contatos/views/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderaz, orderza}


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = [];


  @override
  void initState() {
    super.initState();

    _getAllContacts();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.orderza,
              )
              
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    
    
    return GestureDetector(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 60.0,
                height: 60.0,
                child: CircleAvatar(
                  backgroundColor: Colors.primaries[index] ,
                  child: Text(contacts[index].name != null && contacts[index].name != "" ? contacts[index].name.substring(0,1).toUpperCase() : "?"),
                ),
              ), 
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    contacts[index].name ?? "",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 4,),

                  Text(
                    contacts[index].email ?? "",
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(height: 3,),

                  Text(
                    contacts[index].phone ?? "",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOption(context, index);
      },
    );
  }

  void _showOption(BuildContext context, int index) {
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return BottomSheet(
          onClosing: () {
            
          },
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10.0),
              
              child: Center(
                heightFactor: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    
                      // onPressed: onPressed, 
                      IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.red,
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                        iconSize: 30,
                      ),
                    
                      SizedBox(width: 15,),

                     IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        iconSize: 30,
                        onPressed: () {
                          helper.deleteContact(contacts[index].id);
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });

                        },
                      ),
                   

                    SizedBox(width: 15,),

                    
                      // onPressed: onPressed, 
                    IconButton(
                        icon: Icon(Icons.call),
                        color: Colors.red,
                        iconSize: 30,
                        onPressed: () {
                          
                          launch("tel:+55${contacts[index].phone}");

                          Navigator.pop(context);
                        },
                      )
                    
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }

  void _showContactPage({Contact contact}) async{
    final recContact = await Navigator.push(context, MaterialPageRoute(builder: (context) => ContactPage(contact: contact,)));

    if(recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);
      } else{
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) => {
          setState(() {
            contacts = list;
          })
        });
  }

  void _orderList(OrderOptions result) {
    switch(result){
      case OrderOptions.orderaz:
        contacts.sort( (a,b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        } );
        break;
      case OrderOptions.orderza:
        contacts.sort( (a,b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        } );
        break;
    }
    setState(() {
      
    });
  }
}
