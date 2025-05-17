import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:love14/controllers/poem_controller.dart';
import 'package:love14/utils/app_styles.dart';
import 'package:love14/widgets/poem_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final poemController = Provider.of<PoemController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos', style: AppStyles.titleStyle(context)),
        centerTitle: true,
      ),
      body:
          poemController.favoritePoems.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No tienes poemas favoritos',
                      style: AppStyles.poemContentStyle(context),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: poemController.favoritePoems.length,
                itemBuilder: (context, index) {
                  final poem = poemController.favoritePoems[index];
                  return PoemCard(
                    poem: poem,
                    onFavoritePressed: () {
                      poemController.toggleFavorite(poem.id);
                    },
                  );
                },
              ),
    );
  }
}
