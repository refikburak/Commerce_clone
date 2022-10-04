import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:koctas/data/di/locator.dart';
import 'package:koctas/data/model/product/category.dart';
import 'data/service/rest_client.dart';

import 'data/model/product/product.dart';

void main() {
  setupDI();
  runApp(MaterialApp(
    home: const Koctas(),
    theme: ThemeData(
        appBarTheme:
            const AppBarTheme(color: Color.fromARGB(255, 234, 110, 30))),
  ));
}

class Koctas extends StatefulWidget {
  const Koctas({super.key});

  @override
  State<Koctas> createState() => _KoctasState();
}

class _KoctasState extends State<Koctas> {
  int selectedIndex = 0;
  int gridViewCount = 2;
  var restClient = getIt<RestClient>();
  // @override
  // void initState() {
  //   restClient.getProduct().then((value) {
  //     setState(() {
  //       products = value;
  //       print("GET PRODUCTS AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
  //     });
  //   });
  //   restClient.getCategories().then((value) {
  //     setState(() {
  //       categories = value;
  //       print("GET CATEGORIES BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("KOÇTAŞ"),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
      body: Container(
        child: Column(children: [
          CategoryList(
            height: height,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$gridViewCount  ürün"),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (gridViewCount == 1) {
                      gridViewCount = 2;
                    } else {
                      gridViewCount = 1;
                    }
                    print("GRIDVIEW : $gridViewCount");
                  });
                },
                icon: gridViewCount == 2
                    ? Icon(Icons.grid_view_outlined)
                    : Icon(Icons.view_agenda_outlined),
                iconSize: 30,
              ),
              ElevatedButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: ((context) => SortWidget(
                          height: height,
                          width: width,
                        ))),
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                child: Row(children: const <Widget>[
                  Text(
                    'Sırala',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.sort_rounded,
                    color: Colors.black,
                    size: 30,
                  ),
                ]),
              ),
              ElevatedButton(
                onPressed: (() {}),
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                child: Row(children: const <Widget>[
                  Text(
                    'Filtrele',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 16),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.filter_alt_rounded,
                    color: Colors.black,
                    size: 30,
                  ),
                ]),
              ),
            ],
          ),
          Expanded(
              flex: 8,
              child: ProductView(
                gridViewCount: gridViewCount,
              ))
        ]),
      ),
    );
  }
}

class ProductView extends StatefulWidget {
  const ProductView({
    required this.gridViewCount,
    Key? key,
  }) : super(key: key);
  final int gridViewCount;

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  var restClient = getIt<RestClient>();
  List<Product> products = [];

  @override
  void initState() {
    restClient.getProduct().then((value) {
      setState(() {
        products = value;
        print("GET PRODUCTS AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.count(
            crossAxisCount: widget.gridViewCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: (3 / 5),
            children: List.generate(products.length,
                (index) => GridProduct(product: products[index]))),
      ),
    );
  }
}

class GridProduct extends StatelessWidget {
  const GridProduct({
    required this.product,
    Key? key,
  }) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
                builder: (context) => ProductDetail(product: product)),
            (route) => true);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
                alignment: Alignment.topRight,
              ),
            ],
          ),
          Container(
              height: 125,
              child: Image.network(fit: BoxFit.fitHeight, product.images![0])),
          RateAndCommentBar(),

          //PRODUCT NAME
          Text(
            "${product.title}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          PriceBar(product: product)
        ],
      ),
    );
  }
}

class PriceBar extends StatelessWidget {
  const PriceBar({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          AspectRatio(
              aspectRatio: 1,
              child: Container(
                  color: Colors.red[900],
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "%9",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ))),
          SizedBox(
            width: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "10000 TL",
                style: TextStyle(
                    fontSize: 16,
                    decoration: TextDecoration.lineThrough,
                    decorationThickness: 3),
              ),
              Text(
                "${product.price} TL",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }
}

class RateAndCommentBar extends StatelessWidget {
  const RateAndCommentBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RatingBar.builder(
          initialRating: 5,
          minRating: 5,
          direction: Axis.horizontal,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 0.75),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemSize: 16,
          onRatingUpdate: (value) {},
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "(3 Yorum)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

// class CustomTabbar extends Stat
class CategoryList extends StatefulWidget {
  const CategoryList({Key? key, required this.height}) : super(key: key);

