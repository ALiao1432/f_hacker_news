import 'package:f_hacker_news/data/model/item.dart';
import 'package:f_hacker_news/intl/plural.dart';
import 'package:flutter/material.dart';

typedef OnItemTap = void Function(Item item);
typedef OnItemLongPress = void Function(Item item);
typedef OnItemHover<T> = void Function(T t);

class HackerNewsItem extends StatelessWidget {
  final Item item;
  final OnItemTap onItemTap;

  const HackerNewsItem({
    this.item,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: RichText(
        text: TextSpan(
            text: item.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            children: [
              if (item.url != null) TextSpan(
                text: ' (${Uri.parse(item.url).host})',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ]),
      ),
      subtitle: Wrap(
        children: [
          Text('${item.score} points by ${item.by}'),
          const Text(' | ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(item.type),
          const Text(' | ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(pluralComment(item.descendants ?? 0)),
        ],
      ),
      onTap: onItemTap == null ? null : () => onItemTap(item),
    );
  }
}
