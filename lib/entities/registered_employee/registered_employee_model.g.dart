// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registered_employee_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRegisteredEmployeeModelCollection on Isar {
  IsarCollection<RegisteredEmployeeModel> get registeredEmployeeModels =>
      this.collection();
}

const RegisteredEmployeeModelSchema = CollectionSchema(
  name: r'RegisteredEmployeeModel',
  id: -2283952687240536134,
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
    r'userType': PropertySchema(
      id: 17,
      name: r'userType',
      type: IsarType.string,
    ),
    r'zone': PropertySchema(
      id: 18,
      name: r'zone',
      type: IsarType.string,
    )
  },
  estimateSize: _registeredEmployeeModelEstimateSize,
  serialize: _registeredEmployeeModelSerialize,
  deserialize: _registeredEmployeeModelDeserialize,
  deserializeProp: _registeredEmployeeModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _registeredEmployeeModelGetId,
  getLinks: _registeredEmployeeModelGetLinks,
  attach: _registeredEmployeeModelAttach,
  version: '3.1.0+1',
);

int _registeredEmployeeModelEstimateSize(
  RegisteredEmployeeModel object,
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
    final value = object.userType;
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

void _registeredEmployeeModelSerialize(
  RegisteredEmployeeModel object,
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
  writer.writeString(offsets[17], object.userType);
  writer.writeString(offsets[18], object.zone);
}

RegisteredEmployeeModel _registeredEmployeeModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RegisteredEmployeeModel();
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
  object.userType = reader.readStringOrNull(offsets[17]);
  object.zone = reader.readStringOrNull(offsets[18]);
  return object;
}

P _registeredEmployeeModelDeserializeProp<P>(
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
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _registeredEmployeeModelGetId(RegisteredEmployeeModel object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _registeredEmployeeModelGetLinks(
    RegisteredEmployeeModel object) {
  return [];
}

void _registeredEmployeeModelAttach(
    IsarCollection<dynamic> col, Id id, RegisteredEmployeeModel object) {
  object.id = id;
}

extension RegisteredEmployeeModelQueryWhereSort
    on QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QWhere> {
  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension RegisteredEmployeeModelQueryWhere on QueryBuilder<
    RegisteredEmployeeModel, RegisteredEmployeeModel, QWhereClause> {
  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterWhereClause> idBetween(
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

extension RegisteredEmployeeModelQueryFilter on QueryBuilder<
    RegisteredEmployeeModel, RegisteredEmployeeModel, QFilterCondition> {
  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> addressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> addressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> bankDetailsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bankDetails',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> bankDetailsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bankDetails',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> bankDetailsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bankDetails',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> bankDetailsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bankDetails',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> branchIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'branch',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> branchIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'branch',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> branchIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'branch',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> branchIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'branch',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> dateOfBirthIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateOfBirth',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> dateOfBirthIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateOfBirth',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> dateOfBirthIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateOfBirth',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> dateOfBirthIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateOfBirth',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> dateOfJoiningIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateOfJoining',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> dateOfJoiningIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateOfJoining',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> dateOfJoiningIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateOfJoining',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> dateOfJoiningIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateOfJoining',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> departmentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'department',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> departmentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'department',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> departmentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'department',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> departmentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'department',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> designationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'designation',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> designationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'designation',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> designationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'designation',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> designationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'designation',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> genderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> genderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> genderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> genderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> idProofIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'idProof',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> idProofIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'idProof',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> idProofIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idProof',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> idProofIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'idProof',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> mobileNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mobileNumber',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> mobileNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mobileNumber',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> mobileNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mobileNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> mobileNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mobileNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> profilePictureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'profilePicture',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> profilePictureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'profilePicture',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> profilePictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profilePicture',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> profilePictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profilePicture',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> regIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'regId',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> regIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'regId',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> regIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regId',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> regIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'regId',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> reportingManagerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reportingManager',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> reportingManagerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reportingManager',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> reportingManagerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportingManager',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> reportingManagerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reportingManager',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> reportingManagerNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reportingManagerName',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> reportingManagerNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reportingManagerName',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> reportingManagerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reportingManagerName',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> reportingManagerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reportingManagerName',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> statusEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> userTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userType',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> userTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userType',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> userTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> userTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> userTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> userTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> userTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> userTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
          QAfterFilterCondition>
      userTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
          QAfterFilterCondition>
      userTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> userTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userType',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> userTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userType',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> zoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'zone',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> zoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'zone',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
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

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> zoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zone',
        value: '',
      ));
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel,
      QAfterFilterCondition> zoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'zone',
        value: '',
      ));
    });
  }
}

