import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

String slugify(String title) {
  return title
      .toLowerCase()
      .replaceAll(RegExp(r"[^a-z0-9]+"), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
}

void main() {
  final yaml = loadYaml(File('content/_data/projects.yaml').readAsStringSync())
      as Map;
  final projects = yaml['projects'] as List;

  for (final entry in projects.cast<YamlMap>()) {
    final title = entry['title'] as String;
    final slug = slugify(title);
    final path = p.join('content', 'projects', '$slug.md');

    if (File(path).existsSync()) {
      print('Skipping existing $path');
      continue;
    }

    final description = entry['description'] as String? ?? '';
    final image = entry['image'] as String? ?? '';
    final buffer = StringBuffer();
    buffer.writeln('---');
    buffer.writeln('title: "$title"');
    if (description.isNotEmpty) {
      buffer.writeln('description: "${description.replaceAll('"', '\\"')}"');
    }
    buffer.writeln('---');
    buffer.writeln();
    buffer.writeln('🚧 This page is under construction — details about the project will be added soon.');
    buffer.writeln();
    if (image.isNotEmpty) {
      buffer.writeln('![$title preview](/$image)');
      buffer.writeln();
    }

    File(path).writeAsStringSync(buffer.toString());
    print('Created $path');
  }
}
