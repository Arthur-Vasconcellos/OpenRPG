class CompendiumEditorDescriptor {
  final String entityType;
  final String collectionKey;
  final String label;
  final List<CompendiumFieldDescriptor> fields;

  const CompendiumEditorDescriptor({
    required this.entityType,
    required this.collectionKey,
    required this.label,
    this.fields = const [],
  });

  CompendiumEditorDescriptor copyWith({
    String? entityType,
    String? collectionKey,
    String? label,
    List<CompendiumFieldDescriptor>? fields,
  }) {
    return CompendiumEditorDescriptor(
      entityType: entityType ?? this.entityType,
      collectionKey: collectionKey ?? this.collectionKey,
      label: label ?? this.label,
      fields: fields ?? this.fields,
    );
  }
}

enum CompendiumFieldKind {
  string,
  integer,
  number,
  boolean,
  object,
  list,
  dynamic,
}

class CompendiumFieldDescriptor {
  final String key;
  final String label;
  final CompendiumFieldKind kind;
  final bool required;
  final bool nullable;
  final bool isArray;
  final List<String> choices;
  final List<CompendiumFieldDescriptor> fields;
  final CompendiumFieldDescriptor? itemDescriptor;
  final int sampleCount;

  const CompendiumFieldDescriptor({
    required this.key,
    required this.label,
    required this.kind,
    this.required = false,
    this.nullable = true,
    this.isArray = false,
    this.choices = const [],
    this.fields = const [],
    this.itemDescriptor,
    this.sampleCount = 0,
  });

  CompendiumFieldDescriptor copyWith({
    String? key,
    String? label,
    CompendiumFieldKind? kind,
    bool? required,
    bool? nullable,
    bool? isArray,
    List<String>? choices,
    List<CompendiumFieldDescriptor>? fields,
    CompendiumFieldDescriptor? itemDescriptor,
    bool itemDescriptorAbsent = false,
    int? sampleCount,
  }) {
    return CompendiumFieldDescriptor(
      key: key ?? this.key,
      label: label ?? this.label,
      kind: kind ?? this.kind,
      required: required ?? this.required,
      nullable: nullable ?? this.nullable,
      isArray: isArray ?? this.isArray,
      choices: choices ?? this.choices,
      fields: fields ?? this.fields,
      itemDescriptor: itemDescriptorAbsent
          ? null
          : itemDescriptor ?? this.itemDescriptor,
      sampleCount: sampleCount ?? this.sampleCount,
    );
  }
}

class CompendiumDraftEntity {
  final String entityType;
  final String collectionKey;
  final String id;
  final String name;
  final Map<String, dynamic> data;
  final Map<String, dynamic> extra;

  const CompendiumDraftEntity({
    required this.entityType,
    required this.collectionKey,
    required this.id,
    required this.name,
    required this.data,
    this.extra = const {},
  });
}
