import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resellfirst/components/rf_textfield.dart';
import 'package:resellfirst/models/item_model.dart';
import 'package:resellfirst/provider/items_provider.dart';
import 'package:resellfirst/screens/add_item_screen.dart';
import 'package:resellfirst/screens/item_detail_screen.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _searchController = TextEditingController();

  List<Product> results = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsProvider>(builder: (context, items, chlid) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Produkte'),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 50),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RFTextField(
                  onChanged: (value) {
                    setState(() {
                      results =
                          items.getItemsWhereSearch(_searchController.text);
                    });
                  },
                  text: 'Suchen',
                  maxLength: 120,
                  textInputType: TextInputType.name,
                  controller: _searchController,
                  maxlines: 1),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddItemScreen()));
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              physics: const BouncingScrollPhysics(),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              crossAxisCount: 2,
              children: List.generate(
                  _searchController.text.isEmpty
                      ? items.items.length
                      : results.length,
                  (index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ItemDetailScreen(
                                        productIndex: index,
                                      )));
                        },
                        child: Image.network('http://images.resellfirst.de/' +
                            (_searchController.text.isEmpty
                                ? items.items[index].mainimagename
                                : results[index].mainimagename)),
                      )),
            ),
          ),
        ),
      );
    });
  }
}