extension RegisteredEmployeeModelQueryObject on QueryBuilder<
    RegisteredEmployeeModel, RegisteredEmployeeModel, QFilterCondition> {}

extension RegisteredEmployeeModelQueryLinks on QueryBuilder<
    RegisteredEmployeeModel, RegisteredEmployeeModel, QFilterCondition> {}

extension RegisteredEmployeeModelQuerySortBy
    on QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QSortBy> {
  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByBankDetails() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankDetails', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByBankDetailsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankDetails', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByBranch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branch', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByBranchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branch', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByDateOfBirth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByDateOfBirthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByDateOfJoining() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfJoining', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByDateOfJoiningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfJoining', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByDepartment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'department', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByDepartmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'department', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByDesignation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'designation', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByDesignationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'designation', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByIdProof() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProof', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByIdProofDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProof', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByMobileNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobileNumber', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByMobileNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobileNumber', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByProfilePicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicture', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByProfilePictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicture', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByRegId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regId', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByRegIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regId', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByReportingManager() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManager', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByReportingManagerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManager', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByReportingManagerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManagerName', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByReportingManagerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManagerName', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByUserType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userType', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByUserTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userType', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByZone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zone', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      sortByZoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zone', Sort.desc);
    });
  }
}

extension RegisteredEmployeeModelQuerySortThenBy on QueryBuilder<
    RegisteredEmployeeModel, RegisteredEmployeeModel, QSortThenBy> {
  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByBankDetails() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankDetails', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByBankDetailsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankDetails', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByBranch() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branch', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByBranchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'branch', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByDateOfBirth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByDateOfBirthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfBirth', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByDateOfJoining() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfJoining', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByDateOfJoiningDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateOfJoining', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByDepartment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'department', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByDepartmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'department', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByDesignation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'designation', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByDesignationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'designation', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByIdProof() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProof', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByIdProofDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idProof', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByMobileNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobileNumber', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByMobileNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mobileNumber', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByProfilePicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicture', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByProfilePictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicture', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByRegId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regId', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByRegIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regId', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByReportingManager() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManager', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByReportingManagerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManager', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByReportingManagerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManagerName', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByReportingManagerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reportingManagerName', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByUserType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userType', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByUserTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userType', Sort.desc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByZone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zone', Sort.asc);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QAfterSortBy>
      thenByZoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zone', Sort.desc);
    });
  }
}

extension RegisteredEmployeeModelQueryWhereDistinct on QueryBuilder<
    RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct> {
  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByBankDetails({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bankDetails', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByBranch({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'branch', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByDateOfBirth({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateOfBirth', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByDateOfJoining({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateOfJoining',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByDepartment({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'department', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByDesignation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'designation', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByGender({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByIdProof({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idProof', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByMobileNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mobileNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByProfilePicture({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profilePicture',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByRegId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'regId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByReportingManager({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reportingManager',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByReportingManagerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reportingManagerName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByUserType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RegisteredEmployeeModel, RegisteredEmployeeModel, QDistinct>
      distinctByZone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zone', caseSensitive: caseSensitive);
    });
  }
}

extension RegisteredEmployeeModelQueryProperty on QueryBuilder<
    RegisteredEmployeeModel, RegisteredEmployeeModel, QQueryProperty> {
  QueryBuilder<RegisteredEmployeeModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      bankDetailsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bankDetails');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      branchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'branch');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      dateOfBirthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateOfBirth');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      dateOfJoiningProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateOfJoining');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      departmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'department');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      designationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'designation');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      genderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gender');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      idProofProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idProof');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      mobileNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mobileNumber');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      profilePictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profilePicture');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      regIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'regId');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      reportingManagerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportingManager');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      reportingManagerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reportingManagerName');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, int?, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      userTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userType');
    });
  }

  QueryBuilder<RegisteredEmployeeModel, String?, QQueryOperations>
      zoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zone');
    });
  }
}
