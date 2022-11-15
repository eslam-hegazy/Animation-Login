import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rive/rive.dart';

import 'AnimationEnum.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Artboard? riveArtboard;
  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerLookLeft;
  late RiveAnimationController controllerLookRight;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String testEmail = "eslam@gmail.com";
  String testPassword = "123456";
  final passwordFocusNode = FocusNode();

  bool isLookingLeft = false;
  bool isLookingRight = false;

  void removeAllControllers() {
    riveArtboard?.artboard.removeController(controllerIdle);
    riveArtboard?.artboard.removeController(controllerHandsUp);
    riveArtboard?.artboard.removeController(controllerHandsDown);
    riveArtboard?.artboard.removeController(controllerLookLeft);
    riveArtboard?.artboard.removeController(controllerLookRight);
    riveArtboard?.artboard.removeController(controllerSuccess);
    riveArtboard?.artboard.removeController(controllerFail);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addIdleController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerIdle);
    debugPrint("controllerIdle");
  }

  void addHandsUpController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsUp);
    debugPrint("controllerHandsUp");
  }

  void addHandsDownController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerHandsDown);
    debugPrint("controllerHandsDown");
  }

  void addSuccessController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerSuccess);
    debugPrint("controllerSuccess");
  }

  void addFailController() {
    removeAllControllers();
    riveArtboard?.artboard.addController(controllerFail);
    debugPrint("controllerFail");
  }

  void addLookRightController() {
    removeAllControllers();
    isLookingRight = true;
    riveArtboard?.artboard.addController(controllerLookRight);
    debugPrint("controllerLookRight");
  }

  void addLookLeftController() {
    removeAllControllers();
    isLookingLeft = true;
    riveArtboard?.artboard.addController(controllerLookLeft);
    debugPrint("controllerLookLeft");
  }

  void checkForPasswordFocusNodeToChangeAnimationState() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addHandsUpController();
      } else if (!passwordFocusNode.hasFocus) {
        addHandsDownController();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerLookRight = SimpleAnimation(AnimationEnum.Look_down_riht.name);
    controllerLookLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);

    rootBundle.load('assets/animated_login_screen.riv').then((data) {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;
      artboard.addController(controllerIdle);
      setState(() {
        riveArtboard = artboard;
      });
    });

    checkForPasswordFocusNodeToChangeAnimationState();
  }

  void validateEmailAndPassword() {
    Future.delayed(const Duration(seconds: 1), () {
      if (formKey.currentState!.validate()) {
        addSuccessController();
      } else {
        addFailController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Login Screen',
          style: TextStyle(
              color: Colors.black,
              fontStyle: FontStyle.italic,
              decorationStyle: TextDecorationStyle.dashed),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.5,
                child: riveArtboard == null
                    ? const SizedBox.shrink()
                    : Rive(
                        artboard: riveArtboard!,
                      ),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          labelText: "Email",
                          hintText: "Enter Your Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Correct Email";
                          }
                          null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty &&
                              value.length < 15 &&
                              !isLookingLeft) {
                            addLookLeftController();
                          } else if (value.isNotEmpty &&
                              value.length > 15 &&
                              !isLookingRight) {
                            addLookRightController();
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 25,
                      ),
                      TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            labelText: "Password",
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          focusNode: passwordFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Correct Password";
                            }
                            null;
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 18,
                      ),
                      MaterialButton(
                        elevation: 5,
                        onPressed: () {
                          passwordFocusNode.unfocus();
                          validateEmailAndPassword();
                        },
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decorationStyle: TextDecorationStyle.double,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
