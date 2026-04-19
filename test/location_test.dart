import 'package:flutter_test/flutter_test.dart';
import 'package:node_app/core/domain/entities/location.dart';

void main() {
  group('Location.create', () {
    test('should extract coordinates from address if lat/lng are 0.0', () {
      const address = 'Loc: 0.341, 32.583 (Kampala)';
      final location = Location.create(
        latitude: 0.0,
        longitude: 0.0,
        addressName: address,
      );

      expect(location.latitude, 0.341);
      expect(location.longitude, 32.583);
      expect(location.addressName, address);
    });

    test('should NOT override coordinates if they are already provided', () {
      const address = 'Loc: 0.341, 32.583 (Kampala)';
      final location = Location.create(
        latitude: 1.0,
        longitude: 2.0,
        addressName: address,
      );

      expect(location.latitude, 1.0);
      expect(location.longitude, 2.0);
    });

    test('should return 0.0 if format is invalid', () {
      const address = 'Just some address';
      final location = Location.create(
        latitude: 0.0,
        longitude: 0.0,
        addressName: address,
      );

      expect(location.latitude, 0.0);
      expect(location.longitude, 0.0);
    });
  });
}
