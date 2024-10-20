class DeviceData {
  final String deviceId;
  final double voltage;
  final double current;
  final double vibration;
  final double temperature;
  final double humidity;
  final double onHours;

  DeviceData({
    required this.deviceId,
    required this.voltage,
    required this.current,
    required this.vibration,
    required this.temperature,
    required this.humidity,
    required this.onHours,
  });

  // Factory method to convert Firebase document to DeviceData object
  factory DeviceData.fromFirestore(Map<String, dynamic> json) {
    return DeviceData(
      deviceId: json['deviceId'],
      voltage: json['voltage'],
      current: json['current'],
      vibration: json['vibration'],
      temperature: json['temperature'],
      humidity: json['humidity'],
      onHours: json['onHours'],
    );
  }

  // Method to convert DeviceData to a JSON object for Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'deviceId': deviceId,
      'voltage': voltage,
      'current': current,
      'vibration': vibration,
      'temperature': temperature,
      'humidity': humidity,
      'onHours': onHours,
    };
  }
}
