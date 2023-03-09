import 'dart:async';
import 'dart:io';
import 'package:Bsharkr/models/trainerUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Bsharkr/Client/const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:Bsharkr/colors.dart';
import 'package:Bsharkr/colors.dart' as prefix0;
import 'package:Bsharkr/Client/globals.dart';

import '../main.dart';

class CrudMethods {
  final String id;

  CrudMethods({Key key, @required this.id});

  Future<QuerySnapshot> getData() async {
    return await Firestore.instance
        .collection('clientUsers')
        .where(
          'id',
          isEqualTo: id,
        )
        .getDocuments();
  }
}

class Chat extends StatefulWidget {
  final bool fuckedUpKeyBoard;
  final MyAppState parent;
  final String peerId;
  Chat({Key key, @required this.peerId, this.parent, this.fuckedUpKeyBoard})
      : super(key: key);
  @override
  State createState() => new ChatState(peerId: peerId);
}

class ChatState extends State<Chat> with WidgetsBindingObserver {
  Future _getData;
  TrainerUser _bookedClient;

  final String peerId;

  CrudMethods crudObj;

  ChatState({Key key, @required this.peerId});

  AppLifecycleState _notification;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    _notification = state;
    if (_notification.index != 0) {
      await Firestore.instance
          .collection('pushNotifications')
          .document(prefs.getString('id'))
          .updateData({'chattingWith': null});

      await Firestore.instance
          .collection('clientUsers')
          .document(prefs.getString('id'))
          .updateData({'unseenMessagesCounter.$peerId': FieldValue.delete()});
    } else {
      await Firestore.instance
          .collection('pushNotifications')
          .document(prefs.getString('id'))
          .updateData({'chattingWith': _bookedClient.id.toString()});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    crudObj = CrudMethods(id: peerId);
    _getData = crudObj.getData();

    WidgetsBinding.instance.addObserver(this);

    Firestore.instance
        .collection('pushNotifications')
        .document(prefs.getString('id'))
        .updateData({'chattingWith': peerId.toString()});
    Firestore.instance
        .collection('clientUsers')
        .document(prefs.getString('id'))
        .updateData({'unseenMessagesCounter.$peerId': FieldValue.delete()});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getData,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                ),
              ),
              color: prefix0.backgroundColor,
            );
          }
          _bookedClient = TrainerUser(snapshot.data.documents[0]);

          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: WillPopScope(
              onWillPop: () async {
                await Firestore.instance
                    .collection('pushNotifications')
                    .document(prefs.getString('id'))
                    .updateData({'chattingWith': null});

                await Firestore.instance
                    .collection('clientUsers')
                    .document(prefs.getString('id'))
                    .updateData(
                        {'unseenMessagesCounter.$peerId': FieldValue.delete()});
                if (widget.parent != null) {
                  if (widget.parent.restartedFlagFriends == true) {
                    widget.parent.restartedFlagFriends = false;
                  }
                }
                if (widget.parent != null) {
                  if (widget.parent.restartedFlagClients == true) {
                    widget.parent.restartedFlagClients = false;
                  }
                }
                Navigator.pop(context);

                return true;
              },
              child: new Scaffold(
                  resizeToAvoidBottomPadding:
                      widget.fuckedUpKeyBoard == null ? false : true,
                  backgroundColor: prefix0.backgroundColor,
                  appBar: new AppBar(
                      elevation: 0.0,
                      backgroundColor: Color(0xff3E3E45),
                      title: new Text(
                        _bookedClient.firstName + " " + _bookedClient.lastName,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17 * prefs.getDouble('height'),
                            fontStyle: FontStyle.normal),
                      ),
                      centerTitle: true,
                      leading: new IconButton(
                        icon: new Icon(
                          Icons.backspace,
                          color: Colors.white,
                          size: 24 * prefs.getDouble('height'),
                        ),
                        onPressed: () async {
                          await Firestore.instance
                              .collection('pushNotifications')
                              .document(prefs.getString('id'))
                              .updateData({'chattingWith': null});

                          await Firestore.instance
                              .collection('clientUsers')
                              .document(prefs.getString('id'))
                              .updateData({
                            'unseenMessagesCounter.$peerId': FieldValue.delete()
                          });

                          if (widget.parent != null) {
                            if (widget.parent.restartedFlagFriends == true) {
                              widget.parent.restartedFlagFriends = false;
                            }
                          }
                          if (widget.parent != null) {
                            if (widget.parent.restartedFlagClients == true) {
                              widget.parent.restartedFlagClients = false;
                            }
                          }
                          Navigator.pop(context);
                        },
                      )),
                  body: Theme(
                    data: ThemeData.dark(),
                    child: new ChatScreen(
                      peerId: peerId,
                      bookedClient: _bookedClient,
                      fuckedUpKeyboard: widget.fuckedUpKeyBoard,
                    ),
                  ),
                  resizeToAvoidBottomInset: false),
            ),
          );
        });
  }
}

