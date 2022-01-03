import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_baby_shop_app/constants/colors.dart';
import 'package:the_baby_shop_app/models/product.dart';
import 'package:the_baby_shop_app/providers/products_provider.dart';
import 'package:the_baby_shop_app/screens/display_details.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:the_baby_shop_app/screens/profile_screen.dart';
import 'package:the_baby_shop_app/services/auth_services.dart';
import 'package:the_baby_shop_app/widgets/notification_button.dart';

import 'cart_screen.dart';
import 'display_products.dart';
import 'search_result.dart';

/// Home Screen of the app
class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

ProductProvider productProvider;
Product girlData;
Product boyData;
Product featuresData;

class _HomeState extends State<Home> {
  //List<Category> categories = [];

  bool homeColor = true;
  bool checkoutColor = false;
  bool girlColor = false;
  bool boyColor = false;
  bool profileColor = false;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final _controller = TextEditingController();
  MediaQueryData mediaQuery;

  void getCallAllFunction() {
    productProvider.getBoysData();
    productProvider.getGirlsData();
    productProvider.getFeaturesData();
    productProvider.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    List<Product> girlsProduct;
    List<Product> boysProduct;
    List<Product> featuresProduct;

    productProvider = Provider.of<ProductProvider>(context);
    getCallAllFunction();

    girlsProduct = productProvider.getGirlsList;
    boysProduct = productProvider.getBoysList;
    featuresProduct = productProvider.getFeaturesList;
    // productProvider.getGirlsList;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: kPrimaryColor,
            ),
      ),
      home: SafeArea(
        child: Scaffold(
          backgroundColor: kBGColor,
          key: _key,

          /// Navigation Drawer
          drawer: _buildMyDrawer(),
          body: ListView(
            children: [
              /// Top App Bar
              _buildAppBar(),
              Column(
                children: [
                  /// Images slider
                  _buildImagesSlider(),
                  const SizedBox(
                    height: 5,
                  ),

                  /// Search box
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _controller,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 14),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: const Icon(Icons.search),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: _controller.clear,
                                      ),
                                      hintText: 'Search for hamper'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black38, blurRadius: 4),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () {
                                  // print("this is the text to search for => ${_controller.text}");
                                  productProvider.getSearchList(
                                      list: featuresProduct);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchResult(
                                              data: featuresProduct,
                                              letter: _controller.text,
                                            )),
                                  );
                                },
                                icon: const Icon(Icons.search),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// Buttons
                  const SizedBox(
                    height: 3,
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: _buildButtonCategory(),
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  /// Grid view products
                  SizedBox(
                    height: 500,
                    child: GridView.builder(
                      itemCount: featuresProduct.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 0.7),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (ctx) => DisplayDetailsScreen(
                                  image: featuresProduct[index].imgName,
                                  name: featuresProduct[index].name,
                                  price: featuresProduct[index].price,
                                  description: featuresProduct[index].description,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Container(
                                    width: 160,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                          featuresProduct[index].imgName,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      featuresProduct[index].name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: kTextPurple,
                                      ),
                                    ),
                                    Text(
                                      "RM ${featuresProduct[index].price}",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Drawer
  Widget _buildMyDrawer() {
    List<Product> girlsproduct = productProvider.getGirlsList;
    List<Product> boysproduct = productProvider.getBoysList;
    return Drawer(
      child: ListView(
        children: <Widget>[
          //_buildUserAccountsDrawerHeader(),
          ListTile(
            selected: homeColor,
            onTap: () {
              setState(() {
                homeColor = true;
                girlColor = false;
                checkoutColor = false;
                boyColor = false;
                profileColor = false;
              });
            },
            leading: const Icon(
              Icons.home,
              color: Colors.grey,
            ),
            title: const Text(
              "Home",
              style: TextStyle(
                color: kTextBlack,
              ),
            ),
          ),
          const Divider(
            color: kPrimaryColor,
          ),
          ListTile(
            selected: boyColor,
            onTap: () {
              setState(() {
                boyColor = true;
                girlColor = false;
                homeColor = false;
                profileColor = false;
                checkoutColor = false;
              });
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (ctx) => DisplayProducts(
                        name: "Boys",
                        data: boysproduct,
                      )));
            },
            leading: const Icon(
              Icons.checkroom,
              color: kSecondaryColor,
            ),
            title: const Text(
              "Boys",
              style: TextStyle(
                color: kTextBlack,
              ),
            ),
          ),
          ListTile(
            selected: girlColor,
            onTap: () {
              setState(() {
                girlColor = false;
                boyColor = false;
                homeColor = false;
                profileColor = true;
                checkoutColor = false;
              });
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (ctx) => DisplayProducts(
                          name: "Girls",
                          data: girlsproduct,
                        )
                    //ProfileScreen(),
                    ),
              );
            },
            leading: const Icon(
              Icons.checkroom,
              color: kPrimaryColor,
            ),
            title: const Text(
              "Girls",
              style: TextStyle(
                color: kTextBlack,
              ),
            ),
          ),
          ListTile(
            selected: checkoutColor,
            onTap: () {
              setState(() {
                checkoutColor = true;
                girlColor = false;
                homeColor = false;
                profileColor = false;
                boyColor = false;
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => const CartScreen()));
            },
            leading: const Icon(Icons.shopping_cart),
            title: const Text(
              "Cart",
              style: TextStyle(
                color: kTextBlack,
              ),
            ),
          ),
          ListTile(
            selected: profileColor,
            onTap: () {
              setState(() {
                profileColor = true;
                checkoutColor = false;
                girlColor = false;
                homeColor = false;
                boyColor = false;
              });
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => const ProfileScreen()));
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (ctx) => const Profile()));
            },
            leading: const Icon(Icons.person),
            title: const Text(
              "Profile",
              style: TextStyle(
                color: kTextBlack,
              ),
            ),
          ),
          const Divider(color: kPrimaryColor),
          ListTile(
            /// Logout: Back to sign in screen
            onTap: () async {
              await logOut(context);
            },
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: kTextBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Custom app bar
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        //space between widgets
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),

            /// Drawer icon
            child: IconButton(
              icon: const Icon(
                Icons.dashboard,
                color: kPrimaryColor,
              ),
              onPressed: () {
                _key.currentState.openDrawer();
                //Scaffold.of(context).openDrawer();
                // you can see its working
              },
            ),
          ),
          Column(
            children: const [
              Text('The'),
              Text(
                'Baby Shop',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const NotificationButton(),
          //now create avatar user profile pic
          // const CircleAvatar(
          //   backgroundImage: NetworkImage(profileUrl),
          //   backgroundColor: kPrimaryColor,
          // ),
        ],
      ),
    );
  }

  /// Images slider
  Widget _buildImagesSlider() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 200,
        child: Carousel(
          images: const [
            // image path
            AssetImage('assets/pinkygirl78.jpg'),
            AssetImage('assets/mybabyboy65.jpg'),
            AssetImage('assets/happinesscollection94.jpeg'),
            AssetImage('assets/littlesurprise85.jpg'),
          ],
          borderRadius: true,
          radius: const Radius.circular(30),
          dotBgColor: Colors.transparent,
          dotIncreasedColor: kPrimaryColor,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: const Duration(
            milliseconds: 800,
          ),
        ),
      ),
    );
  }

  /// Boys and Girls categories button
  Widget _buildButtonCategory() {
    List<Product> girlsproduct = productProvider.getGirlsList;
    List<Product> boysproduct = productProvider.getBoysList;
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            Text(
              "Category",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /// Button 'Boy'
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  elevation: 1,
                  padding: const EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayProducts(
                        name: "Boys",
                        data: boysproduct,
                      ),
                    ),
                  );
                },
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: kLinearGradientBlue,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: 160.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Boys",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  elevation: 1,
                  padding: const EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayProducts(
                        name: "Girls",
                        data: girlsproduct,
                      ),
                    ),
                  );
                },
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: kLinearGradientPink,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxWidth: 160.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Girls",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
