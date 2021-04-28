import 'package:flutter/material.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:learnform1/widgets/checkbox_form_field.dart';

void main() {
    runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key ? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      return MaterialApp(

          // แสดงปฏิทินภาษาไทย  แต่ไม่เป็น พ.ศ. !!
          // 2. add GlobalMaterialLocalizations
            // localizationsDelegates: [
            //         GlobalMaterialLocalizations.delegate
            //         ],
            // supportedLocales: [
            //     const Locale('en'),
            //     const Locale('th')
            //     ],

                title: "ลงทะเบียน",
                home: HomePage(),
      );
    }

}


class HomePage extends StatefulWidget{

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

    final ctrlName = new TextEditingController();
    final ctrlSurName = new TextEditingController();
    var grpGender = 'male';
    DateTime selectedDate = DateTime.now();
    int thisYear = 0;
    TimeOfDay selectedTime = TimeOfDay.now();

    String email = "";
    bool bLicenseCar = false, bLicenseBike = false;
    bool bSoldier = false, bMarry = false;
    double iAge = 0;
    var channels = ['Facebook','Twisster','Instagram','Line'].
        map((e) => DropdownMenuItem(child: Text(e),value: e)).toList();
    var channel;
    final keyForm = new GlobalKey<FormState>();
    var agreement = false;


    @override
    void initState() {      // OnCreate
      super.initState();

        setState(() {
            thisYear = DateTime.now().year;
           selectedDate = DateTime.now();
        });
    }

    // Method showDlgDatePicker
    Future<void> showDlgDatePicker(BuildContext context) async {
        final DateTime ? picked = await showDatePicker(
            context: context,
            cancelText: "ยกเลิก",
            confirmText: "เลือก",
            helpText: "เลือกวันที่",
            //locale : const Locale("th","TH"),   // ต้องผ่าน 2 ขั้นตอนก่อน 1.add package pubspec 2.add GlobalMaterialLocalizations
            initialDate: selectedDate,
            firstDate: DateTime(thisYear),    // ตามที่ต้องการกำหนด
            lastDate: DateTime(thisYear+1),   // ห่างจากวันแรก +1 ปี หรือตามต้องการ
            initialDatePickerMode: DatePickerMode.day,
            );

            if (picked != null && picked != selectedDate)
                setState(() {
                    selectedDate = picked;
                    print("เลือกวันที่ : $selectedDate");
                });
    }


    // Method showDlgTimePicker
    Future<void> showDlgTimePicker(BuildContext context) async {

        final TimeOfDay ? picked = await showTimePicker(
            context: context,
            cancelText: "ยกเลิก",
            confirmText: "เลือก",
            helpText: "เลือกเวลา",
            initialTime: selectedTime,
            initialEntryMode: TimePickerEntryMode.dial,
            //initialEntryMode: TimePickerEntryMode.input,

            // Display 24 hours //
            // builder: (BuildContext context,Widget child) {
            //          return  MediaQuery(
            //                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            //                  child: child
            //                  );
            //              },
            );

            if (picked != null && picked != selectedTime)
                setState(() {
                    selectedTime = picked;
                    print("เลือกเวลา : $selectedTime");
                });
    }


    @override
    Widget build(BuildContext context) {

        return
        Scaffold(
            appBar: AppBar(title: Text("ลงทะเบียน"),
                ),

            body: SingleChildScrollView(
                    child: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                         children: [
                                            buildTextField(),
                                            buildRadio(),
                                            buildCheckbox(),
                                            buildSwitch(),
                                            buildSlider(),
                                            Text("อายุ : ${iAge.round()} ปี"),
                        //---Date ----------------------------------------------------------
                                            ElevatedButton(
                                                child: Text("เลือก วันที่"),
                                                onPressed: (){
                                                     showDlgDatePicker(context);
                                                    }
                                            ),
                                            Text("เลือกวันที่ : ${selectedDate.day}/${selectedDate.month}/${selectedDate.year+543}"),
                        //---Time ----------------------------------------------------------
                                            ElevatedButton(
                                                child: Text("เลือก เวลา"),
                                                onPressed: (){
                                                     showDlgTimePicker(context);
                                                    }
                                            ),
                                            Text("เลือกเวลา : "+cnvTime12To24(selectedTime.format(context))),

                                            buildDropDown(),
                                            buildForm(),
                                            ElevatedButton(
                                                    onPressed: (){
                                                        if (!(keyForm.currentState?.validate() ?? false)) return;

                                                        keyForm.currentState?.save();
                                                        print("name = ${ctrlName.text} ${ctrlSurName.text}");
                                                        print("gendar = $grpGender");
                                                        print("car = $bLicenseCar");
                                                        print("bike = $bLicenseBike");
                                                        print("channels = $channel");
                                                        print("email = $email");
                                                    },
                                                    child: Text("บันทึก")),
                                         ],
                                ),
                            ),
                    ),
        );


  }