class ChatScreen extends StatefulWidget {
  final bool fuckedUpKeyboard;
  final String peerId;
  final TrainerUser bookedClient;
  ChatScreen(
      {Key key,
      @required this.peerId,
      @required this.bookedClient,
      this.fuckedUpKeyboard})
      : super(key: key);

  @override
  State createState() =>
      new ChatScreenState(peerId: peerId, bookedClient: bookedClient);
}

class ChatScreenState extends State<ChatScreen> {
  TrainerUser bookedClient;
  ChatScreenState(
      {Key key, @required this.peerId, @required this.bookedClient});

  String peerId;
  String id;

  List<DocumentSnapshot> listMessage = [];
  String groupChatId;

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();

  void requestNextPage() async {
    if (!_isRequesting && !_isFinish) {
      QuerySnapshot querySnapshot;
      _isRequesting = true;
      if (_products.isEmpty) {
        querySnapshot = await Firestore.instance
            .collection('messages')
            .document(groupChatId)
            .collection(groupChatId)
            .orderBy('timestamp', descending: true)
            .limit(15)
            .getDocuments();
      } else {
        querySnapshot = await Firestore.instance
            .collection('messages')
            .document(groupChatId)
            .collection(groupChatId)
            .orderBy('timestamp', descending: true)
            .startAfterDocument(_products[_products.length - 1])
            .limit(15)
            .getDocuments();
      }
      if (querySnapshot != null) {
        int oldSize = _products.length;
        setState(() {
          _products.addAll(querySnapshot.documents);

          listMessage.addAll(querySnapshot.documents);
        });
        int newSize = _products.length;
        if (oldSize != newSize) {
          _streamController.add(_products);
        } else {
          _isFinish = true;
        }
      }
      _isRequesting = false;
    }
  }

