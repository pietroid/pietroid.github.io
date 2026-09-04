import 'dart:io';

import 'package:yaml/yaml.dart';

import '../components/projects/project_context.dart';
import '../components/projects/project_item.dart';
import '../components/projects/project_status.dart';

/// Loads project entries from `content/_data/projects.yaml`.
///
/// The YAML is read synchronously so it can be consumed by Jaspr components
/// during static site generation.
List<ProjectItemData> loadProjects() {
  final file = File('content/_data/projects.yaml');
  final content = file.readAsStringSync();
  final doc = loadYaml(content) as Map;
  final list = doc['projects'] as List;

  return [
    for (final entry in list.cast<YamlMap>())
      ProjectItemData(
        image: entry['image'] as String,
        title: entry['title'] as String,
        description: entry['description'] as String,
        context: entry['context'] as String,
        contextColor: _contextColor(entry['context'] as String),
        status: entry['status'] as String,
        statusColor: _statusColor(entry['status'] as String),
        date: entry['date'].toString(),
      ),
  ];
}

ProjectContextColor _contextColor(String context) {
  return switch (context.trim().toLowerCase()) {
    'very good ventures' || 'freelancing' => ProjectContextColor.teal,
    'personal' => ProjectContextColor.yellow,
    _ => ProjectContextColor.teal,
  };
}

ProjectStatusColor _statusColor(String status) {
  return switch (status.trim().toLowerCase()) {
    'done' => ProjectStatusColor.done,
    'wip' || 'in progress' => ProjectStatusColor.wip,
    _ => ProjectStatusColor.wip,
  };
}
