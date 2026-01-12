// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_employee_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPendingEmployeeModelCollection on Isar {
  IsarCollection<PendingEmployeeModel> get pendingEmployeeModels =>
      this.collection();
}

const PendingEmployeeModelSchema = CollectionSchema(
  name: r'PendingEmployeeModel',
  id: 5839943665682173756,
  properties: {
    r'address': PropertySchema(
      id: 0,
      name: r'address',
      type: IsarType.string,
    ),
    r'bankDetails': PropertySchema(
      id: 1,
      name: r'bankDetails',
      type: IsarType.string,
    ),
    r'branch': PropertySchema(
      id: 2,
      name: r'branch',
      type: IsarType.string,
    ),
    r'dateOfBirth': PropertySchema(
      id: 3,
      name: r'dateOfBirth',
      type: IsarType.string,
    ),
    r'dateOfJoining': PropertySchema(
      id: 4,
      name: r'dateOfJoining',
      type: IsarType.string,
    ),
    r'department': PropertySchema(
      id: 5,
      name: r'department',
      type: IsarType.string,
    ),
    r'designation': PropertySchema(
      id: 6,
      name: r'designation',
      type: IsarType.string,
    ),
    r'email': PropertySchema(
      id: 7,
      name: r'email',
      type: IsarType.string,
    ),
    r'gender': PropertySchema(
      id: 8,
      name: r'gender',
      type: IsarType.string,
    ),
    r'idProof': PropertySchema(
      id: 9,
      name: r'idProof',
      type: IsarType.string,
    ),
    r'mobileNumber': PropertySchema(
      id: 10,
      name: r'mobileNumber',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 11,
      name: r'name',
      type: IsarType.string,
    ),
    r'profilePicture': PropertySchema(
      id: 12,
      name: r'profilePicture',
      type: IsarType.string,
    ),
    r'regId': PropertySchema(
      id: 13,
      name: r'regId',
      type: IsarType.string,
    ),
    r'reportingManager': PropertySchema(
      id: 14,
      name: r'reportingManager',
      type: IsarType.string,
    ),
    r'reportingManagerName': PropertySchema(
      id: 15,
      name: r'reportingManagerName',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 16,
      name: r'status',
      type: IsarType.long,
    ),
    r'zone': PropertySchema(
      id: 17,
      name: r'zone',
      type: IsarType.string,
    )
  },
  estimateSize: _pendingEmployeeModelEstimateSize,
  serialize: _pendingEmployeeModelSerialize,
  deserialize: _pendingEmployeeModelDeserialize,
  deserializeProp: _pendingEmployeeModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _pendingEmployeeModelGetId,
  getLinks: _pendingEmployeeModelGetLinks,
  attach: _pendingEmployeeModelAttach,
  version: '3.3.0',
);

int _pendingEmployeeModelEstimateSize(
  PendingEmployeeModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.address;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.bankDetails;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.branch;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.dateOfBirth;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.dateOfJoining;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.department;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.designation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.email;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.gender;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.idProof;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.mobileNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.profilePicture;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.regId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.reportingManager;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.reportingManagerName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.zone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _pendingEmployeeModelSerialize(
  PendingEmployeeModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeString(offsets[1], object.bankDetails);
  writer.writeString(offsets[2], object.branch);
  writer.writeString(offsets[3], object.dateOfBirth);
  writer.writeString(offsets[4], object.dateOfJoining);
  writer.writeString(offsets[5], object.department);
  writer.writeString(offsets[6], object.designation);
  writer.writeString(offsets[7], object.email);
  writer.writeString(offsets[8], object.gender);
  writer.writeString(offsets[9], object.idProof);
  writer.writeString(offsets[10], object.mobileNumber);
  writer.writeString(offsets[11], object.name);
  writer.writeString(offsets[12], object.profilePicture);
  writer.writeString(offsets[13], object.regId);
  writer.writeString(offsets[14], object.reportingManager);
  writer.writeString(offsets[15], object.reportingManagerName);
  writer.writeLong(offsets[16], object.status);
  writer.writeString(offsets[17], object.zone);
}

PendingEmployeeModel _pendingEmployeeModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PendingEmployeeModel();
  object.address = reader.readStringOrNull(offsets[0]);
  object.bankDetails = reader.readStringOrNull(offsets[1]);
  object.branch = reader.readStringOrNull(offsets[2]);
  object.dateOfBirth = reader.readStringOrNull(offsets[3]);
  object.dateOfJoining = reader.readStringOrNull(offsets[4]);
  object.department = reader.readStringOrNull(offsets[5]);
  object.designation = reader.readStringOrNull(offsets[6]);
  object.email = reader.readStringOrNull(offsets[7]);
  object.gender = reader.readStringOrNull(offsets[8]);
  object.id = id;
  object.idProof = reader.readStringOrNull(offsets[9]);
  object.mobileNumber = reader.readStringOrNull(offsets[10]);
  object.name = reader.readStringOrNull(offsets[11]);
  object.profilePicture = reader.readStringOrNull(offsets[12]);
  object.regId = reader.readStringOrNull(offsets[13]);
  object.reportingManager = reader.readStringOrNull(offsets[14]);
  object.reportingManagerName = reader.readStringOrNull(offsets[15]);
  object.status = reader.readLongOrNull(offsets[16]);
  object.zone = reader.readStringOrNull(offsets[17]);
  return object;
}

