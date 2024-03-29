import 'package:flutter/material.dart';
import 'package:flutter_exercise/models/komoditi_model.dart';
import 'package:flutter_exercise/tabs/komoditiDetail.dart';
import 'package:flutter_exercise/utils/database_helper.dart';
import 'dart:core';

List<KomoditiModel> komoditi_list = [];
List<KomoditiModel> komoditi_list_filtered = [];

class Komoditi extends StatefulWidget {
  const Komoditi({super.key});

  @override
  State<Komoditi> createState() => _KomoditiState();
}

bool _isLoading = true;

class _KomoditiState extends State<Komoditi> {
  int count = 10;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    _runFilter(_controller.text);
  }

  void initState() {
    super.initState();
    getData();
    _controller.addListener(_printLatestValue);
  }

  void getData() async {
    var dbHelper = DatabaseHelper();
    List<KomoditiModel> _komoditi_list = await dbHelper.getKomoditas();
    setState(() {
      komoditi_list = _komoditi_list;
      komoditi_list_filtered = komoditi_list;
      _isLoading = false;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<KomoditiModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = komoditi_list;
    } else {
      results = komoditi_list
          .where((kom) => (kom.subjudulKomoditas +
                  " " +
                  kom.ket1b +
                  " " +
                  kom.ket2b +
                  " " +
                  kom.ket3b +
                  " " +
                  kom.judulKomoditas +
                  " " +
                  kom.nama_lokal)
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      komoditi_list_filtered = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Komoditas'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                    //onChanged: (value) => _runFilter(value),
                    decoration: InputDecoration(
                        hintText: 'Search',
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                                onPressed: _controller.clear,
                                icon: Icon(Icons.clear),
                                splashColor: Colors.transparent,
                              )
                            : null,
                        prefixIcon: Icon(Icons.search)),
                  ),
                ),
                Flexible(child: getKomoditiListView()),
              ],
            ),
    );
  }

  ListView getKomoditiListView() {
    TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      separatorBuilder: (context, index) {
        return Divider();
      },
      itemCount: komoditi_list_filtered.length,
      itemBuilder: (BuildContext context, int position) {
        final index = position;
        return ListTile(
          title: Text(
            komoditi_list_filtered[index].subjudulKomoditas,
            style: titleStyle,
          ),
          subtitle: Text(komoditi_list_filtered[index].judulKomoditas +
              ';\n' +
              komoditi_list_filtered[index].ket1a +
              ': ' +
              komoditi_list_filtered[index].ket1b +
              ';\n' +
              komoditi_list_filtered[index].ket2a +
              ': ' +
              komoditi_list_filtered[index].ket2b +
              ';\n' +
              komoditi_list_filtered[index].ket3a +
              ': ' +
              komoditi_list_filtered[index].ket3b +
              ';'),
          trailing: Icon(
            Icons.keyboard_arrow_right_rounded,
            color: Colors.grey,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => KomoditiDetail(
                        komoditi_list_filtered[index].id,
                        komoditi_list_filtered[index].subjudulKomoditas,
                        komoditi_list_filtered[index].judulKomoditas,
                        komoditi_list_filtered[index].ket1a,
                        komoditi_list_filtered[index].ket1b,
                        komoditi_list_filtered[index].ket2a,
                        komoditi_list_filtered[index].ket2b,
                        komoditi_list_filtered[index].ket3a,
                        komoditi_list_filtered[index].ket3b,
                        komoditi_list_filtered[index].nama_lokal)));
          },
        );
      },
    );
  }
}
