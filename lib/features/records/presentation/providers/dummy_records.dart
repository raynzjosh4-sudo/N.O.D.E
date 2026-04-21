import 'package:node_app/features/records/data/models/main_record_model.dart';
import 'package:node_app/features/records/data/models/record_data_model.dart';
import 'package:node_app/features/records/data/models/record_detail_model.dart';
import 'package:node_app/features/records/data/models/record_model.dart';
import 'package:node_app/features/records/data/models/reminder_model.dart';
import '../../domain/types/record_types.dart';

final List<MainRecordModel> dummyRecords = [
  MainRecordModel(
    id: 'b1a2c3d4-e5f6-40a1-b2c3-d4e5f6a9b8c7',
    updatedAt: DateTime.now(),
    detail: RecordDetailModel(
      contactName: 'Jane Shop (Nets)',
      itemName: 'Mosquito Nets',
      referenceTag: '#REC-04',
      unit: 'Nets',
      targetValue: 100,
      currentValue: 30,
      type: RecordType.standard,
    ),
    data: RecordDataModel(
      items: [
        RecordBreakdownItemModel(
          quantity: 30,
          name: 'Mosquito Nets',
          amount: 30,
        ),
      ],
      grandTotal: 30,
    ),
    reminder: ReminderModel(
      date: DateTime(2026, 4, 25),
      isRecurring: false,
      time: '08:30',
    ),
    records: [
      RecordModel(
        time: DateTime(2026, 4, 16, 10, 15),
        total: 10,
        message: 'First delivery received by Jane',
        balanceAfter: 10,
        reference: '#TRX-A1',
      ),
      RecordModel(
        time: DateTime(2026, 4, 17, 14, 20),
        total: 5,
        message: 'Additional small batch collection',
        balanceAfter: 15,
        reference: '#TRX-A2',
      ),
      RecordModel(
        time: DateTime(2026, 4, 18, 09, 00),
        total: 12,
        message: 'Weekend bulk inventory update',
        balanceAfter: 27,
        reference: '#TRX-A3',
      ),
      RecordModel(
        time: DateTime(2026, 4, 19, 11, 45),
        total: 3,
        message: 'Remaining items from shelf stock',
        balanceAfter: 30,
        reference: '#TRX-A4',
      ),
    ],
  ),
  MainRecordModel(
    id: 'c2d3e4f5-a6b7-41c2-d3e4-f5a6b7c8d9e0',
    updatedAt: DateTime.now(),
    detail: RecordDetailModel(
      contactName: 'Farm Station',
      itemName: 'Eggs Collection',
      referenceTag: '#Morning',
      unit: 'Eggs',
      targetValue: 200,
      currentValue: 145,
      type: RecordType.standard,
    ),
    data: RecordDataModel(
      items: [
        RecordBreakdownItemModel(
          quantity: 145,
          name: 'Eggs Collection',
          amount: 145,
        ),
      ],
      grandTotal: 175, // Cumulative for demo
    ),
    records: [
      RecordModel(
        time: DateTime(2026, 4, 19, 07, 30),
        total: 50,
        message: 'Layer batch #1 collection',
        balanceAfter: 50,
        reference: '#TRX-B1',
      ),
      RecordModel(
        time: DateTime(2026, 4, 19, 09, 00),
        total: 95,
        message: 'Bulk collection from main farm',
        balanceAfter: 145,
        reference: '#TRX-B2',
      ),
    ],
  ),
  MainRecordModel(
    id: 'd3e4f5a6-b7c8-42d3-e4f5-a6b7c8d9e0f1',
    updatedAt: DateTime.now(),
    detail: RecordDetailModel(
      contactName: 'Central Stores',
      itemName: 'Uniforms',
      referenceTag: '#REC-22',
      unit: 'Pairs',
      targetValue: 30,
      currentValue: 30,
      type: RecordType.standard,
    ),
    data: RecordDataModel(
      items: [
        RecordBreakdownItemModel(quantity: 30, name: 'Uniforms', amount: 30),
      ],
      grandTotal: 205,
    ),
    records: [
      RecordModel(
        time: DateTime(2026, 4, 18, 09, 00),
        total: 3,
        message: 'Sizing sample batch',
        balanceAfter: 3,
        reference: '#TRX-H1',
      ),
      RecordModel(
        time: DateTime(2026, 4, 18, 10, 00),
        total: 3,
        message: 'Front desk uniforms',
        balanceAfter: 6,
        reference: '#TRX-H2',
      ),
      RecordModel(
        time: DateTime(2026, 4, 18, 11, 00),
        total: 3,
        message: 'Security team pairs',
        balanceAfter: 9,
        reference: '#TRX-H3',
      ),
      RecordModel(
        time: DateTime(2026, 4, 18, 12, 00),
        total: 3,
        message: 'Maintenance crew',
        balanceAfter: 12,
        reference: '#TRX-H4',
      ),
      RecordModel(
        time: DateTime(2026, 4, 18, 13, 00),
        total: 3,
        message: 'Kitchen staff inventory',
        balanceAfter: 15,
        reference: '#TRX-H5',
      ),
      RecordModel(
        time: DateTime(2026, 4, 18, 14, 00),
        total: 3,
        message: 'Logistics department',
        balanceAfter: 18,
        reference: '#TRX-H6',
      ),
      RecordModel(
        time: DateTime(2026, 4, 18, 15, 00),
        total: 3,
        message: 'Admin office set',
        balanceAfter: 21,
        reference: '#TRX-H7',
      ),
      RecordModel(
        time: DateTime(2026, 4, 18, 16, 00),
        total: 3,
        message: 'Janitorial supply',
        balanceAfter: 24,
        reference: '#TRX-H8',
      ),
      RecordModel(
        time: DateTime(2026, 4, 18, 17, 00),
        total: 3,
        message: 'Temporary staff allocation',
        balanceAfter: 27,
        reference: '#TRX-H9',
      ),
      RecordModel(
        time: DateTime(2026, 4, 18, 18, 00),
        total: 3,
        message: 'Final inventory reconciliation',
        balanceAfter: 30,
        reference: '#TRX-H10',
      ),
    ],
  ),
  MainRecordModel(
    id: 'e4f5a6b7-c8d9-43e4-f5a6b7c8d9e0f1a2',
    updatedAt: DateTime.now(),
    detail: RecordDetailModel(
      contactName: 'Bulk Order',
      itemName: 'Multi-Item Order',
      referenceTag: '#REC-MULT',
      unit: 'Mixed',
      targetValue: 849000,
      currentValue: 289200,
      type: RecordType.standard,
    ),
    data: RecordDataModel(
      items: [
        RecordBreakdownItemModel(quantity: 2, name: 'rail net', amount: 200000),
        RecordBreakdownItemModel(quantity: 14, name: 's1', amount: 459000),
        RecordBreakdownItemModel(quantity: 3, name: '2 stand', amount: 190000),
      ],
      grandTotal: 289200,
    ),
    records: [
      RecordModel(
        time: DateTime(2026, 4, 19, 14, 00),
        total: 10000,
        message: 'Payment 4',
        balanceAfter: 289200,
        reference: '#TRX-BULK5',
      ),
      RecordModel(
        time: DateTime(2026, 4, 19, 13, 00),
        total: 49800,
        message: 'Payment 3',
        balanceAfter: 299200,
        reference: '#TRX-BULK4',
      ),
      RecordModel(
        time: DateTime(2026, 4, 19, 12, 00),
        total: 300000,
        message: 'Partial Payment',
        balanceAfter: 349000,
        reference: '#TRX-BULK3',
      ),
      RecordModel(
        time: DateTime(2026, 4, 19, 11, 00),
        total: 200000,
        message: 'Deposit paid',
        balanceAfter: 649000,
        reference: '#TRX-BULK2',
      ),
      RecordModel(
        time: DateTime(2026, 4, 19, 10, 00),
        total: 849000,
        message: 'Initial bulk supply',
        balanceAfter: 849000,
        reference: '#TRX-BULK1',
      ),
    ],
  ),
];
