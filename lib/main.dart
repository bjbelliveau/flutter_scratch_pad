import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_transition_page_route/slide_transition_page_route.dart';
import 'package:unicorndial/unicorndial.dart';

void main() => runApp(FabTest());

class FabTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: Color.fromRGBO(1, 52, 136, 1.0),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Fab Test App',
      home: _FabHomePage(),
    );
  }
}

class _FabHomePage extends StatefulWidget {
  @override
  _FabHomePageState createState() => _FabHomePageState();
}

class _FabHomePageState extends State<_FabHomePage> {
  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: "train",
      backgroundColor: Colors.redAccent,
      mini: true,
      child: Icon(Icons.phone),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SecondScreen()));
      },
    )));

    childButtons.add(UnicornButton(
        currentButton: FloatingActionButton(
            heroTag: "airplane",
            backgroundColor: Colors.greenAccent,
            mini: true,
            onPressed: () {
              Navigator.push(context, SlideLeftRoute(widget: SecondScreen()));
            },
            child: Icon(Icons.email))));

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: <Widget>[
            NavigationPage(
              image: 'fuser.jpg',
              title: 'Fusers',
            ),
            NavigationPage(
              title: "Maint Kits",
              image: 'kit.jpg',
            ),
            NavigationPage(
              title: "Tech Tips",
              image: 'techtips.png',
            ),
            NavigationPage(
              title: "Instructions",
              image: 'instructions.jpg',
            ),
          ],
        ),
      ),
      /*bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.star),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.print),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.radio),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(CupertinoIcons.phone),
              onPressed: () {},
            ),
          ],
        ),
      ),*/
      floatingActionButton: UnicornDialer(
          hasBackground: false,
          parentButtonBackground: Theme.of(context).primaryColor,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.menu),
          childButtons: childButtons),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

final controller = PageController(
  initialPage: 0,
  keepPage: true,
);

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 175.0,
              floating: false,
              pinned: true,
              backgroundColor: Theme.of(context).primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                title: Text(
                  'FUSERS',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontFamily: 'Montserrat'),
                ),
                background: Image.asset(
                  'assets/images/skinnyglobe.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ];
        },
        body: ListView.builder(itemBuilder: (context, index){
          return ListTile(
            title: Text('List Tile'),
            onTap: (){},
            contentPadding: EdgeInsets.all(10.0),
            trailing: Icon(Icons.chevron_right),
          );
        }, itemCount: 20, )
      ),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  final String image;

  const BackgroundImage({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            image,
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Theme.of(context).primaryColor.withOpacity(0.6),
              BlendMode.srcATop),
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15.0,
          sigmaY: 15.0,
        ),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
        ),
      ),
    );
  }
}

class NavigationPage extends StatelessWidget {
  final String image;
  final String title;

  const NavigationPage({Key key, this.image, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imagePrefix = "assets/images/";
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        BackgroundImage(
          image: imagePrefix + image,
        ),
        Card(
          elevation: 2.0,
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: EdgeInsets.only(
              left: 35.0, top: 35.0, right: 35.0, bottom: 100.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: AssetImage(
                  imagePrefix + image,
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.85), BlendMode.srcATop),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image(
                  image: ExactAssetImage('${imagePrefix}skinnyglobe.png'),
                  fit: BoxFit.fitWidth,
                ),
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat'),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Put a few words here to talk about what we're looking at",
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 25.0),
                    onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            maintainState: true,
                            builder: (context) => SecondScreen(),
                          ),
                        ),
                    child: Text(
                      "Click for more info",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Theme.of(context).primaryColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
