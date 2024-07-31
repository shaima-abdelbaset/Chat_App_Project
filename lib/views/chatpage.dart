
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubitchatapp/constant.dart';
import 'package:cubitchatapp/model/messagemodel.dart';
import 'package:cubitchatapp/widgets/customchatbuble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chatpage extends StatefulWidget {
  //const Chatpage({Key? key}) : super(key: key);
static String id="chatPage";
  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final  ScrollController _controller = ScrollController();

  CollectionReference messages = FirebaseFirestore.instance.collection('messages');

TextEditingController controller=TextEditingController();

  @override
  Widget build (BuildContext context){
    var email=ModalRoute.of(context)!.settings.arguments as String;

    return StreamBuilder<QuerySnapshot>(
    stream: messages.orderBy(KCreatedAt ,descending:true).snapshots(),
    builder: (context,snapshot)
        {
          if (snapshot.hasData) {
            List<Message>messageslist=[];
            for(int i=0;i<snapshot.data!.docs.length;i++)
              {
                messageslist.add(Message.fromJson(snapshot.data!.docs[i]));
              }
          //  print( snapshot.data!.docs[0]['message']);
            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: KPrimaryColor,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/scholar.png',height: 55,),
                      Text('chat',style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  centerTitle:true ,

                ),
                body:
                Column(
                  children: [

                    Expanded(
                      child: ListView.builder(
                       reverse:true ,
                          controller: _controller,
                          itemCount: messageslist.length,
                          itemBuilder: (context,index){
                      return messageslist[index].id==email?
                      CustomChatBuble(message: messageslist[index]
                       ):CustomChatBubleFriend(message: messageslist[index],);


                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: controller,
                        onSubmitted: (data){
                          messages.add({
                            KMessage: data,
                            KCreatedAt:DateTime.now(), 'id':   email});
                          controller.clear();
        _controller.jumpTo(
        _controller.position.maxScrollExtent,
        //duration: Duration(seconds: 1),
        //curve: Curves.easeIn,
        );

                        },
                        decoration: InputDecoration(
                            hintText: 'send message',
                            suffixIcon: Icon(Icons.send,
                              color: KPrimaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),

                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color:KPrimaryColor,
                                //   Icon:Icons.message,


                              ),
                            )
                        ),

                      ),
                    ),
                  ],
                )

            );

          }
          else
            {
              return Text('loodind.....');
            }
        }
  );
}
}

