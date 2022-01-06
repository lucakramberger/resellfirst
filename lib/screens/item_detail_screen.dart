// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resellfirst/models/item_model.dart';
import 'package:resellfirst/provider/items_provider.dart';
import 'package:resellfirst/screens/edit_item_screen.dart';
import 'package:resellfirst/screens/home.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({Key? key, required this.productIndex})
      : super(key: key);

  final int productIndex;

  Widget _buildPopupDialogWithSize(BuildContext context) {
    return AlertDialog(
      title: const Text('Größen hinzufügen'),
      content: const Text('Willst du dieses Produkt wirklich löschen?'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Abbrechen'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context)
              ..pop()
              ..pop();
            Provider.of<ItemsProvider>(context, listen: false)
                .removeItem(productIndex);
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Löschen'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemsProvider>(builder: (context, items, child) {
      if (productIndex >= items.items.length) {
        return Scaffold(
          body: Center(
            child: Container(),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(items.items[productIndex].sku),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditItemScreen(
                                product: items.items[productIndex],
                              )));
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialogWithSize(context),
                  );
                },
                icon: Icon(Icons.delete))
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: PageView(
                  pageSnapping: true,
                  children: List.generate(
                      items.items[productIndex].imagenames!.length + 1,
                      (index) {
                    if (index == 0) {
                      return Image.network('http://images.resellfirst.de/' +
                          items.items[productIndex].mainimagename);
                    }
                    return Image.network('http://images.resellfirst.de/' +
                        items.items[productIndex].imagenames![index - 1]);
                  }),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(items.items[productIndex].name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 20)),
              const SizedBox(
                height: 5,
              ),
              Text(items.items[productIndex].sku,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 14)),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(items.items[productIndex].description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 14)),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                    'Status: ' +
                        (items.items[productIndex].published == 1
                            ? 'Öffentlich'
                            : 'Privat'),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 14)),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(items.items[productIndex].brand,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 14)),
                        Text(
                            items.items[productIndex].category == 'kategorie'
                                ? ''
                                : items.items[productIndex].category,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 14)),
                        Text(
                            items.items[productIndex].subcategory ==
                                    'unterkategorie'
                                ? ''
                                : items.items[productIndex].subcategory,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 14)),
                        Text(items.items[productIndex].releasedate,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 14)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(items.items[productIndex].color,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 14)),
                        Text(items.items[productIndex].uppermaterial,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 14)),
                        Text(items.items[productIndex].innermaterial,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 14)),
                        Text(items.items[productIndex].solematerial,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 14)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: List.generate(
                      items.items[productIndex].sizes!.length, (index) {
                    String artNumbers = '';
                    items.items[productIndex].sizes![index].articleNumbers!
                        .forEach((element) {
                      artNumbers += element.artikelnummer;
                      artNumbers += ',';
                    });
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Größe: ' +
                                            items.items[productIndex]
                                                .sizes![index].size
                                                .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(color: Colors.grey[700])),
                                    Text(
                                        'Menge: ' +
                                            items.items[productIndex]
                                                .sizes![index].amount
                                                .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(color: Colors.grey[700])),
                                    Text(
                                        'Preis: ' +
                                            items.items[productIndex]
                                                .sizes![index].price
                                                .toString() +
                                            '€',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(color: Colors.grey[700])),
                                    Text('Artikelnummern:\n' + artNumbers,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(color: Colors.grey[700])),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[200],
                          )),
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
