// Create a Form widget.

import 'package:cattle_weight/DataBase/catPro_handler.dart';
import 'package:cattle_weight/model/catPro.dart';
import 'package:cattle_weight/Screens/Pages/catPro_screen.dart';
import 'package:flutter/material.dart';

class CatProFormEdit extends StatefulWidget {
  final CatProModel catPro;
  const CatProFormEdit({
    Key? key,
    required this.catPro,
  }) : super(key: key);

  @override
  CatProFormEditState createState() {
    return CatProFormEditState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class CatProFormEditState extends State<CatProFormEdit> {
  final _formKey = GlobalKey<FormState>();
  String _selectedGender = 'male';
  String cattleName = "";
  String species = 'Species';

  CatProHelper? catProHelper;
  late Future<List<CatProModel>> notesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedGender = widget.catPro.gender;
    cattleName = widget.catPro.name;
    species = widget.catPro.species;

    catProHelper = new CatProHelper();
    loadData();
  }

  loadData() async {
    notesList = catProHelper!.getCatProList();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("แก้ไขข้อมูล",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ชื่อโค",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                style: TextStyle(fontSize: 24),
                decoration: InputDecoration(
                  focusColor: Colors.white,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fillColor: Colors.grey,

                  //create lable
                  labelText: "${cattleName}",
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // return 'Please enter name';
                  } else {
                    cattleName = value;
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
              Text("เพศ",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ListTile(
                leading: Radio<String>(
                  value: 'male',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                title: const Text('Male',style: TextStyle(fontSize: 18)),
              ),
              ListTile(
                leading: Radio<String>(
                  value: 'female',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                title: const Text('Female',style: TextStyle(fontSize: 18)),
              ),
              SizedBox(
                height: 16,
              ),
              Text("สายพันธุ์",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 8,
              ),
              SizedBox(
                width: 360,
                height: 64,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  )),
                  value: species,
                  items: <String>['Species', 'Brahman', 'Angus', 'Charolais']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      species = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 44, vertical: 16),
                              textStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('ยกเลิก'),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 44, vertical: 16),
                              textStyle: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            String name = widget.catPro.name;
                            if (_formKey.currentState!.validate()) {
                              //   // ScaffoldMessenger.of(context).showSnackBar(
                              //   //   const SnackBar(
                              //   //       content: Text('Processing Data')),
                              //   // );
                              name = cattleName;
                              // print(
                              //     "Name: $cattleName\tGender: $_selectedGender\tSpecies: $species");

                            }

                            // print(
                            //     "Name: $name\tGender: $_selectedGender\tSpecies: $species");

                            final newCatPro = CatProModel(
                                id: widget.catPro.id,
                                name: name,
                                gender: _selectedGender,
                                species: species);

                            await catProHelper!.updateCatPro(newCatPro);

                            loadData();

                            // Navigator.pop(context);

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => CatProScreen()),
                                (Route<dynamic> route) => false);
                          },
                          child: const Text('บันทึก'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
