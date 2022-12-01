import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/Trade.dart';
import 'HomeScreen.dart';
import 'RateUserScreen.dart';
import 'TradeHistoryScreen.dart';

class TradeDetailsScreen extends StatefulWidget {
  final Trade trade;

  const TradeDetailsScreen({Key? key, required this.trade}) : super(key: key);

  @override
  State<TradeDetailsScreen> createState() => _TradeDetailsScreenState();
}

class _TradeDetailsScreenState extends State<TradeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

      body: Container(
        alignment: Alignment.center, //Set container alignment  then wrap the column with singleChildScrollView
        child: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 30.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: 'Trade Status: '),
                    TextSpan(
                        text: widget.trade.tradeStatus,
                        style: const TextStyle(
                            fontSize: 30.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Text(
                'Sender: ' + widget.trade.senderName,
                style: const TextStyle(fontSize: 20),
              ),
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: 150,
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: ListView.builder(
                    itemCount: widget.trade.senderToys.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                widget.trade.senderToys[i].toyImageURL),
                            radius: 25,
                          ),
                          title: Text(widget.trade.senderToys[i].name),
                          subtitle:
                          Text(widget.trade.senderToys[i].description),
                          onTap: () => {});
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Receiver: ' + widget.trade.receiverName,
                style: const TextStyle(fontSize: 20),
              ),
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: 150,
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ListView.builder(
                    itemCount: widget.trade.receiverToys.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                widget.trade.receiverToys[i].toyImageURL),
                            radius: 25,
                          ),
                          title: Text(widget.trade.receiverToys[i].name),
                          subtitle: Text(widget.trade.receiverToys[i].description),
                          onTap: () => {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const TradeDetailsScreen()),
                            // )
                          });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                      elevation: 12.0,
                      textStyle: const TextStyle(color: Colors.white, fontSize: 16)),
                  child: const Text('Rate this user'),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RateUserScreen(
                              id: widget.trade.receiverId,
                            )));
                  }),
            ]),
      )
      )
    );
  }
  void handleClick(String value) async {
    switch (value) {
      case 'Logout':
        await FirebaseAuth.instance.signOut();
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
