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

/** This is an auto generated class representing the LatLong type in your schema. */
class LatLong {
  final String? _latitude;
  final String? _longitude;

  String get latitude {
    try {
      return _latitude!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String get longitude {
    try {
      return _longitude!;
    } catch (e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: amplify_core.AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  const LatLong._internal({required latitude, required longitude})
      : _latitude = latitude,
        _longitude = longitude;

  factory LatLong({required String latitude, required String longitude}) {
    return LatLong._internal(latitude: latitude, longitude: longitude);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LatLong &&
        _latitude == other._latitude &&
        _longitude == other._longitude;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("LatLong {");
    buffer.write("latitude=" + "$_latitude" + ", ");
    buffer.write("longitude=" + "$_longitude");
    buffer.write("}");

    return buffer.toString();
  }

  LatLong copyWith({String? latitude, String? longitude}) {
    return LatLong._internal(
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude);
  }

  LatLong copyWithModelFieldValues(
      {ModelFieldValue<String>? latitude, ModelFieldValue<String>? longitude}) {
    return LatLong._internal(
        latitude: latitude == null ? this.latitude : latitude.value,
        longitude: longitude == null ? this.longitude : longitude.value);
  }

  LatLong.fromJson(Map<String, dynamic> json)
      : _latitude = json['latitude'],
        _longitude = json['longitude'];

  Map<String, dynamic> toJson() =>
      {'latitude': _latitude, 'longitude': _longitude};

  Map<String, Object?> toMap() =>
      {'latitude': _latitude, 'longitude': _longitude};

  static var schema = amplify_core.Model.defineSchema(
      define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "LatLong";
    modelSchemaDefinition.pluralName = "LatLongs";

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'latitude',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(
        amplify_core.ModelFieldDefinition.customTypeField(
            fieldName: 'longitude',
            isRequired: true,
            ofType: amplify_core.ModelFieldType(
                amplify_core.ModelFieldTypeEnum.string)));
  });
}
