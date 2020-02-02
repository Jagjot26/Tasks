import 'package:flutter/material.dart';
import 'signin_screen.dart';

class HomeScreen extends StatefulWidget {
  static final id = "HomeSceenRoute";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  pushToSignInScreen(BuildContext context, bool isOwner) {
    if (isOwner) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(isOwner: true),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(isOwner: false),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.17,
                        ),
                        GestureDetector(
                          onTap: () => pushToSignInScreen(context, true),
                          child: CircleAvatar(
                              child: Image.asset('images/man.png'), radius: 55),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        GestureDetector(
                          onTap: () => pushToSignInScreen(context, true),
                          child: Text(
                            "ShopOwner",
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  color: Colors.blue[500],
                ),
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.17,
                        ),
                        GestureDetector(
                          onTap: () => pushToSignInScreen(context, false),
                          child: CircleAvatar(
                              child: Image.asset('images/boy.png'), radius: 55),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        GestureDetector(
                          onTap: () => pushToSignInScreen(context, false),
                          child: Text(
                            "Worker",
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  color: Color(0xff8000ff),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.445,
              ),
              Center(
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.038).animate(_controller),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.13,
                    width: MediaQuery.of(context).size.width * 0.23,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/notes.png'),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Color(0xff684fd2)
