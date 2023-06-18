import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kelola_uang/screens/create_screen.dart';
import 'package:kelola_uang/screens/update_screen.dart';
import 'package:kelola_uang/api/transaksi.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'kelola duit ku',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List _listdata = [];
  Map _totaldataDuid = {};
  List _totaldataPemasukan = [];
  List _totaldataPengeluaran = [];
  bool _isloading = true;
  bool _isloadingpemasukan = true;
  bool _isloadingpengeluaran = true;
  bool _isloadingduid = true;

  Future _getdata() async {
    try {
      final response = await http.get(Uri.parse(Transaksi().getAll));

      if (response.statusCode==200) {
        final data = jsonDecode(response.body);
        setState(() {
          _listdata = data;
          _isloading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _pemasukan() async {
    try {
      final response = await http.get(Uri.parse(Transaksi().pemasukan));

      if (response.statusCode==200) {
        final dataPemasukan = jsonDecode(response.body);
        setState(() {
          _totaldataPemasukan = dataPemasukan;
          _isloadingpemasukan = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _pengeluaran() async {
    try {
      final response = await http.get(Uri.parse(Transaksi().pengeluaran));

      if (response.statusCode==200) {
        final dataPengeluaran = jsonDecode(response.body);
        setState(() {
          _totaldataPengeluaran = dataPengeluaran;
          _isloadingpengeluaran = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _totalduid() async {
    try {
      final response = await http.get(Uri.parse(Transaksi().totalDuid));

      if (response.statusCode==200) {
        final dataDuid = jsonDecode(response.body);
        setState(() {
          _totaldataDuid = dataDuid;
          _isloadingduid = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getdata();
    _totalduid();
    _pemasukan();
    _pengeluaran();
    
    super.initState();
  }  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Duid Ku"), 
        actions: [IconButton(
          icon: Icon(Icons.add), 
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateScreen()));
          },)],),
      body: _isloading 
      ? Center(child: CircularProgressIndicator()) 
      : SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              SizedBox(
                height: 20
              ),
              _isloadingduid 
              ? Text("Total Duid : Rp. Waiting...")
              : Text("Total Duid : Rp. ${(_totaldataDuid['pemasukan'][0]['SUM(total)'].toString() == 'null' ? 0 : int.parse(_totaldataDuid['pemasukan'][0]['SUM(total)'].toString())) - (_totaldataDuid['pengeluaran'][0]['SUM(total)'].toString() == 'null' ? 0 : int.parse(_totaldataDuid['pengeluaran'][0]['SUM(total)'].toString()))}"),
              SizedBox(
                height: 20
              ),
              Text("Total Pemasukan : Rp. ${_isloadingpemasukan ? 'Waiting...' : (_totaldataPemasukan[0]['SUM(total)'].toString() == 'null' ? 0 : _totaldataPemasukan[0]['SUM(total)'])}"),
              SizedBox(
                height: 20
              ),
              Text("Total Pengeluaran : Rp. ${_isloadingpengeluaran ? 'Waiting...' : (_totaldataPengeluaran[0]['SUM(total)'].toString() == 'null' ? 0 : _totaldataPengeluaran[0]['SUM(total)'])}"),
              SizedBox(
                height: 20
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _listdata.length,
                primary: false,
                itemBuilder: ((context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_listdata[index]['name']),
                      subtitle: Text("Rp. ${_listdata[index]['total'].toString()}"),
                      leading: _listdata[index]['type'].toString() == '1'
                        ? Icon(Icons.download, color: Colors.green)
                        : Icon(Icons.upload, color: Colors.red),
                      trailing: Wrap(children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.grey,),
                          onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateScreen(ListData: {
                              'id' : _listdata[index]['id'],
                              'type' : _listdata[index]['type'],
                              'name' : _listdata[index]['name'],
                              'total' : _listdata[index]['total'],
                            },)));
                          },
                        ),
                        SizedBox(
                          width: 20
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red,), 
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: ((context) {
                              return AlertDialog(
                                title: Text("Peringatan!"),
                                content: Text("Anda yakin akan menghapus"),
                                actions: [TextButton(
                                  child: Text('Yakin'),
                                  onPressed: () async {
                                    try {
                                      final response = await http.post(
                                        Uri.parse(Transaksi().delete),
                                        body: {
                                          "id" : _listdata[index]['id'],
                                        }  
                                      );
                                      if (response.statusCode==200){
                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => super.widget), (route) => false,);
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
        
                                  }
                                )],
                              );;
                            }));
                          },
                        ),
                      ]),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}