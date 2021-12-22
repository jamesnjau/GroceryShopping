import 'package:flutter/material.dart';
import 'package:grocery/models/product_model.dart';
import 'package:search_page/search_page.dart';

class ProductSearchSreen extends StatelessWidget {
  static List<Product> people = [
    Product(productName: 'name', shopName: 'surname', price: 7),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (context, index) {
          final Product person = people[index];
          return ListTile(
            title: Text(person.productName!),
            subtitle: Text(person.shopName!),
            trailing: Text('${person.price} yo'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search People',
        onPressed: () => showSearch(
          context: context,
          delegate: SearchPage<Product>(
            onQueryUpdate: (s) => print(s),
            items: people,
            searchLabel: 'Search People',
            suggestion:
                Center(child: Text('Filter people by name, surname or age')),
            failure: Center(child: Text('No persons found')),
            filter: (person) => [
              person.productName!,
              person.shopName!,
              person.price.toString(),
            ],
            builder: (person) => ListTile(
              title: Text(person.productName!),
              subtitle: Text(person.shopName!),
              trailing: Text('${person.weight} yo'),
            ),
          ),
        ),
        child: Icon(Icons.search),
      ),
    );
  }
}
