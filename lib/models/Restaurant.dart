/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:amplify_core/amplify_core.dart' as amplify_core;

import 'ModelProvider.dart';

/** This is an auto generated class representing the Restaurant type in your schema. */
class Restaurant extends amplify_core.Model {
  static const classType = const _RestaurantModelType();
  final String id;
  final String? _firstName;
  final String? _lastName;
  final String? _restaurant;
  final int? _averagePrice;
  final String? _email;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @Deprecated(
      '[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;

  RestaurantModelIdentifier get modelIdentifier {
    return RestaurantModelIdentifier(id: id);
  }

  String get firstName {
    try {
      return _firstName!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get lastName {
    try {
      return _lastName!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get restaurant {
    try {
      return _restaurant!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  int get averagePrice {
    try {
      return _averagePrice!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get email {
    try {
      return _email!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }

  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const Restaurant._internal(
      {required this.id,
      required firstName,
      required lastName,
      required restaurant,
      required averagePrice,
      required email,
      createdAt,
      updatedAt})
      : _firstName = firstName,
        _lastName = lastName,
        _restaurant = restaurant,
        _averagePrice = averagePrice,
        _email = email,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory Restaurant(
      {String? id,
      required String firstName,
      required String lastName,
      required String restaurant,
      required int averagePrice,
      required String email}) {
    return Restaurant._internal(
        id: id == null ? amplify_core.UUID.getUUID() : id,
        firstName: firstName,
        lastName: lastName,
        restaurant: restaurant,
        averagePrice: averagePrice,
        email: email);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Restaurant &&
        id == other.id &&
        _firstName == other._firstName &&
        _lastName == other._lastName &&
        _restaurant == other._restaurant &&
        _averagePrice == other._averagePrice &&
        _email == other._email;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Restaurant {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("firstName=" + "$_firstName" + ", ");
    buffer.write("lastName=" + "$_lastName" + ", ");
    buffer.write("restaurant=" + "$_restaurant" + ", ");
    buffer.write("averagePrice=" +
        (_averagePrice != null ? _averagePrice!.toString() : "null") +
        ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Restaurant copyWith(
      {String? firstName,
      String? lastName,
      String? restaurant,
      int? averagePrice,
      String? email}) {
    return Restaurant._internal(
        id: id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        restaurant: restaurant ?? this.restaurant,
        averagePrice: averagePrice ?? this.averagePrice,
        email: email ?? this.email);
  }

  Restaurant copyWithModelFieldValues(
      {ModelFieldValue<String>? firstName,
      ModelFieldValue<String>? lastName,
      ModelFieldValue<String>? restaurant,
      ModelFieldValue<int>? averagePrice,
      ModelFieldValue<String>? email}) {
    return Restaurant._internal(
        id: id,
        firstName: firstName == null ? this.firstName : firstName.value,
        lastName: lastName == null ? this.lastName : lastName.value,
        restaurant: restaurant == null ? this.restaurant : restaurant.value,
        averagePrice:
            averagePrice == null ? this.averagePrice : averagePrice.value,
        email: email == null ? this.email : email.value);
  }

  Restaurant.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _firstName = json['firstName'],
        _lastName = json['lastName'],
        _restaurant = json['restaurant'],
        _averagePrice = (json['averagePrice'] as num?)?.toInt(),
        _email = json['email'],
        _createdAt = json['createdAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? amplify_core.TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': _firstName,
        'lastName': _lastName,
        'restaurant': _restaurant,
        'averagePrice': _averagePrice,
        'email': _email,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  Map<String, Object?> toMap() => {
        'id': id,
        'firstName': _firstName,
        'lastName': _lastName,
        'restaurant': _restaurant,
        'averagePrice': _averagePrice,
        'email': _email,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt
      };

  static final amplify_core.QueryModelIdentifier<RestaurantModelIdentifier>
      MODEL_IDENTIFIER =
      amplify_core.QueryModelIdentifier<RestaurantModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final FIRSTNAME = amplify_core.QueryField(fieldName: "firstName");
  static final LASTNAME = amplify_core.QueryField(fieldName: "lastName");
  static final RESTAURANT = amplify_core.QueryField(fieldName: "restaurant");
  static final AVERAGEPRICE =
      amplify_core.QueryField(fieldName: "averagePrice");
  static final EMAIL = amplify_core.QueryField(fieldName: "email");
  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Restaurant";
    modelSchemaDefinition.pluralName = "Restaurants";

    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
          authStrategy: amplify_core.AuthStrategy.PUBLIC,
          operations: const [amplify_core.ModelOperation.READ]),
      amplify_core.AuthRule(
          authStrategy: amplify_core.AuthStrategy.OWNER,
          ownerField: "owner",
          identityClaim: "cognito:username",
          provider: amplify_core.AuthRuleProvider.USERPOOLS,
          operations: const [
            amplify_core.ModelOperation.CREATE,
            amplify_core.ModelOperation.UPDATE,
            amplify_core.ModelOperation.DELETE,
            amplify_core.ModelOperation.READ
          ])
    ];

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Restaurant.FIRSTNAME,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Restaurant.LASTNAME,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Restaurant.RESTAURANT,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Restaurant.AVERAGEPRICE,
        isRequired: true,
        ofType:
            amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
        key: Restaurant.EMAIL,
        isRequired: true,
        ofType: amplify_core.ModelFieldType(
            amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.nonQueryField(
            fieldName: 'createdAt',
            isRequired: false,
            isReadOnly: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.nonQueryField(
            fieldName: 'updatedAt',
            isRequired: false,
            isReadOnly: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.dateTime)));
  });
}

class _RestaurantModelType extends amplify_core.ModelType<Restaurant> {
  const _RestaurantModelType();

  @override
  Restaurant fromJson(Map<String, dynamic> jsonData) {
    return Restaurant.fromJson(jsonData);
  }

  @override
  String modelName() {
    return 'Restaurant';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Restaurant] in your schema.
 */
class RestaurantModelIdentifier
    implements amplify_core.ModelIdentifier<Restaurant> {
  final String id;

  /** Create an instance of RestaurantModelIdentifier using [id] the primary key. */
  const RestaurantModelIdentifier({required this.id});

  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{'id': id});

  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
      .entries
      .map((entry) => (<String, dynamic>{entry.key: entry.value}))
      .toList();

  @override
  String serializeAsString() => serializeAsMap().values.join('#');

  @override
  String toString() => 'RestaurantModelIdentifier(id: $id)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is RestaurantModelIdentifier && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