String cnvTime12To24(String timeValue){

    var dtFormat = DateFormat("h:mm a");
    var dtTime = dtFormat.parse(timeValue);
    return DateFormat('HH:mm').format(dtTime);

}


    Widget buildForm(){

        return Form(
                key: keyForm,
                child: Column(
                       children: [
                           TextFormField(
                               decoration: InputDecoration(
                                            labelText: "อีเมล"),
                                maxLength: 100,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value){
                                    value ??= '';   ///  Note:: if (value == null) { value = null}
                                    if (value.isEmpty){
                                       return 'กรุณากรอกอีเมล';
                                    }

                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'รูปแบบอีเมลไม่ถูกต้อง !!';

                                    return null;
                                },
                                onSaved: (value) => email = value ?? "",
                               ),

                            CheckboxFormField(
                                title: Text('ยอมรับ'),
                                initialValue: false,
                                onSaved: (value) => agreement = value ?? false,
                                validator: (value){
                                    value ??= false;
                                    if (!value) return 'ต้องยอมรับก่อนบันทึก';
                                },
                            ),
                       ],
                )
        );

    }

    Widget buildDropDown(){

        return DropdownButton(
                value: channel,     // value (must in List items)
                items: channels,    // list items
                onChanged: (selectedValue){
                    setState(() {
                        channel = selectedValue.toString();
                    });
                }
        );

    }


    // Widget buildDate(BuildContext context) {

    //     return  ElevatedButton(
    //                     child: Text("Date"),
    //                     onPressed: (){
    //                         // pickupDate(context);
    //                             showDatePicker(
    //                                     context: context,
    //                                     initialDate: choosedateTime,
    //                                     firstDate: DateTime(thisYear),
    //                                     lastDate: DateTime(thisYear)
    //                                     ).then((date) {
    //                                         setState(() {
    //                                             //date ??= DateTime.now();
    //                                             choosedateTime = date ??= DateTime.now();
    //                                         });
    //                                     });
    //                     }

    //             );
    // }



    Widget buildSlider(){

        return Slider(value: iAge,
                label: iAge.round().toString(),
                min: 0,
                max: 120,
                divisions: 100,
                onChanged: (value){
                    setState(() {
                        iAge = value;
                        });
                    }
        );
    }

    Widget buildSwitch(){

        return Column(
                   children: [
                       SwitchListTile(
                           title: Text("เกณฑ์ทหาร ?"),
                            value: bSoldier,
                            onChanged:  (value) {
                                setState((){
                                        bSoldier = value;
                                    });
                                }
                                ),

                       SwitchListTile(
                           title: Text("แต่งงาน ?"),
                            value: bMarry,
                            onChanged:  (value) {
                                setState((){
                                        bMarry = value;
                                    });
                                }
                                ),

                   ],
        );

    }

    Widget buildCheckbox(){

        return  Column(
                    children: [
                        CheckboxListTile(
                            title: Text("มีใบขับขี่รถยนต์"),
                            value: bLicenseCar,
                            onChanged: (value) {
                                setState((){
                                        bLicenseCar = value ?? false;
                                    });
                                }
                            ),

                        CheckboxListTile(
                            title: Text("มีใบขับขี่รถจักรยานยนต์"),
                            value: bLicenseBike,
                            onChanged: (value) {
                                setState((){
                                        bLicenseBike = value ?? false;
                                    });
                                }
                            ),

                    ],
        );

    }

    Widget buildRadio() {

        return Column(
                children: [
                    RadioListTile(
                            title: Text("ชาย"),
                            subtitle: Text("เพศชาย"),
                            value: "male",
                            groupValue: grpGender,
                            onChanged: (value){
                                setState(() {
                                    grpGender = value.toString();
                                });
                            }),

                    RadioListTile(
                            title: Text("หญิง"),
                            subtitle: Text("เพศหญิง"),
                            value: "female",
                            groupValue: grpGender,
                            onChanged: (value){
                                setState(() {
                                    grpGender = value.toString();
                                });
                            }),

                ],
        );
    }

    Widget buildTextField(){

        return Column(
          children: [
            TextField(
                        decoration: InputDecoration(
                                        labelText: "ชื่อ"
                                    ),
                        maxLength: 50,
                        keyboardType: TextInputType.name,
                        controller: ctrlName,

            ),

            TextField(
                        decoration: InputDecoration(
                                        labelText: "นามสกุล"
                                    ),
                        maxLength: 50,
                        keyboardType: TextInputType.name,
                        controller: ctrlSurName,

            ),

          ],
        );


    }
}