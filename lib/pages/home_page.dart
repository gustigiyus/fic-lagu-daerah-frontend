import 'package:flutter/material.dart';
import 'package:flutter_lagu_daerah_app/data/models/province.dart';
import 'package:flutter_lagu_daerah_app/pages/detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lagu Daerah',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailPage(
                  province: laguDaerahList[index],
                );
              }))
            },
            child: Card(
              child: ListTile(
                title: Text(laguDaerahList[index].laguDaerah),
                subtitle: Text(
                    '${laguDaerahList[index].nama} - ${laguDaerahList[index].ibuKota}'),
                leading: Image.network(
                  laguDaerahList[index].photo,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        itemCount: laguDaerahList.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Tamba Lagu'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: 'Nama Lagu'),
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Nama Daerah'),
                      )
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Submit')),
                  ],
                );
              })
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
