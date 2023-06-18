import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:kelola_uang/api/transaksi.dart';
import 'package:kelola_uang/main.dart';


class UpdateScreen extends StatefulWidget {
  final Map ListData;
  const UpdateScreen({Key? key, required this.ListData}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final formKey = GlobalKey<FormState>();
  
  TextEditingController id = TextEditingController();
  int type = 0;
  TextEditingController name = TextEditingController();
  TextEditingController total = TextEditingController();

  Future _update() async {
    final response = await http.post(
      Uri.parse(Transaksi().update),
        body: {
          "id" : id.text,
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
  
  int _value = 0;

  @override
  void initState() {
    _value = int.parse(widget.ListData['type']);
    
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    id.text=widget.ListData['id'];
    name.text=widget.ListData['name'];
    total.text=widget.ListData['total'];
    return Scaffold(
      appBar: AppBar(title: Text("Update")),
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
                      _update().then((value) {
                        if (value)  {
                          final snackBar = SnackBar(
                            content: const Text('Data berhasil diubah!'),
                          );
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyHomePage()), (route) => false);
                        } else {
                          final snackBar = SnackBar(
                            content: const Text('Data gagal diubah!'),
                          );
                        }
                      });
                    }
                  }, 
                  child: Text("Ubah")),
                ]
              ),
            ),
          ),
        )
      ),
    );
  }
}