import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:kelola_uang/api/transaksi.dart';
import 'package:kelola_uang/main.dart';


class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final formKey = GlobalKey<FormState>();
  
  int type = 0;
  TextEditingController name = TextEditingController();
  TextEditingController total = TextEditingController();

Future _simpan() async {
    final response = await http.post(
      Uri.parse(Transaksi().create),
        body: {
          "type" : type.toString(),
          "name" : name.text,
          "total" : total.text,
        }
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
  }
  
  int _value = 1;

  @override
  void initState() {
    _value = 0;
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create")),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama'),
                  TextFormField(
                    controller: name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Nama tidak boleh kosong";
                      }
                    },
                  ),
                  SizedBox(
                    height: 20
                  ),
                  Text("Tipe Transaksi"),
                  // TextFormField(
                  //   controller: type,
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return "Tipe tidak boleh kosong";
                  //     }
                  //   },
                  // ),
                  ListTile(
                    title: Text("Pemasukan"),
                    leading: Radio(
                      groupValue: _value,
                      value: 1,
                      onChanged: (value) {
                        setState(() {
                          _value = int.parse(value.toString());
                          type = 1;
                        });
                        print(value);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text("Pengeluaran"),
                    leading: Radio(
                      groupValue: _value,
                      value: 0, 
                      onChanged: (value) {
                        setState(() {
                          _value = int.parse(value.toString());
                          type = 0;
                        });
                        print(value);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20
                  ),
                  Text('Total'),
                  TextFormField(
                    controller: total,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Total tidak boleh kosong";
                      }
                    },
                  ),
                  SizedBox(
                    height: 30
                  ),
                  ElevatedButton(onPressed: (){
                    if (formKey.currentState!.validate()) {
                      _simpan().then((value) {
                        if (value)  {
                          final snackBar = SnackBar(
                            content: const Text('Data berhasil disimpan!'),
                          );
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyHomePage()), (route) => false);
                        } else {
                          final snackBar = SnackBar(
                            content: const Text('Data gagal disimpan!'),
                          );
                        }
                      });
                    }
                  }, 
                  child: Text("Simpan")),
                ]
              ),
            ),
          ),
        )
      ),
    );
  }
}