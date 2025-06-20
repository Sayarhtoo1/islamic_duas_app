import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:islamic_duas_app/models/dua.dart';
import 'package:islamic_duas_app/providers/favorite_dua_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Duas',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Consumer<FavoriteDuaProvider>(
        builder: (context, provider, child) {
          if (provider.favoriteDuas.isEmpty) {
            return Center(child: Text('No favorite duas yet.'));
          } else {
            return ListView.builder(
              itemCount: provider.favoriteDuas.length,
              itemBuilder: (context, index) {
                Dua dua = provider.favoriteDuas[index];
                return Card(
                  color: Theme.of(context).cardColor,
                  elevation: Theme.of(context).cardTheme.elevation,
                  shape: Theme.of(context).cardTheme.shape,
                  margin: Theme.of(context).cardTheme.margin,
                  child: ListTile(
                    title: Text(
                      dua.titleMyanmar,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      dua.categoryMyanmar,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        provider.isFavorite(dua) ? Icons.favorite : Icons.favorite_border,
                        color: provider.isFavorite(dua) ? Theme.of(context).hintColor : Colors.grey,
                      ),
                      onPressed: () {
                        provider.toggleFavorite(dua);
                      },
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/duaDetail',
                        arguments: dua,
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}