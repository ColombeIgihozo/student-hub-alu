import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/models.dart';

class AppState extends ChangeNotifier {
  AppPhase phase = AppPhase.splash;
  bool authed = false;
  String role = 'Student';
  AppTab tab = AppTab.home;
  final List<AppOverlayRoute> overlayStack = [];
  final Map<String, String> rsvp = {};
  final Map<String, bool> joined = {'c1': true, 'c2': true, 'c4': true, 'c7': true};
  final Map<String, bool> saved = {};
  final Map<String, String> notifReadIds = {};
  int streak = 5;
  final List<EventItem> posts = [];
  String? toastMessage;
  EventItem? shareEvent;

  List<EventItem> get allEvents => [...MockData.events, ...posts];

  int get chatUnread =>
      MockData.chats.fold(0, (sum, c) => sum + c.unread);

  bool get canPost => role == 'Club Leader' || role == 'Organizer';

  void setPhase(AppPhase value) {
    phase = value;
    notifyListeners();
  }

  void authenticate(String selectedRole) {
    authed = true;
    role = selectedRole;
    phase = AppPhase.app;
    notifyListeners();
  }

  void logout() {
    authed = false;
    phase = AppPhase.auth;
    overlayStack.clear();
    tab = AppTab.home;
    notifyListeners();
  }

  void switchTab(AppTab value) {
    overlayStack.clear();
    tab = value;
    notifyListeners();
  }

  void push(String name, [Map<String, String> params = const {}]) {
    overlayStack.add(AppOverlayRoute(name: name, params: params));
    notifyListeners();
  }

  void pop() {
    if (overlayStack.isNotEmpty) {
      overlayStack.removeLast();
      notifyListeners();
    }
  }

  void toggleRsvp(String id, String? type) {
    final current = rsvp[id];
    if (current == type || type == null) {
      rsvp.remove(id);
    } else {
      rsvp[id] = type;
      if (type == 'going') {
        showToast("You're going! 🎉");
      }
    }
    notifyListeners();
  }

  void toggleJoin(String id) {
    if (joined.containsKey(id)) {
      joined.remove(id);
    } else {
      joined[id] = true;
    }
    notifyListeners();
  }

  void toggleSave(String id) {
    if (saved.containsKey(id)) {
      saved.remove(id);
      showToast('Removed from saved');
    } else {
      saved[id] = true;
      showToast('Saved');
    }
    notifyListeners();
  }

  void addPost(EventItem event) {
    posts.insert(0, event);
    notifyListeners();
  }

  void markAllNotificationsRead() {
    for (final n in MockData.notifications) {
      notifReadIds[n.id] = 'read';
    }
    notifyListeners();
  }

  bool isNotificationRead(String id) => notifReadIds.containsKey(id);

  void showToast(String message) {
    toastMessage = message;
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), () {
      if (toastMessage == message) {
        toastMessage = null;
        notifyListeners();
      }
    });
  }

  void openShare(EventItem event) {
    shareEvent = event;
    notifyListeners();
  }

  void closeShare() {
    shareEvent = null;
    notifyListeners();
  }

  String? rsvpStatus(String id) => rsvp[id];

  bool isJoined(String id) => joined.containsKey(id);

  bool isSaved(String id) => saved.containsKey(id);
}
