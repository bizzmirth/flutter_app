// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_techno_enterprise_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPendingTechnoEnterpriseModelCollection on Isar {
  IsarCollection<PendingTechnoEnterpriseModel>
      get pendingTechnoEnterpriseModels => this.collection();
}

const PendingTechnoEnterpriseModelSchema = CollectionSchema(
  name: r'PendingTechnoEnterpriseModel',
  id: 2592237727399448207,
  properties: {
    r'address': PropertySchema(
      id: 0,
      name: r'address',
      type: IsarType.string,
    ),
    r'adharCard': PropertySchema(
      id: 1,
      name: r'adharCard',
      type: IsarType.string,
    ),
    r'amount': PropertySchema(
      id: 2,
      name: r'amount',
      type: IsarType.string,
    ),
    r'bankPassbook': PropertySchema(
      id: 3,
      name: r'bankPassbook',
      type: IsarType.string,
    ),
    r'businessPackage': PropertySchema(
      id: 4,
      name: r'businessPackage',
      type: IsarType.string,
    ),
    r'city': PropertySchema(
      id: 5,
      name: r'city',
      type: IsarType.string,
    ),
    r'country': PropertySchema(
      id: 6,
      name: r'country',
      type: IsarType.string,
    ),
    r'countryCd': PropertySchema(
      id: 7,
      name: r'countryCd',
      type: IsarType.string,
    ),
    r'dob': PropertySchema(
      id: 8,
      name: r'dob',
      type: IsarType.string,
    ),
    r'email': PropertySchema(
      id: 9,
      name: r'email',
      type: IsarType.string,
    ),
    r'gender': PropertySchema(
      id: 10,
      name: r'gender',
      type: IsarType.string,
    ),
    r'gstNo': PropertySchema(
      id: 11,
      name: r'gstNo',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 12,
      name: r'name',
      type: IsarType.string,
    ),
    r'nomineeName': PropertySchema(
      id: 13,
      name: r'nomineeName',
      type: IsarType.string,
    ),
    r'nomineeRelation': PropertySchema(
      id: 14,
      name: r'nomineeRelation',
      type: IsarType.string,
    ),
    r'packageFor': PropertySchema(
      id: 15,
      name: r'packageFor',
      type: IsarType.string,
    ),
    r'panCard': PropertySchema(
      id: 16,
      name: r'panCard',
      type: IsarType.string,
    ),
    r'paymentProof': PropertySchema(
      id: 17,
      name: r'paymentProof',
      type: IsarType.string,
    ),
    r'phoneNumber': PropertySchema(
      id: 18,
      name: r'phoneNumber',
      type: IsarType.string,
    ),
    r'pincode': PropertySchema(
      id: 19,
      name: r'pincode',
      type: IsarType.string,
    ),
    r'profilePicture': PropertySchema(
      id: 20,
      name: r'profilePicture',
      type: IsarType.string,
    ),
    r'refName': PropertySchema(
      id: 21,
      name: r'refName',
      type: IsarType.string,
    ),
    r'state': PropertySchema(
      id: 22,
      name: r'state',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 23,
      name: r'status',
      type: IsarType.long,
    ),
    r'userId': PropertySchema(
      id: 24,
      name: r'userId',
      type: IsarType.string,
    ),
    r'votingCard': PropertySchema(
      id: 25,
      name: r'votingCard',
      type: IsarType.string,
    )
  },
  estimateSize: _pendingTechnoEnterpriseModelEstimateSize,
  serialize: _pendingTechnoEnterpriseModelSerialize,
  deserialize: _pendingTechnoEnterpriseModelDeserialize,
  deserializeProp: _pendingTechnoEnterpriseModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _pendingTechnoEnterpriseModelGetId,
  getLinks: _pendingTechnoEnterpriseModelGetLinks,
  attach: _pendingTechnoEnterpriseModelAttach,
  version: '3.1.0+1',
);

