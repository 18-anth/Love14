import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:love14/controllers/poem_controller.dart';
import 'package:love14/utils/app_styles.dart';
import 'package:love14/widgets/poem_card.dart';

class AmapillaScreen extends StatelessWidget {
  const AmapillaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final poemController = Provider.of<PoemController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Poemas de Amor', style: AppStyles.titleStyle(context)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navegar a pantalla de agregar poema
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: poemController.poems.length,
        itemBuilder: (context, index) {
          final poem = poemController.poems[index];
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
