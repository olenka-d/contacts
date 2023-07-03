import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';


void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact>? contacts;

  @override
  void initState() {
    super.initState();
    getContact();
  }

  void getContact() async {
    PermissionStatus status = await Permission.contacts.request();
    if (status.isGranted) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ContactsData(
        contacts: contacts,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "My contacts",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue,
            elevation: 0,
          ),
          body: ContactList(),
          /*(contacts) == null
              ? Center(child: ElevatedButton(
            child: Text('Get contacts'),
            onPressed: () {
              openAppSettings();
            },
          ),
          )
              : ListView.builder(
                itemCount: contacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  Uint8List? image = contacts![index].photo;
                  String num = (contacts![index].phones.isNotEmpty) ? (contacts![index].phones.first.number) : "--";
                  return ListTile(
                    leading: (contacts![index].photo == null)
                        ? const CircleAvatar(child: Icon(Icons.person))
                        : CircleAvatar(backgroundImage: MemoryImage(image!)),
                    title: Text(
                        "${contacts![index].name.first} ${contacts![index].name.last}"),

                    onTap: () async {
                      if (contacts![index].phones.isNotEmpty) {
                        final updatedContact = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailContact(contact: contacts![index]),
                          ),
                        );
                        if (updatedContact != null) {
                          // Update the contact in the list
                          setState(() {
                            contacts![index] = updatedContact;
                          });
                        }
                      }
                    },);
                },
              )
          )*/
        )
    );
  }
}

class DetailContact extends StatefulWidget {
  final Contact contact;

  const DetailContact({Key? key, required this.contact}) : super(key: key);

  @override
  _DetailContactState createState() => _DetailContactState();
}

class _DetailContactState extends State<DetailContact> {
  File? _image;

  Future<void> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //pickImageFromGallery();
  }

  Widget build(BuildContext context) {
    final contact = widget.contact;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My contacts",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              pickImageFromGallery();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipOval(
                child: _image != null
                    ? Image.file(
                  _image!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
                    : contact.photo != null //widget
                    ? Image.memory(
                  contact.photo!,         //widget
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
                    : const Icon(Icons.person, size: 100),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              contact.name.first + ' ' + contact.name.last, //widget
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: contact.phones.length,  //widget
              itemBuilder: (BuildContext context, int index) {
                String phoneNumber = contact.phones[index].number;  //widget
                return ListTile(
                  title: Text('Phone: $phoneNumber'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ContactsData extends InheritedWidget {
  final List<Contact>? contacts;

  ContactsData({
    Key? key,
    required this.contacts,
    required Widget child,
  }) : super(key: key, child: child);

  static ContactsData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ContactsData>();
  }

  @override
  bool updateShouldNotify(ContactsData oldWidget) {
    return oldWidget.contacts != contacts;
  }
}

class ContactList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contacts = ContactsData
        .of(context)
        ?.contacts;
    return ListView.builder(
        itemCount: contacts!.length,
        itemBuilder: (BuildContext context, int index) {
          Uint8List? image = contacts[index].photo;
          String num = (contacts![index].phones.isNotEmpty) ? (contacts![index]
              .phones.first.number) : "--";
          return ListTile(
            leading: (contacts![index].photo == null)
                ? const CircleAvatar(child: Icon(Icons.person))
                : CircleAvatar(backgroundImage: MemoryImage(image!)),
            title: Text(
                "${contacts![index].name.first} ${contacts![index].name.last}"),

            onTap: () async {
              if (contacts![index].phones.isNotEmpty) {
                final updatedContact = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailContact(contact: contacts![index]),
                  ),
                );
              }
            },);
        }
    );
  }
}