P _pendingEmployeeModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readLongOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pendingEmployeeModelGetId(PendingEmployeeModel object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _pendingEmployeeModelGetLinks(
    PendingEmployeeModel object) {
  return [];
}

void _pendingEmployeeModelAttach(
    IsarCollection<dynamic> col, Id id, PendingEmployeeModel object) {
  object.id = id;
}

extension PendingEmployeeModelQueryWhereSort
    on QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QWhere> {
  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PendingEmployeeModelQueryWhere
    on QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QWhereClause> {
  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PendingEmployeeModelQueryFilter on QueryBuilder<PendingEmployeeModel,
    PendingEmployeeModel, QFilterCondition> {
  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> addressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> addressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> addressEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> addressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> addressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> addressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'address',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> addressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> addressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      addressContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      addressMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'address',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> bankDetailsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bankDetails',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> bankDetailsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bankDetails',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> bankDetailsEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bankDetails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> bankDetailsGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bankDetails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> bankDetailsLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bankDetails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> bankDetailsBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bankDetails',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> bankDetailsStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bankDetails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> bankDetailsEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bankDetails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      bankDetailsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bankDetails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      bankDetailsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bankDetails',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> bankDetailsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bankDetails',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> bankDetailsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bankDetails',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> branchIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'branch',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> branchIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'branch',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> branchEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'branch',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> branchGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'branch',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> branchLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'branch',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> branchBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'branch',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> branchStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'branch',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> branchEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'branch',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      branchContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'branch',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      branchMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'branch',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> branchIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'branch',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> branchIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'branch',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfBirthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateOfBirth',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfBirthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateOfBirth',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfBirthEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfBirthGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfBirthLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfBirthBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateOfBirth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfBirthStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dateOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfBirthEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dateOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      dateOfBirthContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dateOfBirth',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      dateOfBirthMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dateOfBirth',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfBirthIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateOfBirth',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfBirthIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateOfBirth',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfJoiningIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateOfJoining',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfJoiningIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateOfJoining',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfJoiningEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateOfJoining',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfJoiningGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateOfJoining',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfJoiningLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateOfJoining',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfJoiningBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateOfJoining',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfJoiningStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dateOfJoining',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfJoiningEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dateOfJoining',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      dateOfJoiningContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dateOfJoining',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      dateOfJoiningMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dateOfJoining',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfJoiningIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateOfJoining',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> dateOfJoiningIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateOfJoining',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> departmentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'department',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> departmentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'department',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> departmentEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'department',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> departmentGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'department',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> departmentLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'department',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> departmentBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'department',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> departmentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'department',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> departmentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'department',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      departmentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'department',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      departmentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'department',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> departmentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'department',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> departmentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'department',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> designationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'designation',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> designationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'designation',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> designationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'designation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> designationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'designation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> designationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'designation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> designationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'designation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> designationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'designation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> designationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'designation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      designationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'designation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      designationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'designation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> designationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'designation',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> designationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'designation',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> emailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> emailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> emailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> emailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'email',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> emailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> emailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      emailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'email',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      emailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'email',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> genderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> genderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> genderEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> genderGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> genderLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> genderBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gender',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> genderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> genderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      genderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gender',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      genderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gender',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> genderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> genderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idProofIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'idProof',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idProofIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'idProof',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idProofEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idProofGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idProofLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idProofBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idProof',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idProofStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'idProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idProofEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'idProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      idProofContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'idProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      idProofMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'idProof',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idProofIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idProof',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> idProofIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idProof',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> mobileNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mobileNumber',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> mobileNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mobileNumber',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> mobileNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mobileNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> mobileNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mobileNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> mobileNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mobileNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> mobileNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mobileNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> mobileNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mobileNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> mobileNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mobileNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      mobileNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mobileNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      mobileNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mobileNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> mobileNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mobileNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> mobileNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mobileNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> profilePictureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'profilePicture',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> profilePictureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'profilePicture',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> profilePictureEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> profilePictureGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> profilePictureLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> profilePictureBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profilePicture',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> profilePictureStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'profilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> profilePictureEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'profilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      profilePictureContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profilePicture',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      profilePictureMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profilePicture',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> profilePictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profilePicture',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> profilePictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profilePicture',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> regIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'regId',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> regIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'regId',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> regIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> regIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'regId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> regIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'regId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> regIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'regId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> regIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'regId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> regIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'regId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      regIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'regId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      regIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'regId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> regIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regId',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> regIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'regId',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reportingManager',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reportingManager',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportingManager',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reportingManager',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reportingManager',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reportingManager',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reportingManager',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reportingManager',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      reportingManagerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reportingManager',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      reportingManagerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reportingManager',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportingManager',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reportingManager',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reportingManagerName',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reportingManagerName',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportingManagerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reportingManagerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reportingManagerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reportingManagerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reportingManagerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reportingManagerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      reportingManagerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reportingManagerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      reportingManagerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reportingManagerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportingManagerName',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> reportingManagerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reportingManagerName',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> statusEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> statusGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> statusLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> statusBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> zoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'zone',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> zoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'zone',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> zoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> zoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'zone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> zoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'zone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> zoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'zone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> zoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'zone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> zoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'zone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      zoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'zone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
          QAfterFilterCondition>
      zoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'zone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> zoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zone',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel,
      QAfterFilterCondition> zoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'zone',
        value: '',
      ));
    });
  }
}

