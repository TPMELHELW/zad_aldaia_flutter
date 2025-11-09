import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zad_aldaia/core/routing/routes.dart';
import 'package:zad_aldaia/features/categories/data/models/category.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;
  final Function(Category)? onMoveUp;
  final Function(Category)? onMoveDown;

  const CategoryWidget({super.key, required this.category, this.onTap, this.onMoveUp, this.onMoveDown});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: category.isActive ? 1.0 : 0.5,
      child: Card(
        elevation: 2.0,
        child: ListTile(
          onTap: onTap,
          leading: (category.image == null) ? null : CachedNetworkImage(imageUrl: category.image!, height: 50, width: 50, fit: BoxFit.cover),
          title: Text(category.title ?? '---'),
          subtitle: Text(category.lang ?? ''),
          // subtitle: Text('${category.childrenCount} - ${category.articlesCount}'),
          trailing:
              (Supabase.instance.client.auth.currentUser == null)
                  ? null
                  : SizedBox(
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.amber),
                          onPressed: () {
                            Navigator.of(context).pushNamed(MyRoutes.addCategoryScreen, arguments: {"id": category.id});
                          },
                        ),
                        Column(
                          children: [
                            InkWell(onTap: () => onMoveUp?.call(category), child: Icon(Icons.arrow_circle_up)),
                            InkWell(onTap: () => onMoveDown?.call(category), child: Icon(Icons.arrow_circle_down)),
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