  var stream;
  @override
  void initState() {
    readLocal();
    stream = Firestore.instance
        .collection('messages')
        .document(groupChatId)
        .collection(groupChatId)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((data) => {onChangeData(data.documentChanges)});

    requestNextPage();
    super.initState();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(
        () {
          isShowSticker = false;
        },
      );
    }
  }

  readLocal() async {
    id = prefs.getString('id') ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(
        () {
          isLoading = true;
        },
      );
      uploadFile();
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(
      () {
        isShowSticker = !isShowSticker;
      },
    );
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then(
      (downloadUrl) {
        imageUrl = downloadUrl;
        setState(
          () {
            isLoading = false;
            onSendMessage(imageUrl, 1);
          },
        );
      },
      onError: (err) {
        setState(
          () {
            isLoading = false;
          },
        );
        Fluttertoast.showToast(msg: 'This file is not an image');
      },
    );
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();
      Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(
            DateTime.now().millisecondsSinceEpoch.toString(),
          )
          .setData(
        {
          'idFrom': id,
          'idTo': peerId,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
          'type': type
        },
      );

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == id) {
      // Right (my message)
      return Container(
        padding: EdgeInsets.only(left: 100 * prefs.getDouble('width')),
        width: 200 * prefs.getDouble('width'),
        child: Row(
          children: <Widget>[
            Flexible(
              child: document['type'] == 0
                  // Text
                  ? Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              document['content'],
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.fromLTRB(
                          15.0 * prefs.getDouble('width'),
                          10.0 * prefs.getDouble('height'),
                          15.0 * prefs.getDouble('width'),
                          10.0 * prefs.getDouble('height')),
                      decoration: BoxDecoration(
                        color: prefix0.secondaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    )
                  : document['type'] == 1
                      // Image
                      ? Container(
                          child: Material(
                            child: Container(
                              width: 200 * prefs.getDouble('height'),
                              height: 200 * prefs.getDouble('height'),
                              decoration: BoxDecoration(
                                  color: prefix0.backgroundColor,
                                  shape: BoxShape.circle),
                              child: Image.network(
                                bookedClient.photoUrl,
                                fit: BoxFit.cover,
                                scale: 1.0,
                                loadingBuilder: (BuildContext ctx, Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                prefix0.mainColor),
                                        backgroundColor:
                                            prefix0.backgroundColor,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                          margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                              right: 10.0),
                        )
                      // Sticker
                      : Container(
                          child: new Image.asset(
                            'images/${document['content']}.gif',
                            width: 100.0 * prefs.getDouble('height'),
                            height: 100.0 * prefs.getDouble('height'),
                            fit: BoxFit.cover,
                          ),
                          margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                              right: 10.0),
                        ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      );
    } else {
      // Left (peer message)
      return Container(
        padding: EdgeInsets.only(right: 100 * prefs.getDouble('width')),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        color: backgroundColor,
                        child: bookedClient.photoUrl == null
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(
                                      255,
                                      bookedClient.colorRed,
                                      bookedClient.colorGreen,
                                      bookedClient.colorBlue),
                                  shape: BoxShape.circle,
                                ),
                                height: (35 * prefs.getDouble('height')),
                                width: (35 * prefs.getDouble('height')),
                                child: Center(
                                    child: Text(bookedClient.firstName[0],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25 *
                                                prefs.getDouble('height')))))
                            : Material(
                                child: Container(
                                  width: 35 * prefs.getDouble('height'),
                                  height: 35 * prefs.getDouble('height'),
                                  decoration: BoxDecoration(
                                      color: prefix0.backgroundColor,
                                      shape: BoxShape.circle),
                                  child: Image.network(
                                    bookedClient.photoUrl,
                                    fit: BoxFit.cover,
                                    scale: 1.0,
                                    loadingBuilder: (BuildContext ctx,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    prefix0.mainColor),
                                            backgroundColor:
                                                prefix0.backgroundColor,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(77.5),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: (35 * prefs.getDouble('height'))),
                Flexible(
                  child: document['type'] == 0
                      ? Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                  document['content'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.fromLTRB(
                              15.0 * prefs.getDouble('width'),
                              10.0 * prefs.getDouble('height'),
                              15.0 * prefs.getDouble('width'),
                              10.0 * prefs.getDouble('height')),
                          decoration: BoxDecoration(
                            color: Color(0xff683E99),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          margin: EdgeInsets.only(
                              left: 10.0 * prefs.getDouble('width')),
                        )
                      : document['type'] == 1
                          ? Container(
                              child: Material(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                              margin: EdgeInsets.only(
                                  left: 10.0 * prefs.getDouble('width')),
                            )
                          : Container(
                              child: new Image.asset(
                                'images/${document['content']}.gif',
                                width: 100.0 * prefs.getDouble('height'),
                                height: 100.0 * prefs.getDouble('height'),
                                fit: BoxFit.cover,
                              ),
                              margin: EdgeInsets.only(
                                  bottom:
                                      isLastMessageRight(index) ? 20.0 : 10.0,
                                  right: 10.0),
                            ),
                ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          int.parse(
                            document['timestamp'],
                          ),
                        ),
                      ),
                      style: TextStyle(
                          color: greyColor,
                          fontSize: 13.0 * prefs.getDouble('height'),
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(
                        left: 50.0 * prefs.getDouble('width'),
                        top: 5.0 * prefs.getDouble('height'),
                        bottom: 5.0 * prefs.getDouble('height')),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0 * prefs.getDouble('height')),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(
        () {
          isShowSticker = false;
        },
      );
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (mounted) {
      stream.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding:
          widget.fuckedUpKeyboard == null ? false : true,
      backgroundColor: prefix0.backgroundColor,
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                // List of messages
                buildListMessage(),

                // Input content
                buildInput(),
              ],
            ),

            // Loading
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: new Image.asset(
                  'images/mimi1.gif',
                  width: 50.0 * prefs.getDouble('height'),
                  height: 50.0 * prefs.getDouble('height'),
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: new Image.asset(
                  'images/mimi2.gif',
                  width: 50.0 * prefs.getDouble('height'),
                  height: 50.0 * prefs.getDouble('height'),
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
                child: new Image.asset(
                  'images/mimi3.gif',
                  width: 50.0 * prefs.getDouble('height'),
                  height: 50.0 * prefs.getDouble('height'),
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi4', 2),
                child: new Image.asset(
                  'images/mimi4.gif',
                  width: 50.0 * prefs.getDouble('height'),
                  height: 50.0 * prefs.getDouble('height'),
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: new Image.asset(
                  'images/mimi5.gif',
                  width: 50.0 * prefs.getDouble('height'),
                  height: 50.0 * prefs.getDouble('height'),
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
                child: new Image.asset(
                  'images/mimi6.gif',
                  width: 50.0 * prefs.getDouble('height'),
                  height: 50.0 * prefs.getDouble('height'),
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi7', 2),
                child: new Image.asset(
                  'images/mimi7.gif',
                  width: 50.0 * prefs.getDouble('height'),
                  height: 50.0 * prefs.getDouble('height'),
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: new Image.asset(
                  'images/mimi8.gif',
                  width: 50.0 * prefs.getDouble('height'),
                  height: 50.0 * prefs.getDouble('height'),
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
                child: new Image.asset(
                  'images/mimi9.gif',
                  width: 50.0 * prefs.getDouble('height'),
                  height: 50.0 * prefs.getDouble('height'),
                  fit: BoxFit.cover,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: new BoxDecoration(
          border: new Border(
            top: new BorderSide(color: greyColor2, width: 0.5),
          ),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0 * prefs.getDouble('height'),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(prefix0.mainColor),
                ),
              ),
              color: prefix0.backgroundColor,
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Button send image

          // Edit text

          Padding(
            padding:
                EdgeInsets.symmetric(vertical: 13 * prefs.getDouble('height')),
            child: Container(
              color: prefix0.secondaryColor,
              width: 343 * prefs.getDouble('width'),
              child: TextField(
                keyboardAppearance: Brightness.dark,
                keyboardType: TextInputType.multiline,
                minLines: null,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                focusNode: focusNode,
                controller: textEditingController,
                style: TextStyle(
                    fontSize: 15.0 * prefs.getDouble('height'),
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.only(
                      top: 4.0 * prefs.getDouble('height'),
                      bottom: 4.0 * prefs.getDouble('height'),
                      left: 20 * prefs.getDouble('width')),
                  fillColor: Color.fromARGB(255, 88, 88, 94),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 2 * prefs.getDouble('height'))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                          color: mainColor,
                          style: BorderStyle.solid,
                          width: 2 * prefs.getDouble('height'))),
                  suffixIcon: Padding(
                    padding:
                        EdgeInsets.only(right: 8 * prefs.getDouble('width')),
                    child: new IconButton(
                        icon: new Icon(
                          Icons.send,
                          size: 24 * prefs.getDouble('height'),
                        ),
                        onPressed: () =>
                            onSendMessage(textEditingController.text, 0),
                        color: Colors.white),
                  ),
                  hintStyle: TextStyle(
                      color: Color(0xffFFFFFF),
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.normal),
                  border: InputBorder.none,
                  hintText: 'Type...',
                ),
              ),
            ),
          ),
          // Button send message
        ],
      ),
      constraints: new BoxConstraints(
        minHeight: 76.0 * prefs.getDouble('height'),
        minWidth: double.infinity,
        maxHeight: 176.0 * prefs.getDouble('height'),
        maxWidth: double.infinity,
      ),
      color: prefix0.secondaryColor,
    );
  }

  StreamController<List<DocumentSnapshot>> _streamController =
      StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot> _products = [];

  bool _isRequesting = false;
  bool _isFinish = false;
  bool flag;

  void onChangeData(List<DocumentChange> documentChanges) {
    setState(() {
      documentChanges.forEach((productChange) {
        if (productChange.newIndex <= _products.length) {
          if (productChange.type == DocumentChangeType.added) {
            List<DocumentSnapshot> aux = [];
            _products.forEach((element) {
              aux.add(element);
            });
            _products.clear();
            listMessage.clear();
            _products.add(productChange.document);
            listMessage.add(productChange.document);
            aux.forEach((element) {
              listMessage.add(element);
              _products.add(element);
            });
          }
        }
      });
      if (flag == null) {
        flag = false;
      }
    });
  }

  Widget buildListMessage() {
    if (flag == false) {
      if (_products.length == 1) {
        _products.removeLast();
        listMessage.removeLast();
      }
      flag = true;
    }
    for(int i = 0 ; i < _products.length; i ++) {
      for(int j = 0; j < _products.length; j ++) {
        if(_products[i].documentID == _products[j].documentID && i != j){
          _products.removeAt(i);
        }
      }
    }
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(mainColor),
              ),
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.maxScrollExtent ==
                    scrollInfo.metrics.pixels) {
                  requestNextPage();
                }
                return true;
              },
              child: _products.length != 0
                  ? ListView.builder(
                      padding: EdgeInsets.all(10.0 * prefs.getDouble('height')),
                      itemBuilder: (context, index) => buildItem(
                        index,
                        _products[index],
                      ),
                      itemCount: _products.length,
                      reverse: true,
                      controller: listScrollController,
                    )
                  : Container()),
    );
  }
}
