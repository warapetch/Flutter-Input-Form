import 'package:flutter/material.dart';
import 'package:learnform1/widgets/checkbox_form_field.dart';

void main() {

    runApp(MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key ? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      return MaterialApp(
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
    Widget build(BuildContext context) {

        return
        Scaffold(
            appBar: AppBar(title: Text("ลงทะเบียน"),),
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
                value: channel,  // value must in List
                items: channels,
                // [
                //     DropdownMenuItem(
                //             child: Text("Facebook"),
                //             value: "Facebook",
                //             ),
                // ]
                onChanged: (selectedValue){
                    setState(() {
                        channel = selectedValue.toString();
                    });
                }
        );

    }

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