import 'package:intl/intl.dart';

String pluralComment(int count) => Intl.plural(
      count,
      zero: 'no comment',
      one: '1 comment',
      other: '$count comments',
    );
