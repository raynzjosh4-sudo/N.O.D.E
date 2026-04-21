class ReminderModel {
  final DateTime? date;
  final bool isRecurring;
  final String? time;

  ReminderModel({
    this.date,
    this.isRecurring = false,
    this.time,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      isRecurring: json['is_recurring'] as bool? ?? false,
      time: json['time'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String(),
      'is_recurring': isRecurring,
      'time': time,
    };
  }
}
