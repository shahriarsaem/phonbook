import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _updateController = TextEditingController();

  Box? contactBox;
  @override
  void initState() {
    // TODO: implement initState
    contactBox = Hive.box('contact-list');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
      child: Column(
        children: [
          TextField(
            controller: _controller,
          ),
          ElevatedButton(
            onPressed: () {
              var userInput = _controller.text;
              contactBox!.add(userInput);
            },
            child: Text('Save'),
          ),
          Expanded(
              child: ValueListenableBuilder(
            valueListenable: Hive.box('contact-list').listenable(),
            builder: (context, box, widget) {
              return ListView.builder(
                  itemCount: contactBox!.keys.toList().length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(contactBox!.getAt(index).toString()),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Column(
                                            children: [
                                              TextField(
                                                controller: _updateController,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  contactBox!.putAt(index,
                                                      _updateController.text);
                                                },
                                                child: Text('Update'),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                                icon: Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                onPressed: () {
                                  contactBox!.deleteAt(index);
                                },
                                icon: Icon(Icons.remove_circle),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
          )),
        ],
      ),
    ));
  }
}
