// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';
import 'package:go_router/go_router.dart';
import 'package:surplus/bloc/friend/friend_posts_bloc.dart';
import 'package:surplus/data/models/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:surplus/bloc/location/location_bloc.dart';
import 'package:surplus/bloc/user/user_bloc.dart';
import 'package:surplus/data/models/chat.dart';
import 'package:surplus/utils/helpers.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.chat});

  // Need for socket
  final Chat chat;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final streamOf = BehaviorSubject<List<Message>>();
  final status = BehaviorSubject<bool>.seeded(false);
  List<Uint8List> selectedImages = [];
  io.Socket? socket;

  Future<List<Uint8List>> _selectFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: true,
    );
    final files = <Uint8List>[];
    if (result != null) {
      final filesOf = result.files;
      for (var element in filesOf) {
        final bytes = element.bytes;
        // print('\x1B[32mbytes: $bytes\x1B[0m');
        if (bytes != null) {
          files.add(bytes);
        }
      }
    }
    setState(() {
      selectedImages = files;
    });
    return files;
  }

  @override
  void initState() {
    super.initState();
    streamOf.add(<Message>[]);
    initSocket();
  }

  Future<void> initSocket() async {
    //! LOCAL
    const String url = 'http://192.168.1.139:5000/';
    // const String url = 'http://192.168.200.87:5000/';

    //! SERVER
    // const String url = "https://surplus-84pe.onrender.com/";

    socket = io.io(
      url, // server url
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'reconnectionAttempts': 5,
        'reconnectionDelay': 1000,
        'reconnectionDelayMax': 5000,
      },
    );

    /// connect event
    socket?.connect();

    socket?.on(
      'connect',
      (_) => null,
    ); // socket.id is the unique identifier for the socket

    /// disconnect event
    socket?.on(
      'disconnect',
      (_) => null,
    );
    socket?.on(
      'connect_error',
      (_) => null,
    );

    /// error event
    socket?.on(
      'error',
      (_) => null,
    );

    /// connect to help room
    socket?.emit(
      'message',
      <String, dynamic>{
        'chatId': '${widget.chat.id}',
        'sender': BlocProvider.of<UserBloc>(context).state.user.id
      },
    );

    /// listen to chat room [chatId]
    socket?.on(
      "message",
      (messages) async {
        // print('\x1B[35m(server emitted message event)\x1B[0m');
        final parsedListOfMessages = List<Message>.from(
          messages
                  ?.map(
                    (e) {
                      final message = e as Map<String, dynamic>;
                      // print('message: $message');
                      return Message.fromJson(message);
                    },
                  )
                  .toSet()
                  .toList() ??
              <Message>[],
        );

        // final lastOfStream = streamOf.valueOrNull ?? <Message>[];

        streamOf.add([
          // ...lastOfStream,
          ...parsedListOfMessages,
        ]);
      },
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    streamOf.close();
    socket?.disconnect();
    socket?.clearListeners();
    socket?.close();
    socket?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String profilePic = '';
    String name = '';
    User? friend;

    final String userId =
        BlocProvider.of<UserBloc>(context).state.user.id ?? '';

    if (widget.chat.to?.id == userId) {
      profilePic = widget.chat.from?.profilePic ?? '';
      name = widget.chat.from?.name ?? '';
      friend = widget.chat.from;
    } else {
      profilePic = widget.chat.to?.profilePic ?? '';
      name = widget.chat.to?.name ?? '';
      friend = widget.chat.to;
    }

    return StreamBuilder<List<Message>>(
      stream: streamOf,
      builder: (context, snapshot) {
        final messages = snapshot.data ?? [];
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFFF15A29),
            flexibleSpace: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(profilePic),
                        maxRadius: 20,
                      ),
                      onTap: () {
                        context.pushNamed('friend', extra: friend);

                        context
                            .read<FriendPostsBloc>()
                            .add(FriendPostLoadEvent(userId: friend?.id ?? ''));
                      },
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                padding: const EdgeInsets.all(10),
                color: Colors.black,
                iconSize: 28,
                onPressed: () async {
                  // final call = Uri.parse('tel:+91 ${friend!.phone}');
                  // if (await canLaunchUrl(call)) {
                  //   launchUrl(call);
                  // } else {
                  //   throw 'Could not launch $call';
                  // }

                  socket?.emit(
                    'sendMessage',
                    <String, dynamic>{
                      'chatId': '${widget.chat.id}',
                      'message': 'Requested For Phone Number',
                      'sender': userId,
                    },
                  );
                },
                icon: const Icon(Icons.call),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: messages.reversed.toList().length,
                    reverse: true,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      final String time = timeConverted(
                          time: messages.reversed
                              .toList()[index]
                              .timestamp
                              .toString());

                      return Align(
                        alignment:
                            (messages.reversed.toList()[index].sender == userId
                                ? Alignment.topRight
                                : Alignment.topLeft),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 45,
                            maxHeight: MediaQuery.of(context).size.height,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: (messages.reversed.toList()[index].sender ==
                                    userId
                                ? Colors.grey.shade200
                                : Colors.blue[200]),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 30,
                                    top: 10,
                                    bottom: 20,
                                  ),
                                  child: messages.reversed
                                                  .toList()[index]
                                                  .content !=
                                              null &&
                                          messages.reversed
                                              .toList()[index]
                                              .content!
                                              .startsWith('https://ting-ting')
                                      ? Image.network(
                                          messages.reversed
                                              .toList()[index]
                                              .content!,
                                          height: 200,
                                          width: 150,
                                          fit: BoxFit.cover,
                                        )
                                      : Linkify(
                                          onOpen: (link) async {
                                            //  print(Uri.tryParse(link.url)!);

                                            if (await canLaunchUrl(
                                              Uri.tryParse(link.url)!,
                                            )) {
                                              await canLaunchUrl(
                                                  Uri.tryParse(link.url)!);
                                              await launchUrl(
                                                Uri.tryParse(link.url)!,
                                                mode:
                                                    LaunchMode.inAppBrowserView,
                                              );
                                            } else {
                                              throw 'Could not launch Google Maps';
                                            }
                                          },
                                          text: messages.reversed
                                                  .toList()[index]
                                                  .content ??
                                              '',
                                          style: GoogleFonts.montserrat(
                                            color: messages.reversed
                                                            .toList()[index]
                                                            .content !=
                                                        null &&
                                                    messages.reversed
                                                        .toList()[index]
                                                        .content!
                                                        .startsWith(
                                                            'https://ting-ting')
                                                ? Colors.blue
                                                : Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 5),
                                Positioned(
                                  bottom: 4,
                                  right: 6,
                                  child: Text(
                                    time,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      // images
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.memory(
                                selectedImages[index],
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.photo),
                        onPressed: () async {
                          final files = await _selectFiles();

                          if (files.isNotEmpty) {
                            try {
                              final base64Files = files
                                  .map((e) => base64Encode(e.toList()))
                                  .toList();

                              socket?.emit(
                                'message',
                                <String, dynamic>{
                                  'chatId': '${widget.chat.id}',
                                  'content': [...base64Files],
                                  'sender': userId,
                                },
                              );
                            } on Exception catch (_) {
                              throw Exception(
                                  '\x1B[31merror sending files\x1B[0m');
                            }
                          }
                        },
                        color: Colors.black,
                      ),

                      IconButton(
                        onPressed: () {
                          final double lat =
                              BlocProvider.of<LocationBloc>(context)
                                      .state
                                      .position
                                      ?.latitude ??
                                  0.0;
                          final double long =
                              BlocProvider.of<LocationBloc>(context)
                                      .state
                                      .position
                                      ?.longitude ??
                                  0.0;

                          final result =
                              'https://www.google.com/maps/search/?api=1&query=$lat,$long';

                          socket?.emit(
                            'sendMessage',
                            <String, dynamic>{
                              'chatId': '${widget.chat.id}',
                              'message': result,
                              'sender': userId,
                            },
                          );
                        },
                        icon: const Icon(Icons.location_on),
                      ),

                      FloatingActionButton(
                        onPressed: () {
                          final message = messageController.text
                              .trim(); // Get the message text

                          if (message.isNotEmpty) {
                            // Send message
                            socket?.emit(
                              'sendMessage',
                              <String, dynamic>{
                                'chatId': '${widget.chat.id}',
                                'message': message,
                                'sender': userId,
                              },
                            );
                          } else if (selectedImages.isNotEmpty) {
                            // Send image files
                            try {
                              final base64Files = selectedImages
                                  .map((e) => base64Encode(e.toList()))
                                  .toList();

                              socket?.emit(
                                'sendMessage',
                                <String, dynamic>{
                                  'chatId': '${widget.chat.id}',
                                  'message': [...base64Files],
                                  'sender': userId,
                                },
                              );
                            } on Exception catch (_) {
                              throw Exception(
                                  '\x1B[31merror sending files\x1B[0m');
                            }
                          }

                          // Clear message input and selected images
                          setState(() {
                            messageController.clear();
                            selectedImages.clear();
                          });
                        },
                        backgroundColor: const Color(0xFFF15A29),
                        elevation: 0,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// final Widget msgcard =  Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color:
//                                   (messages.reversed.toList()[index].sender ==
//                                           userId
//                                       ? Colors.grey.shade200
//                                       : Colors.blue[200]),
//                             ),
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   messages.reversed.toList()[index].content ??
//                                       '',
//                                   style: GoogleFonts.montserrat(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 Text(
//                                   time,
//                                   style: GoogleFonts.montserrat(
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.normal,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
