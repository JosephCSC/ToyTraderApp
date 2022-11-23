import 'package:flutter/material.dart';
import 'package:toy_trader/models/Toy.dart';
import '../firebase_services/DatabaseService.dart';
import 'package:toy_trader/widgets/MessageList.dart';
import 'package:toy_trader/widgets/ToyGridList.dart';
import '../models/ProfileInfo.dart';

class ConversationsScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: MessageList())
    );
  }
}



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DatabaseService dbService = DatabaseService();
  late ProfileInfo userProfile;

  @override
  Widget build(BuildContext context) {
    ProfileInfo userProfile;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
        alignment: Alignment.topCenter,
        child: FutureBuilder<ProfileInfo?>(
          future: dbService.getProfileInfo(""),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              userProfile = snapshot.data!;
              return Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    padding: const EdgeInsets.all(200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 3, color: Colors.blue),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(userProfile.profileImageUrl)
                      )
                    )
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    alignment: Alignment.centerLeft,
                    child: Text('Name: ' + userProfile.screenName, style: const TextStyle(fontSize: 20))
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: const Text('My Toys',
                    style: TextStyle(fontSize: 30),)
                  ),
                  Flexible(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        decoration: BoxDecoration(
                          /*border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),

                           */
                        ),
                        child: ToyGridList(userProfile.toys)
                    )
                  )
                ],
              );
            }
            else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}


class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DatabaseService dbService = DatabaseService();
  final myController = TextEditingController();
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as ProfileInfo?;
    ProfileInfo? profileInfo;
    if(arg != null) {
      profileInfo = arg;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        // color: const Color(0xffC4DFCB),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding : EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: TextField(
                      controller: myController,
                      onSubmitted: (value) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {});
                      },
                      decoration: InputDecoration(

                          suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {});
                              } //Need to be linked with search result
                          ),
                          hintText: 'Search for toys',
                          border: OutlineInputBorder()
                      ),
                    )
                ),

                Container(
                  child: FutureBuilder<List<Toy>>(
                    future: dbService.getMainFeed(myController.text),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Toy> toyList = snapshot.data!;

                        return Column(
                          children: [
                            Flexible(
                                child: ToyGridList(toyList)
                            )
                          ]

                        );

                      }
                      else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                  width: deviceWidth(context),
                 height: deviceHeight(context) *.65,
                 alignment: Alignment.topLeft,
               ),
              ],
            )
        ),
      ),
    );
  }

}

//longlist, need to get data from data base and covert
//into widget data type
//will be moved into SearchToyScreen and rebuild framework.
List<String> getList(){
  var items=List<String>.generate(10,(counter)=>"Toy $counter");
  return items;
}

Widget getListView(){
  var listitems = getList();
  var listView = ListView.builder(
      itemBuilder:(context, index){
        return ListTile(
          title: Text(listitems[index])
        );
      }
  );
  return listView;
}
double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;
double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;


