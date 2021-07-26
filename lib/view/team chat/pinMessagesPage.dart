import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secretchat/model/team_model.dart';

class PinMessagesPage extends StatefulWidget {
  final TeamModel teamModel;

  PinMessagesPage({this.teamModel});
  //const PinMessagesPage({ Key? key }) : super(key: key);

  @override
  _PinMessagesPageState createState() => _PinMessagesPageState();
}

class _PinMessagesPageState extends State<PinMessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              // .collection('users/${getxController.authData.value}/mescsages')
              .collection('personal_connections')
              .doc('${widget.teamModel.teamId}')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Container(
                child: Text('${snapshot.data['pinMessages']} Pin Messages'),
              );
            }
            return Container();
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 83.5,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 188,
                    color: Color.fromRGBO(23, 34, 24, 0.3),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          // .collection('users/${getxController.authData.value}/mescsages')
                          .collection('personal_connections')
                          .doc('${widget.teamModel.teamId}')
                          .collection('messages')
                          .orderBy('createdOn', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                          // Center(
                          //   child: Container(
                          //     child: CircularProgressIndicator(),
                          //   ),
                          // );
                        }
                        if (snapshot.hasData) {
                          return Container(
                            height: size.height - 200,
                            child: ListView.builder(
                                reverse: true,
                                itemBuilder: (ctx, index) {
                                  print(snapshot.data.docs[index].data());
                                  
                                    print('rayyanlovessaurab');

                                    if (snapshot.data.docs[index]['type'] ==
                                        'textMessage') {
                                      // if (snapshot.data.docs[index]['isGif'] ==
                                      //     false) {
                                      return GestureDetector(
                                        child: ListTile(
                                          leading: getxController
                                                      .authData.value !=
                                                  snapshot.data.docs[index]
                                                      ['sentBy']
                                              ? Text(
                                                  "${snapshot.data.docs[index]['sentBy']}")
                                              : SizedBox(
                                                  height: 0,
                                                  width: 0,
                                                ),
                                          title: Text(
                                              '${snapshot.data.docs[index]['message']}'),
                                          // trailing: snapshot.data.docs[index]
                                          //             ['isEdited'] ==
                                          //         true
                                          //     ? Text('Edited')
                                          //     : Container(),
                                        ),
                                        onTap: () {
                                          onTapOnMessage(
                                            snapshot.data.docs[index].id,
                                            snapshot.data.docs[index]
                                                ['message'],
                                            snapshot.data.docs[index]['sentBy'],
                                            snapshot.data.docs[index]
                                                ['createdOn'],
                                            snapshot.data.docs[index]['type'],
                                            snapshot.data.docs[index]
                                                ['isPinMessage'],
                                          );
                                        },
                                      );
                                    }

                                    if (snapshot.data.docs[index]['type'] ==
                                        'editedMessage') {
                                      // if (snapshot.data.docs[index]['isGif'] ==
                                      //     false) {
                                      return GestureDetector(
                                        child: ListTile(
                                          leading: getxController
                                                      .authData.value !=
                                                  snapshot.data.docs[index]
                                                      ['sentBy']
                                              ? Text(
                                                  "${snapshot.data.docs[index]['sentBy']}")
                                              : SizedBox(
                                                  height: 0,
                                                  width: 0,
                                                ),
                                          title: Text(
                                              '${snapshot.data.docs[index]['message']}'),
                                          trailing: Text('Edited'),
                                        ),
                                        onTap: () {
                                          onTapOnMessage(
                                            snapshot.data.docs[index].id,
                                            snapshot.data.docs[index]
                                                ['message'],
                                            snapshot.data.docs[index]['sentBy'],
                                            snapshot.data.docs[index]
                                                ['createdOn'],
                                            snapshot.data.docs[index]['type'],
                                            snapshot.data.docs[index]
                                                ['isPinMessage'],
                                          );
                                        },
                                      );
                                      //}

                                    }

                                    //////////////////////////////////////////////////////////////
                                    ///getting the gif messages over here
                                    if (snapshot.data.docs[index]['type'] ==
                                        'gifMessage') {
                                      var link = snapshot
                                          .data.docs[index]['message']
                                          .toString()
                                          .trimRight();
                                      print('${link}hi');
                                      return GestureDetector(
                                        child: Container(
                                          height: 200,
                                          width: 200,
                                          child: Image.network(
                                            '$link',
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        onTap: () {
                                          onTapOnMessage(
                                            snapshot.data.docs[index].id,
                                            snapshot.data.docs[index]
                                                ['message'],
                                            snapshot.data.docs[index]['sentBy'],
                                            snapshot.data.docs[index]
                                                ['createdOn'],
                                            snapshot.data.docs[index]['type'],
                                            snapshot.data.docs[index]
                                                ['isPinMessage'],
                                          );
                                        },
                                      );
                                    }
                                    itemCount: snapshot.data.docs.length,
                                );
                              }
                              return Container();
                            },
                          ),
                        )
                      : Container(),

                                    return Container();
                                  }

                            
                
                      
                ),
    );
  }
}
