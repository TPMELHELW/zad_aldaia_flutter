import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zad_aldaia/core/di/dependency_injection.dart';
import 'package:zad_aldaia/core/helpers/storage.dart';
import 'package:zad_aldaia/features/items/data/models/item.dart';
import 'package:zad_aldaia/features/items/logic/items_cubit.dart';
import 'package:zad_aldaia/features/items/ui/widgets/image_item.dart';
import 'package:zad_aldaia/features/items/ui/widgets/text_item.dart';
import 'package:zad_aldaia/features/items/ui/widgets/video_item.dart';
import 'package:zad_aldaia/generated/l10n.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final ItemsCubit cubit = getIt<ItemsCubit>();
  String query = '';
  loadData() {
    cubit.loadItems(likeMap: {'content': query});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              SearchBar(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
                hintText: S.of(context).search,
                trailing: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.clear),
                  ),
                ],
                onChanged: (value) {
                  query = value;
                },
              ),
              Expanded(
                child: BlocProvider(
                  create: (context) => cubit,
                  child: BlocBuilder<ItemsCubit, ItemsState>(
                    builder: (context, state) {
                      if (state is ErrorState) {
                        return Center(child: Text(state.error));
                      }
                      if (state is LoadingState) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is ListLoadedState) {
                        if (state.items.isEmpty) {
                          return Center(child: Text('Empty'));
                        }
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.items.length,
                                itemBuilder: (context, index) {
                                  var prevItemId = index > 0 ? state.items[index - 1].id : null;
                                  var item = state.items[index];
                                  var nextItemId = index < state.items.length - 1 ? state.items[index + 1].id : null;
                                  switch (item.type) {
                                    case ItemType.text:
                                      return TextItem(
                                        item: item,
                                        onItemUp: (item) async {
                                          await cubit.swapItemsOrder(item.id, prevItemId ?? "", index, index - 1);
                                          loadData();
                                        },
                                        onItemDown: (item) async {
                                          await cubit.swapItemsOrder(item.id, nextItemId ?? "", index, index + 1);
                                          loadData();
                                        },
                                      );
                                    case ItemType.image:
                                      return ImageItem(
                                        item: item,
                                        onItemUp: (item) async {
                                          await cubit.swapItemsOrder(item.id, prevItemId ?? "", index, index - 1);
                                          loadData();
                                        },
                                        onItemDown: (item) async {
                                          await cubit.swapItemsOrder(item.id, nextItemId ?? "", index, index + 1);
                                          loadData();
                                        },
                                        onDownloadPressed: (url) async {
                                          Storage.download(url);
                                        },
                                      );
                                    case ItemType.video:
                                      return VideoItem(
                                        item: item,
                                        onItemUp: (item) async {
                                          await cubit.swapItemsOrder(item.id, prevItemId ?? "", index, index - 1);
                                          loadData();
                                        },
                                        onItemDown: (item) async {
                                          await cubit.swapItemsOrder(item.id, nextItemId ?? "", index, index + 1);
                                          loadData();
                                        },
                                      );
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
