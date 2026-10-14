// Modelos prontos para serialização futura (Firebase/API): adicione fromJson/toJson aqui.
enum ProfileType { responsible, child }

class User {
  final String id, name, email, phone;
  final ProfileType profileType;
  final String? photoUrl;
  final DateTime createdAt;
  const User({required this.id, required this.name, required this.email, required this.phone,
      this.profileType = ProfileType.responsible, this.photoUrl, required this.createdAt});
}

class Child {
  final String id, name, responsibleId, deviceId;
  final DateTime birthDate, createdAt;
  final String? photoUrl;
  final bool locationEnabled;
  const Child({required this.id, required this.name, required this.birthDate, this.photoUrl,
      required this.responsibleId, required this.deviceId, this.locationEnabled = true,
      required this.createdAt});
  int get age {
    final n = DateTime.now();
    return n.year - birthDate.year - ((n.month < birthDate.month ||
        (n.month == birthDate.month && n.day < birthDate.day)) ? 1 : 0);
  }
}

class Location {
  final String id, childId;
  final double latitude, longitude, accuracy;
  final DateTime timestamp;
  const Location({required this.id, required this.childId, required this.latitude,
      required this.longitude, required this.timestamp, this.accuracy = 10});
}

enum AlertType { leftSafeZone, enteredSafeZone, locationUnavailable, lowBattery, deviceDisconnected }
enum AlertPriority { high, medium, low }

class Alert {
  final String id, childId, title, message;
  final AlertType type;
  final DateTime timestamp;
  final bool read;
  const Alert({required this.id, required this.childId, required this.type, required this.title,
      required this.message, required this.timestamp, this.read = false});
  AlertPriority get priority => switch (type) {
        AlertType.leftSafeZone || AlertType.deviceDisconnected => AlertPriority.high,
        AlertType.lowBattery || AlertType.locationUnavailable => AlertPriority.medium,
        _ => AlertPriority.low,
      };
  Alert copyWith({bool? read}) => Alert(id: id, childId: childId, type: type, title: title,
      message: message, timestamp: timestamp, read: read ?? this.read);
}

class SafeZone {
  final String id, childId, name;
  final double latitude, longitude, radius; // radius em metros
  final DateTime createdAt;
  const SafeZone({required this.id, required this.childId, required this.name,
      required this.latitude, required this.longitude, required this.radius, required this.createdAt});
}

class LocationHistory {
  final String id, childId, address;
  final double latitude, longitude;
  final DateTime timestamp;
  const LocationHistory({required this.id, required this.childId, required this.latitude,
      required this.longitude, required this.timestamp, this.address = ''});
}
