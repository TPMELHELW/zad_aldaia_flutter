import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zad_aldaia/core/helpers/share.dart';
import 'package:zad_aldaia/core/routing/routes.dart';
import 'package:zad_aldaia/features/items/data/models/item.dart';

class ImageItem extends StatefulWidget {
  final Item item;
  final bool? isSelected;
  final Function(Item)? onSelect;
  final Function(Item)? onItemUp;
  final Function(Item)? onItemDown;
  final Future Function(String) onDownloadPressed;

  const ImageItem({
    super.key, 
    required this.item, 
    required this.onDownloadPressed, 
    this.onSelect, 
    this.isSelected, 
    this.onItemUp, 
    this.onItemDown
  });

  @override
  State<ImageItem> createState() => _ImageItemState();
}

class _ImageItemState extends State<ImageItem> {
  bool isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
           widget.item.title ?? 'Image',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF005A32)),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: widget.item.imageUrl ?? '',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            _buildActionBar(),
          ],
        ),
      ],
    );
  }

  Widget _buildActionBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: isDownloading 
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(),
                    )
                  : const Icon(Icons.download, color: Color(0xFF005A32)),
                onPressed: isDownloading ? null : _downloadImage,
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Color(0xFF005A32)),
                onPressed: () => Share.item(widget.item),
              ),
            ],
          ),
          Row(
            children: [
              if (Supabase.instance.client.auth.currentUser != null) ...[
                IconButton(
                  icon: const Icon(Icons.arrow_upward, color: Color(0xFF005A32)),
                  onPressed: () => widget.onItemUp?.call(widget.item),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward, color: Color(0xFF005A32)),
                  onPressed: () => widget.onItemDown?.call(widget.item),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF005A32)),
                  onPressed: () => Navigator.of(context).pushNamed(
                    MyRoutes.addItemScreen, 
                    arguments: {"id": widget.item.id}
                  ),
                ),
              ],
              if (widget.isSelected != null)
                IconButton(
                  icon: Icon(
                    widget.isSelected! ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: const Color(0xFF005A32),
                  ),
                  onPressed: () => widget.onSelect?.call(widget.item),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _downloadImage() async {
    setState(() => isDownloading = true);
    try {
      await widget.onDownloadPressed(widget.item.imageUrl ?? '');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image downloaded successfully')),
      );
    } finally {
      setState(() => isDownloading = false);
    }
  }
}