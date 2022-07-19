class MyItem {
  const MyItem(this.id, this.name);

  final int id;
  final String name;

  MyItem.defaultItem(this.id) : name = 'Default Item';
  MyItem.moreItem(this.id) : name = 'More Items';
  MyItem.moreItemBefore(this.id) : name = 'More Items Before';
}

class Message {
  final String text;
  final DateTime date;
  final bool isMe;

  const Message({required this.text, required this.date, this.isMe = true});

  Message.text(this.text)
      : date = DateTime.now(),
        isMe = true;

  static List<Message> dummyMessages({int? year, int? month, int? day}) {
    final dateYear = year ?? 2022;
    final dateMonth = month ?? 7;
    final dateDay = day ?? 13;
    return [
      Message(
        text: 'Hi. sam',
        date: DateTime(dateYear, dateMonth, dateDay, 8, 58, 30),
        isMe: true,
      ),
      Message(
        text: 'Michael. Good to meet you!',
        date: DateTime(dateYear, dateMonth, dateDay, 8, 58, 48),
        isMe: false,
      ),
      Message(
        text: 'How are you?',
        date: DateTime(dateYear, dateMonth, dateDay, 8, 58, 58),
        isMe: true,
      ),
      Message(
        text: 'I am fine. Thank you.',
        date: DateTime(dateYear, dateMonth, dateDay, 8, 59, 0),
        isMe: false,
      ),
      Message(
        text: 'What kind of music do you like?',
        date: DateTime(dateYear, dateMonth, dateDay, 8, 59, 10),
        isMe: true,
      ),
      Message(
        text: 'I love country. i\'ve met taylor swift before too. you?',
        date: DateTime(dateYear, dateMonth, dateDay, 8, 59, 20),
        isMe: false,
      ),
      Message(
        text: 'I have never met taylor swift.',
        date: DateTime(dateYear, dateMonth, dateDay, 8, 59, 40),
        isMe: true,
      ),
      Message(
        text: 'She\'s nice. it was at a concert',
        date: DateTime(dateYear, dateMonth, dateDay, 8, 59, 50),
        isMe: false,
      ),
      Message(
        text: 'Have you read any good books lately?',
        date: DateTime(dateYear, dateMonth, dateDay, 8, 59, 59),
        isMe: true,
      ),
      Message(
        text: 'I\'ve read a lot of good books. I\'m not a big reader.',
        date: DateTime(dateYear, dateMonth, dateDay, 9, 0, 10),
        isMe: false,
      ),
      Message(
        text: 'What\'s your favorite book?',
        date: DateTime(dateYear, dateMonth, dateDay, 9, 0, 20),
        isMe: true,
      ),
      Message(
        text: 'The Hobbit',
        date: DateTime(dateYear, dateMonth, dateDay, 9, 0, 30),
        isMe: false,
      ),
      Message(
        text: 'Do you like horror books?',
        date: DateTime(dateYear, dateMonth, dateDay, 9, 0, 40),
        isMe: true,
      ),
      Message(
        text: 'I don\'t like horror books. I prefer fantasy.',
        date: DateTime(dateYear, dateMonth, dateDay, 9, 0, 50),
        isMe: false,
      ),
      Message(
        text: 'What\'s your favorite color?',
        date: DateTime(dateYear, dateMonth, dateDay, 9, 1, 0),
        isMe: true,
      ),
      Message(
        text: 'I like rainbow colors. the meds i take make me see things ',
        date: DateTime(dateYear, dateMonth, dateDay, 9, 1, 10),
        isMe: false,
      ),
      Message(
        text: 'That sounds like a lot of fun?',
        date: DateTime(dateYear, dateMonth, dateDay, 9, 1, 20),
        isMe: true,
      ),
      Message(
        text: 'I don\'t like horror books. I prefer fantasy.',
        date: DateTime(dateYear, dateMonth, dateDay, 9, 1, 30),
        isMe: false,
      ),
      Message(
        text: 'What\'s your favorite book?',
        date: DateTime(dateYear, dateMonth, dateDay, 9, 1, 40),
        isMe: true,
      ),
      Message(
        text: 'The Hobbit',
        date: DateTime(dateYear, dateMonth, dateDay, 9, 1, 50),
        isMe: false,
      ),
      Message(
        text: 'Do you like horror books?',
        date: DateTime(dateYear, dateMonth, dateDay, 9, 2, 0),
        isMe: true,
      ),
    ];
  }
}
