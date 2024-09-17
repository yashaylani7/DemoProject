import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:projectsub/screens/search.dart';

import 'cart.dart';
import 'kyc.dart'; // For auto-scrolling banners

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final List<String> banners = [
    'assets/img_2.png', // Replace with your banner image paths
    'assets/img_7.png',
    'assets/img_4.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DealsDray'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search action
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()), // Define SearchPage
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Cart action
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()), // Define CartPage
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Auto-scrolling Banner Section
          Expanded(
            flex: 2, // Flex for the banner section
            child: CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.25,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                enlargeCenterPage: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
              ),
              items: banners.map((banner) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.asset(
                        banner,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 10), // Spacing between banner and other content

          // KYC Pending Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              color: Colors.blueAccent,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KYC Pending',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'You need to provide the required documents for your account activation. Please complete your KYC process to unlock all features.',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Handle KYC Click Action
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => KycPage()), // Define KycPage
                      );
                    },
                    child: Text(
                      'Complete KYC',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10), // Spacing between sections

          // Categories Section
          Expanded(
            flex: 1,
            child: GridView.count(
              crossAxisCount: 4,
              children: <Widget>[
                categoryItem('Mobile', Icons.phone_android),
                categoryItem('Laptop', Icons.laptop_mac),
                categoryItem('Camera', Icons.camera_alt),
                categoryItem('LED', Icons.tv),
                // Add more categories if needed
              ],
            ),
          ),

          SizedBox(height: 10), // Spacing between sections

          // Exclusive Deals Section
          Expanded(
            flex: 2,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                exclusiveDealItem('assets/img_4.png', '32% Off'),
                exclusiveDealItem('assets/img_5.png', '14% Off'),
                exclusiveDealItem('assets/img_6.png', '24% Off'),
                exclusiveDealItem('assets/img_2.png', '10% Off'),

                // Add more deals if needed
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey,
        currentIndex: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home',backgroundColor: Colors.blueGrey),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories',backgroundColor: Colors.blueGrey),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Deals',backgroundColor: Colors.blueGrey),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart',backgroundColor: Colors.blueGrey),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile',backgroundColor: Colors.blueGrey),
        ],
        onTap: (index) {
          // Handle navigation between different tabs
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/categories');
              break;
            case 2:
              Navigator.pushNamed(context, '/deals');
              break;
            case 3:
              Navigator.pushNamed(context, '/cart');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  Widget categoryItem(String title, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 40),
        SizedBox(height: 5),
        Text(title),
      ],
    );
  }

  Widget exclusiveDealItem(String imagePath, String discount) {
    return Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imagePath, fit: BoxFit.fill, height: 100),
          SizedBox(height: 10),
          Text(discount, style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
