// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:resellfirst/components/rf_textfield.dart';
import 'package:resellfirst/models/article_number_model.dart';
import 'package:resellfirst/models/item_model.dart';
import 'package:resellfirst/models/size_model.dart';
import 'package:resellfirst/provider/items_provider.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({Key? key, required this.product}) : super(key: key);
  final Product product;
  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  @override
  void initState() {
    Product product = widget.product;
    _skuController.text = product.sku;
    _nameController.text = product.name;
    brand = product.brand;
    _solematerialController.text = product.solematerial;
    _uppermaterialController.text = product.uppermaterial;
    _innermaterialController.text = product.innermaterial;
    _descController.text = product.description;
    _colorController.text = product.color;

    mainimage = product.mainimage;
    mainimagename = product.mainimagename;
    category = product.category;
    sizes = product.sizes;
    imagenames = product.imagenames;
    subcatergory = product.subcategory;
    releaseDate = product.releasedate;
    super.initState();
  }

  final TextEditingController _skuController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _solematerialController = TextEditingController();

  final TextEditingController _uppermaterialController =
      TextEditingController();

  final TextEditingController _innermaterialController =
      TextEditingController();

  final TextEditingController _descController = TextEditingController();

  final TextEditingController _colorController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  ImagePicker picker = ImagePicker();

  bool _isLoading = false;

  String? sku = '';

  List<String>? imagenames = [];

  String? category = 'kategorie';

  String? subcatergory = 'unterkategorie';

  String? name = '';

  String? brand = 'marke';

  String? mainimagename = '';

  String? mainimage = '';

  String? releaseDate = '';

  String? color = '';

  String? solematerial = '';

  String? uppermaterial = '';

  String? innermaterial = '';

  String? description = '';

  List<XFile>? images = [];

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

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    final TextEditingController _sizeController = TextEditingController();

    final TextEditingController _amountController = TextEditingController();

    final TextEditingController _priceController = TextEditingController();

    final TextEditingController _artNumberController = TextEditingController();
    return AlertDialog(
      title: const Text('Gr????en hinzuf??gen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RFTextField(
              maxlines: 1,
              text: 'Gr????e',
              maxLength: 240,
              textInputType: TextInputType.text,
              controller: _sizeController,
            ),
            const SizedBox(
              height: 10,
            ),
            RFTextField(
              maxlines: 1,
              text: 'Menge',
              maxLength: 240,
              textInputType: TextInputType.text,
              controller: _amountController,
            ),
            const SizedBox(
              height: 10,
            ),
            RFTextField(
              maxlines: 1,
              text: 'Preis',
              maxLength: 240,
              textInputType: TextInputType.text,
              controller: _priceController,
            ),
            const SizedBox(
              height: 10,
            ),
            RFTextField(
              maxlines: 5,
              text: 'Artikelnummern',
              maxLength: 10000,
              textInputType: TextInputType.text,
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
          child: const Text('Hinzuf??gen'),
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

    // ignore: avoid_function_literals_in_foreach_calls
    size.articleNumbers!.forEach(
        (element) => _artNumberController.text += element.artikelnummer + ',');

    return AlertDialog(
      title: const Text('Gr????en editieren'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RFTextField(
            maxlines: 1,
            text: 'Gr????e',
            maxLength: 240,
            textInputType: TextInputType.text,
            controller: _sizeController,
          ),
          const SizedBox(
            height: 10,
          ),
          RFTextField(
            maxlines: 1,
            text: 'Menge',
            maxLength: 240,
            textInputType: TextInputType.text,
            controller: _amountController,
          ),
          const SizedBox(
            height: 10,
          ),
          RFTextField(
            maxlines: 1,
            text: 'Preis',
            maxLength: 240,
            textInputType: TextInputType.text,
            controller: _priceController,
          ),
          const SizedBox(
            height: 10,
          ),
          RFTextField(
            maxlines: 5,
            text: 'Artikelnummern',
            maxLength: 10000,
            textInputType: TextInputType.text,
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
          child: const Text('Editieren'),
        ),
      ],
    );
  }

  Future<void> loadAssets() async {
    List<XFile>? resultList = await picker.pickMultiImage();

    setState(() {
      if (resultList != null) {
        images = resultList;
      }
    });
  }

  void removeSize(int index) {
    setState(() {
      sizes!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Produkt editieren'),
        ),
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * .08),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                RFTextField(
                  maxlines: 1,
                  text: 'SKU',
                  maxLength: 240,
                  textInputType: TextInputType.text,
                  controller: _skuController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Sku muss ausgef??llt sein';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                RFTextField(
                  maxlines: 1,
                  text: 'Name',
                  maxLength: 240,
                  textInputType: TextInputType.text,
                  controller: _nameController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Name muss ausgef??llt sein';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                RFTextField(
                  maxlines: 1,
                  text: 'Farbe',
                  maxLength: 240,
                  textInputType: TextInputType.text,
                  controller: _colorController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Farbe muss ausgef??llt sein';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              selectedDate.day.toString() +
                                  '.' +
                                  selectedDate.month.toString() +
                                  '.' +
                                  selectedDate.year.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.grey[700]),
                            ),
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey[200],
                          )),
                    )),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Marke ist ein Pflichtfeld'),
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(15),
                                  filled: true,
                                  fillColor: Colors.grey[
                                      200], //Theme.of(context).canvasColor,
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
                                                child: Text(
                                                    brands.elementAt(index)),
                                              ))),
                                ),
                              );
                            },
                          ),
                        ],
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
                                          value: categories[brand]!
                                              .elementAt(index),
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
                  textInputType: TextInputType.text,
                  controller: _descController,
                ),
                const SizedBox(
                  height: 15,
                ),
                RFTextField(
                  maxlines: 1,
                  text: 'Sohlen Material',
                  maxLength: 240,
                  textInputType: TextInputType.text,
                  controller: _solematerialController,
                ),
                const SizedBox(
                  height: 15,
                ),
                RFTextField(
                  maxlines: 1,
                  text: 'Au??enmaterial',
                  maxLength: 240,
                  textInputType: TextInputType.text,
                  controller: _uppermaterialController,
                ),
                const SizedBox(
                  height: 15,
                ),
                RFTextField(
                  maxlines: 1,
                  text: 'Innenmaterial',
                  maxLength: 240,
                  textInputType: TextInputType.text,
                  controller: _innermaterialController,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Ver??ffentlichen ?',
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
                  child: Text('Gr????en',
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
                          Text('Noch keine Gr????en vorhanden',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.grey[700]))
                        ]
                      : List.generate(sizes!.length, (index) {
                          String artNumbers = '';
                          // ignore: avoid_function_literals_in_foreach_calls
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
                                              'Gr????e: ' +
                                                  sizes![index].size.toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      color: Colors.grey[700])),
                                          Text(
                                              'Menge: ' +
                                                  sizes![index]
                                                      .amount
                                                      .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(
                                                      color: Colors.grey[700])),
                                          Text(
                                              'Preis: ' +
                                                  sizes![index]
                                                      .price
                                                      .toString() +
                                                  '???',
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
                                                          context,
                                                          sizes![index]),
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
              if (formKey.currentState!.validate() && brand != 'marke') {
                releaseDate = selectedDate.month.toString() +
                    '.' +
                    selectedDate.year.toString();
                setState(() {
                  _isLoading = !_isLoading;
                });
                Product product = Product(
                    brand: brand!,
                    color: _colorController.text,
                    category: category! == 'kategorie' ? '' : category!,
                    subcategory:
                        subcatergory! == 'unterkategorie' ? '' : subcatergory!,
                    description: _descController.text,
                    sku: _skuController.text,
                    innermaterial: _innermaterialController.text,
                    name: _nameController.text,
                    published: published ? 1 : 0,
                    releasedate: releaseDate!,
                    solematerial: _solematerialController.text,
                    uppermaterial: _uppermaterialController.text,
                    mainimage: mainimage!,
                    images: images!,
                    sizes: sizes!,
                    createdat: DateTime.now().toString(),
                    mainimagename: mainimagename!);
                Provider.of<ItemsProvider>(context, listen: false)
                    .updateItem(widget.product, product);
                await Future.delayed(const Duration(seconds: 5));
                Navigator.pop(context);
              }
            },
            label: _isLoading
                ? const CircularProgressIndicator.adaptive(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xffe78857)),
                    backgroundColor: Color(0xff85b7d6))
                : const Text('Editieren')),
      ),
    );
  }
}
