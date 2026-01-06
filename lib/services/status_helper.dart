import 'package:bizzmirth_app/services/status_config.dart';
import 'package:flutter/material.dart';

class StatusHelper {
  static const Map<String, StatusConfig> _statusMap = {
    '1': StatusConfig(text: 'Active', color: Colors.green),
    '2': StatusConfig(text: 'Pending', color: Colors.orange),
    '3': StatusConfig(text: 'Inactive', color: Colors.red),
  };

  static StatusConfig get(String status) {
    return _statusMap[status] ??
        const StatusConfig(text: 'Unknown', color: Colors.grey);
  }
}
