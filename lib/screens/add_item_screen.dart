// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:provider/provider.dart';
import 'package:resellfirst/components/rf_datepicker.dart';
import 'package:resellfirst/components/rf_textfield.dart';
import 'package:resellfirst/models/article_number_model.dart';
import 'package:resellfirst/models/item_model.dart';
import 'package:resellfirst/models/size_model.dart';
import 'package:resellfirst/provider/items_provider.dart';

class AddItemScreen extends StatefulWidget {
  AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _skuController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _brandController = TextEditingController();

  final TextEditingController _solematerialController = TextEditingController();

  final TextEditingController _uppermaterialController =
      TextEditingController();

  final TextEditingController _innermaterialController =
      TextEditingController();

  final TextEditingController _descController = TextEditingController();

  final TextEditingController _colorController = TextEditingController();

  bool _isLoading = false;

  String? sku = '';

  String? category = 'kategorie';

  String? subcatergory = 'unterkategorie';

  String? name = '';

  String? brand = 'marke';

  String? releaseDate = '';

  String? color = '';

  String? solematerial = '';

  String? uppermaterial = '';

  String? innermaterial = '';

  String? description = '';

  List<Asset>? images = [];

  bool published = false;

  List<SizeAmount>? sizes = [];

  List<String> brands = [
    'marke',
    'nike',
    'yeezy',
    'jordan',
    'off white',
    'others'
  ];

  Map<String, List<String>> categories = {
    'marke': ['kategorie'],
    'nike': ['kategorie', 'dunk', 'air force 1'],
    'yeezy': ['kategorie', '350', '500', '700', 'slides', 'foam runner'],
    'jordan': ['kategorie', 'jordan 1', 'jordan 4', 'jordan 11'],
    'off white': ['kategorie', 'nike', 'ikea'],
    'others': ['kategorie'],
  };

  Map<String, List<String>> subcategories = {
    'kategorie': ['unterkategorie'],
    'dunk': ['unterkategorie', 'low', 'high'],
    'air force 1': ['unterkategorie', 'Low', 'High'],
    '350': ['unterkategorie', '350', '500', '700', 'slides', 'foam runner'],
    'jordan 1': ['unterkategorie', 'low', 'mid', 'high'],
    '500': ['unterkategorie'],
    '700': ['unterkategorie'],
    'slides': ['unterkategorie'],
    'foam runner': ['unterkategorie'],
    'jordan 4': ['unterkategorie'],
    'jordan 11': ['unterkategorie'],
    'nike': ['unterkategorie'],
    'ikea': ['unterkategorie'],
  };

