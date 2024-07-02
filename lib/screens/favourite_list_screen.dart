import 'package:app_turismo/dao/package_dao.dart';
import 'package:app_turismo/models/package.dart';
import 'package:flutter/material.dart';

class FavouriteListScreen extends StatelessWidget {
  const FavouriteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite List"),
      ),
      body: const FavouriteList(),
    );
  }
}

class FavouriteList extends StatefulWidget {
  const FavouriteList({super.key});

  @override
  State<FavouriteList> createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  List<Package> _favoritePackages = [];
  final PackageDao _packageDao = PackageDao();

  fetchFavorites() {
    _packageDao.getFavoritePackages().then(
      (value) {
        if (mounted) {
          setState(() {
            _favoritePackages = value;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    fetchFavorites();

    return ListView.builder(
        itemCount: _favoritePackages.length,
        itemBuilder: (context, index) => FavouriteItem(
              favoritePackage: _favoritePackages[index],
              deleteAction: () {
                _packageDao.delete(_favoritePackages[index].id);
              },
            ));
  }
}

class FavouriteItem extends StatelessWidget {
  final Package favoritePackage;
  final Function deleteAction;

  const FavouriteItem({
    super.key,
    required this.favoritePackage,
    required this.deleteAction,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 5;

    return Card(
        child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            favoritePackage.image,
            height: width,
            width: width,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(favoritePackage.name)),
        ),
        IconButton(
            onPressed: () {
              deleteAction();
            },
            icon: const Icon(Icons.delete))
      ],
    ));
  }
}
