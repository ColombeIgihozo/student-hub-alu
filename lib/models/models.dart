import 'package:flutter/material.dart';

class Person {
  const Person({
    required this.id,
    required this.name,
    required this.initials,
    required this.hue,
  });

  final String id;
  final String name;
  final String initials;
  final double hue;
}

class Community {
  const Community({
    required this.id,
    required this.name,
    required this.members,
    required this.hue,
    required this.joined,
    required this.newActivity,
    required this.cat,
    required this.short,
    required this.about,
  });

  final String id;
  final String name;
  final int members;
  final double hue;
  final bool joined;
  final bool newActivity;
  final String cat;
  final String short;
  final String about;
}

class EventItem {
  const EventItem({
    required this.id,
    required this.title,
    required this.cat,
    required this.kind,
    required this.org,
    required this.day,
    required this.date,
    required this.time,
    required this.month,
    required this.campus,
    required this.hue,
    required this.going,
    required this.goingN,
    required this.interestedN,
    required this.about,
    this.featured = false,
    this.trending = false,
    this.max,
    this.deadline,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String cat;
  final String kind;
  final String org;
  final String day;
  final String date;
  final String time;
  final String month;
  final String campus;
  final double hue;
  final List<String> going;
  final int goingN;
  final int interestedN;
  final String about;
  final bool featured;
  final bool trending;
  final int? max;
  final String? deadline;
  final List<String> tags;
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.from,
    required this.text,
    required this.time,
  });

  final String id;
  final String from;
  final String text;
  final String time;
}

class ChatThread {
  const ChatThread({
    required this.id,
    required this.type,
    required this.name,
    required this.hue,
    required this.unread,
    required this.last,
    required this.time,
    required this.messages,
    this.cid,
    this.withPerson,
  });

  final String id;
  final String type;
  final String? cid;
  final String? withPerson;
  final String name;
  final double hue;
  final int unread;
  final String last;
  final String time;
  final List<ChatMessage> messages;
}

class BadgeItem {
  const BadgeItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.earned,
    required this.desc,
    this.progress,
  });

  final String id;
  final String name;
  final IconData icon;
  final bool earned;
  final String desc;
  final String? progress;
}

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.group,
    required this.type,
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
    this.who,
  });

  final String id;
  final String group;
  final String type;
  final IconData icon;
  final String? who;
  final String title;
  final String body;
  final String time;
  final bool unread;
}

class PulseData {
  const PulseData({
    required this.week,
    required this.topEventTitle,
    required this.topEventN,
    required this.trendingCommunity,
    required this.trendingGrowth,
    required this.newOpps,
    required this.quote,
    required this.quoteBy,
  });

  final String week;
  final String topEventTitle;
  final int topEventN;
  final String trendingCommunity;
  final String trendingGrowth;
  final int newOpps;
  final String quote;
  final String quoteBy;
}

class AppOverlayRoute {
  const AppOverlayRoute({required this.name, this.params = const {}});

  final String name;
  final Map<String, String> params;
}

enum AppPhase { splash, onboarding, auth, app }

enum AppTab { home, explore, communities, chat, profile }
