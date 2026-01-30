// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_record.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetServiceRecordCollection on Isar {
  IsarCollection<int, ServiceRecord> get serviceRecords => this.collection();
}

final ServiceRecordSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'ServiceRecord',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(name: 'vehicleId', type: IsarType.long),
      IsarPropertySchema(name: 'serviceType', type: IsarType.string),
      IsarPropertySchema(name: 'serviceDate', type: IsarType.dateTime),
      IsarPropertySchema(name: 'description', type: IsarType.string),
      IsarPropertySchema(name: 'cost', type: IsarType.double),
      IsarPropertySchema(name: 'mechanic', type: IsarType.string),
      IsarPropertySchema(name: 'notes', type: IsarType.string),
      IsarPropertySchema(name: 'createdAt', type: IsarType.dateTime),
      IsarPropertySchema(name: 'updatedAt', type: IsarType.dateTime),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<int, ServiceRecord>(
    serialize: serializeServiceRecord,
    deserialize: deserializeServiceRecord,
    deserializeProperty: deserializeServiceRecordProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeServiceRecord(IsarWriter writer, ServiceRecord object) {
  IsarCore.writeLong(writer, 1, object.vehicleId);
  IsarCore.writeString(writer, 2, object.serviceType);
  IsarCore.writeLong(
    writer,
    3,
    object.serviceDate.toUtc().microsecondsSinceEpoch,
  );
  {
    final value = object.description;
    if (value == null) {
      IsarCore.writeNull(writer, 4);
    } else {
      IsarCore.writeString(writer, 4, value);
    }
  }
  IsarCore.writeDouble(writer, 5, object.cost ?? double.nan);
  {
    final value = object.mechanic;
    if (value == null) {
      IsarCore.writeNull(writer, 6);
    } else {
      IsarCore.writeString(writer, 6, value);
    }
  }
  {
    final value = object.notes;
    if (value == null) {
      IsarCore.writeNull(writer, 7);
    } else {
      IsarCore.writeString(writer, 7, value);
    }
  }
  IsarCore.writeLong(
    writer,
    8,
    object.createdAt.toUtc().microsecondsSinceEpoch,
  );
  IsarCore.writeLong(
    writer,
    9,
    object.updatedAt.toUtc().microsecondsSinceEpoch,
  );
  return object.id;
}

@isarProtected
ServiceRecord deserializeServiceRecord(IsarReader reader) {
  final int _vehicleId;
  _vehicleId = IsarCore.readLong(reader, 1);
  final String _serviceType;
  _serviceType = IsarCore.readString(reader, 2) ?? '';
  final DateTime _serviceDate;
  {
    final value = IsarCore.readLong(reader, 3);
    if (value == -9223372036854775808) {
      _serviceDate =
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    } else {
      _serviceDate =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  final String? _description;
  _description = IsarCore.readString(reader, 4);
  final double? _cost;
  {
    final value = IsarCore.readDouble(reader, 5);
    if (value.isNaN) {
      _cost = null;
    } else {
      _cost = value;
    }
  }
  final String? _mechanic;
  _mechanic = IsarCore.readString(reader, 6);
  final String? _notes;
  _notes = IsarCore.readString(reader, 7);
  final object = ServiceRecord(
    vehicleId: _vehicleId,
    serviceType: _serviceType,
    serviceDate: _serviceDate,
    description: _description,
    cost: _cost,
    mechanic: _mechanic,
    notes: _notes,
  );
  object.id = IsarCore.readId(reader);
  {
    final value = IsarCore.readLong(reader, 8);
    if (value == -9223372036854775808) {
      object.createdAt =
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    } else {
      object.createdAt =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  {
    final value = IsarCore.readLong(reader, 9);
    if (value == -9223372036854775808) {
      object.updatedAt =
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    } else {
      object.updatedAt =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  return object;
}

@isarProtected
dynamic deserializeServiceRecordProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readLong(reader, 1);
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      {
        final value = IsarCore.readLong(reader, 3);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 4:
      return IsarCore.readString(reader, 4);
    case 5:
      {
        final value = IsarCore.readDouble(reader, 5);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 6:
      return IsarCore.readString(reader, 6);
    case 7:
      return IsarCore.readString(reader, 7);
    case 8:
      {
        final value = IsarCore.readLong(reader, 8);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    case 9:
      {
        final value = IsarCore.readLong(reader, 9);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(
            value,
            isUtc: true,
          ).toLocal();
        }
      }
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _ServiceRecordUpdate {
  bool call({
    required int id,
    int? vehicleId,
    String? serviceType,
    DateTime? serviceDate,
    String? description,
    double? cost,
    String? mechanic,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

class _ServiceRecordUpdateImpl implements _ServiceRecordUpdate {
  const _ServiceRecordUpdateImpl(this.collection);

  final IsarCollection<int, ServiceRecord> collection;

  @override
  bool call({
    required int id,
    Object? vehicleId = ignore,
    Object? serviceType = ignore,
    Object? serviceDate = ignore,
    Object? description = ignore,
    Object? cost = ignore,
    Object? mechanic = ignore,
    Object? notes = ignore,
    Object? createdAt = ignore,
    Object? updatedAt = ignore,
  }) {
    return collection.updateProperties(
          [id],
          {
            if (vehicleId != ignore) 1: vehicleId as int?,
            if (serviceType != ignore) 2: serviceType as String?,
            if (serviceDate != ignore) 3: serviceDate as DateTime?,
            if (description != ignore) 4: description as String?,
            if (cost != ignore) 5: cost as double?,
            if (mechanic != ignore) 6: mechanic as String?,
            if (notes != ignore) 7: notes as String?,
            if (createdAt != ignore) 8: createdAt as DateTime?,
            if (updatedAt != ignore) 9: updatedAt as DateTime?,
          },
        ) >
        0;
  }
}

sealed class _ServiceRecordUpdateAll {
  int call({
    required List<int> id,
    int? vehicleId,
    String? serviceType,
    DateTime? serviceDate,
    String? description,
    double? cost,
    String? mechanic,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

class _ServiceRecordUpdateAllImpl implements _ServiceRecordUpdateAll {
  const _ServiceRecordUpdateAllImpl(this.collection);

  final IsarCollection<int, ServiceRecord> collection;

  @override
  int call({
    required List<int> id,
    Object? vehicleId = ignore,
    Object? serviceType = ignore,
    Object? serviceDate = ignore,
    Object? description = ignore,
    Object? cost = ignore,
    Object? mechanic = ignore,
    Object? notes = ignore,
    Object? createdAt = ignore,
    Object? updatedAt = ignore,
  }) {
    return collection.updateProperties(id, {
      if (vehicleId != ignore) 1: vehicleId as int?,
      if (serviceType != ignore) 2: serviceType as String?,
      if (serviceDate != ignore) 3: serviceDate as DateTime?,
      if (description != ignore) 4: description as String?,
      if (cost != ignore) 5: cost as double?,
      if (mechanic != ignore) 6: mechanic as String?,
      if (notes != ignore) 7: notes as String?,
      if (createdAt != ignore) 8: createdAt as DateTime?,
      if (updatedAt != ignore) 9: updatedAt as DateTime?,
    });
  }
}

extension ServiceRecordUpdate on IsarCollection<int, ServiceRecord> {
  _ServiceRecordUpdate get update => _ServiceRecordUpdateImpl(this);

  _ServiceRecordUpdateAll get updateAll => _ServiceRecordUpdateAllImpl(this);
}

sealed class _ServiceRecordQueryUpdate {
  int call({
    int? vehicleId,
    String? serviceType,
    DateTime? serviceDate,
    String? description,
    double? cost,
    String? mechanic,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

class _ServiceRecordQueryUpdateImpl implements _ServiceRecordQueryUpdate {
  const _ServiceRecordQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<ServiceRecord> query;
  final int? limit;

  @override
  int call({
    Object? vehicleId = ignore,
    Object? serviceType = ignore,
    Object? serviceDate = ignore,
    Object? description = ignore,
    Object? cost = ignore,
    Object? mechanic = ignore,
    Object? notes = ignore,
    Object? createdAt = ignore,
    Object? updatedAt = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (vehicleId != ignore) 1: vehicleId as int?,
      if (serviceType != ignore) 2: serviceType as String?,
      if (serviceDate != ignore) 3: serviceDate as DateTime?,
      if (description != ignore) 4: description as String?,
      if (cost != ignore) 5: cost as double?,
      if (mechanic != ignore) 6: mechanic as String?,
      if (notes != ignore) 7: notes as String?,
      if (createdAt != ignore) 8: createdAt as DateTime?,
      if (updatedAt != ignore) 9: updatedAt as DateTime?,
    });
  }
}

extension ServiceRecordQueryUpdate on IsarQuery<ServiceRecord> {
  _ServiceRecordQueryUpdate get updateFirst =>
      _ServiceRecordQueryUpdateImpl(this, limit: 1);

  _ServiceRecordQueryUpdate get updateAll =>
      _ServiceRecordQueryUpdateImpl(this);
}

class _ServiceRecordQueryBuilderUpdateImpl
    implements _ServiceRecordQueryUpdate {
  const _ServiceRecordQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<ServiceRecord, ServiceRecord, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? vehicleId = ignore,
    Object? serviceType = ignore,
    Object? serviceDate = ignore,
    Object? description = ignore,
    Object? cost = ignore,
    Object? mechanic = ignore,
    Object? notes = ignore,
    Object? createdAt = ignore,
    Object? updatedAt = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (vehicleId != ignore) 1: vehicleId as int?,
        if (serviceType != ignore) 2: serviceType as String?,
        if (serviceDate != ignore) 3: serviceDate as DateTime?,
        if (description != ignore) 4: description as String?,
        if (cost != ignore) 5: cost as double?,
        if (mechanic != ignore) 6: mechanic as String?,
        if (notes != ignore) 7: notes as String?,
        if (createdAt != ignore) 8: createdAt as DateTime?,
        if (updatedAt != ignore) 9: updatedAt as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension ServiceRecordQueryBuilderUpdate
    on QueryBuilder<ServiceRecord, ServiceRecord, QOperations> {
  _ServiceRecordQueryUpdate get updateFirst =>
      _ServiceRecordQueryBuilderUpdateImpl(this, limit: 1);

  _ServiceRecordQueryUpdate get updateAll =>
      _ServiceRecordQueryBuilderUpdateImpl(this);
}

extension ServiceRecordQueryFilter
    on QueryBuilder<ServiceRecord, ServiceRecord, QFilterCondition> {
  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition> idEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  idGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  idGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition> idLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 0, value: value));
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  idLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 0, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition> idBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 0, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  vehicleIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 1, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  vehicleIdGreaterThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 1, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  vehicleIdGreaterThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 1, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  vehicleIdLessThan(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 1, value: value));
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  vehicleIdLessThanOrEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 1, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  vehicleIdBetween(int lower, int upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 1, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceTypeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceTypeGreaterThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceTypeGreaterThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceTypeLessThan(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 2, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceTypeLessThanOrEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceTypeBetween(String lower, String upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 2, value: ''),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceDateGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceDateGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceDateLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 3, value: value));
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceDateLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 3, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  serviceDateBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 3, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 4));
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  descriptionIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 4));
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  descriptionEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  descriptionGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  descriptionGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  descriptionLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 4, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  descriptionLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  descriptionBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 4,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 4, value: ''),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  costIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  costIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition> costEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  costGreaterThan(double? value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  costGreaterThanOrEqualTo(double? value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  costLessThan(double? value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  costLessThanOrEqualTo(double? value, {double epsilon = Filter.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 5, value: value, epsilon: epsilon),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition> costBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  mechanicIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  mechanicIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  mechanicEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  mechanicGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  mechanicGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  mechanicLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 6, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  mechanicLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  mechanicBetween(String? lower, String? upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  mechanicStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  mechanicEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  mechanicContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  mechanicMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 6,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  mechanicIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  mechanicIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 6, value: ''),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  notesIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  notesEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  notesGreaterThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  notesGreaterThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  notesLessThan(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(property: 7, value: value, caseSensitive: caseSensitive),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  notesLessThanOrEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  notesBetween(String? lower, String? upper, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 7,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  notesStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  notesEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 7,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(property: 7, value: ''),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  createdAtGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  createdAtLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 8, value: value));
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  createdAtLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 8, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  createdAtBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 8, lower: lower, upper: upper),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  updatedAtGreaterThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  updatedAtLessThan(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(LessCondition(property: 9, value: value));
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  updatedAtLessThanOrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(property: 9, value: value),
      );
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterFilterCondition>
  updatedAtBetween(DateTime lower, DateTime upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(property: 9, lower: lower, upper: upper),
      );
    });
  }
}

extension ServiceRecordQueryObject
    on QueryBuilder<ServiceRecord, ServiceRecord, QFilterCondition> {}

extension ServiceRecordQuerySortBy
    on QueryBuilder<ServiceRecord, ServiceRecord, QSortBy> {
  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> sortByVehicleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy>
  sortByVehicleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> sortByServiceType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy>
  sortByServiceTypeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> sortByServiceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy>
  sortByServiceDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> sortByDescription({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy>
  sortByDescriptionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> sortByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> sortByCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> sortByMechanic({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> sortByMechanicDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> sortByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> sortByNotesDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }
}

extension ServiceRecordQuerySortThenBy
    on QueryBuilder<ServiceRecord, ServiceRecord, QSortThenBy> {
  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> thenByVehicleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy>
  thenByVehicleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> thenByServiceType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy>
  thenByServiceTypeDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> thenByServiceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy>
  thenByServiceDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> thenByDescription({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy>
  thenByDescriptionDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> thenByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> thenByCostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> thenByMechanic({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> thenByMechanicDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> thenByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> thenByNotesDesc({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }
}

extension ServiceRecordQueryWhereDistinct
    on QueryBuilder<ServiceRecord, ServiceRecord, QDistinct> {
  QueryBuilder<ServiceRecord, ServiceRecord, QAfterDistinct>
  distinctByVehicleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterDistinct>
  distinctByServiceType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterDistinct>
  distinctByServiceDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterDistinct>
  distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterDistinct> distinctByCost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterDistinct>
  distinctByMechanic({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterDistinct> distinctByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }

  QueryBuilder<ServiceRecord, ServiceRecord, QAfterDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9);
    });
  }
}

extension ServiceRecordQueryProperty1
    on QueryBuilder<ServiceRecord, ServiceRecord, QProperty> {
  QueryBuilder<ServiceRecord, int, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ServiceRecord, int, QAfterProperty> vehicleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ServiceRecord, String, QAfterProperty> serviceTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ServiceRecord, DateTime, QAfterProperty> serviceDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ServiceRecord, String?, QAfterProperty> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ServiceRecord, double?, QAfterProperty> costProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ServiceRecord, String?, QAfterProperty> mechanicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ServiceRecord, String?, QAfterProperty> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ServiceRecord, DateTime, QAfterProperty> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ServiceRecord, DateTime, QAfterProperty> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }
}

extension ServiceRecordQueryProperty2<R>
    on QueryBuilder<ServiceRecord, R, QAfterProperty> {
  QueryBuilder<ServiceRecord, (R, int), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ServiceRecord, (R, int), QAfterProperty> vehicleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ServiceRecord, (R, String), QAfterProperty>
  serviceTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ServiceRecord, (R, DateTime), QAfterProperty>
  serviceDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ServiceRecord, (R, String?), QAfterProperty>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ServiceRecord, (R, double?), QAfterProperty> costProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ServiceRecord, (R, String?), QAfterProperty> mechanicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ServiceRecord, (R, String?), QAfterProperty> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ServiceRecord, (R, DateTime), QAfterProperty>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ServiceRecord, (R, DateTime), QAfterProperty>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }
}

extension ServiceRecordQueryProperty3<R1, R2>
    on QueryBuilder<ServiceRecord, (R1, R2), QAfterProperty> {
  QueryBuilder<ServiceRecord, (R1, R2, int), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<ServiceRecord, (R1, R2, int), QOperations> vehicleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<ServiceRecord, (R1, R2, String), QOperations>
  serviceTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<ServiceRecord, (R1, R2, DateTime), QOperations>
  serviceDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<ServiceRecord, (R1, R2, String?), QOperations>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<ServiceRecord, (R1, R2, double?), QOperations> costProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<ServiceRecord, (R1, R2, String?), QOperations>
  mechanicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<ServiceRecord, (R1, R2, String?), QOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<ServiceRecord, (R1, R2, DateTime), QOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<ServiceRecord, (R1, R2, DateTime), QOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }
}