  final double height;

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  var restClient = getIt<RestClient>();
  List<Category> categories = [];
  int selectedCategory = 0;
  @override
  void initState() {
    restClient.getCategories().then((value) {
      setState(() {
        categories = value;
        categories.insert(0, new Category(id: -1, name: "Tümünü Gör"));
        print("GET CATEGORIES BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height * .09,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = index;
                  print(selectedCategory);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                      color: const Color.fromARGB(255, 48, 48, 48),
                      style: BorderStyle.solid,
                      width: 1),
                  color: index == selectedCategory
                      ? Color.fromARGB(255, 48, 48, 48)
                      : Colors.white,
                ),
                margin: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    '${categories[index].name}',
                    style: TextStyle(
                        color: index == selectedCategory
                            ? Colors.white
                            : Color.fromARGB(255, 48, 48, 48)),
                  ),
                ),
              ),
            );
          },
          itemCount: categories.length),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey[600],
        selectedItemColor: Colors.black,
        currentIndex: 1,
        selectedIconTheme:
            const IconThemeData(color: Color.fromARGB(255, 234, 110, 30)),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: "Anasayfa", icon: Icon(Icons.home_filled)),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted_rounded),
              label: "Kategoriler"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_rounded), label: "Sepetim"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Hesabım"),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on_rounded), label: "Mağazalar")
        ]);
  }
}

class SortWidget extends StatefulWidget {
  const SortWidget({
    super.key,
    required this.width,
    required this.height,
  });
  final double width;
  final double height;

  @override
  State<SortWidget> createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget> {
  String? sortType = "Pahalıdan ucuza";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal")),
        TextButton(
            onPressed: () {
              final snackBar = SnackBar(
                content: Text('$sortType sıralandı'),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text("Tamam")),
      ],
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          child: Column(children: [
            RadioListTile(
              value: "Pahalıdan ucuza",
              groupValue: sortType,
              onChanged: (value) {
                setState(() {
                  sortType = value;
                });
              },
              title: const Text("Fiyata Göre (Önce en yüksek)"),
            ),
            RadioListTile(
              value: "Ucuzdan pahalıya",
              groupValue: sortType,
              onChanged: (value) {
                setState(() {
                  sortType = value;
                });
              },
              title: const Text("Fiyata Göre (Önce en düşük)"),
            ),
            RadioListTile(
              value: "Kategoriye göre (A-Z)",
              groupValue: sortType,
              onChanged: (value) {
                setState(() {
                  sortType = value;
                });
              },
              title: const Text("Kategoriye Göre (A-Z)"),
            ),
            RadioListTile(
              value: "Kategoriye göre (Z-A)",
              groupValue: sortType,
              onChanged: (value) {
                setState(() {
                  sortType = value;
                });
              },
              title: const Text("Kategoriye Göre (Z-A)"),
            ),
          ]),
        ),
      ),
    );
  }
}

class ProductDetail extends StatelessWidget {
  const ProductDetail({required this.product, super.key});
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${product.title}'),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Image.asset("assets/table.jpg"),
                CarouselSlider(
                  options: CarouselOptions(height: 400.0),
                  items: product.images?.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(color: Colors.amber),
                            child: Image.network(
                              i,
                              fit: BoxFit.cover,
                            ));
                      },
                    );
                  }).toList(),
                ),
                RateAndCommentBar(),
                RichText(
                  text: TextSpan(
                      text: product.title,
                      style: TextStyle(
                          height: 1.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: " ${product.description}",
                            style: TextStyle(
                                height: 1.5,
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.normal))
                      ]),
                ),
              ],
            )),
      ),
      bottomNavigationBar: Material(
        elevation: 10,
        child: Container(
          height: MediaQuery.of(context).size.height / 7.5,
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PriceBar(product: product),
              Container(
                color: Colors.green,
                padding: EdgeInsets.all(8.0),
                child: Column(children: [
                  Text("Sepete Ekle",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  Text(
                    "10000 TL kazanç sağla!",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
