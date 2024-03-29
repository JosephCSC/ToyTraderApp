
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_services/DatabaseService.dart';
import '../models/Trade.dart';
import 'HomeScreen.dart';
import 'TradeHistoryScreen.dart';
import 'authentication/SignInScreen.dart';

class RateUserScreen extends StatefulWidget{
  final String id;
  final Trade trade;

  const RateUserScreen ({Key? key, required this.id, required this.trade}) : super(key: key);
  @override
  State<RateUserScreen> createState() => _RatingState();
}

class _RatingState extends State<RateUserScreen>{
  DatabaseService dbService = DatabaseService();
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  createAlertDialog(BuildContext context,bool flag){
    return showDialog(context: context, builder: (BuildContext context) {
      if (flag==false){
        return AlertDialog(
          title: Text('Rate Successfully!'),
          actions: <Widget>[
            MaterialButton(
                elevation: 5.0,
                child: Text('Back'),
                onPressed: (){
                  Navigator.pop(context);
                })
          ],
        );
      }
      else{
        return AlertDialog(
          title: Text('You have already rated this one!'),
          actions: <Widget>[
            MaterialButton(
                elevation: 5.0,
                child: Text('Back'),
                onPressed: (){
                  Navigator.pop(context);
                })
          ],
        );
      }
    });
  }

  double rating=0;
  @override
  Widget build(BuildContext context) =>Scaffold(
      appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Trade History', 'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
          title: IconButton(
            color: Colors.white,
            iconSize: physicalHeight / 11,
            icon: Image.asset('assets/images/logo.png'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          )
      ),

      body: Center(
          child: Column(
              children:<Widget> [
            SizedBox(
              height:200,
            ),
            RatingBar.builder(
              initialRating: 3,
              minRating:0,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) => setState(() {
                this.rating = rating;
              })),
            TextButton(
                child: const Text('submit'),
                onPressed: () async {
                  if (widget.trade.receiverRatingRcvd==false){
                    await dbService.rateUser(rating, widget.id, widget.trade);
                    widget.trade.receiverRatingRcvd=true;
                    dbService.updateTrade(widget.trade);
                    createAlertDialog(context,widget.trade.receiverRatingRcvd);
                  }
                  else
                    createAlertDialog(context,widget.trade.receiverRatingRcvd);
                }
                ),
          ]
      )
    )
  );
  void handleClick(String value) async {
    switch (value) {
      case 'Logout':
        await FirebaseAuth.instance.signOut();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen(toggleView: toggleView,)),
        );
        break;
      case 'Trade History':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TradeHistory()),
        );
        break;
    }
  }
}