int _pendingTechnoEnterpriseModelEstimateSize(
  PendingTechnoEnterpriseModel object,
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
    final value = object.adharCard;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.amount;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.bankPassbook;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.businessPackage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.city;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.country;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.countryCd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.dob;
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
    final value = object.gstNo;
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
    final value = object.nomineeName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.nomineeRelation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.packageFor;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.panCard;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.paymentProof;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.phoneNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pincode;
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
    final value = object.refName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.state;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.votingCard;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _pendingTechnoEnterpriseModelSerialize(
  PendingTechnoEnterpriseModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeString(offsets[1], object.adharCard);
  writer.writeString(offsets[2], object.amount);
  writer.writeString(offsets[3], object.bankPassbook);
  writer.writeString(offsets[4], object.businessPackage);
  writer.writeString(offsets[5], object.city);
  writer.writeString(offsets[6], object.country);
  writer.writeString(offsets[7], object.countryCd);
  writer.writeString(offsets[8], object.dob);
  writer.writeString(offsets[9], object.email);
  writer.writeString(offsets[10], object.gender);
  writer.writeString(offsets[11], object.gstNo);
  writer.writeString(offsets[12], object.name);
  writer.writeString(offsets[13], object.nomineeName);
  writer.writeString(offsets[14], object.nomineeRelation);
  writer.writeString(offsets[15], object.packageFor);
  writer.writeString(offsets[16], object.panCard);
  writer.writeString(offsets[17], object.paymentProof);
  writer.writeString(offsets[18], object.phoneNumber);
  writer.writeString(offsets[19], object.pincode);
  writer.writeString(offsets[20], object.profilePicture);
  writer.writeString(offsets[21], object.refName);
  writer.writeString(offsets[22], object.state);
  writer.writeLong(offsets[23], object.status);
  writer.writeString(offsets[24], object.userId);
  writer.writeString(offsets[25], object.votingCard);
}

PendingTechnoEnterpriseModel _pendingTechnoEnterpriseModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PendingTechnoEnterpriseModel();
  object.address = reader.readStringOrNull(offsets[0]);
  object.adharCard = reader.readStringOrNull(offsets[1]);
  object.amount = reader.readStringOrNull(offsets[2]);
  object.bankPassbook = reader.readStringOrNull(offsets[3]);
  object.businessPackage = reader.readStringOrNull(offsets[4]);
  object.city = reader.readStringOrNull(offsets[5]);
  object.country = reader.readStringOrNull(offsets[6]);
  object.countryCd = reader.readStringOrNull(offsets[7]);
  object.dob = reader.readStringOrNull(offsets[8]);
  object.email = reader.readStringOrNull(offsets[9]);
  object.gender = reader.readStringOrNull(offsets[10]);
  object.gstNo = reader.readStringOrNull(offsets[11]);
  object.id = id;
  object.name = reader.readStringOrNull(offsets[12]);
  object.nomineeName = reader.readStringOrNull(offsets[13]);
  object.nomineeRelation = reader.readStringOrNull(offsets[14]);
  object.packageFor = reader.readStringOrNull(offsets[15]);
  object.panCard = reader.readStringOrNull(offsets[16]);
  object.paymentProof = reader.readStringOrNull(offsets[17]);
  object.phoneNumber = reader.readStringOrNull(offsets[18]);
  object.pincode = reader.readStringOrNull(offsets[19]);
  object.profilePicture = reader.readStringOrNull(offsets[20]);
  object.refName = reader.readStringOrNull(offsets[21]);
  object.state = reader.readStringOrNull(offsets[22]);
  object.status = reader.readLongOrNull(offsets[23]);
  object.userId = reader.readStringOrNull(offsets[24]);
  object.votingCard = reader.readStringOrNull(offsets[25]);
  return object;
}

