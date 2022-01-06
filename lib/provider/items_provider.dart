import 'package:flutter/cupertino.dart';
import 'package:resellfirst/models/article_number_model.dart';
import 'package:resellfirst/models/size_model.dart';
import 'package:resellfirst/services/article_number_service.dart';
import 'package:resellfirst/services/image_service.dart';
import 'package:resellfirst/services/product_service.dart';
import 'package:resellfirst/services/sizes_service.dart';

import '../models/item_model.dart';

class ItemsProvider extends ChangeNotifier {
  List<Product> items = [];

  int oldindex = -1;

  Future<void> addItem(Product item, bool update) async {
    int id = await ApiSerivce.createProduct(item);
    if (!update) {
      String mainimagename =
          await ImageService.uploadMainImage(id, item.images![0]);

      item.mainimagename = mainimagename;
      item.imagenames = [];
      for (var i = 1; i < item.images!.length; i++) {
        String imagename =
            await ImageService.uploadImagesToProductId(id, item.images![i]);
        item.imagenames?.add(imagename);
      }
    }

    List<SizeAmount> tempSizes = [];

    for (var i = 0; i < item.sizes!.length; i++) {
      item.sizes![i].productid = id;
      SizeAmount size = await SizesService.createSizeAmounts(item.sizes![i]);
      size.articleNumbers = [];

      for (ArticleNumber articleNumber in item.sizes![i].articleNumbers!) {
        articleNumber.sizeamountid = size.id;
        ArticleNumber newArtNumb =
            await ArticleNumberService.createArticleNumbers(articleNumber);
        size.articleNumbers!.add(newArtNumb);
      }

      tempSizes.add(size);
    }
    item.sizes = tempSizes;

    item.id = id;
    if (update) {
      items.insert(oldindex, item);
    } else {
      items.add(item);
    }
    notifyListeners();
  }

  void loadItem(Product item) async {
    List<String> imagenames =
        await ImageService.getImagenamesByProductID(item.id!);
    item.imagenames = imagenames;

    List<SizeAmount> sizes =
        await SizesService.getSizeAmountsByProductId(item.id!);

    for (var i = 0; i < sizes.length; i++) {
      List<ArticleNumber> newArtNumbs =
          await ArticleNumberService.getArticleNumbersBySizeAmountID(
              sizes[i].id!);
      sizes[i].articleNumbers = newArtNumbs;
    }

    item.sizes = sizes;

    items.add(item);
    notifyListeners();
  }

  Future<void> removeItem(int index) async {
    await ApiSerivce.deleteProduct(items[index].id!);

    List<String> imageids =
        await ImageService.getImagenamesByProductID(items[index].id!);

    for (String imageid in imageids) {
      await ImageService.deleteImagesByID(imageid);
    }

    List<SizeAmount> sizes =
        await SizesService.getSizeAmountsByProductId(items[index].id!);

    for (SizeAmount size in sizes) {
      await SizesService.deleteSizesByID(size.id!);
      List<ArticleNumber> newArtNumbs =
          await ArticleNumberService.getArticleNumbersBySizeAmountID(size.id!);
      for (var i = 0; i < newArtNumbs.length; i++) {
        await ArticleNumberService.deleteArticlenumbersByID(newArtNumbs[i].id!);
      }
    }

    items.removeAt(index);
    notifyListeners();
  }

  Future<void> updateItem(Product oldItem, Product newItem) async {
    Product item = await ApiSerivce.updateProduct(newItem, oldItem.id!);
    oldindex = items.indexOf(oldItem);

    List<SizeAmount> tempSizes = [];
    item.imagenames = oldItem.imagenames;

    List<SizeAmount> oldSizes =
        await SizesService.getSizeAmountsByProductId(item.id!);

    for (SizeAmount size in oldSizes) {
      size.articleNumbers =
          await ArticleNumberService.getArticleNumbersBySizeAmountID(size.id!);
      await SizesService.deleteSizesByID(size.id!);
      for (ArticleNumber articleNumber in size.articleNumbers!) {
        await ArticleNumberService.deleteArticlenumbersByID(articleNumber.id!);
      }
    }

    for (var i = 0; i < newItem.sizes!.length; i++) {
      newItem.sizes![i].productid = item.id;

      SizeAmount size = await SizesService.createSizeAmounts(newItem.sizes![i]);
      size.articleNumbers = [];

      for (ArticleNumber articleNumber in newItem.sizes![i].articleNumbers!) {
        articleNumber.sizeamountid = size.id;
        ArticleNumber newArtNumb =
            await ArticleNumberService.createArticleNumbers(articleNumber);
        size.articleNumbers!.add(newArtNumb);
      }

      tempSizes.add(size);
    }
    item.sizes = tempSizes;

    items[oldindex] = item;
    notifyListeners();
  }

  List<Product> getItemsWhereSearch(String searchText) {
    return items
        .where((element) =>
            element.sku.contains(searchText) ||
            element.brand.contains(searchText) ||
            element.category.contains(searchText) ||
            element.subcategory.contains(searchText) ||
            element.name.contains(searchText))
        .toList();
  }
}