import 'package:app_turismo/dao/package_dao.dart';
import 'package:app_turismo/models/package.dart';
import 'package:app_turismo/services/package_service.dart';
import 'package:flutter/material.dart';

///PANTALLA DE BUSQUEDA DE PAQUETES
class PackageSearchScreen extends StatefulWidget {
  const PackageSearchScreen({super.key});

  @override
  State<PackageSearchScreen> createState() => _PackageSearchScreenState();
}

class _PackageSearchScreenState extends State<PackageSearchScreen> {
  final Map<String, String> _placeOptions = {
    's001': 'Machu Picchu',
    's002': 'Ayacucho',
    's003': 'Chichen Itza',
    's004': 'Cristo Redentor',
    's005': 'Islas Malvinas',
    's006': 'Murralla China',
  };
  String? _selectedPlace;

  final Map<String, String> _packageOptions = {
    '1': 'Viaje',
    '2': 'Hospedaje',
  };
  String? _selectedPackage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Search Packages"),
        ),
        body: Column(
          children: [
            //DROPDOWN PLACES
            DropdownButton<String>(
              hint: const Text('Select a place'),
              items: _placeOptions.entries
                  .map((entry) => DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      ))
                  .toList(),
              value: _selectedPlace,
              onChanged: (String? value) {
                setState(() {
                  _selectedPlace = value;
                });
              },
            ),
            //DROPDOWN PACKAGE
            DropdownButton<String>(
              hint: const Text('Select a package'),
              items: _packageOptions.entries
                  .map((entry) => DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      ))
                  .toList(),
              value: _selectedPackage,
              onChanged: (String? value) {
                setState(() {
                  _selectedPackage = value;
                });
              },
            ),
            //LIST
            Expanded(
                child: PackageList(
                    place: _selectedPlace ?? '',
                    packageType: _selectedPackage ?? '')),
          ],
        ));
  }
}

///WIDGET QUE MUESTRA UNA LISTA DE PAQUETES
class PackageList extends StatefulWidget {
  final String place;
  final String packageType;
  const PackageList(
      {super.key, required this.place, required this.packageType});

  @override
  State<PackageList> createState() => _PackageListState();
}

class _PackageListState extends State<PackageList> {
  List _packages = [];
  final _packageService = PackageService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          _packageService.getByPlaceAndType(widget.place, widget.packageType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else {
          _packages = snapshot.data ?? [];

          return ListView.builder(
            itemCount: _packages.length,
            itemBuilder: (context, index) {
              return PackageItem(package: _packages[index]);
            },
          );
        }
      },
    );
  }
}

///WIDGET QUE MUESTRA UN PAQUETE
class PackageItem extends StatefulWidget {
  final Package package;
  const PackageItem({super.key, required this.package});

  @override
  State<PackageItem> createState() => _PackageItemState();
}

class _PackageItemState extends State<PackageItem> {
  bool _isFavorite = false;
  final _packageDao = PackageDao();

  checkFavorite() {
    _packageDao.isFavorite(widget.package.id).then(
      (value) {
        if (mounted) {
          setState(() {
            _isFavorite = value;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    checkFavorite();

    return Card(
      child: Column(
        children: [
          //IMAGEN
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.package.image,
              height: width * 0.75,
              width: width,
              fit: BoxFit.cover,
            ),
          ),
          //NOMBRE
          Text(
            widget.package.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          //UBICACION
          Text(widget.package.location),
          //TOGGLE FAVORITE
          IconButton(
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
              _isFavorite
                  ? _packageDao.insert(widget.package)
                  : _packageDao.delete(widget.package.id);
            },
            icon: _isFavorite
                ? Icon(
                    Icons.favorite,
                    color: Theme.of(context).primaryColor,
                  )
                : Icon(Icons.favorite_border,
                    color: Theme.of(context).hintColor),
          ),
          //DESCRIPCION
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.package.description),
          )
        ],
      ),
    );
  }
}