P _pendingTechnoEnterpriseModelDeserializeProp<P>(
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
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readLongOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pendingTechnoEnterpriseModelGetId(PendingTechnoEnterpriseModel object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _pendingTechnoEnterpriseModelGetLinks(
    PendingTechnoEnterpriseModel object) {
  return [];
}

void _pendingTechnoEnterpriseModelAttach(
    IsarCollection<dynamic> col, Id id, PendingTechnoEnterpriseModel object) {
  object.id = id;
}

extension PendingTechnoEnterpriseModelQueryWhereSort on QueryBuilder<
    PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel, QWhere> {
  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PendingTechnoEnterpriseModelQueryWhere on QueryBuilder<
    PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel, QWhereClause> {
  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

extension PendingTechnoEnterpriseModelQueryFilter on QueryBuilder<
    PendingTechnoEnterpriseModel,
    PendingTechnoEnterpriseModel,
    QFilterCondition> {
  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> addressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> addressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> adharCardIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'adharCard',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> adharCardIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'adharCard',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> adharCardEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adharCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> adharCardGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'adharCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> adharCardLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'adharCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> adharCardBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'adharCard',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> adharCardStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'adharCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> adharCardEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'adharCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      adharCardContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'adharCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      adharCardMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'adharCard',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> adharCardIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adharCard',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> adharCardIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'adharCard',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> amountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> amountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'amount',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> amountEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> amountGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> amountLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> amountBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> amountStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> amountEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      amountContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'amount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      amountMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'amount',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> amountIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> amountIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'amount',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> bankPassbookIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bankPassbook',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> bankPassbookIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bankPassbook',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> bankPassbookEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bankPassbook',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> bankPassbookGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bankPassbook',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> bankPassbookLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bankPassbook',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> bankPassbookBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bankPassbook',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> bankPassbookStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bankPassbook',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> bankPassbookEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bankPassbook',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      bankPassbookContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bankPassbook',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      bankPassbookMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bankPassbook',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> bankPassbookIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bankPassbook',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> bankPassbookIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bankPassbook',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> businessPackageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'businessPackage',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> businessPackageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'businessPackage',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> businessPackageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> businessPackageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'businessPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> businessPackageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'businessPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> businessPackageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'businessPackage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> businessPackageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'businessPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> businessPackageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'businessPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      businessPackageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'businessPackage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      businessPackageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'businessPackage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> businessPackageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'businessPackage',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> businessPackageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'businessPackage',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> cityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'city',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> cityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'city',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> cityEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> cityGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> cityLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> cityBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'city',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> cityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> cityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      cityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'city',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      cityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'city',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> cityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> cityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'city',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'country',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'country',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'country',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      countryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'country',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      countryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'country',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'country',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'country',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'countryCd',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'countryCd',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countryCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryCdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'countryCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryCdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'countryCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryCdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'countryCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'countryCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'countryCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      countryCdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'countryCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      countryCdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'countryCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'countryCd',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> countryCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'countryCd',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> dobIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dob',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> dobIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dob',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> dobEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dob',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> dobGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dob',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> dobLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dob',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> dobBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dob',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> dobStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dob',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> dobEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dob',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      dobContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dob',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      dobMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dob',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> dobIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dob',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> dobIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dob',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> emailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> emailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'email',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'email',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> genderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> genderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gender',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> genderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> genderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gender',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> gstNoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'gstNo',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> gstNoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'gstNo',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> gstNoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gstNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> gstNoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'gstNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> gstNoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'gstNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> gstNoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'gstNo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> gstNoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'gstNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> gstNoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'gstNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      gstNoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'gstNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      gstNoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'gstNo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> gstNoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'gstNo',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> gstNoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'gstNo',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nomineeName',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nomineeName',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nomineeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nomineeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nomineeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nomineeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nomineeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nomineeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      nomineeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nomineeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      nomineeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nomineeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nomineeName',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nomineeName',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeRelationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nomineeRelation',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeRelationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nomineeRelation',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeRelationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nomineeRelation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeRelationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nomineeRelation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeRelationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nomineeRelation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeRelationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nomineeRelation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeRelationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nomineeRelation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeRelationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nomineeRelation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      nomineeRelationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nomineeRelation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      nomineeRelationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nomineeRelation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeRelationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nomineeRelation',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> nomineeRelationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nomineeRelation',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> packageForIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'packageFor',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> packageForIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'packageFor',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> packageForEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageFor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> packageForGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packageFor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> packageForLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packageFor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> packageForBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packageFor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> packageForStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'packageFor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> packageForEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'packageFor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      packageForContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'packageFor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      packageForMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'packageFor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> packageForIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageFor',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> packageForIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'packageFor',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> panCardIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'panCard',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> panCardIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'panCard',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> panCardEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'panCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> panCardGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'panCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> panCardLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'panCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> panCardBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'panCard',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> panCardStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'panCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> panCardEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'panCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      panCardContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'panCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      panCardMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'panCard',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> panCardIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'panCard',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> panCardIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'panCard',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> paymentProofIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'paymentProof',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> paymentProofIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'paymentProof',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> paymentProofEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> paymentProofGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> paymentProofLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> paymentProofBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentProof',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> paymentProofStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paymentProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> paymentProofEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paymentProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      paymentProofContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paymentProof',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      paymentProofMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paymentProof',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> paymentProofIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentProof',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> paymentProofIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paymentProof',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> phoneNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'phoneNumber',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> phoneNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'phoneNumber',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> phoneNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> phoneNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> phoneNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> phoneNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phoneNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> phoneNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> phoneNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      phoneNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phoneNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      phoneNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phoneNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> phoneNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phoneNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> phoneNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phoneNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> pincodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pincode',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> pincodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pincode',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> pincodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pincode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> pincodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pincode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> pincodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pincode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> pincodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pincode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> pincodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pincode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> pincodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pincode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      pincodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pincode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      pincodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pincode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> pincodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pincode',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> pincodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pincode',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> profilePictureIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'profilePicture',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> profilePictureIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'profilePicture',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> profilePictureIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profilePicture',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> profilePictureIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profilePicture',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> refNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'refName',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> refNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'refName',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> refNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'refName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> refNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'refName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> refNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'refName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> refNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'refName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> refNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'refName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> refNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'refName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      refNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'refName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      refNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'refName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> refNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'refName',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> refNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'refName',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> stateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'state',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> stateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'state',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> stateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> stateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> stateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> stateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'state',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> stateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> stateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      stateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      stateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'state',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> stateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> stateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> statusIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> statusIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'status',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> statusEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
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

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> userIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> userIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> userIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> userIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> votingCardIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'votingCard',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> votingCardIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'votingCard',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> votingCardEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'votingCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> votingCardGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'votingCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> votingCardLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'votingCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> votingCardBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'votingCard',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> votingCardStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'votingCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> votingCardEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'votingCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      votingCardContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'votingCard',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
          QAfterFilterCondition>
      votingCardMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'votingCard',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> votingCardIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'votingCard',
        value: '',
      ));
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterFilterCondition> votingCardIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'votingCard',
        value: '',
      ));
    });
  }
}

