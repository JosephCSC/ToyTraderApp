// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conversation _$ConversationFromJson(Map json) => Conversation(
      json['otherUserId'] as String,
      json['lastMessage'] as String,
      json['time'] as String,
    );

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'otherUserId': instance.otherUserId,
      'lastMessage': instance.lastMessage,
      'time': instance.time,
    };