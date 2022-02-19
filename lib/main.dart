import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'dart:js' as js;
import 'dart:math';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const MyApp());
}

const Color mainTheme = Color(0xFF128C7E);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },

      child: MaterialApp(
        title: 'Quickchat for whatsapp',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.teal,
        ),
        home: const MyHomePage(title: 'Quick chat for whatsapp'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String urll = 'https://api.whatsapp.com/send?phone=';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();
  String _phoneNumber = '';
  List arr = [];
  final _shakeKey = GlobalKey<ShakeWidgetState>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        leading: const Icon(FontAwesomeIcons.whatsapp),
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          padding: EdgeInsets.all(30),

          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          //color: mainTheme,

          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/wallpaper.png'),
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Start whatsapp conversations without creating new contacts",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                    ShakeWidget(
                      key: _shakeKey,
                      // 5. configure the animation parameters
                      shakeCount: 3,
                      shakeOffset: 10,
                      shakeDuration: Duration(milliseconds: 400),

                      child: Container(
                        padding: EdgeInsets.all(30),
                        child: InternationalPhoneNumberInput(
                          initialValue: PhoneNumber(isoCode: 'JO'),
                          selectorTextStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                          textFieldController: controller,
                          textStyle:
                              TextStyle(color: Colors.white, fontSize: 16),
                          inputDecoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "Phone number",
                            hintStyle:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          selectorConfig: SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            setSelectorButtonAsPrefixIcon: true,
                            leadingPadding: 20,
                            useEmoji: true,
                          ),
                          formatInput: true,
                          autoFocus: true,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          onInputChanged: (PhoneNumber num) {
                            print(num.phoneNumber);
                            // formKey.save();
                          },
                          onInputValidated: (bool value) {
                            print("onInputValidated " + value.toString());
                            // setState(() {
                            //   _phoneIsValid = value;
                            // });
                          },
                          onSaved: (PhoneNumber number) {
                            setState(() {
                              _phoneNumber = (number.phoneNumber)!;
                            });
                          },
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 250,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                print('MSG BUTTON');
                                final form = formKey.currentState;

                                if (form != null && !form.validate()) {
                                  _shakeKey.currentState?.shake();
                                } else {
                                  form?.save();
                                  print(urll + _phoneNumber);
                                  js.context.callMethod(
                                      'open', [urll + _phoneNumber]);
                                }
                                // js.context.callMethod('open', [urll+_phoneNumber]);

                                // processPhoneNumber();
                              });
                            },
                            style: defButton(Colors.teal),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.chat),
                                  Container(
                                    width: 8,
                                  ),
                                  Text(
                                    "Start conversation",
                                    style: TextStyle(fontSize: 17),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                print('QR Button');
                                final form = formKey.currentState;

                                if (form != null && !form.validate()) {
                                  _shakeKey.currentState?.shake();
                                } else {
                                  form?.save();
                                  print(urll + _phoneNumber);
                                  if (arr.isEmpty) {
                                    arr.add(QrImage(
                                      data: urll + _phoneNumber,
                                      version: QrVersions.auto,
                                      size: 300,
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.all(10),
                                    ));
                                  } else {
                                    arr[0] = QrImage(
                                      data: urll + _phoneNumber,
                                      version: QrVersions.auto,
                                      size: 300,
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.all(10),
                                    );
                                  }
                                }
                                // js.context.callMethod('open', [urll+_phoneNumber]);

                                // processPhoneNumber();
                              });
                            },
                            style: defButton((Colors.grey[800])!),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.qr_code),
                                  Container(
                                    width: 8,
                                  ),
                                  Text("Get QR code",
                                      style: TextStyle(fontSize: 17))
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 10,
                      width: 10,
                    ),
                    Text(
                      "Not affiliated with whatsapp",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    arr.isEmpty
                        ? Container()
                        : Container(
                            child: Column(children: [
                              arr[0],
                              Container(
                                width: 10,
                                height: 10,
                              ),
                              Text(
                                'Save the QR Code to start a conversation with ${_phoneNumber} when scanned',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              )
                            ]),
                            padding: EdgeInsets.all(15),
                          ),
                    SizedBox.fromSize(size: Size(10, 10))
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  ButtonStyle defButton(Color fillColor) {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.all(fillColor),
        elevation: MaterialStateProperty.all(
            10) // maximumSize: MaterialStateProperty.all(Size(200, 30))
        );
  }
}

class SineCurve extends Curve {
  SineCurve({this.count = 3});

  final double count;

  // 2. override transformInternal() method
  @override
  double transformInternal(double t) {
    return sin(count * 2 * pi * t);
  }
}

abstract class AnimationControllerState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {
  AnimationControllerState(this.animationDuration);

  final Duration animationDuration;
  late final animationController =
      AnimationController(vsync: this, duration: animationDuration);

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    Key? key,
    required this.child,
    required this.shakeOffset,
    this.shakeCount = 3,
    this.shakeDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  // 1. pass a child widget
  final Widget child;

  // 2. configurable properties
  final double shakeOffset;
  final int shakeCount;
  final Duration shakeDuration;

  // 3. pass the shakeDuration as an argument to ShakeWidgetState. See below.
  @override
  ShakeWidgetState createState() => ShakeWidgetState(shakeDuration);
}

class ShakeWidgetState extends AnimationControllerState<ShakeWidget> {
  ShakeWidgetState(Duration duration) : super(duration);

  // 1. create a Tween
  late Animation<double> _sineAnimation = Tween(
    begin: 0.0,
    end: 1.0,
    // 2. animate it with a CurvedAnimation
  ).animate(CurvedAnimation(
    parent: animationController,
    // 3. use our SineCurve
    curve: SineCurve(count: widget.shakeCount.toDouble()),
  ));

  @override
  Widget build(BuildContext context) {
    // 1. return an AnimatedBuilder
    return AnimatedBuilder(
      // 2. pass our custom animation as an argument
      animation: _sineAnimation,
      // 3. optimization: pass the given child as an argument
      child: widget.child,
      builder: (context, child) {
        return Transform.translate(
          // 4. apply a translation as a function of the animation value
          offset: Offset(_sineAnimation.value * widget.shakeOffset, 0),
          // 5. use the child widget
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // 1. register a status listener
    animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    // 2. dispose it when done
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    // 3. reset animationController when the animation is complete
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shake() {
    animationController.forward();
  }
}
