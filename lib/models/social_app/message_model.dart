class MessageModel
{
   String ? senderId;
   String ? receiverTd;
   String ? dateTime;
   String ? text;



   MessageModel({
     this.senderId,
     this.receiverTd,
     this.dateTime,
     this.text,

  });

   MessageModel.fromJson(Map<String , dynamic> json)
  {
    senderId = json['senderId'];
    receiverTd = json['receiverTd'];
    dateTime = json['dateTime'];
    text = json['text'];

  }

  Map<String , dynamic> toMap()
  {
    return {
      'senderId':senderId,
      'receiverTd':receiverTd,
      'dateTime':dateTime,
      'text':text,
    };
  }
}