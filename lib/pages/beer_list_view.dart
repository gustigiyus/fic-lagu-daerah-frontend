import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lagu_daerah_app/data/models/lagu_response_model.dart';
import 'package:flutter_lagu_daerah_app/pages/lagu_detail_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../data/datasources/lagu_remote_datasource.dart';

class BeerListView extends StatefulWidget {
  const BeerListView({super.key});

  @override
  _BeerListViewState createState() => _BeerListViewState();
}

class _BeerListViewState extends State<BeerListView> {
  // static const _pageSize = 20;

  final PagingController<int, Lagu> _pagingController =
      PagingController(firstPageKey: 1);

  final TextEditingController judulController = TextEditingController();
  final TextEditingController laguController = TextEditingController();
  final TextEditingController daerahController = TextEditingController();

  XFile? image;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await LaguRemoteDatasource().getLaguDaerahPages(pageKey);
      // final lastPage = newItems.data.lastPage;
      final isLastPage = newItems.data.currentPage == newItems.data.lastPage;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems.data.data);
      } else {
        _pagingController.appendPage(newItems.data.data, ++pageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _refreshPage() async {
    _pagingController.refresh();
    // try {
    // final newItems = await LaguRemoteDatasource().getLaguDaerahPages(pageKey);
    // // final lastPage = newItems.data.lastPage;
    // final isLastPage = newItems.data.currentPage == newItems.data.lastPage;
    // if (isLastPage) {

    // _pagingController.appendLastPage(newItems.data.data);
    //   } else {
    //     _pagingController.refresh();
    //     _pagingController.appendPage(newItems.data.data, ++pageKey);
    //   }
    // } catch (error) {
    //   _pagingController.error = error;
    // }
  }

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
      body: PagedListView<int, Lagu>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Lagu>(
          itemBuilder: (context, item, index) {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LaguDetailPage(
                    lagu: item,
                  );
                }));
              },
              child: Card(
                child: ListTile(
                  title: Text(item.judul),
                  subtitle: Text(item.daerah),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        '${LaguRemoteDatasource.imageUrl}/${item.imageUrl!}'),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //show dialog add new lagu
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Add New Lagu'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'Judul',
                            ),
                            controller: judulController,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'Lagu',
                            ),
                            maxLines: 4,
                            controller: laguController,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'Daerah',
                            ),
                            controller: daerahController,
                          ),
                          const SizedBox(height: 12),
                          image != null
                              ? SizedBox(
                                  height: 80,
                                  child: Image.file(File(image!.path)),
                                )
                              : const SizedBox(),
                          //upload image
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  // Pick an image.
                                  image = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  setState(() {});
                                },
                                child: const Text('Upload Gambar'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (image == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Gambar wajib diisi'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          // add new lagu
                          await LaguRemoteDatasource().addLaguDaerah(
                            judulController.text,
                            laguController.text,
                            daerahController.text,
                            image!,
                          );
                          judulController.clear();
                          laguController.clear();
                          daerahController.clear();
                          image == null;
                          await _refreshPage();
                          // setState(() {});
                          Navigator.pop(context);
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
