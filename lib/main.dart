import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'firebase_options.dart';
import 'signaling.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Signaling signaling = Signaling();
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');

  bool isClient = false;

  @override
  void initState() {
    if (isClient) {
      localRenderer.initialize();
    } else {}

    signaling.onAddRemoteStream = ((stream) {
      remoteRenderer.srcObject = stream;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to Flutter Explained - WebRTC"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    signaling.openUserMedia(localRenderer, remoteRenderer);
                  },
                  child: const Text("Open camera & microphone"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    roomId = await signaling.createRoom(remoteRenderer);
                    textEditingController.text = roomId!;
                    setState(() {});
                  },
                  child: const Text("Create room"),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add roomId
                    signaling.joinRoom(
                      textEditingController.text,
                      remoteRenderer,
                    );
                  },
                  child: const Text("Join room"),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    signaling.hangUp(localRenderer);
                  },
                  child: const Text("Hangup"),
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: RTCVideoView(localRenderer, mirror: true)),
                  Expanded(child: RTCVideoView(remoteRenderer)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Join the following Room: "),
                Flexible(
                  child: TextFormField(
                    controller: textEditingController,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 8)
        ],
      ),
    );
  }
}




// // ignore_for_file: avoid_print

// import 'dart:async';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';

// import 'firebase_options.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return const NeumorphicApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       themeMode: ThemeMode.dark,
//       theme: NeumorphicThemeData(
//         baseColor: Color(0xFFFFFFFF),
//         lightSource: LightSource.topLeft,
//       ),
//       darkTheme: NeumorphicThemeData(
//         baseColor: Color(0xFF3E3E3E),
//         lightSource: LightSource.topLeft,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   Timer? timer;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         title: const Text('Sewage Robot Controller'),
//       ),
//       backgroundColor: NeumorphicTheme.baseColor(context),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 NeumorphicButton(
//                   onPressed: () {},
//                   style: const NeumorphicStyle(
//                     shape: NeumorphicShape.convex,
//                     depth: 2,
//                     boxShape: NeumorphicBoxShape.circle(),
//                   ),
//                   padding: const EdgeInsets.all(12.0),
//                   child: GestureDetector(
//                     onLongPressStart: (detail) {
//                       timer = Timer.periodic(const Duration(milliseconds: 100),
//                           (timer) {
//                         print("F");
//                       });
//                     },
//                     onLongPressEnd: (detail) {
//                       if (timer != null) {
//                         timer!.cancel();
//                       }
//                     },
//                     child: const Icon(
//                       Icons.arrow_upward_rounded,
//                       color: Colors.white,
//                       size: 80,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 NeumorphicButton(
//                   onPressed: () {
//                     print("L");
//                   },
//                   style: const NeumorphicStyle(
//                     shape: NeumorphicShape.convex,
//                     depth: 2,
//                     boxShape: NeumorphicBoxShape.circle(),
//                   ),
//                   padding: const EdgeInsets.all(12.0),
//                   child: const Icon(
//                     Icons.arrow_back_rounded,
//                     color: Colors.white,
//                     size: 80,
//                   ),
//                 ),
//                 NeumorphicButton(
//                   onPressed: () {
//                     print("R");
//                   },
//                   style: const NeumorphicStyle(
//                     shape: NeumorphicShape.convex,
//                     depth: 2,
//                     boxShape: NeumorphicBoxShape.circle(),
//                   ),
//                   padding: const EdgeInsets.all(12.0),
//                   child: const Icon(
//                     Icons.arrow_forward_rounded,
//                     color: Colors.white,
//                     size: 80,
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 NeumorphicButton(
//                   onPressed: () {
//                     print("B");
//                   },
//                   style: const NeumorphicStyle(
//                     shape: NeumorphicShape.convex,
//                     depth: 2,
//                     boxShape: NeumorphicBoxShape.circle(),
//                   ),
//                   padding: const EdgeInsets.all(12.0),
//                   child: GestureDetector(
//                     onLongPressStart: (detail) {
//                       timer = Timer.periodic(const Duration(milliseconds: 100),
//                           (timer) {
//                         print("B");
//                       });
//                     },
//                     onLongPressEnd: (detail) {
//                       if (timer != null) {
//                         timer!.cancel();
//                       }
//                     },
//                     child: const Icon(
//                       Icons.arrow_downward_rounded,
//                       color: Colors.white,
//                       size: 80,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.only(left: 30.0, right: 30.0),
//               child: Neumorphic(
//                 style: NeumorphicStyle(
//                   shape: NeumorphicShape.concave,
//                   depth: -5,
//                   boxShape: NeumorphicBoxShape.roundRect(
//                     BorderRadius.circular(12),
//                   ),
//                 ),
//                 padding: const EdgeInsets.all(12.0),
//                 child: Container(
//                   height: 200.0,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