  Widget _buildPopupDialog(BuildContext context) {
    final TextEditingController _sizeController = TextEditingController();

    final TextEditingController _amountController = TextEditingController();

    final TextEditingController _priceController = TextEditingController();

    final TextEditingController _artNumberController = TextEditingController();
    return AlertDialog(
      title: const Text('Größen hinzufügen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RFTextField(
              maxlines: 1,
              text: 'Größe',
              maxLength: 240,
              textInputType: TextInputType.number,
              controller: _sizeController,
            ),
            const SizedBox(
              height: 10,
            ),
            RFTextField(
              maxlines: 1,
              text: 'Menge',
              maxLength: 240,
              textInputType: TextInputType.number,
              controller: _amountController,
            ),
            const SizedBox(
              height: 10,
            ),
            RFTextField(
              maxlines: 1,
              text: 'Preis',
              maxLength: 240,
              textInputType: TextInputType.number,
              controller: _priceController,
            ),
            const SizedBox(
              height: 10,
            ),
            RFTextField(
              maxlines: 5,
              text: 'Artikelnummern',
              maxLength: 10000,
              textInputType: TextInputType.number,
              controller: _artNumberController,
            ),
          ],
        ),
      ),
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
            List<String> numbers = _artNumberController.text.split(',');
            List<ArticleNumber> artNumbers = [];
            for (String numb in numbers) {
              artNumbers.add(ArticleNumber(artikelnummer: numb));
            }
            setState(() {
              sizes!.add(SizeAmount(
                  articleNumbers: artNumbers,
                  size: double.parse(_sizeController.text),
                  amount: int.parse(_amountController.text),
                  price: double.parse(_priceController.text)));
            });

            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Hinzufügen'),
        ),
      ],
    );
  }

  Widget _buildPopupDialogWithSize(BuildContext context, SizeAmount size) {
    final TextEditingController _sizeController = TextEditingController();

    final TextEditingController _amountController = TextEditingController();

    final TextEditingController _priceController = TextEditingController();

    final TextEditingController _artNumberController = TextEditingController();

    _sizeController.text = size.size.toString();
    _amountController.text = size.amount.toString();
    _priceController.text = size.price.toString();

    size.articleNumbers!.forEach(
        (element) => _artNumberController.text += element.artikelnummer);

    return AlertDialog(
      title: const Text('Größen hinzufügen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RFTextField(
            maxlines: 1,
            text: 'Größe',
            maxLength: 240,
            textInputType: TextInputType.number,
            controller: _sizeController,
          ),
          const SizedBox(
            height: 10,
          ),
          RFTextField(
            maxlines: 1,
            text: 'Menge',
            maxLength: 240,
            textInputType: TextInputType.number,
            controller: _amountController,
          ),
          const SizedBox(
            height: 10,
          ),
          RFTextField(
            maxlines: 1,
            text: 'Preis',
            maxLength: 240,
            textInputType: TextInputType.number,
            controller: _priceController,
          ),
          const SizedBox(
            height: 10,
          ),
          RFTextField(
            maxlines: 5,
            text: 'Artikelnummern',
            maxLength: 10000,
            textInputType: TextInputType.number,
            controller: _artNumberController,
          ),
        ],
      ),
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
            setState(() {
              sizes![sizes!.indexOf(size)] = SizeAmount(
                  size: double.parse(_sizeController.text),
                  amount: int.parse(_amountController.text),
                  price: double.parse(_priceController.text));
            });

            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Hinzufügen'),
        ),
      ],
    );
  }

  String _error = 'No Error Dectected';

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images!,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: const MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      print(images!.length);
      _error = error;
    });
  }

  void removeSize(int index) {
    setState(() {
      sizes!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produkt hinuzfügen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * .08),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  loadAssets();
                },
                child: SizedBox(
                  height: 200,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: images!.isEmpty
                        ? [
                            Container(
                              height: 200,
                              width: 200,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.add),
                              ),
                            )
                          ]
                        : List.generate(images!.length, (index) {
                            Asset asset = images![index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: AssetThumb(
                                asset: asset,
                                width: 200,
                                height: 200,
                              ),
                            );
                          }),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RFTextField(
                maxlines: 1,
                text: 'SKU',
                maxLength: 240,
                textInputType: TextInputType.name,
                controller: _skuController,
              ),
              const SizedBox(
                height: 15,
              ),
              RFTextField(
                maxlines: 1,
                text: 'Name',
                maxLength: 240,
                textInputType: TextInputType.name,
                controller: _nameController,
              ),
              const SizedBox(
                height: 15,
              ),
              RFTextField(
                maxlines: 1,
                text: 'Farbe',
                maxLength: 240,
                textInputType: TextInputType.name,
                controller: _colorController,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  const Expanded(child: RFDatePicker()),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            filled: true,
                            fillColor: Colors
                                .grey[200], //Theme.of(context).canvasColor,
                            focusColor: Colors.lightBlue,
                            hoverColor: Colors.lightBlue,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none),
                            isDense: true,
                            counterText: '',
                          ),
                          isEmpty: brand == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(color: Colors.grey[700]),
                                value: brand,
                                isDense: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    brand = newValue;
                                  });
                                },
                                items: List.generate(
                                    brands.length,
                                    (index) => DropdownMenuItem<String>(
                                          value: brands.elementAt(index),
                                          child: Text(brands.elementAt(index)),
                                        ))),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor:
                              Colors.grey[200], //Theme.of(context).canvasColor,
                          focusColor: Colors.lightBlue,
                          hoverColor: Colors.lightBlue,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none),
                          isDense: true,
                          counterText: '',
                        ),
                        isEmpty: category == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.grey[700]),
                              value: category,
                              isDense: true,
                              onChanged: (newValue) {
                                setState(() {
                                  category = newValue;
                                });
                              },
                              items: List.generate(
                                  categories[brand]!.length,
                                  (index) => DropdownMenuItem<String>(
                                        value:
                                            categories[brand]!.elementAt(index),
                                        child: Text(categories[brand]!
                                            .elementAt(index)),
                                      ))),
                        ),
                      );
                    },
                  )),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          filled: true,
                          fillColor:
                              Colors.grey[200], //Theme.of(context).canvasColor,
                          focusColor: Colors.lightBlue,
                          hoverColor: Colors.lightBlue,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none),
                          isDense: true,
                          counterText: '',
                        ),
                        isEmpty: subcatergory == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.grey[700]),
                              value: subcatergory,
                              isDense: true,
                              onChanged: (newValue) {
                                setState(() {
                                  subcatergory = newValue;
                                });
                              },
                              items: List.generate(
                                  subcategories[category]!.length,
                                  (index) => DropdownMenuItem<String>(
                                        value: subcategories[category]!
                                            .elementAt(index),
                                        child: Text(subcategories[category]!
                                            .elementAt(index)),
                                      ))),
                        ),
                      );
                    },
                  )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              RFTextField(
                maxlines: 1,
                text: 'Beschreibung',
                maxLength: 240,
                textInputType: TextInputType.name,
                controller: _descController,
              ),
              const SizedBox(
                height: 15,
              ),
              RFTextField(
                maxlines: 1,
                text: 'Sohlen Material',
                maxLength: 240,
                textInputType: TextInputType.name,
                controller: _solematerialController,
              ),
              const SizedBox(
                height: 15,
              ),
              RFTextField(
                maxlines: 1,
                text: 'Außenmaterial',
                maxLength: 240,
                textInputType: TextInputType.name,
                controller: _uppermaterialController,
              ),
              const SizedBox(
                height: 15,
              ),
              RFTextField(
                maxlines: 1,
                text: 'Innenmaterial',
                maxLength: 240,
                textInputType: TextInputType.name,
                controller: _innermaterialController,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Veröffentlichen ?',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.grey[700], fontSize: 17)),
                  CupertinoSwitch(
                    value: published,
                    onChanged: (value) {
                      setState(() {
                        published = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Größen',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.grey[700], fontSize: 17)),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: sizes!.isEmpty
                    ? [
                        Text('Noch keine Größen vorhanden',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.grey[700]))
                      ]
                    : List.generate(sizes!.length, (index) {
                        String artNumbers = '';
                        sizes![index].articleNumbers!.forEach((element) {
                          artNumbers += element.artikelnummer;
                          artNumbers += ',';
                        });
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Größe: ' +
                                                sizes![index].size.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    color: Colors.grey[700])),
                                        Text(
                                            'Menge: ' +
                                                sizes![index].amount.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    color: Colors.grey[700])),
                                        Text(
                                            'Preis: ' +
                                                sizes![index].price.toString() +
                                                '€',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    color: Colors.grey[700])),
                                        Text('Artikelnummern:\n' + artNumbers,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    color: Colors.grey[700])),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    _buildPopupDialogWithSize(
                                                        context, sizes![index]),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              size: 18,
                                            )),
                                        IconButton(
                                            onPressed: () {
                                              removeSize(index);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 18,
                                            ))
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
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context),
                  );
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          setState(() {
            _isLoading = !_isLoading;
          });
          Product product = Product(
              brand: brand!,
              color: _colorController.text,
              category: category!,
              subcategory: subcatergory!,
              description: _descController.text,
              sku: _skuController.text,
              innermaterial: _innermaterialController.text,
              name: _nameController.text,
              published: published ? 1 : 0,
              releasedate: releaseDate!,
              solematerial: _solematerialController.text,
              uppermaterial: _uppermaterialController.text,
              mainimage: 'empty',
              images: images!,
              sizes: sizes!,
              createdat: DateTime.now().toString(),
              mainimagename: 'empty');
          Provider.of<ItemsProvider>(context, listen: false)
              .addItem(product, false)
              .then((value) => Navigator.pop(context));
        },
        label: _isLoading
            ? const CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xffe78857)),
                backgroundColor: Color(0xff85b7d6))
            : const Text('Hinzufügen'),
      ),
    );
  }
}
