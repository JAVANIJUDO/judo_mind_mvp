import 'package:flutter/material.dart';

import '../../models/technique_model.dart';
import 'widgets/technical_analysis.dart';
import 'widgets/video_buttons.dart';
import 'widgets/quiz_section.dart';
import 'widgets/media_gallery.dart';
import '../../core/widgets/judo_icon.dart';
import '../../core/widgets/judo_card.dart';
import '../../core/widgets/judo_section_title.dart';

class TechniqueDetailScreen extends StatelessWidget {
  final TechniqueModel technique;

  const TechniqueDetailScreen({
    super.key,
    required this.technique,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050505),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          technique.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 900,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  technique.japaneseName,
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _BasicInfoCard(
                  technique: technique,
                ),
                const SizedBox(height: 22),

                MediaGallery(
  media: technique.media,
),
                const SizedBox(height: 28),

                const _SectionTitle(
                  title: 'Overview',
                ),
                const SizedBox(height: 10),

                _BodyText(
                  text: technique.description,
                ),
                const SizedBox(height: 30),

                TechnicalAnalysis(
                  kuzushi: technique.kuzushi,
                  tsukuri: technique.tsukuri,
                  kake: technique.kake,
                ),
                const SizedBox(height: 30),

                _StringListSection(
                  title: 'Common Errors',
                  items: technique.commonErrors,
                  iconType: "warning",
                ),
                const SizedBox(height: 28),

                _StringListSection(
                  title: 'Combinations',
                  items: technique.combinations,
                  iconType: "technique",
                ),
                const SizedBox(height: 28),

                
                const SizedBox(height: 30),

QuizSection(
  quizzes: technique.quiz,
),

const SizedBox(height: 30),
                
                const SizedBox(height: 28),

                _StringListSection(
                  title: 'Official Sources',
                  items: technique.sources,
                  iconType: "source",
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BasicInfoCard extends StatelessWidget {
  final TechniqueModel technique;

  const _BasicInfoCard({
    required this.technique,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF0066FF).withOpacity(0.35),
        ),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _InfoChip(
            label: 'Category',
            value: technique.category,
          ),
          _InfoChip(
            label: 'Type',
            value: technique.type,
          ),
          _InfoChip(
            label: 'Level',
            value: technique.beltLevel,
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _InfoChip({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF080808),
        borderRadius: BorderRadius.circular(14),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Color(0xFF0066FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TechniqueImage extends StatelessWidget {
  final String imagePath;

  const _TechniqueImage({
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF0066FF),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: imagePath.isEmpty
            ? const _ImagePlaceholder()
            : Image.asset(
                imagePath,
                width: double.infinity,
                height: 360,
                fit: BoxFit.contain,
                errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                ) {
                  return const _ImagePlaceholder(
                    message: 'Unable to display technique image',
                  );
                },
              ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final String message;

  const _ImagePlaceholder({
    this.message = 'Official Technique Image',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _BodyText extends StatelessWidget {
  final String text;

  const _BodyText({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 16,
        height: 1.6,
      ),
    );
  }
}

class _StringListSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final String iconType;

  const _StringListSection({
    required this.title,
    required this.items,
    required this.iconType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JudoSectionTitle(
  title: title,
  iconType: iconType,
),
        const SizedBox(height: 12),
        if (items.isEmpty)
          const Text(
            'No information has been added yet.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 15,
            ),
          )
        else
          ...items.map(
            (String item) {
              return JudoCard(

  padding: const EdgeInsets.all(15),

  child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    JudoIcon(
  type: iconType,
  size: 28,
),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}