// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PeopleTable extends People with TableInfo<$PeopleTable, PeopleData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeopleTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CUSTOMER'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startBalanceMeta =
      const VerificationMeta('startBalance');
  @override
  late final GeneratedColumn<double> startBalance = GeneratedColumn<double>(
      'start_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
      'start_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _creditLimitMeta =
      const VerificationMeta('creditLimit');
  @override
  late final GeneratedColumn<double> creditLimit = GeneratedColumn<double>(
      'credit_limit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _paymentTermsDaysMeta =
      const VerificationMeta('paymentTermsDays');
  @override
  late final GeneratedColumn<int> paymentTermsDays = GeneratedColumn<int>(
      'payment_terms_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        phone,
        email,
        address,
        notes,
        type,
        category,
        startBalance,
        startDate,
        creditLimit,
        paymentTermsDays,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'people';
  @override
  VerificationContext validateIntegrity(Insertable<PeopleData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('start_balance')) {
      context.handle(
          _startBalanceMeta,
          startBalance.isAcceptableOrUnknown(
              data['start_balance']!, _startBalanceMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
          _creditLimitMeta,
          creditLimit.isAcceptableOrUnknown(
              data['credit_limit']!, _creditLimitMeta));
    }
    if (data.containsKey('payment_terms_days')) {
      context.handle(
          _paymentTermsDaysMeta,
          paymentTermsDays.isAcceptableOrUnknown(
              data['payment_terms_days']!, _paymentTermsDaysMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PeopleData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PeopleData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      startBalance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}start_balance'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_date']),
      creditLimit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit_limit'])!,
      paymentTermsDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}payment_terms_days'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $PeopleTable createAlias(String alias) {
    return $PeopleTable(attachedDatabase, alias);
  }
}

class PeopleData extends DataClass implements Insertable<PeopleData> {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final String type;
  final String? category;
  final double startBalance;
  final String? startDate;
  final double creditLimit;
  final int paymentTermsDays;
  final int isDeleted;
  const PeopleData(
      {required this.id,
      required this.name,
      this.phone,
      this.email,
      this.address,
      this.notes,
      required this.type,
      this.category,
      required this.startBalance,
      this.startDate,
      required this.creditLimit,
      required this.paymentTermsDays,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['start_balance'] = Variable<double>(startBalance);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<String>(startDate);
    }
    map['credit_limit'] = Variable<double>(creditLimit);
    map['payment_terms_days'] = Variable<int>(paymentTermsDays);
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  PeopleCompanion toCompanion(bool nullToAbsent) {
    return PeopleCompanion(
      id: Value(id),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      type: Value(type),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      startBalance: Value(startBalance),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      creditLimit: Value(creditLimit),
      paymentTermsDays: Value(paymentTermsDays),
      isDeleted: Value(isDeleted),
    );
  }

  factory PeopleData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PeopleData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String?>(json['category']),
      startBalance: serializer.fromJson<double>(json['startBalance']),
      startDate: serializer.fromJson<String?>(json['startDate']),
      creditLimit: serializer.fromJson<double>(json['creditLimit']),
      paymentTermsDays: serializer.fromJson<int>(json['paymentTermsDays']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String?>(category),
      'startBalance': serializer.toJson<double>(startBalance),
      'startDate': serializer.toJson<String?>(startDate),
      'creditLimit': serializer.toJson<double>(creditLimit),
      'paymentTermsDays': serializer.toJson<int>(paymentTermsDays),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  PeopleData copyWith(
          {int? id,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? type,
          Value<String?> category = const Value.absent(),
          double? startBalance,
          Value<String?> startDate = const Value.absent(),
          double? creditLimit,
          int? paymentTermsDays,
          int? isDeleted}) =>
      PeopleData(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        notes: notes.present ? notes.value : this.notes,
        type: type ?? this.type,
        category: category.present ? category.value : this.category,
        startBalance: startBalance ?? this.startBalance,
        startDate: startDate.present ? startDate.value : this.startDate,
        creditLimit: creditLimit ?? this.creditLimit,
        paymentTermsDays: paymentTermsDays ?? this.paymentTermsDays,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  PeopleData copyWithCompanion(PeopleCompanion data) {
    return PeopleData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      startBalance: data.startBalance.present
          ? data.startBalance.value
          : this.startBalance,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      creditLimit:
          data.creditLimit.present ? data.creditLimit.value : this.creditLimit,
      paymentTermsDays: data.paymentTermsDays.present
          ? data.paymentTermsDays.value
          : this.paymentTermsDays,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PeopleData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('startBalance: $startBalance, ')
          ..write('startDate: $startDate, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('paymentTermsDays: $paymentTermsDays, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      phone,
      email,
      address,
      notes,
      type,
      category,
      startBalance,
      startDate,
      creditLimit,
      paymentTermsDays,
      isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PeopleData &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.type == this.type &&
          other.category == this.category &&
          other.startBalance == this.startBalance &&
          other.startDate == this.startDate &&
          other.creditLimit == this.creditLimit &&
          other.paymentTermsDays == this.paymentTermsDays &&
          other.isDeleted == this.isDeleted);
}

class PeopleCompanion extends UpdateCompanion<PeopleData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<String> type;
  final Value<String?> category;
  final Value<double> startBalance;
  final Value<String?> startDate;
  final Value<double> creditLimit;
  final Value<int> paymentTermsDays;
  final Value<int> isDeleted;
  const PeopleCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.startBalance = const Value.absent(),
    this.startDate = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.paymentTermsDays = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  PeopleCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.startBalance = const Value.absent(),
    this.startDate = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.paymentTermsDays = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : name = Value(name);
  static Insertable<PeopleData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<String>? type,
    Expression<String>? category,
    Expression<double>? startBalance,
    Expression<String>? startDate,
    Expression<double>? creditLimit,
    Expression<int>? paymentTermsDays,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (startBalance != null) 'start_balance': startBalance,
      if (startDate != null) 'start_date': startDate,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (paymentTermsDays != null) 'payment_terms_days': paymentTermsDays,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  PeopleCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<String?>? notes,
      Value<String>? type,
      Value<String?>? category,
      Value<double>? startBalance,
      Value<String?>? startDate,
      Value<double>? creditLimit,
      Value<int>? paymentTermsDays,
      Value<int>? isDeleted}) {
    return PeopleCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      type: type ?? this.type,
      category: category ?? this.category,
      startBalance: startBalance ?? this.startBalance,
      startDate: startDate ?? this.startDate,
      creditLimit: creditLimit ?? this.creditLimit,
      paymentTermsDays: paymentTermsDays ?? this.paymentTermsDays,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (startBalance.present) {
      map['start_balance'] = Variable<double>(startBalance.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<double>(creditLimit.value);
    }
    if (paymentTermsDays.present) {
      map['payment_terms_days'] = Variable<int>(paymentTermsDays.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeopleCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('startBalance: $startBalance, ')
          ..write('startDate: $startDate, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('paymentTermsDays: $paymentTermsDays, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _trackStockMeta =
      const VerificationMeta('trackStock');
  @override
  late final GeneratedColumn<bool> trackStock = GeneratedColumn<bool>(
      'track_stock', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("track_stock" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _currentStockMeta =
      const VerificationMeta('currentStock');
  @override
  late final GeneratedColumn<double> currentStock = GeneratedColumn<double>(
      'current_stock', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _avgCostMeta =
      const VerificationMeta('avgCost');
  @override
  late final GeneratedColumn<double> avgCost = GeneratedColumn<double>(
      'avg_cost', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _reorderLevelMeta =
      const VerificationMeta('reorderLevel');
  @override
  late final GeneratedColumn<double> reorderLevel = GeneratedColumn<double>(
      'reorder_level', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(10.0));
  static const VerificationMeta _bundle1QtyMeta =
      const VerificationMeta('bundle1Qty');
  @override
  late final GeneratedColumn<double> bundle1Qty = GeneratedColumn<double>(
      'bundle1_qty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle1PriceMeta =
      const VerificationMeta('bundle1Price');
  @override
  late final GeneratedColumn<double> bundle1Price = GeneratedColumn<double>(
      'bundle1_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle2QtyMeta =
      const VerificationMeta('bundle2Qty');
  @override
  late final GeneratedColumn<double> bundle2Qty = GeneratedColumn<double>(
      'bundle2_qty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle2PriceMeta =
      const VerificationMeta('bundle2Price');
  @override
  late final GeneratedColumn<double> bundle2Price = GeneratedColumn<double>(
      'bundle2_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle3QtyMeta =
      const VerificationMeta('bundle3Qty');
  @override
  late final GeneratedColumn<double> bundle3Qty = GeneratedColumn<double>(
      'bundle3_qty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle3PriceMeta =
      const VerificationMeta('bundle3Price');
  @override
  late final GeneratedColumn<double> bundle3Price = GeneratedColumn<double>(
      'bundle3_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle4QtyMeta =
      const VerificationMeta('bundle4Qty');
  @override
  late final GeneratedColumn<double> bundle4Qty = GeneratedColumn<double>(
      'bundle4_qty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle4PriceMeta =
      const VerificationMeta('bundle4Price');
  @override
  late final GeneratedColumn<double> bundle4Price = GeneratedColumn<double>(
      'bundle4_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle5QtyMeta =
      const VerificationMeta('bundle5Qty');
  @override
  late final GeneratedColumn<double> bundle5Qty = GeneratedColumn<double>(
      'bundle5_qty', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _bundle5PriceMeta =
      const VerificationMeta('bundle5Price');
  @override
  late final GeneratedColumn<double> bundle5Price = GeneratedColumn<double>(
      'bundle5_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        price,
        category,
        trackStock,
        currentStock,
        avgCost,
        reorderLevel,
        bundle1Qty,
        bundle1Price,
        bundle2Qty,
        bundle2Price,
        bundle3Qty,
        bundle3Price,
        bundle4Qty,
        bundle4Price,
        bundle5Qty,
        bundle5Price,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('track_stock')) {
      context.handle(
          _trackStockMeta,
          trackStock.isAcceptableOrUnknown(
              data['track_stock']!, _trackStockMeta));
    }
    if (data.containsKey('current_stock')) {
      context.handle(
          _currentStockMeta,
          currentStock.isAcceptableOrUnknown(
              data['current_stock']!, _currentStockMeta));
    }
    if (data.containsKey('avg_cost')) {
      context.handle(_avgCostMeta,
          avgCost.isAcceptableOrUnknown(data['avg_cost']!, _avgCostMeta));
    }
    if (data.containsKey('reorder_level')) {
      context.handle(
          _reorderLevelMeta,
          reorderLevel.isAcceptableOrUnknown(
              data['reorder_level']!, _reorderLevelMeta));
    }
    if (data.containsKey('bundle1_qty')) {
      context.handle(
          _bundle1QtyMeta,
          bundle1Qty.isAcceptableOrUnknown(
              data['bundle1_qty']!, _bundle1QtyMeta));
    }
    if (data.containsKey('bundle1_price')) {
      context.handle(
          _bundle1PriceMeta,
          bundle1Price.isAcceptableOrUnknown(
              data['bundle1_price']!, _bundle1PriceMeta));
    }
    if (data.containsKey('bundle2_qty')) {
      context.handle(
          _bundle2QtyMeta,
          bundle2Qty.isAcceptableOrUnknown(
              data['bundle2_qty']!, _bundle2QtyMeta));
    }
    if (data.containsKey('bundle2_price')) {
      context.handle(
          _bundle2PriceMeta,
          bundle2Price.isAcceptableOrUnknown(
              data['bundle2_price']!, _bundle2PriceMeta));
    }
    if (data.containsKey('bundle3_qty')) {
      context.handle(
          _bundle3QtyMeta,
          bundle3Qty.isAcceptableOrUnknown(
              data['bundle3_qty']!, _bundle3QtyMeta));
    }
    if (data.containsKey('bundle3_price')) {
      context.handle(
          _bundle3PriceMeta,
          bundle3Price.isAcceptableOrUnknown(
              data['bundle3_price']!, _bundle3PriceMeta));
    }
    if (data.containsKey('bundle4_qty')) {
      context.handle(
          _bundle4QtyMeta,
          bundle4Qty.isAcceptableOrUnknown(
              data['bundle4_qty']!, _bundle4QtyMeta));
    }
    if (data.containsKey('bundle4_price')) {
      context.handle(
          _bundle4PriceMeta,
          bundle4Price.isAcceptableOrUnknown(
              data['bundle4_price']!, _bundle4PriceMeta));
    }
    if (data.containsKey('bundle5_qty')) {
      context.handle(
          _bundle5QtyMeta,
          bundle5Qty.isAcceptableOrUnknown(
              data['bundle5_qty']!, _bundle5QtyMeta));
    }
    if (data.containsKey('bundle5_price')) {
      context.handle(
          _bundle5PriceMeta,
          bundle5Price.isAcceptableOrUnknown(
              data['bundle5_price']!, _bundle5PriceMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      trackStock: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}track_stock'])!,
      currentStock: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_stock'])!,
      avgCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_cost'])!,
      reorderLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}reorder_level'])!,
      bundle1Qty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle1_qty'])!,
      bundle1Price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle1_price'])!,
      bundle2Qty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle2_qty'])!,
      bundle2Price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle2_price'])!,
      bundle3Qty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle3_qty'])!,
      bundle3Price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle3_price'])!,
      bundle4Qty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle4_qty'])!,
      bundle4Price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle4_price'])!,
      bundle5Qty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle5_qty'])!,
      bundle5Price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}bundle5_price'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String? category;
  final bool trackStock;
  final double currentStock;
  final double avgCost;
  final double reorderLevel;
  final double bundle1Qty;
  final double bundle1Price;
  final double bundle2Qty;
  final double bundle2Price;
  final double bundle3Qty;
  final double bundle3Price;
  final double bundle4Qty;
  final double bundle4Price;
  final double bundle5Qty;
  final double bundle5Price;
  final int isDeleted;
  const Product(
      {required this.id,
      required this.name,
      this.description,
      required this.price,
      this.category,
      required this.trackStock,
      required this.currentStock,
      required this.avgCost,
      required this.reorderLevel,
      required this.bundle1Qty,
      required this.bundle1Price,
      required this.bundle2Qty,
      required this.bundle2Price,
      required this.bundle3Qty,
      required this.bundle3Price,
      required this.bundle4Qty,
      required this.bundle4Price,
      required this.bundle5Qty,
      required this.bundle5Price,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['track_stock'] = Variable<bool>(trackStock);
    map['current_stock'] = Variable<double>(currentStock);
    map['avg_cost'] = Variable<double>(avgCost);
    map['reorder_level'] = Variable<double>(reorderLevel);
    map['bundle1_qty'] = Variable<double>(bundle1Qty);
    map['bundle1_price'] = Variable<double>(bundle1Price);
    map['bundle2_qty'] = Variable<double>(bundle2Qty);
    map['bundle2_price'] = Variable<double>(bundle2Price);
    map['bundle3_qty'] = Variable<double>(bundle3Qty);
    map['bundle3_price'] = Variable<double>(bundle3Price);
    map['bundle4_qty'] = Variable<double>(bundle4Qty);
    map['bundle4_price'] = Variable<double>(bundle4Price);
    map['bundle5_qty'] = Variable<double>(bundle5Qty);
    map['bundle5_price'] = Variable<double>(bundle5Price);
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      price: Value(price),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      trackStock: Value(trackStock),
      currentStock: Value(currentStock),
      avgCost: Value(avgCost),
      reorderLevel: Value(reorderLevel),
      bundle1Qty: Value(bundle1Qty),
      bundle1Price: Value(bundle1Price),
      bundle2Qty: Value(bundle2Qty),
      bundle2Price: Value(bundle2Price),
      bundle3Qty: Value(bundle3Qty),
      bundle3Price: Value(bundle3Price),
      bundle4Qty: Value(bundle4Qty),
      bundle4Price: Value(bundle4Price),
      bundle5Qty: Value(bundle5Qty),
      bundle5Price: Value(bundle5Price),
      isDeleted: Value(isDeleted),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      price: serializer.fromJson<double>(json['price']),
      category: serializer.fromJson<String?>(json['category']),
      trackStock: serializer.fromJson<bool>(json['trackStock']),
      currentStock: serializer.fromJson<double>(json['currentStock']),
      avgCost: serializer.fromJson<double>(json['avgCost']),
      reorderLevel: serializer.fromJson<double>(json['reorderLevel']),
      bundle1Qty: serializer.fromJson<double>(json['bundle1Qty']),
      bundle1Price: serializer.fromJson<double>(json['bundle1Price']),
      bundle2Qty: serializer.fromJson<double>(json['bundle2Qty']),
      bundle2Price: serializer.fromJson<double>(json['bundle2Price']),
      bundle3Qty: serializer.fromJson<double>(json['bundle3Qty']),
      bundle3Price: serializer.fromJson<double>(json['bundle3Price']),
      bundle4Qty: serializer.fromJson<double>(json['bundle4Qty']),
      bundle4Price: serializer.fromJson<double>(json['bundle4Price']),
      bundle5Qty: serializer.fromJson<double>(json['bundle5Qty']),
      bundle5Price: serializer.fromJson<double>(json['bundle5Price']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'price': serializer.toJson<double>(price),
      'category': serializer.toJson<String?>(category),
      'trackStock': serializer.toJson<bool>(trackStock),
      'currentStock': serializer.toJson<double>(currentStock),
      'avgCost': serializer.toJson<double>(avgCost),
      'reorderLevel': serializer.toJson<double>(reorderLevel),
      'bundle1Qty': serializer.toJson<double>(bundle1Qty),
      'bundle1Price': serializer.toJson<double>(bundle1Price),
      'bundle2Qty': serializer.toJson<double>(bundle2Qty),
      'bundle2Price': serializer.toJson<double>(bundle2Price),
      'bundle3Qty': serializer.toJson<double>(bundle3Qty),
      'bundle3Price': serializer.toJson<double>(bundle3Price),
      'bundle4Qty': serializer.toJson<double>(bundle4Qty),
      'bundle4Price': serializer.toJson<double>(bundle4Price),
      'bundle5Qty': serializer.toJson<double>(bundle5Qty),
      'bundle5Price': serializer.toJson<double>(bundle5Price),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Product copyWith(
          {int? id,
          String? name,
          Value<String?> description = const Value.absent(),
          double? price,
          Value<String?> category = const Value.absent(),
          bool? trackStock,
          double? currentStock,
          double? avgCost,
          double? reorderLevel,
          double? bundle1Qty,
          double? bundle1Price,
          double? bundle2Qty,
          double? bundle2Price,
          double? bundle3Qty,
          double? bundle3Price,
          double? bundle4Qty,
          double? bundle4Price,
          double? bundle5Qty,
          double? bundle5Price,
          int? isDeleted}) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        price: price ?? this.price,
        category: category.present ? category.value : this.category,
        trackStock: trackStock ?? this.trackStock,
        currentStock: currentStock ?? this.currentStock,
        avgCost: avgCost ?? this.avgCost,
        reorderLevel: reorderLevel ?? this.reorderLevel,
        bundle1Qty: bundle1Qty ?? this.bundle1Qty,
        bundle1Price: bundle1Price ?? this.bundle1Price,
        bundle2Qty: bundle2Qty ?? this.bundle2Qty,
        bundle2Price: bundle2Price ?? this.bundle2Price,
        bundle3Qty: bundle3Qty ?? this.bundle3Qty,
        bundle3Price: bundle3Price ?? this.bundle3Price,
        bundle4Qty: bundle4Qty ?? this.bundle4Qty,
        bundle4Price: bundle4Price ?? this.bundle4Price,
        bundle5Qty: bundle5Qty ?? this.bundle5Qty,
        bundle5Price: bundle5Price ?? this.bundle5Price,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      price: data.price.present ? data.price.value : this.price,
      category: data.category.present ? data.category.value : this.category,
      trackStock:
          data.trackStock.present ? data.trackStock.value : this.trackStock,
      currentStock: data.currentStock.present
          ? data.currentStock.value
          : this.currentStock,
      avgCost: data.avgCost.present ? data.avgCost.value : this.avgCost,
      reorderLevel: data.reorderLevel.present
          ? data.reorderLevel.value
          : this.reorderLevel,
      bundle1Qty:
          data.bundle1Qty.present ? data.bundle1Qty.value : this.bundle1Qty,
      bundle1Price: data.bundle1Price.present
          ? data.bundle1Price.value
          : this.bundle1Price,
      bundle2Qty:
          data.bundle2Qty.present ? data.bundle2Qty.value : this.bundle2Qty,
      bundle2Price: data.bundle2Price.present
          ? data.bundle2Price.value
          : this.bundle2Price,
      bundle3Qty:
          data.bundle3Qty.present ? data.bundle3Qty.value : this.bundle3Qty,
      bundle3Price: data.bundle3Price.present
          ? data.bundle3Price.value
          : this.bundle3Price,
      bundle4Qty:
          data.bundle4Qty.present ? data.bundle4Qty.value : this.bundle4Qty,
      bundle4Price: data.bundle4Price.present
          ? data.bundle4Price.value
          : this.bundle4Price,
      bundle5Qty:
          data.bundle5Qty.present ? data.bundle5Qty.value : this.bundle5Qty,
      bundle5Price: data.bundle5Price.present
          ? data.bundle5Price.value
          : this.bundle5Price,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('trackStock: $trackStock, ')
          ..write('currentStock: $currentStock, ')
          ..write('avgCost: $avgCost, ')
          ..write('reorderLevel: $reorderLevel, ')
          ..write('bundle1Qty: $bundle1Qty, ')
          ..write('bundle1Price: $bundle1Price, ')
          ..write('bundle2Qty: $bundle2Qty, ')
          ..write('bundle2Price: $bundle2Price, ')
          ..write('bundle3Qty: $bundle3Qty, ')
          ..write('bundle3Price: $bundle3Price, ')
          ..write('bundle4Qty: $bundle4Qty, ')
          ..write('bundle4Price: $bundle4Price, ')
          ..write('bundle5Qty: $bundle5Qty, ')
          ..write('bundle5Price: $bundle5Price, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      description,
      price,
      category,
      trackStock,
      currentStock,
      avgCost,
      reorderLevel,
      bundle1Qty,
      bundle1Price,
      bundle2Qty,
      bundle2Price,
      bundle3Qty,
      bundle3Price,
      bundle4Qty,
      bundle4Price,
      bundle5Qty,
      bundle5Price,
      isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.price == this.price &&
          other.category == this.category &&
          other.trackStock == this.trackStock &&
          other.currentStock == this.currentStock &&
          other.avgCost == this.avgCost &&
          other.reorderLevel == this.reorderLevel &&
          other.bundle1Qty == this.bundle1Qty &&
          other.bundle1Price == this.bundle1Price &&
          other.bundle2Qty == this.bundle2Qty &&
          other.bundle2Price == this.bundle2Price &&
          other.bundle3Qty == this.bundle3Qty &&
          other.bundle3Price == this.bundle3Price &&
          other.bundle4Qty == this.bundle4Qty &&
          other.bundle4Price == this.bundle4Price &&
          other.bundle5Qty == this.bundle5Qty &&
          other.bundle5Price == this.bundle5Price &&
          other.isDeleted == this.isDeleted);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<double> price;
  final Value<String?> category;
  final Value<bool> trackStock;
  final Value<double> currentStock;
  final Value<double> avgCost;
  final Value<double> reorderLevel;
  final Value<double> bundle1Qty;
  final Value<double> bundle1Price;
  final Value<double> bundle2Qty;
  final Value<double> bundle2Price;
  final Value<double> bundle3Qty;
  final Value<double> bundle3Price;
  final Value<double> bundle4Qty;
  final Value<double> bundle4Price;
  final Value<double> bundle5Qty;
  final Value<double> bundle5Price;
  final Value<int> isDeleted;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.price = const Value.absent(),
    this.category = const Value.absent(),
    this.trackStock = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.avgCost = const Value.absent(),
    this.reorderLevel = const Value.absent(),
    this.bundle1Qty = const Value.absent(),
    this.bundle1Price = const Value.absent(),
    this.bundle2Qty = const Value.absent(),
    this.bundle2Price = const Value.absent(),
    this.bundle3Qty = const Value.absent(),
    this.bundle3Price = const Value.absent(),
    this.bundle4Qty = const Value.absent(),
    this.bundle4Price = const Value.absent(),
    this.bundle5Qty = const Value.absent(),
    this.bundle5Price = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required double price,
    this.category = const Value.absent(),
    this.trackStock = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.avgCost = const Value.absent(),
    this.reorderLevel = const Value.absent(),
    this.bundle1Qty = const Value.absent(),
    this.bundle1Price = const Value.absent(),
    this.bundle2Qty = const Value.absent(),
    this.bundle2Price = const Value.absent(),
    this.bundle3Qty = const Value.absent(),
    this.bundle3Price = const Value.absent(),
    this.bundle4Qty = const Value.absent(),
    this.bundle4Price = const Value.absent(),
    this.bundle5Qty = const Value.absent(),
    this.bundle5Price = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : name = Value(name),
        price = Value(price);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? price,
    Expression<String>? category,
    Expression<bool>? trackStock,
    Expression<double>? currentStock,
    Expression<double>? avgCost,
    Expression<double>? reorderLevel,
    Expression<double>? bundle1Qty,
    Expression<double>? bundle1Price,
    Expression<double>? bundle2Qty,
    Expression<double>? bundle2Price,
    Expression<double>? bundle3Qty,
    Expression<double>? bundle3Price,
    Expression<double>? bundle4Qty,
    Expression<double>? bundle4Price,
    Expression<double>? bundle5Qty,
    Expression<double>? bundle5Price,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (price != null) 'price': price,
      if (category != null) 'category': category,
      if (trackStock != null) 'track_stock': trackStock,
      if (currentStock != null) 'current_stock': currentStock,
      if (avgCost != null) 'avg_cost': avgCost,
      if (reorderLevel != null) 'reorder_level': reorderLevel,
      if (bundle1Qty != null) 'bundle1_qty': bundle1Qty,
      if (bundle1Price != null) 'bundle1_price': bundle1Price,
      if (bundle2Qty != null) 'bundle2_qty': bundle2Qty,
      if (bundle2Price != null) 'bundle2_price': bundle2Price,
      if (bundle3Qty != null) 'bundle3_qty': bundle3Qty,
      if (bundle3Price != null) 'bundle3_price': bundle3Price,
      if (bundle4Qty != null) 'bundle4_qty': bundle4Qty,
      if (bundle4Price != null) 'bundle4_price': bundle4Price,
      if (bundle5Qty != null) 'bundle5_qty': bundle5Qty,
      if (bundle5Price != null) 'bundle5_price': bundle5Price,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  ProductsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<double>? price,
      Value<String?>? category,
      Value<bool>? trackStock,
      Value<double>? currentStock,
      Value<double>? avgCost,
      Value<double>? reorderLevel,
      Value<double>? bundle1Qty,
      Value<double>? bundle1Price,
      Value<double>? bundle2Qty,
      Value<double>? bundle2Price,
      Value<double>? bundle3Qty,
      Value<double>? bundle3Price,
      Value<double>? bundle4Qty,
      Value<double>? bundle4Price,
      Value<double>? bundle5Qty,
      Value<double>? bundle5Price,
      Value<int>? isDeleted}) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      trackStock: trackStock ?? this.trackStock,
      currentStock: currentStock ?? this.currentStock,
      avgCost: avgCost ?? this.avgCost,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      bundle1Qty: bundle1Qty ?? this.bundle1Qty,
      bundle1Price: bundle1Price ?? this.bundle1Price,
      bundle2Qty: bundle2Qty ?? this.bundle2Qty,
      bundle2Price: bundle2Price ?? this.bundle2Price,
      bundle3Qty: bundle3Qty ?? this.bundle3Qty,
      bundle3Price: bundle3Price ?? this.bundle3Price,
      bundle4Qty: bundle4Qty ?? this.bundle4Qty,
      bundle4Price: bundle4Price ?? this.bundle4Price,
      bundle5Qty: bundle5Qty ?? this.bundle5Qty,
      bundle5Price: bundle5Price ?? this.bundle5Price,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (trackStock.present) {
      map['track_stock'] = Variable<bool>(trackStock.value);
    }
    if (currentStock.present) {
      map['current_stock'] = Variable<double>(currentStock.value);
    }
    if (avgCost.present) {
      map['avg_cost'] = Variable<double>(avgCost.value);
    }
    if (reorderLevel.present) {
      map['reorder_level'] = Variable<double>(reorderLevel.value);
    }
    if (bundle1Qty.present) {
      map['bundle1_qty'] = Variable<double>(bundle1Qty.value);
    }
    if (bundle1Price.present) {
      map['bundle1_price'] = Variable<double>(bundle1Price.value);
    }
    if (bundle2Qty.present) {
      map['bundle2_qty'] = Variable<double>(bundle2Qty.value);
    }
    if (bundle2Price.present) {
      map['bundle2_price'] = Variable<double>(bundle2Price.value);
    }
    if (bundle3Qty.present) {
      map['bundle3_qty'] = Variable<double>(bundle3Qty.value);
    }
    if (bundle3Price.present) {
      map['bundle3_price'] = Variable<double>(bundle3Price.value);
    }
    if (bundle4Qty.present) {
      map['bundle4_qty'] = Variable<double>(bundle4Qty.value);
    }
    if (bundle4Price.present) {
      map['bundle4_price'] = Variable<double>(bundle4Price.value);
    }
    if (bundle5Qty.present) {
      map['bundle5_qty'] = Variable<double>(bundle5Qty.value);
    }
    if (bundle5Price.present) {
      map['bundle5_price'] = Variable<double>(bundle5Price.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('trackStock: $trackStock, ')
          ..write('currentStock: $currentStock, ')
          ..write('avgCost: $avgCost, ')
          ..write('reorderLevel: $reorderLevel, ')
          ..write('bundle1Qty: $bundle1Qty, ')
          ..write('bundle1Price: $bundle1Price, ')
          ..write('bundle2Qty: $bundle2Qty, ')
          ..write('bundle2Price: $bundle2Price, ')
          ..write('bundle3Qty: $bundle3Qty, ')
          ..write('bundle3Price: $bundle3Price, ')
          ..write('bundle4Qty: $bundle4Qty, ')
          ..write('bundle4Price: $bundle4Price, ')
          ..write('bundle5Qty: $bundle5Qty, ')
          ..write('bundle5Price: $bundle5Price, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
      'person_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _invoiceNumberMeta =
      const VerificationMeta('invoiceNumber');
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
      'invoice_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('NORMAL'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, personId, invoiceNumber, date, total, status, notes, isDeleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(Insertable<Sale> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
          _invoiceNumberMeta,
          invoiceNumber.isAcceptableOrUnknown(
              data['invoice_number']!, _invoiceNumberMeta));
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}person_id'])!,
      invoiceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_number'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final int id;
  final int personId;
  final String invoiceNumber;
  final String date;
  final double total;
  final String status;
  final String? notes;
  final int isDeleted;
  const Sale(
      {required this.id,
      required this.personId,
      required this.invoiceNumber,
      required this.date,
      required this.total,
      required this.status,
      this.notes,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['person_id'] = Variable<int>(personId);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['date'] = Variable<String>(date);
    map['total'] = Variable<double>(total);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      personId: Value(personId),
      invoiceNumber: Value(invoiceNumber),
      date: Value(date),
      total: Value(total),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isDeleted: Value(isDeleted),
    );
  }

  factory Sale.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<int>(json['id']),
      personId: serializer.fromJson<int>(json['personId']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      date: serializer.fromJson<String>(json['date']),
      total: serializer.fromJson<double>(json['total']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personId': serializer.toJson<int>(personId),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'date': serializer.toJson<String>(date),
      'total': serializer.toJson<double>(total),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Sale copyWith(
          {int? id,
          int? personId,
          String? invoiceNumber,
          String? date,
          double? total,
          String? status,
          Value<String?> notes = const Value.absent(),
          int? isDeleted}) =>
      Sale(
        id: id ?? this.id,
        personId: personId ?? this.personId,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        date: date ?? this.date,
        total: total ?? this.total,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      date: data.date.present ? data.date.value : this.date,
      total: data.total.present ? data.total.value : this.total,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('date: $date, ')
          ..write('total: $total, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, personId, invoiceNumber, date, total, status, notes, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.invoiceNumber == this.invoiceNumber &&
          other.date == this.date &&
          other.total == this.total &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.isDeleted == this.isDeleted);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<int> id;
  final Value<int> personId;
  final Value<String> invoiceNumber;
  final Value<String> date;
  final Value<double> total;
  final Value<String> status;
  final Value<String?> notes;
  final Value<int> isDeleted;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.date = const Value.absent(),
    this.total = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  SalesCompanion.insert({
    this.id = const Value.absent(),
    required int personId,
    required String invoiceNumber,
    required String date,
    required double total,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : personId = Value(personId),
        invoiceNumber = Value(invoiceNumber),
        date = Value(date),
        total = Value(total);
  static Insertable<Sale> custom({
    Expression<int>? id,
    Expression<int>? personId,
    Expression<String>? invoiceNumber,
    Expression<String>? date,
    Expression<double>? total,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (date != null) 'date': date,
      if (total != null) 'total': total,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  SalesCompanion copyWith(
      {Value<int>? id,
      Value<int>? personId,
      Value<String>? invoiceNumber,
      Value<String>? date,
      Value<double>? total,
      Value<String>? status,
      Value<String?>? notes,
      Value<int>? isDeleted}) {
    return SalesCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      date: date ?? this.date,
      total: total ?? this.total,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('date: $date, ')
          ..write('total: $total, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTable extends SaleItems
    with TableInfo<$SaleItemsTable, SaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<int> saleId = GeneratedColumn<int>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _costOfGoodsMeta =
      const VerificationMeta('costOfGoods');
  @override
  late final GeneratedColumn<double> costOfGoods = GeneratedColumn<double>(
      'cost_of_goods', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, saleId, productId, quantity, price, total, costOfGoods];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items';
  @override
  VerificationContext validateIntegrity(Insertable<SaleItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('cost_of_goods')) {
      context.handle(
          _costOfGoodsMeta,
          costOfGoods.isAcceptableOrUnknown(
              data['cost_of_goods']!, _costOfGoodsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sale_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      costOfGoods: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_of_goods'])!,
    );
  }

  @override
  $SaleItemsTable createAlias(String alias) {
    return $SaleItemsTable(attachedDatabase, alias);
  }
}

class SaleItem extends DataClass implements Insertable<SaleItem> {
  final int id;
  final int saleId;
  final int productId;
  final double quantity;
  final double price;
  final double total;
  final double costOfGoods;
  const SaleItem(
      {required this.id,
      required this.saleId,
      required this.productId,
      required this.quantity,
      required this.price,
      required this.total,
      required this.costOfGoods});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sale_id'] = Variable<int>(saleId);
    map['product_id'] = Variable<int>(productId);
    map['quantity'] = Variable<double>(quantity);
    map['price'] = Variable<double>(price);
    map['total'] = Variable<double>(total);
    map['cost_of_goods'] = Variable<double>(costOfGoods);
    return map;
  }

  SaleItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      quantity: Value(quantity),
      price: Value(price),
      total: Value(total),
      costOfGoods: Value(costOfGoods),
    );
  }

  factory SaleItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItem(
      id: serializer.fromJson<int>(json['id']),
      saleId: serializer.fromJson<int>(json['saleId']),
      productId: serializer.fromJson<int>(json['productId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      total: serializer.fromJson<double>(json['total']),
      costOfGoods: serializer.fromJson<double>(json['costOfGoods']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saleId': serializer.toJson<int>(saleId),
      'productId': serializer.toJson<int>(productId),
      'quantity': serializer.toJson<double>(quantity),
      'price': serializer.toJson<double>(price),
      'total': serializer.toJson<double>(total),
      'costOfGoods': serializer.toJson<double>(costOfGoods),
    };
  }

  SaleItem copyWith(
          {int? id,
          int? saleId,
          int? productId,
          double? quantity,
          double? price,
          double? total,
          double? costOfGoods}) =>
      SaleItem(
        id: id ?? this.id,
        saleId: saleId ?? this.saleId,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        total: total ?? this.total,
        costOfGoods: costOfGoods ?? this.costOfGoods,
      );
  SaleItem copyWithCompanion(SaleItemsCompanion data) {
    return SaleItem(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      total: data.total.present ? data.total.value : this.total,
      costOfGoods:
          data.costOfGoods.present ? data.costOfGoods.value : this.costOfGoods,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItem(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('total: $total, ')
          ..write('costOfGoods: $costOfGoods')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, saleId, productId, quantity, price, total, costOfGoods);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItem &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.total == this.total &&
          other.costOfGoods == this.costOfGoods);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItem> {
  final Value<int> id;
  final Value<int> saleId;
  final Value<int> productId;
  final Value<double> quantity;
  final Value<double> price;
  final Value<double> total;
  final Value<double> costOfGoods;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.total = const Value.absent(),
    this.costOfGoods = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    this.id = const Value.absent(),
    required int saleId,
    required int productId,
    required double quantity,
    required double price,
    required double total,
    this.costOfGoods = const Value.absent(),
  })  : saleId = Value(saleId),
        productId = Value(productId),
        quantity = Value(quantity),
        price = Value(price),
        total = Value(total);
  static Insertable<SaleItem> custom({
    Expression<int>? id,
    Expression<int>? saleId,
    Expression<int>? productId,
    Expression<double>? quantity,
    Expression<double>? price,
    Expression<double>? total,
    Expression<double>? costOfGoods,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (total != null) 'total': total,
      if (costOfGoods != null) 'cost_of_goods': costOfGoods,
    });
  }

  SaleItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? saleId,
      Value<int>? productId,
      Value<double>? quantity,
      Value<double>? price,
      Value<double>? total,
      Value<double>? costOfGoods}) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      total: total ?? this.total,
      costOfGoods: costOfGoods ?? this.costOfGoods,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<int>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (costOfGoods.present) {
      map['cost_of_goods'] = Variable<double>(costOfGoods.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('total: $total, ')
          ..write('costOfGoods: $costOfGoods')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
      'person_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, personId, date, amount, paymentMethod, reference, isDeleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<Payment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}person_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final int id;
  final int personId;
  final String date;
  final double amount;
  final String paymentMethod;
  final String? reference;
  final int isDeleted;
  const Payment(
      {required this.id,
      required this.personId,
      required this.date,
      required this.amount,
      required this.paymentMethod,
      this.reference,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['person_id'] = Variable<int>(personId);
    map['date'] = Variable<String>(date);
    map['amount'] = Variable<double>(amount);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      personId: Value(personId),
      date: Value(date),
      amount: Value(amount),
      paymentMethod: Value(paymentMethod),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      isDeleted: Value(isDeleted),
    );
  }

  factory Payment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<int>(json['id']),
      personId: serializer.fromJson<int>(json['personId']),
      date: serializer.fromJson<String>(json['date']),
      amount: serializer.fromJson<double>(json['amount']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      reference: serializer.fromJson<String?>(json['reference']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personId': serializer.toJson<int>(personId),
      'date': serializer.toJson<String>(date),
      'amount': serializer.toJson<double>(amount),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'reference': serializer.toJson<String?>(reference),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Payment copyWith(
          {int? id,
          int? personId,
          String? date,
          double? amount,
          String? paymentMethod,
          Value<String?> reference = const Value.absent(),
          int? isDeleted}) =>
      Payment(
        id: id ?? this.id,
        personId: personId ?? this.personId,
        date: date ?? this.date,
        amount: amount ?? this.amount,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        reference: reference.present ? reference.value : this.reference,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      reference: data.reference.present ? data.reference.value : this.reference,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('reference: $reference, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, personId, date, amount, paymentMethod, reference, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.paymentMethod == this.paymentMethod &&
          other.reference == this.reference &&
          other.isDeleted == this.isDeleted);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<int> id;
  final Value<int> personId;
  final Value<String> date;
  final Value<double> amount;
  final Value<String> paymentMethod;
  final Value<String?> reference;
  final Value<int> isDeleted;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.reference = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  PaymentsCompanion.insert({
    this.id = const Value.absent(),
    required int personId,
    required String date,
    required double amount,
    required String paymentMethod,
    this.reference = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : personId = Value(personId),
        date = Value(date),
        amount = Value(amount),
        paymentMethod = Value(paymentMethod);
  static Insertable<Payment> custom({
    Expression<int>? id,
    Expression<int>? personId,
    Expression<String>? date,
    Expression<double>? amount,
    Expression<String>? paymentMethod,
    Expression<String>? reference,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (reference != null) 'reference': reference,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  PaymentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? personId,
      Value<String>? date,
      Value<double>? amount,
      Value<String>? paymentMethod,
      Value<String?>? reference,
      Value<int>? isDeleted}) {
    return PaymentsCompanion(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      reference: reference ?? this.reference,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('reference: $reference, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $AllocationsTable extends Allocations
    with TableInfo<$AllocationsTable, Allocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _paymentIdMeta =
      const VerificationMeta('paymentId');
  @override
  late final GeneratedColumn<int> paymentId = GeneratedColumn<int>(
      'payment_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<int> saleId = GeneratedColumn<int>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
      'is_active', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns =>
      [id, paymentId, saleId, amount, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allocations';
  @override
  VerificationContext validateIntegrity(Insertable<Allocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('payment_id')) {
      context.handle(_paymentIdMeta,
          paymentId.isAcceptableOrUnknown(data['payment_id']!, _paymentIdMeta));
    } else if (isInserting) {
      context.missing(_paymentIdMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Allocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Allocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      paymentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}payment_id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sale_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $AllocationsTable createAlias(String alias) {
    return $AllocationsTable(attachedDatabase, alias);
  }
}

class Allocation extends DataClass implements Insertable<Allocation> {
  final int id;
  final int paymentId;
  final int saleId;
  final double amount;
  final int isActive;
  const Allocation(
      {required this.id,
      required this.paymentId,
      required this.saleId,
      required this.amount,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['payment_id'] = Variable<int>(paymentId);
    map['sale_id'] = Variable<int>(saleId);
    map['amount'] = Variable<double>(amount);
    map['is_active'] = Variable<int>(isActive);
    return map;
  }

  AllocationsCompanion toCompanion(bool nullToAbsent) {
    return AllocationsCompanion(
      id: Value(id),
      paymentId: Value(paymentId),
      saleId: Value(saleId),
      amount: Value(amount),
      isActive: Value(isActive),
    );
  }

  factory Allocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Allocation(
      id: serializer.fromJson<int>(json['id']),
      paymentId: serializer.fromJson<int>(json['paymentId']),
      saleId: serializer.fromJson<int>(json['saleId']),
      amount: serializer.fromJson<double>(json['amount']),
      isActive: serializer.fromJson<int>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'paymentId': serializer.toJson<int>(paymentId),
      'saleId': serializer.toJson<int>(saleId),
      'amount': serializer.toJson<double>(amount),
      'isActive': serializer.toJson<int>(isActive),
    };
  }

  Allocation copyWith(
          {int? id,
          int? paymentId,
          int? saleId,
          double? amount,
          int? isActive}) =>
      Allocation(
        id: id ?? this.id,
        paymentId: paymentId ?? this.paymentId,
        saleId: saleId ?? this.saleId,
        amount: amount ?? this.amount,
        isActive: isActive ?? this.isActive,
      );
  Allocation copyWithCompanion(AllocationsCompanion data) {
    return Allocation(
      id: data.id.present ? data.id.value : this.id,
      paymentId: data.paymentId.present ? data.paymentId.value : this.paymentId,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      amount: data.amount.present ? data.amount.value : this.amount,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Allocation(')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('saleId: $saleId, ')
          ..write('amount: $amount, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, paymentId, saleId, amount, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Allocation &&
          other.id == this.id &&
          other.paymentId == this.paymentId &&
          other.saleId == this.saleId &&
          other.amount == this.amount &&
          other.isActive == this.isActive);
}

class AllocationsCompanion extends UpdateCompanion<Allocation> {
  final Value<int> id;
  final Value<int> paymentId;
  final Value<int> saleId;
  final Value<double> amount;
  final Value<int> isActive;
  const AllocationsCompanion({
    this.id = const Value.absent(),
    this.paymentId = const Value.absent(),
    this.saleId = const Value.absent(),
    this.amount = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  AllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int paymentId,
    required int saleId,
    required double amount,
    this.isActive = const Value.absent(),
  })  : paymentId = Value(paymentId),
        saleId = Value(saleId),
        amount = Value(amount);
  static Insertable<Allocation> custom({
    Expression<int>? id,
    Expression<int>? paymentId,
    Expression<int>? saleId,
    Expression<double>? amount,
    Expression<int>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (paymentId != null) 'payment_id': paymentId,
      if (saleId != null) 'sale_id': saleId,
      if (amount != null) 'amount': amount,
      if (isActive != null) 'is_active': isActive,
    });
  }

  AllocationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? paymentId,
      Value<int>? saleId,
      Value<double>? amount,
      Value<int>? isActive}) {
    return AllocationsCompanion(
      id: id ?? this.id,
      paymentId: paymentId ?? this.paymentId,
      saleId: saleId ?? this.saleId,
      amount: amount ?? this.amount,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (paymentId.present) {
      map['payment_id'] = Variable<int>(paymentId.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<int>(saleId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllocationsCompanion(')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('saleId: $saleId, ')
          ..write('amount: $amount, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ProductPurchasesTable extends ProductPurchases
    with TableInfo<$ProductPurchasesTable, ProductPurchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductPurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
      'supplier_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _qtyPerUnitMeta =
      const VerificationMeta('qtyPerUnit');
  @override
  late final GeneratedColumn<double> qtyPerUnit = GeneratedColumn<double>(
      'qty_per_unit', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _costPerUnitMeta =
      const VerificationMeta('costPerUnit');
  @override
  late final GeneratedColumn<double> costPerUnit = GeneratedColumn<double>(
      'cost_per_unit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalCostMeta =
      const VerificationMeta('totalCost');
  @override
  late final GeneratedColumn<double> totalCost = GeneratedColumn<double>(
      'total_cost', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _remainingQuantityMeta =
      const VerificationMeta('remainingQuantity');
  @override
  late final GeneratedColumn<double> remainingQuantity =
      GeneratedColumn<double>('remaining_quantity', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productId,
        supplierId,
        date,
        quantity,
        qtyPerUnit,
        costPerUnit,
        totalCost,
        remainingQuantity
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_purchases';
  @override
  VerificationContext validateIntegrity(Insertable<ProductPurchase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('qty_per_unit')) {
      context.handle(
          _qtyPerUnitMeta,
          qtyPerUnit.isAcceptableOrUnknown(
              data['qty_per_unit']!, _qtyPerUnitMeta));
    }
    if (data.containsKey('cost_per_unit')) {
      context.handle(
          _costPerUnitMeta,
          costPerUnit.isAcceptableOrUnknown(
              data['cost_per_unit']!, _costPerUnitMeta));
    } else if (isInserting) {
      context.missing(_costPerUnitMeta);
    }
    if (data.containsKey('total_cost')) {
      context.handle(_totalCostMeta,
          totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta));
    } else if (isInserting) {
      context.missing(_totalCostMeta);
    }
    if (data.containsKey('remaining_quantity')) {
      context.handle(
          _remainingQuantityMeta,
          remainingQuantity.isAcceptableOrUnknown(
              data['remaining_quantity']!, _remainingQuantityMeta));
    } else if (isInserting) {
      context.missing(_remainingQuantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductPurchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductPurchase(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}supplier_id']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      qtyPerUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}qty_per_unit'])!,
      costPerUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_per_unit'])!,
      totalCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_cost'])!,
      remainingQuantity: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}remaining_quantity'])!,
    );
  }

  @override
  $ProductPurchasesTable createAlias(String alias) {
    return $ProductPurchasesTable(attachedDatabase, alias);
  }
}

class ProductPurchase extends DataClass implements Insertable<ProductPurchase> {
  final int id;
  final int productId;
  final int? supplierId;
  final String date;
  final double quantity;
  final double qtyPerUnit;
  final double costPerUnit;
  final double totalCost;
  final double remainingQuantity;
  const ProductPurchase(
      {required this.id,
      required this.productId,
      this.supplierId,
      required this.date,
      required this.quantity,
      required this.qtyPerUnit,
      required this.costPerUnit,
      required this.totalCost,
      required this.remainingQuantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<int>(supplierId);
    }
    map['date'] = Variable<String>(date);
    map['quantity'] = Variable<double>(quantity);
    map['qty_per_unit'] = Variable<double>(qtyPerUnit);
    map['cost_per_unit'] = Variable<double>(costPerUnit);
    map['total_cost'] = Variable<double>(totalCost);
    map['remaining_quantity'] = Variable<double>(remainingQuantity);
    return map;
  }

  ProductPurchasesCompanion toCompanion(bool nullToAbsent) {
    return ProductPurchasesCompanion(
      id: Value(id),
      productId: Value(productId),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      date: Value(date),
      quantity: Value(quantity),
      qtyPerUnit: Value(qtyPerUnit),
      costPerUnit: Value(costPerUnit),
      totalCost: Value(totalCost),
      remainingQuantity: Value(remainingQuantity),
    );
  }

  factory ProductPurchase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductPurchase(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      supplierId: serializer.fromJson<int?>(json['supplierId']),
      date: serializer.fromJson<String>(json['date']),
      quantity: serializer.fromJson<double>(json['quantity']),
      qtyPerUnit: serializer.fromJson<double>(json['qtyPerUnit']),
      costPerUnit: serializer.fromJson<double>(json['costPerUnit']),
      totalCost: serializer.fromJson<double>(json['totalCost']),
      remainingQuantity: serializer.fromJson<double>(json['remainingQuantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'supplierId': serializer.toJson<int?>(supplierId),
      'date': serializer.toJson<String>(date),
      'quantity': serializer.toJson<double>(quantity),
      'qtyPerUnit': serializer.toJson<double>(qtyPerUnit),
      'costPerUnit': serializer.toJson<double>(costPerUnit),
      'totalCost': serializer.toJson<double>(totalCost),
      'remainingQuantity': serializer.toJson<double>(remainingQuantity),
    };
  }

  ProductPurchase copyWith(
          {int? id,
          int? productId,
          Value<int?> supplierId = const Value.absent(),
          String? date,
          double? quantity,
          double? qtyPerUnit,
          double? costPerUnit,
          double? totalCost,
          double? remainingQuantity}) =>
      ProductPurchase(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        supplierId: supplierId.present ? supplierId.value : this.supplierId,
        date: date ?? this.date,
        quantity: quantity ?? this.quantity,
        qtyPerUnit: qtyPerUnit ?? this.qtyPerUnit,
        costPerUnit: costPerUnit ?? this.costPerUnit,
        totalCost: totalCost ?? this.totalCost,
        remainingQuantity: remainingQuantity ?? this.remainingQuantity,
      );
  ProductPurchase copyWithCompanion(ProductPurchasesCompanion data) {
    return ProductPurchase(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      date: data.date.present ? data.date.value : this.date,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      qtyPerUnit:
          data.qtyPerUnit.present ? data.qtyPerUnit.value : this.qtyPerUnit,
      costPerUnit:
          data.costPerUnit.present ? data.costPerUnit.value : this.costPerUnit,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
      remainingQuantity: data.remainingQuantity.present
          ? data.remainingQuantity.value
          : this.remainingQuantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductPurchase(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('supplierId: $supplierId, ')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('qtyPerUnit: $qtyPerUnit, ')
          ..write('costPerUnit: $costPerUnit, ')
          ..write('totalCost: $totalCost, ')
          ..write('remainingQuantity: $remainingQuantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, supplierId, date, quantity,
      qtyPerUnit, costPerUnit, totalCost, remainingQuantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductPurchase &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.supplierId == this.supplierId &&
          other.date == this.date &&
          other.quantity == this.quantity &&
          other.qtyPerUnit == this.qtyPerUnit &&
          other.costPerUnit == this.costPerUnit &&
          other.totalCost == this.totalCost &&
          other.remainingQuantity == this.remainingQuantity);
}

class ProductPurchasesCompanion extends UpdateCompanion<ProductPurchase> {
  final Value<int> id;
  final Value<int> productId;
  final Value<int?> supplierId;
  final Value<String> date;
  final Value<double> quantity;
  final Value<double> qtyPerUnit;
  final Value<double> costPerUnit;
  final Value<double> totalCost;
  final Value<double> remainingQuantity;
  const ProductPurchasesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.date = const Value.absent(),
    this.quantity = const Value.absent(),
    this.qtyPerUnit = const Value.absent(),
    this.costPerUnit = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.remainingQuantity = const Value.absent(),
  });
  ProductPurchasesCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    this.supplierId = const Value.absent(),
    required String date,
    required double quantity,
    this.qtyPerUnit = const Value.absent(),
    required double costPerUnit,
    required double totalCost,
    required double remainingQuantity,
  })  : productId = Value(productId),
        date = Value(date),
        quantity = Value(quantity),
        costPerUnit = Value(costPerUnit),
        totalCost = Value(totalCost),
        remainingQuantity = Value(remainingQuantity);
  static Insertable<ProductPurchase> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<int>? supplierId,
    Expression<String>? date,
    Expression<double>? quantity,
    Expression<double>? qtyPerUnit,
    Expression<double>? costPerUnit,
    Expression<double>? totalCost,
    Expression<double>? remainingQuantity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (date != null) 'date': date,
      if (quantity != null) 'quantity': quantity,
      if (qtyPerUnit != null) 'qty_per_unit': qtyPerUnit,
      if (costPerUnit != null) 'cost_per_unit': costPerUnit,
      if (totalCost != null) 'total_cost': totalCost,
      if (remainingQuantity != null) 'remaining_quantity': remainingQuantity,
    });
  }

  ProductPurchasesCompanion copyWith(
      {Value<int>? id,
      Value<int>? productId,
      Value<int?>? supplierId,
      Value<String>? date,
      Value<double>? quantity,
      Value<double>? qtyPerUnit,
      Value<double>? costPerUnit,
      Value<double>? totalCost,
      Value<double>? remainingQuantity}) {
    return ProductPurchasesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      supplierId: supplierId ?? this.supplierId,
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
      qtyPerUnit: qtyPerUnit ?? this.qtyPerUnit,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      totalCost: totalCost ?? this.totalCost,
      remainingQuantity: remainingQuantity ?? this.remainingQuantity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (qtyPerUnit.present) {
      map['qty_per_unit'] = Variable<double>(qtyPerUnit.value);
    }
    if (costPerUnit.present) {
      map['cost_per_unit'] = Variable<double>(costPerUnit.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<double>(totalCost.value);
    }
    if (remainingQuantity.present) {
      map['remaining_quantity'] = Variable<double>(remainingQuantity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductPurchasesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('supplierId: $supplierId, ')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('qtyPerUnit: $qtyPerUnit, ')
          ..write('costPerUnit: $costPerUnit, ')
          ..write('totalCost: $totalCost, ')
          ..write('remainingQuantity: $remainingQuantity')
          ..write(')'))
        .toString();
  }
}

class $StockAllocationsTable extends StockAllocations
    with TableInfo<$StockAllocationsTable, StockAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _saleItemIdMeta =
      const VerificationMeta('saleItemId');
  @override
  late final GeneratedColumn<int> saleItemId = GeneratedColumn<int>(
      'sale_item_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _purchaseIdMeta =
      const VerificationMeta('purchaseId');
  @override
  late final GeneratedColumn<int> purchaseId = GeneratedColumn<int>(
      'purchase_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _costPerUnitMeta =
      const VerificationMeta('costPerUnit');
  @override
  late final GeneratedColumn<double> costPerUnit = GeneratedColumn<double>(
      'cost_per_unit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, saleItemId, purchaseId, quantity, costPerUnit];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_allocations';
  @override
  VerificationContext validateIntegrity(Insertable<StockAllocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_item_id')) {
      context.handle(
          _saleItemIdMeta,
          saleItemId.isAcceptableOrUnknown(
              data['sale_item_id']!, _saleItemIdMeta));
    } else if (isInserting) {
      context.missing(_saleItemIdMeta);
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
          _purchaseIdMeta,
          purchaseId.isAcceptableOrUnknown(
              data['purchase_id']!, _purchaseIdMeta));
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('cost_per_unit')) {
      context.handle(
          _costPerUnitMeta,
          costPerUnit.isAcceptableOrUnknown(
              data['cost_per_unit']!, _costPerUnitMeta));
    } else if (isInserting) {
      context.missing(_costPerUnitMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockAllocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      saleItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sale_item_id'])!,
      purchaseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}purchase_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      costPerUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_per_unit'])!,
    );
  }

  @override
  $StockAllocationsTable createAlias(String alias) {
    return $StockAllocationsTable(attachedDatabase, alias);
  }
}

class StockAllocation extends DataClass implements Insertable<StockAllocation> {
  final int id;
  final int saleItemId;
  final int purchaseId;
  final double quantity;
  final double costPerUnit;
  const StockAllocation(
      {required this.id,
      required this.saleItemId,
      required this.purchaseId,
      required this.quantity,
      required this.costPerUnit});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sale_item_id'] = Variable<int>(saleItemId);
    map['purchase_id'] = Variable<int>(purchaseId);
    map['quantity'] = Variable<double>(quantity);
    map['cost_per_unit'] = Variable<double>(costPerUnit);
    return map;
  }

  StockAllocationsCompanion toCompanion(bool nullToAbsent) {
    return StockAllocationsCompanion(
      id: Value(id),
      saleItemId: Value(saleItemId),
      purchaseId: Value(purchaseId),
      quantity: Value(quantity),
      costPerUnit: Value(costPerUnit),
    );
  }

  factory StockAllocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockAllocation(
      id: serializer.fromJson<int>(json['id']),
      saleItemId: serializer.fromJson<int>(json['saleItemId']),
      purchaseId: serializer.fromJson<int>(json['purchaseId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      costPerUnit: serializer.fromJson<double>(json['costPerUnit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saleItemId': serializer.toJson<int>(saleItemId),
      'purchaseId': serializer.toJson<int>(purchaseId),
      'quantity': serializer.toJson<double>(quantity),
      'costPerUnit': serializer.toJson<double>(costPerUnit),
    };
  }

  StockAllocation copyWith(
          {int? id,
          int? saleItemId,
          int? purchaseId,
          double? quantity,
          double? costPerUnit}) =>
      StockAllocation(
        id: id ?? this.id,
        saleItemId: saleItemId ?? this.saleItemId,
        purchaseId: purchaseId ?? this.purchaseId,
        quantity: quantity ?? this.quantity,
        costPerUnit: costPerUnit ?? this.costPerUnit,
      );
  StockAllocation copyWithCompanion(StockAllocationsCompanion data) {
    return StockAllocation(
      id: data.id.present ? data.id.value : this.id,
      saleItemId:
          data.saleItemId.present ? data.saleItemId.value : this.saleItemId,
      purchaseId:
          data.purchaseId.present ? data.purchaseId.value : this.purchaseId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      costPerUnit:
          data.costPerUnit.present ? data.costPerUnit.value : this.costPerUnit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockAllocation(')
          ..write('id: $id, ')
          ..write('saleItemId: $saleItemId, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('quantity: $quantity, ')
          ..write('costPerUnit: $costPerUnit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, saleItemId, purchaseId, quantity, costPerUnit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockAllocation &&
          other.id == this.id &&
          other.saleItemId == this.saleItemId &&
          other.purchaseId == this.purchaseId &&
          other.quantity == this.quantity &&
          other.costPerUnit == this.costPerUnit);
}

class StockAllocationsCompanion extends UpdateCompanion<StockAllocation> {
  final Value<int> id;
  final Value<int> saleItemId;
  final Value<int> purchaseId;
  final Value<double> quantity;
  final Value<double> costPerUnit;
  const StockAllocationsCompanion({
    this.id = const Value.absent(),
    this.saleItemId = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.costPerUnit = const Value.absent(),
  });
  StockAllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int saleItemId,
    required int purchaseId,
    required double quantity,
    required double costPerUnit,
  })  : saleItemId = Value(saleItemId),
        purchaseId = Value(purchaseId),
        quantity = Value(quantity),
        costPerUnit = Value(costPerUnit);
  static Insertable<StockAllocation> custom({
    Expression<int>? id,
    Expression<int>? saleItemId,
    Expression<int>? purchaseId,
    Expression<double>? quantity,
    Expression<double>? costPerUnit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleItemId != null) 'sale_item_id': saleItemId,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (quantity != null) 'quantity': quantity,
      if (costPerUnit != null) 'cost_per_unit': costPerUnit,
    });
  }

  StockAllocationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? saleItemId,
      Value<int>? purchaseId,
      Value<double>? quantity,
      Value<double>? costPerUnit}) {
    return StockAllocationsCompanion(
      id: id ?? this.id,
      saleItemId: saleItemId ?? this.saleItemId,
      purchaseId: purchaseId ?? this.purchaseId,
      quantity: quantity ?? this.quantity,
      costPerUnit: costPerUnit ?? this.costPerUnit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saleItemId.present) {
      map['sale_item_id'] = Variable<int>(saleItemId.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<int>(purchaseId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (costPerUnit.present) {
      map['cost_per_unit'] = Variable<double>(costPerUnit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('saleItemId: $saleItemId, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('quantity: $quantity, ')
          ..write('costPerUnit: $costPerUnit')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<int> personId = GeneratedColumn<int>(
      'person_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        date,
        category,
        description,
        amount,
        paymentMethod,
        reference,
        personId,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method']),
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}person_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final String date;
  final String category;
  final String description;
  final double amount;
  final String? paymentMethod;
  final String? reference;
  final int? personId;
  final int isDeleted;
  const Expense(
      {required this.id,
      required this.date,
      required this.category,
      required this.description,
      required this.amount,
      this.paymentMethod,
      this.reference,
      this.personId,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<String>(date);
    map['category'] = Variable<String>(category);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    if (!nullToAbsent || personId != null) {
      map['person_id'] = Variable<int>(personId);
    }
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      date: Value(date),
      category: Value(category),
      description: Value(description),
      amount: Value(amount),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      personId: personId == null && nullToAbsent
          ? const Value.absent()
          : Value(personId),
      isDeleted: Value(isDeleted),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      category: serializer.fromJson<String>(json['category']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      reference: serializer.fromJson<String?>(json['reference']),
      personId: serializer.fromJson<int?>(json['personId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<String>(date),
      'category': serializer.toJson<String>(category),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'reference': serializer.toJson<String?>(reference),
      'personId': serializer.toJson<int?>(personId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Expense copyWith(
          {int? id,
          String? date,
          String? category,
          String? description,
          double? amount,
          Value<String?> paymentMethod = const Value.absent(),
          Value<String?> reference = const Value.absent(),
          Value<int?> personId = const Value.absent(),
          int? isDeleted}) =>
      Expense(
        id: id ?? this.id,
        date: date ?? this.date,
        category: category ?? this.category,
        description: description ?? this.description,
        amount: amount ?? this.amount,
        paymentMethod:
            paymentMethod.present ? paymentMethod.value : this.paymentMethod,
        reference: reference.present ? reference.value : this.reference,
        personId: personId.present ? personId.value : this.personId,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      description:
          data.description.present ? data.description.value : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      reference: data.reference.present ? data.reference.value : this.reference,
      personId: data.personId.present ? data.personId.value : this.personId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('reference: $reference, ')
          ..write('personId: $personId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, category, description, amount,
      paymentMethod, reference, personId, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.date == this.date &&
          other.category == this.category &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.paymentMethod == this.paymentMethod &&
          other.reference == this.reference &&
          other.personId == this.personId &&
          other.isDeleted == this.isDeleted);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<String> date;
  final Value<String> category;
  final Value<String> description;
  final Value<double> amount;
  final Value<String?> paymentMethod;
  final Value<String?> reference;
  final Value<int?> personId;
  final Value<int> isDeleted;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.reference = const Value.absent(),
    this.personId = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required String date,
    required String category,
    required String description,
    required double amount,
    this.paymentMethod = const Value.absent(),
    this.reference = const Value.absent(),
    this.personId = const Value.absent(),
    this.isDeleted = const Value.absent(),
  })  : date = Value(date),
        category = Value(category),
        description = Value(description),
        amount = Value(amount);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<String>? date,
    Expression<String>? category,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<String>? paymentMethod,
    Expression<String>? reference,
    Expression<int>? personId,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (reference != null) 'reference': reference,
      if (personId != null) 'person_id': personId,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int>? id,
      Value<String>? date,
      Value<String>? category,
      Value<String>? description,
      Value<double>? amount,
      Value<String?>? paymentMethod,
      Value<String?>? reference,
      Value<int?>? personId,
      Value<int>? isDeleted}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      reference: reference ?? this.reference,
      personId: personId ?? this.personId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<int>(personId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('reference: $reference, ')
          ..write('personId: $personId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $ExpenseCategoriesTable extends ExpenseCategories
    with TableInfo<$ExpenseCategoriesTable, ExpenseCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
      'color', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('grey'));
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('receipt'));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<int> isDefault = GeneratedColumn<int>(
      'is_default', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, color, icon, isDefault, isDeleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_categories';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_default'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $ExpenseCategoriesTable createAlias(String alias) {
    return $ExpenseCategoriesTable(attachedDatabase, alias);
  }
}

class ExpenseCategory extends DataClass implements Insertable<ExpenseCategory> {
  final int id;
  final String name;
  final String color;
  final String icon;
  final int isDefault;
  final int isDeleted;
  const ExpenseCategory(
      {required this.id,
      required this.name,
      required this.color,
      required this.icon,
      required this.isDefault,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<String>(color);
    map['icon'] = Variable<String>(icon);
    map['is_default'] = Variable<int>(isDefault);
    map['is_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  ExpenseCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      icon: Value(icon),
      isDefault: Value(isDefault),
      isDeleted: Value(isDeleted),
    );
  }

  factory ExpenseCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String>(json['color']),
      icon: serializer.fromJson<String>(json['icon']),
      isDefault: serializer.fromJson<int>(json['isDefault']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String>(color),
      'icon': serializer.toJson<String>(icon),
      'isDefault': serializer.toJson<int>(isDefault),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  ExpenseCategory copyWith(
          {int? id,
          String? name,
          String? color,
          String? icon,
          int? isDefault,
          int? isDeleted}) =>
      ExpenseCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        icon: icon ?? this.icon,
        isDefault: isDefault ?? this.isDefault,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  ExpenseCategory copyWithCompanion(ExpenseCategoriesCompanion data) {
    return ExpenseCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('isDefault: $isDefault, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, icon, isDefault, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.isDefault == this.isDefault &&
          other.isDeleted == this.isDeleted);
}

class ExpenseCategoriesCompanion extends UpdateCompanion<ExpenseCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> color;
  final Value<String> icon;
  final Value<int> isDefault;
  final Value<int> isDeleted;
  const ExpenseCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  ExpenseCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ExpenseCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<int>? isDefault,
    Expression<int>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (isDefault != null) 'is_default': isDefault,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  ExpenseCategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? color,
      Value<String>? icon,
      Value<int>? isDefault,
      Value<int>? isDeleted}) {
    return ExpenseCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<int>(isDefault.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<int>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('isDefault: $isDefault, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PeopleTable people = $PeopleTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $AllocationsTable allocations = $AllocationsTable(this);
  late final $ProductPurchasesTable productPurchases =
      $ProductPurchasesTable(this);
  late final $StockAllocationsTable stockAllocations =
      $StockAllocationsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $ExpenseCategoriesTable expenseCategories =
      $ExpenseCategoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        people,
        products,
        sales,
        saleItems,
        payments,
        allocations,
        productPurchases,
        stockAllocations,
        expenses,
        expenseCategories
      ];
}

typedef $$PeopleTableCreateCompanionBuilder = PeopleCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> notes,
  Value<String> type,
  Value<String?> category,
  Value<double> startBalance,
  Value<String?> startDate,
  Value<double> creditLimit,
  Value<int> paymentTermsDays,
  Value<int> isDeleted,
});
typedef $$PeopleTableUpdateCompanionBuilder = PeopleCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> notes,
  Value<String> type,
  Value<String?> category,
  Value<double> startBalance,
  Value<String?> startDate,
  Value<double> creditLimit,
  Value<int> paymentTermsDays,
  Value<int> isDeleted,
});

class $$PeopleTableFilterComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get startBalance => $composableBuilder(
      column: $table.startBalance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paymentTermsDays => $composableBuilder(
      column: $table.paymentTermsDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$PeopleTableOrderingComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get startBalance => $composableBuilder(
      column: $table.startBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paymentTermsDays => $composableBuilder(
      column: $table.paymentTermsDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$PeopleTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeopleTable> {
  $$PeopleTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get startBalance => $composableBuilder(
      column: $table.startBalance, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => column);

  GeneratedColumn<int> get paymentTermsDays => $composableBuilder(
      column: $table.paymentTermsDays, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$PeopleTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PeopleTable,
    PeopleData,
    $$PeopleTableFilterComposer,
    $$PeopleTableOrderingComposer,
    $$PeopleTableAnnotationComposer,
    $$PeopleTableCreateCompanionBuilder,
    $$PeopleTableUpdateCompanionBuilder,
    (PeopleData, BaseReferences<_$AppDatabase, $PeopleTable, PeopleData>),
    PeopleData,
    PrefetchHooks Function()> {
  $$PeopleTableTableManager(_$AppDatabase db, $PeopleTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeopleTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeopleTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeopleTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<double> startBalance = const Value.absent(),
            Value<String?> startDate = const Value.absent(),
            Value<double> creditLimit = const Value.absent(),
            Value<int> paymentTermsDays = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              PeopleCompanion(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            notes: notes,
            type: type,
            category: category,
            startBalance: startBalance,
            startDate: startDate,
            creditLimit: creditLimit,
            paymentTermsDays: paymentTermsDays,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<double> startBalance = const Value.absent(),
            Value<String?> startDate = const Value.absent(),
            Value<double> creditLimit = const Value.absent(),
            Value<int> paymentTermsDays = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              PeopleCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            email: email,
            address: address,
            notes: notes,
            type: type,
            category: category,
            startBalance: startBalance,
            startDate: startDate,
            creditLimit: creditLimit,
            paymentTermsDays: paymentTermsDays,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PeopleTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PeopleTable,
    PeopleData,
    $$PeopleTableFilterComposer,
    $$PeopleTableOrderingComposer,
    $$PeopleTableAnnotationComposer,
    $$PeopleTableCreateCompanionBuilder,
    $$PeopleTableUpdateCompanionBuilder,
    (PeopleData, BaseReferences<_$AppDatabase, $PeopleTable, PeopleData>),
    PeopleData,
    PrefetchHooks Function()>;
typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> description,
  required double price,
  Value<String?> category,
  Value<bool> trackStock,
  Value<double> currentStock,
  Value<double> avgCost,
  Value<double> reorderLevel,
  Value<double> bundle1Qty,
  Value<double> bundle1Price,
  Value<double> bundle2Qty,
  Value<double> bundle2Price,
  Value<double> bundle3Qty,
  Value<double> bundle3Price,
  Value<double> bundle4Qty,
  Value<double> bundle4Price,
  Value<double> bundle5Qty,
  Value<double> bundle5Price,
  Value<int> isDeleted,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> description,
  Value<double> price,
  Value<String?> category,
  Value<bool> trackStock,
  Value<double> currentStock,
  Value<double> avgCost,
  Value<double> reorderLevel,
  Value<double> bundle1Qty,
  Value<double> bundle1Price,
  Value<double> bundle2Qty,
  Value<double> bundle2Price,
  Value<double> bundle3Qty,
  Value<double> bundle3Price,
  Value<double> bundle4Qty,
  Value<double> bundle4Price,
  Value<double> bundle5Qty,
  Value<double> bundle5Price,
  Value<int> isDeleted,
});

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get trackStock => $composableBuilder(
      column: $table.trackStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentStock => $composableBuilder(
      column: $table.currentStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgCost => $composableBuilder(
      column: $table.avgCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get reorderLevel => $composableBuilder(
      column: $table.reorderLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle1Qty => $composableBuilder(
      column: $table.bundle1Qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle1Price => $composableBuilder(
      column: $table.bundle1Price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle2Qty => $composableBuilder(
      column: $table.bundle2Qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle2Price => $composableBuilder(
      column: $table.bundle2Price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle3Qty => $composableBuilder(
      column: $table.bundle3Qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle3Price => $composableBuilder(
      column: $table.bundle3Price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle4Qty => $composableBuilder(
      column: $table.bundle4Qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle4Price => $composableBuilder(
      column: $table.bundle4Price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle5Qty => $composableBuilder(
      column: $table.bundle5Qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get bundle5Price => $composableBuilder(
      column: $table.bundle5Price, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get trackStock => $composableBuilder(
      column: $table.trackStock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentStock => $composableBuilder(
      column: $table.currentStock,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgCost => $composableBuilder(
      column: $table.avgCost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get reorderLevel => $composableBuilder(
      column: $table.reorderLevel,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle1Qty => $composableBuilder(
      column: $table.bundle1Qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle1Price => $composableBuilder(
      column: $table.bundle1Price,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle2Qty => $composableBuilder(
      column: $table.bundle2Qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle2Price => $composableBuilder(
      column: $table.bundle2Price,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle3Qty => $composableBuilder(
      column: $table.bundle3Qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle3Price => $composableBuilder(
      column: $table.bundle3Price,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle4Qty => $composableBuilder(
      column: $table.bundle4Qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle4Price => $composableBuilder(
      column: $table.bundle4Price,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle5Qty => $composableBuilder(
      column: $table.bundle5Qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get bundle5Price => $composableBuilder(
      column: $table.bundle5Price,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get trackStock => $composableBuilder(
      column: $table.trackStock, builder: (column) => column);

  GeneratedColumn<double> get currentStock => $composableBuilder(
      column: $table.currentStock, builder: (column) => column);

  GeneratedColumn<double> get avgCost =>
      $composableBuilder(column: $table.avgCost, builder: (column) => column);

  GeneratedColumn<double> get reorderLevel => $composableBuilder(
      column: $table.reorderLevel, builder: (column) => column);

  GeneratedColumn<double> get bundle1Qty => $composableBuilder(
      column: $table.bundle1Qty, builder: (column) => column);

  GeneratedColumn<double> get bundle1Price => $composableBuilder(
      column: $table.bundle1Price, builder: (column) => column);

  GeneratedColumn<double> get bundle2Qty => $composableBuilder(
      column: $table.bundle2Qty, builder: (column) => column);

  GeneratedColumn<double> get bundle2Price => $composableBuilder(
      column: $table.bundle2Price, builder: (column) => column);

  GeneratedColumn<double> get bundle3Qty => $composableBuilder(
      column: $table.bundle3Qty, builder: (column) => column);

  GeneratedColumn<double> get bundle3Price => $composableBuilder(
      column: $table.bundle3Price, builder: (column) => column);

  GeneratedColumn<double> get bundle4Qty => $composableBuilder(
      column: $table.bundle4Qty, builder: (column) => column);

  GeneratedColumn<double> get bundle4Price => $composableBuilder(
      column: $table.bundle4Price, builder: (column) => column);

  GeneratedColumn<double> get bundle5Qty => $composableBuilder(
      column: $table.bundle5Qty, builder: (column) => column);

  GeneratedColumn<double> get bundle5Price => $composableBuilder(
      column: $table.bundle5Price, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
    Product,
    PrefetchHooks Function()> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<bool> trackStock = const Value.absent(),
            Value<double> currentStock = const Value.absent(),
            Value<double> avgCost = const Value.absent(),
            Value<double> reorderLevel = const Value.absent(),
            Value<double> bundle1Qty = const Value.absent(),
            Value<double> bundle1Price = const Value.absent(),
            Value<double> bundle2Qty = const Value.absent(),
            Value<double> bundle2Price = const Value.absent(),
            Value<double> bundle3Qty = const Value.absent(),
            Value<double> bundle3Price = const Value.absent(),
            Value<double> bundle4Qty = const Value.absent(),
            Value<double> bundle4Price = const Value.absent(),
            Value<double> bundle5Qty = const Value.absent(),
            Value<double> bundle5Price = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            name: name,
            description: description,
            price: price,
            category: category,
            trackStock: trackStock,
            currentStock: currentStock,
            avgCost: avgCost,
            reorderLevel: reorderLevel,
            bundle1Qty: bundle1Qty,
            bundle1Price: bundle1Price,
            bundle2Qty: bundle2Qty,
            bundle2Price: bundle2Price,
            bundle3Qty: bundle3Qty,
            bundle3Price: bundle3Price,
            bundle4Qty: bundle4Qty,
            bundle4Price: bundle4Price,
            bundle5Qty: bundle5Qty,
            bundle5Price: bundle5Price,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            required double price,
            Value<String?> category = const Value.absent(),
            Value<bool> trackStock = const Value.absent(),
            Value<double> currentStock = const Value.absent(),
            Value<double> avgCost = const Value.absent(),
            Value<double> reorderLevel = const Value.absent(),
            Value<double> bundle1Qty = const Value.absent(),
            Value<double> bundle1Price = const Value.absent(),
            Value<double> bundle2Qty = const Value.absent(),
            Value<double> bundle2Price = const Value.absent(),
            Value<double> bundle3Qty = const Value.absent(),
            Value<double> bundle3Price = const Value.absent(),
            Value<double> bundle4Qty = const Value.absent(),
            Value<double> bundle4Price = const Value.absent(),
            Value<double> bundle5Qty = const Value.absent(),
            Value<double> bundle5Price = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            name: name,
            description: description,
            price: price,
            category: category,
            trackStock: trackStock,
            currentStock: currentStock,
            avgCost: avgCost,
            reorderLevel: reorderLevel,
            bundle1Qty: bundle1Qty,
            bundle1Price: bundle1Price,
            bundle2Qty: bundle2Qty,
            bundle2Price: bundle2Price,
            bundle3Qty: bundle3Qty,
            bundle3Price: bundle3Price,
            bundle4Qty: bundle4Qty,
            bundle4Price: bundle4Price,
            bundle5Qty: bundle5Qty,
            bundle5Price: bundle5Price,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, BaseReferences<_$AppDatabase, $ProductsTable, Product>),
    Product,
    PrefetchHooks Function()>;
typedef $$SalesTableCreateCompanionBuilder = SalesCompanion Function({
  Value<int> id,
  required int personId,
  required String invoiceNumber,
  required String date,
  required double total,
  Value<String> status,
  Value<String?> notes,
  Value<int> isDeleted,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<int> id,
  Value<int> personId,
  Value<String> invoiceNumber,
  Value<String> date,
  Value<double> total,
  Value<String> status,
  Value<String?> notes,
  Value<int> isDeleted,
});

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$SalesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
    Sale,
    PrefetchHooks Function()> {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> personId = const Value.absent(),
            Value<String> invoiceNumber = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              SalesCompanion(
            id: id,
            personId: personId,
            invoiceNumber: invoiceNumber,
            date: date,
            total: total,
            status: status,
            notes: notes,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int personId,
            required String invoiceNumber,
            required String date,
            required double total,
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              SalesCompanion.insert(
            id: id,
            personId: personId,
            invoiceNumber: invoiceNumber,
            date: date,
            total: total,
            status: status,
            notes: notes,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SalesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
    Sale,
    PrefetchHooks Function()>;
typedef $$SaleItemsTableCreateCompanionBuilder = SaleItemsCompanion Function({
  Value<int> id,
  required int saleId,
  required int productId,
  required double quantity,
  required double price,
  required double total,
  Value<double> costOfGoods,
});
typedef $$SaleItemsTableUpdateCompanionBuilder = SaleItemsCompanion Function({
  Value<int> id,
  Value<int> saleId,
  Value<int> productId,
  Value<double> quantity,
  Value<double> price,
  Value<double> total,
  Value<double> costOfGoods,
});

class $$SaleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costOfGoods => $composableBuilder(
      column: $table.costOfGoods, builder: (column) => ColumnFilters(column));
}

class $$SaleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costOfGoods => $composableBuilder(
      column: $table.costOfGoods, builder: (column) => ColumnOrderings(column));
}

class $$SaleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<double> get costOfGoods => $composableBuilder(
      column: $table.costOfGoods, builder: (column) => column);
}

class $$SaleItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SaleItemsTable,
    SaleItem,
    $$SaleItemsTableFilterComposer,
    $$SaleItemsTableOrderingComposer,
    $$SaleItemsTableAnnotationComposer,
    $$SaleItemsTableCreateCompanionBuilder,
    $$SaleItemsTableUpdateCompanionBuilder,
    (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
    SaleItem,
    PrefetchHooks Function()> {
  $$SaleItemsTableTableManager(_$AppDatabase db, $SaleItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> saleId = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<double> costOfGoods = const Value.absent(),
          }) =>
              SaleItemsCompanion(
            id: id,
            saleId: saleId,
            productId: productId,
            quantity: quantity,
            price: price,
            total: total,
            costOfGoods: costOfGoods,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int saleId,
            required int productId,
            required double quantity,
            required double price,
            required double total,
            Value<double> costOfGoods = const Value.absent(),
          }) =>
              SaleItemsCompanion.insert(
            id: id,
            saleId: saleId,
            productId: productId,
            quantity: quantity,
            price: price,
            total: total,
            costOfGoods: costOfGoods,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SaleItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SaleItemsTable,
    SaleItem,
    $$SaleItemsTableFilterComposer,
    $$SaleItemsTableOrderingComposer,
    $$SaleItemsTableAnnotationComposer,
    $$SaleItemsTableCreateCompanionBuilder,
    $$SaleItemsTableUpdateCompanionBuilder,
    (SaleItem, BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem>),
    SaleItem,
    PrefetchHooks Function()>;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  required int personId,
  required String date,
  required double amount,
  required String paymentMethod,
  Value<String?> reference,
  Value<int> isDeleted,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<int> id,
  Value<int> personId,
  Value<String> date,
  Value<double> amount,
  Value<String> paymentMethod,
  Value<String?> reference,
  Value<int> isDeleted,
});

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$PaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
    Payment,
    PrefetchHooks Function()> {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> personId = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              PaymentsCompanion(
            id: id,
            personId: personId,
            date: date,
            amount: amount,
            paymentMethod: paymentMethod,
            reference: reference,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int personId,
            required String date,
            required double amount,
            required String paymentMethod,
            Value<String?> reference = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              PaymentsCompanion.insert(
            id: id,
            personId: personId,
            date: date,
            amount: amount,
            paymentMethod: paymentMethod,
            reference: reference,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, BaseReferences<_$AppDatabase, $PaymentsTable, Payment>),
    Payment,
    PrefetchHooks Function()>;
typedef $$AllocationsTableCreateCompanionBuilder = AllocationsCompanion
    Function({
  Value<int> id,
  required int paymentId,
  required int saleId,
  required double amount,
  Value<int> isActive,
});
typedef $$AllocationsTableUpdateCompanionBuilder = AllocationsCompanion
    Function({
  Value<int> id,
  Value<int> paymentId,
  Value<int> saleId,
  Value<double> amount,
  Value<int> isActive,
});

class $$AllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $AllocationsTable> {
  $$AllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paymentId => $composableBuilder(
      column: $table.paymentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$AllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AllocationsTable> {
  $$AllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paymentId => $composableBuilder(
      column: $table.paymentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$AllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AllocationsTable> {
  $$AllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get paymentId =>
      $composableBuilder(column: $table.paymentId, builder: (column) => column);

  GeneratedColumn<int> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$AllocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AllocationsTable,
    Allocation,
    $$AllocationsTableFilterComposer,
    $$AllocationsTableOrderingComposer,
    $$AllocationsTableAnnotationComposer,
    $$AllocationsTableCreateCompanionBuilder,
    $$AllocationsTableUpdateCompanionBuilder,
    (Allocation, BaseReferences<_$AppDatabase, $AllocationsTable, Allocation>),
    Allocation,
    PrefetchHooks Function()> {
  $$AllocationsTableTableManager(_$AppDatabase db, $AllocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AllocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> paymentId = const Value.absent(),
            Value<int> saleId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<int> isActive = const Value.absent(),
          }) =>
              AllocationsCompanion(
            id: id,
            paymentId: paymentId,
            saleId: saleId,
            amount: amount,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int paymentId,
            required int saleId,
            required double amount,
            Value<int> isActive = const Value.absent(),
          }) =>
              AllocationsCompanion.insert(
            id: id,
            paymentId: paymentId,
            saleId: saleId,
            amount: amount,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AllocationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AllocationsTable,
    Allocation,
    $$AllocationsTableFilterComposer,
    $$AllocationsTableOrderingComposer,
    $$AllocationsTableAnnotationComposer,
    $$AllocationsTableCreateCompanionBuilder,
    $$AllocationsTableUpdateCompanionBuilder,
    (Allocation, BaseReferences<_$AppDatabase, $AllocationsTable, Allocation>),
    Allocation,
    PrefetchHooks Function()>;
typedef $$ProductPurchasesTableCreateCompanionBuilder
    = ProductPurchasesCompanion Function({
  Value<int> id,
  required int productId,
  Value<int?> supplierId,
  required String date,
  required double quantity,
  Value<double> qtyPerUnit,
  required double costPerUnit,
  required double totalCost,
  required double remainingQuantity,
});
typedef $$ProductPurchasesTableUpdateCompanionBuilder
    = ProductPurchasesCompanion Function({
  Value<int> id,
  Value<int> productId,
  Value<int?> supplierId,
  Value<String> date,
  Value<double> quantity,
  Value<double> qtyPerUnit,
  Value<double> costPerUnit,
  Value<double> totalCost,
  Value<double> remainingQuantity,
});

class $$ProductPurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductPurchasesTable> {
  $$ProductPurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get supplierId => $composableBuilder(
      column: $table.supplierId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get qtyPerUnit => $composableBuilder(
      column: $table.qtyPerUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costPerUnit => $composableBuilder(
      column: $table.costPerUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalCost => $composableBuilder(
      column: $table.totalCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get remainingQuantity => $composableBuilder(
      column: $table.remainingQuantity,
      builder: (column) => ColumnFilters(column));
}

class $$ProductPurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductPurchasesTable> {
  $$ProductPurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get supplierId => $composableBuilder(
      column: $table.supplierId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get qtyPerUnit => $composableBuilder(
      column: $table.qtyPerUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costPerUnit => $composableBuilder(
      column: $table.costPerUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalCost => $composableBuilder(
      column: $table.totalCost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get remainingQuantity => $composableBuilder(
      column: $table.remainingQuantity,
      builder: (column) => ColumnOrderings(column));
}

class $$ProductPurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductPurchasesTable> {
  $$ProductPurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get supplierId => $composableBuilder(
      column: $table.supplierId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get qtyPerUnit => $composableBuilder(
      column: $table.qtyPerUnit, builder: (column) => column);

  GeneratedColumn<double> get costPerUnit => $composableBuilder(
      column: $table.costPerUnit, builder: (column) => column);

  GeneratedColumn<double> get totalCost =>
      $composableBuilder(column: $table.totalCost, builder: (column) => column);

  GeneratedColumn<double> get remainingQuantity => $composableBuilder(
      column: $table.remainingQuantity, builder: (column) => column);
}

class $$ProductPurchasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductPurchasesTable,
    ProductPurchase,
    $$ProductPurchasesTableFilterComposer,
    $$ProductPurchasesTableOrderingComposer,
    $$ProductPurchasesTableAnnotationComposer,
    $$ProductPurchasesTableCreateCompanionBuilder,
    $$ProductPurchasesTableUpdateCompanionBuilder,
    (
      ProductPurchase,
      BaseReferences<_$AppDatabase, $ProductPurchasesTable, ProductPurchase>
    ),
    ProductPurchase,
    PrefetchHooks Function()> {
  $$ProductPurchasesTableTableManager(
      _$AppDatabase db, $ProductPurchasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductPurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductPurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductPurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<int?> supplierId = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> qtyPerUnit = const Value.absent(),
            Value<double> costPerUnit = const Value.absent(),
            Value<double> totalCost = const Value.absent(),
            Value<double> remainingQuantity = const Value.absent(),
          }) =>
              ProductPurchasesCompanion(
            id: id,
            productId: productId,
            supplierId: supplierId,
            date: date,
            quantity: quantity,
            qtyPerUnit: qtyPerUnit,
            costPerUnit: costPerUnit,
            totalCost: totalCost,
            remainingQuantity: remainingQuantity,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int productId,
            Value<int?> supplierId = const Value.absent(),
            required String date,
            required double quantity,
            Value<double> qtyPerUnit = const Value.absent(),
            required double costPerUnit,
            required double totalCost,
            required double remainingQuantity,
          }) =>
              ProductPurchasesCompanion.insert(
            id: id,
            productId: productId,
            supplierId: supplierId,
            date: date,
            quantity: quantity,
            qtyPerUnit: qtyPerUnit,
            costPerUnit: costPerUnit,
            totalCost: totalCost,
            remainingQuantity: remainingQuantity,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductPurchasesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductPurchasesTable,
    ProductPurchase,
    $$ProductPurchasesTableFilterComposer,
    $$ProductPurchasesTableOrderingComposer,
    $$ProductPurchasesTableAnnotationComposer,
    $$ProductPurchasesTableCreateCompanionBuilder,
    $$ProductPurchasesTableUpdateCompanionBuilder,
    (
      ProductPurchase,
      BaseReferences<_$AppDatabase, $ProductPurchasesTable, ProductPurchase>
    ),
    ProductPurchase,
    PrefetchHooks Function()>;
typedef $$StockAllocationsTableCreateCompanionBuilder
    = StockAllocationsCompanion Function({
  Value<int> id,
  required int saleItemId,
  required int purchaseId,
  required double quantity,
  required double costPerUnit,
});
typedef $$StockAllocationsTableUpdateCompanionBuilder
    = StockAllocationsCompanion Function({
  Value<int> id,
  Value<int> saleItemId,
  Value<int> purchaseId,
  Value<double> quantity,
  Value<double> costPerUnit,
});

class $$StockAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $StockAllocationsTable> {
  $$StockAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get saleItemId => $composableBuilder(
      column: $table.saleItemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get purchaseId => $composableBuilder(
      column: $table.purchaseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costPerUnit => $composableBuilder(
      column: $table.costPerUnit, builder: (column) => ColumnFilters(column));
}

class $$StockAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockAllocationsTable> {
  $$StockAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get saleItemId => $composableBuilder(
      column: $table.saleItemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get purchaseId => $composableBuilder(
      column: $table.purchaseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costPerUnit => $composableBuilder(
      column: $table.costPerUnit, builder: (column) => ColumnOrderings(column));
}

class $$StockAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockAllocationsTable> {
  $$StockAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get saleItemId => $composableBuilder(
      column: $table.saleItemId, builder: (column) => column);

  GeneratedColumn<int> get purchaseId => $composableBuilder(
      column: $table.purchaseId, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get costPerUnit => $composableBuilder(
      column: $table.costPerUnit, builder: (column) => column);
}

class $$StockAllocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockAllocationsTable,
    StockAllocation,
    $$StockAllocationsTableFilterComposer,
    $$StockAllocationsTableOrderingComposer,
    $$StockAllocationsTableAnnotationComposer,
    $$StockAllocationsTableCreateCompanionBuilder,
    $$StockAllocationsTableUpdateCompanionBuilder,
    (
      StockAllocation,
      BaseReferences<_$AppDatabase, $StockAllocationsTable, StockAllocation>
    ),
    StockAllocation,
    PrefetchHooks Function()> {
  $$StockAllocationsTableTableManager(
      _$AppDatabase db, $StockAllocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockAllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockAllocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> saleItemId = const Value.absent(),
            Value<int> purchaseId = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> costPerUnit = const Value.absent(),
          }) =>
              StockAllocationsCompanion(
            id: id,
            saleItemId: saleItemId,
            purchaseId: purchaseId,
            quantity: quantity,
            costPerUnit: costPerUnit,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int saleItemId,
            required int purchaseId,
            required double quantity,
            required double costPerUnit,
          }) =>
              StockAllocationsCompanion.insert(
            id: id,
            saleItemId: saleItemId,
            purchaseId: purchaseId,
            quantity: quantity,
            costPerUnit: costPerUnit,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StockAllocationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StockAllocationsTable,
    StockAllocation,
    $$StockAllocationsTableFilterComposer,
    $$StockAllocationsTableOrderingComposer,
    $$StockAllocationsTableAnnotationComposer,
    $$StockAllocationsTableCreateCompanionBuilder,
    $$StockAllocationsTableUpdateCompanionBuilder,
    (
      StockAllocation,
      BaseReferences<_$AppDatabase, $StockAllocationsTable, StockAllocation>
    ),
    StockAllocation,
    PrefetchHooks Function()>;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  required String date,
  required String category,
  required String description,
  required double amount,
  Value<String?> paymentMethod,
  Value<String?> reference,
  Value<int?> personId,
  Value<int> isDeleted,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<String> date,
  Value<String> category,
  Value<String> description,
  Value<double> amount,
  Value<String?> paymentMethod,
  Value<String?> reference,
  Value<int?> personId,
  Value<int> isDeleted,
});

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<int> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()> {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<String?> paymentMethod = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<int?> personId = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              ExpensesCompanion(
            id: id,
            date: date,
            category: category,
            description: description,
            amount: amount,
            paymentMethod: paymentMethod,
            reference: reference,
            personId: personId,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String date,
            required String category,
            required String description,
            required double amount,
            Value<String?> paymentMethod = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<int?> personId = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              ExpensesCompanion.insert(
            id: id,
            date: date,
            category: category,
            description: description,
            amount: amount,
            paymentMethod: paymentMethod,
            reference: reference,
            personId: personId,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
    Expense,
    PrefetchHooks Function()>;
typedef $$ExpenseCategoriesTableCreateCompanionBuilder
    = ExpenseCategoriesCompanion Function({
  Value<int> id,
  required String name,
  Value<String> color,
  Value<String> icon,
  Value<int> isDefault,
  Value<int> isDeleted,
});
typedef $$ExpenseCategoriesTableUpdateCompanionBuilder
    = ExpenseCategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> color,
  Value<String> icon,
  Value<int> isDefault,
  Value<int> isDeleted,
});

class $$ExpenseCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$ExpenseCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$ExpenseCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ExpenseCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpenseCategoriesTable,
    ExpenseCategory,
    $$ExpenseCategoriesTableFilterComposer,
    $$ExpenseCategoriesTableOrderingComposer,
    $$ExpenseCategoriesTableAnnotationComposer,
    $$ExpenseCategoriesTableCreateCompanionBuilder,
    $$ExpenseCategoriesTableUpdateCompanionBuilder,
    (
      ExpenseCategory,
      BaseReferences<_$AppDatabase, $ExpenseCategoriesTable, ExpenseCategory>
    ),
    ExpenseCategory,
    PrefetchHooks Function()> {
  $$ExpenseCategoriesTableTableManager(
      _$AppDatabase db, $ExpenseCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseCategoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> color = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<int> isDefault = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              ExpenseCategoriesCompanion(
            id: id,
            name: name,
            color: color,
            icon: icon,
            isDefault: isDefault,
            isDeleted: isDeleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String> color = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<int> isDefault = const Value.absent(),
            Value<int> isDeleted = const Value.absent(),
          }) =>
              ExpenseCategoriesCompanion.insert(
            id: id,
            name: name,
            color: color,
            icon: icon,
            isDefault: isDefault,
            isDeleted: isDeleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExpenseCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpenseCategoriesTable,
    ExpenseCategory,
    $$ExpenseCategoriesTableFilterComposer,
    $$ExpenseCategoriesTableOrderingComposer,
    $$ExpenseCategoriesTableAnnotationComposer,
    $$ExpenseCategoriesTableCreateCompanionBuilder,
    $$ExpenseCategoriesTableUpdateCompanionBuilder,
    (
      ExpenseCategory,
      BaseReferences<_$AppDatabase, $ExpenseCategoriesTable, ExpenseCategory>
    ),
    ExpenseCategory,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PeopleTableTableManager get people =>
      $$PeopleTableTableManager(_db, _db.people);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$AllocationsTableTableManager get allocations =>
      $$AllocationsTableTableManager(_db, _db.allocations);
  $$ProductPurchasesTableTableManager get productPurchases =>
      $$ProductPurchasesTableTableManager(_db, _db.productPurchases);
  $$StockAllocationsTableTableManager get stockAllocations =>
      $$StockAllocationsTableTableManager(_db, _db.stockAllocations);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$ExpenseCategoriesTableTableManager get expenseCategories =>
      $$ExpenseCategoriesTableTableManager(_db, _db.expenseCategories);
}
