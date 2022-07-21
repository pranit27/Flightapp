

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:praneet/api.dart';
import 'package:praneet/model.dart';



final navigatorKeyMain = GlobalKey<NavigatorState>();


const server_url = "http://127.0.0.1:8000";
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flight Search App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController departure_city = TextEditingController();
  TextEditingController arrival_city = TextEditingController();
  DateTime? dateTime;
  List<FlightModel>? flights;

  String get textToShow {
    return dateTime == null
        ? "Select Date & Time"
        : DateFormat('dd/MM/yyyy HH:mm').format(dateTime!);
  }
  Future pickDateTime(BuildContext context) async {
    final initialDate = dateTime == null ? DateTime.now() : dateTime!;
    final firstDate = initialDate.subtract(Duration(days: 365 * 5));
    final lastDate = initialDate.add(Duration(days: 365 * 5));
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (newDate == null) return;

    final initialTime = dateTime == null
        ? TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute)
        : TimeOfDay(hour: dateTime!.hour, minute: dateTime!.minute);
    final newTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (newTime == null) return;
    final newDateTime = DateTime(newDate.year,newDate.month,newDate.day,newTime.hour,newTime.minute);

    setState(() => dateTime = newDateTime);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(child:Text("Flight Search App",style:TextStyle(color:Colors.blue,fontSize: 25,fontFamily: 'Medium',fontWeight: FontWeight.w500,))),
            Row(
              children:[
                Expanded(
                  child: Container(
                      margin: EdgeInsets.all(15),
                      child: TextFormField(
                        controller: departure_city,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        onChanged: (value) {
                          // setState(() {
                          //   departure_city.text = value.toString();
                          // });
                        },
                        decoration: InputDecoration(
                          focusColor: Colors.black,
                          //add prefix icon

                          // errorText: "Error",

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.blue, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.black,

                          hintText: "Departure City",

                          //make hint text
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),

                          //create lable
                          labelText: 'Departure City',
                          //lable style
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(15),
                    child: TextFormField(
                      controller: arrival_city,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (value) {
                      },
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        //add prefix icon

                        // errorText: "Error",

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Colors.blue, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.black,

                        hintText: "Arrival City",

                        //make hint text
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),

                        //create lable
                        labelText: 'Arrival City',
                        //lable style
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
    Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextButton(
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(30)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(

              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.grey)
              )
          )
      ),
    onPressed: () => pickDateTime(context),
    child: Text(textToShow,style:TextStyle(color:Colors.grey,fontSize: 16,fontWeight: FontWeight.w500,)),
    )
    ),
              ]
            ),
            TextButton(
              onPressed: ()async {
                flights = await flightplan(departure_city: departure_city.text,arrival_city: arrival_city.text,date_time: dateTime!.toIso8601String(),context: context);
setState(() {

});
              },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(

            RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.blue)
    )
    )
    ),
              child:Text("Search",style:TextStyle(color:Colors.white,fontSize: 24,fontWeight: FontWeight.w500,))
            ),
            flights!=null?ListView.builder(
              shrinkWrap: true,
              itemCount: flights!.length,
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: Colors.blue,
                    title:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(flights![index].flightno),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(flights![index].departure_city),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(flights![index].arrival_city),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(DateFormat("dd-MM-yy HH:MM").format(DateTime.parse(flights![index].arrival_time))),
                        ),
                      ],
                    )
                  ),
                );

              },
            ):SizedBox.shrink(),
          ],
        ),
      )
    // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
