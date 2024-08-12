class Message {
  String msg;
  final MessageType msgType;
  final List<double>? prediction;

  Message({required this.msg, required this.msgType, this.prediction});
}

enum MessageType { user, bot }