extension PendingTechnoEnterpriseModelQueryObject on QueryBuilder<
    PendingTechnoEnterpriseModel,
    PendingTechnoEnterpriseModel,
    QFilterCondition> {}

extension PendingTechnoEnterpriseModelQueryLinks on QueryBuilder<
    PendingTechnoEnterpriseModel,
    PendingTechnoEnterpriseModel,
    QFilterCondition> {}

extension PendingTechnoEnterpriseModelQuerySortBy on QueryBuilder<
    PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel, QSortBy> {
  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByAdharCard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adharCard', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByAdharCardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adharCard', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByBankPassbook() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankPassbook', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByBankPassbookDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankPassbook', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByBusinessPackage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessPackage', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByBusinessPackageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessPackage', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByCountryCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryCd', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByCountryCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryCd', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByDob() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dob', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByDobDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dob', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByGstNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstNo', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByGstNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstNo', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByNomineeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomineeName', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByNomineeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomineeName', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByNomineeRelation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomineeRelation', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByNomineeRelationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomineeRelation', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByPackageFor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageFor', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByPackageForDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageFor', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByPanCard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'panCard', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByPanCardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'panCard', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByPaymentProof() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentProof', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByPaymentProofDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentProof', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByPhoneNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByPhoneNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByPincode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pincode', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByPincodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pincode', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByProfilePicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicture', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByProfilePictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicture', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByRefName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refName', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByRefNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refName', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByVotingCard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'votingCard', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> sortByVotingCardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'votingCard', Sort.desc);
    });
  }
}

