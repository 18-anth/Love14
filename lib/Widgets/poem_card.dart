import 'package:flutter/material.dart';
import 'package:love14/Widgets/romantic_button.dart';
import 'package:love14/models/poem.dart';
import 'package:love14/utils/app_styles.dart';
import 'package:love14/widgets/animated_flower.dart';

class PoemCard extends StatelessWidget {
  final Poem poem;
  final VoidCallback onFavoritePressed;
  final VoidCallback? onTap;

  const PoemCard({
    super.key,
    required this.poem,
    required this.onFavoritePressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xfff3ece7), Color(0xfff3ece7)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ), // Opcional: bordes redondeados
          boxShadow: const [
            BoxShadow(
              offset: Offset(-10, 10),
              color: Color.fromARGB(80, 0, 0, 0),
              blurRadius: 10,
            ),
            BoxShadow(
              offset: Offset(10, -10),
              color: Color.fromARGB(147, 202, 202, 202),
              blurRadius: 10,
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(poem.title, style: AppStyles.poemTitleStyle(context)),
                    RomanticButton(
                      onPressed: onFavoritePressed,
                      icon:
                          poem.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                      color: poem.isFavorite ? Colors.red : null,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(poem.content, style: AppStyles.poemContentStyle(context)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(poem.author, style: AppStyles.authorStyle(context)),
                    const AnimatedFlower(size: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