extension PendingEmployeeModelQueryObject on QueryBuilder<PendingEmployeeModel,
    PendingEmployeeModel, QFilterCondition> {}

extension PendingEmployeeModelQueryLinks on QueryBuilder<PendingEmployeeModel,
    PendingEmployeeModel, QFilterCondition> {}

extension PendingEmployeeModelQuerySortBy
    on QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QSortBy> {
  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByBankDetails() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankDetails', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByBankDetailsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankDetails', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByBranch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branch', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByBranchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branch', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByDateOfBirth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByDateOfBirthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByDateOfJoining() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfJoining', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByDateOfJoiningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfJoining', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByDepartment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'department', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByDepartmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'department', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByDesignation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'designation', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByDesignationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'designation', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByIdProof() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProof', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByIdProofDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProof', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByMobileNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobileNumber', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByMobileNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobileNumber', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByProfilePicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicture', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByProfilePictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicture', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByRegId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regId', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByRegIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regId', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByReportingManager() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManager', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByReportingManagerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManager', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByReportingManagerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManagerName', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByReportingManagerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManagerName', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByZone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zone', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      sortByZoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zone', Sort.desc);
    });
  }
}

extension PendingEmployeeModelQuerySortThenBy
    on QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QSortThenBy> {
  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByBankDetails() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankDetails', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByBankDetailsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankDetails', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByBranch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branch', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByBranchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branch', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByDateOfBirth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByDateOfBirthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByDateOfJoining() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfJoining', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByDateOfJoiningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfJoining', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByDepartment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'department', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByDepartmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'department', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByDesignation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'designation', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByDesignationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'designation', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByIdProof() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProof', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByIdProofDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProof', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByMobileNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobileNumber', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByMobileNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobileNumber', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByProfilePicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicture', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByProfilePictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicture', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByRegId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regId', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByRegIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regId', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByReportingManager() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManager', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByReportingManagerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManager', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByReportingManagerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManagerName', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByReportingManagerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManagerName', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByZone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zone', Sort.asc);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QAfterSortBy>
      thenByZoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zone', Sort.desc);
    });
  }
}

extension PendingEmployeeModelQueryWhereDistinct
    on QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct> {
  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByBankDetails({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bankDetails', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByBranch({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'branch', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByDateOfBirth({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateOfBirth', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByDateOfJoining({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateOfJoining',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByDepartment({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'department', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByDesignation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'designation', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByGender({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByIdProof({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idProof', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByMobileNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mobileNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByProfilePicture({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profilePicture',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByRegId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'regId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByReportingManager({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reportingManager',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByReportingManagerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reportingManagerName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<PendingEmployeeModel, PendingEmployeeModel, QDistinct>
      distinctByZone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zone', caseSensitive: caseSensitive);
    });
  }
}

extension PendingEmployeeModelQueryProperty on QueryBuilder<
    PendingEmployeeModel, PendingEmployeeModel, QQueryProperty> {
  QueryBuilder<PendingEmployeeModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations>
      addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations>
      bankDetailsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bankDetails');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations>
      branchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'branch');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations>
      dateOfBirthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateOfBirth');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations>
      dateOfJoiningProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateOfJoining');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations>
      departmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'department');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations>
      designationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'designation');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations>
      emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations>
      genderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gender');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations>
      idProofProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idProof');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations>
      mobileNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mobileNumber');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations>
      profilePictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profilePicture');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations>
      regIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'regId');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations>
      reportingManagerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportingManager');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations>
      reportingManagerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportingManagerName');
    });
  }

  QueryBuilder<PendingEmployeeModel, int?, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<PendingEmployeeModel, String?, QQueryOperations> zoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zone');
    });
  }
}