extension PendingTechnoEnterpriseModelQuerySortThenBy on QueryBuilder<
    PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel, QSortThenBy> {
  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByAdharCard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adharCard', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByAdharCardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'adharCard', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByBankPassbook() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankPassbook', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByBankPassbookDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankPassbook', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByBusinessPackage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessPackage', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByBusinessPackageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'businessPackage', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByCity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByCityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'city', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByCountryCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryCd', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByCountryCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryCd', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByDob() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dob', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByDobDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dob', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByGender() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByGenderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gender', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByGstNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstNo', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByGstNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gstNo', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByNomineeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomineeName', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByNomineeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomineeName', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByNomineeRelation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomineeRelation', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByNomineeRelationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nomineeRelation', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByPackageFor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageFor', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByPackageForDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageFor', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByPanCard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'panCard', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByPanCardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'panCard', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByPaymentProof() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentProof', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByPaymentProofDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentProof', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByPhoneNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByPhoneNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phoneNumber', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByPincode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pincode', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByPincodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pincode', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByProfilePicture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicture', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByProfilePictureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profilePicture', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByRefName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refName', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByRefNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refName', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByVotingCard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'votingCard', Sort.asc);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QAfterSortBy> thenByVotingCardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'votingCard', Sort.desc);
    });
  }
}

extension PendingTechnoEnterpriseModelQueryWhereDistinct on QueryBuilder<
    PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel, QDistinct> {
  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByAddress({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByAdharCard({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'adharCard', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByAmount({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByBankPassbook({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bankPassbook', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByBusinessPackage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'businessPackage',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByCity({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'city', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByCountry({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'country', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByCountryCd({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'countryCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByDob({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dob', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByGender({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gender', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByGstNo({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gstNo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByNomineeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nomineeName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByNomineeRelation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nomineeRelation',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByPackageFor({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'packageFor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByPanCard({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'panCard', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByPaymentProof({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentProof', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByPhoneNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phoneNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByPincode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pincode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByProfilePicture({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profilePicture',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByRefName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'refName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByState({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'state', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, PendingTechnoEnterpriseModel,
      QDistinct> distinctByVotingCard({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'votingCard', caseSensitive: caseSensitive);
    });
  }
}

extension PendingTechnoEnterpriseModelQueryProperty on QueryBuilder<
    PendingTechnoEnterpriseModel,
    PendingTechnoEnterpriseModel,
    QQueryProperty> {
  QueryBuilder<PendingTechnoEnterpriseModel, int, QQueryOperations>
      idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      adharCardProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'adharCard');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      bankPassbookProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bankPassbook');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      businessPackageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'businessPackage');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      cityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'city');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      countryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'country');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      countryCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'countryCd');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      dobProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dob');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      genderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gender');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      gstNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gstNo');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      nomineeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nomineeName');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      nomineeRelationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nomineeRelation');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      packageForProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'packageFor');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      panCardProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'panCard');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      paymentProofProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentProof');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      phoneNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phoneNumber');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      pincodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pincode');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      profilePictureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profilePicture');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      refNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'refName');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      stateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'state');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, int?, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<PendingTechnoEnterpriseModel, String?, QQueryOperations>
      votingCardProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'votingCard');
    });
  }
}
