import 'package:flutter/material.dart';

import '../../../core/theme/judo_design_tokens.dart';
import '../../../core/theme/judo_typography.dart';
import '../../../core/widgets/judo_card.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/quiz_model.dart';

class QuizSection extends StatefulWidget {
  final List<QuizModel> quizzes;

  const QuizSection({super.key, required this.quizzes});

  @override
  State<QuizSection> createState() => _QuizSectionState();
}

class _QuizSectionState extends State<QuizSection> {
  int currentQuestion = 0;
  int? selectedAnswer;
  int score = 0;
  bool answered = false;
  bool finished = false;

  void checkAnswer() {
    if (selectedAnswer == null) return;

    setState(() {
      answered = true;
      if (selectedAnswer ==
          widget.quizzes[currentQuestion].correctAnswerIndex) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (currentQuestion < widget.quizzes.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
        answered = false;
      });
    } else {
      setState(() => finished = true);
    }
  }

  void restartQuiz() {
    setState(() {
      currentQuestion = 0;
      selectedAnswer = null;
      score = 0;
      answered = false;
      finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.quizzes.isEmpty) {
      return JudoCard(
        key: const ValueKey<String>('quiz-empty'),
        child: Text(
          l10n.quizUnavailable,
          textAlign: TextAlign.center,
          style: JudoTypography.bodyMedium,
        ),
      );
    }

    if (finished) {
      return _ResultCard(
        score: score,
        total: widget.quizzes.length,
        onRestart: restartQuiz,
      );
    }

    final quiz = widget.quizzes[currentQuestion];
    final content = _ResolvedQuizContent.from(
      quiz,
      Localizations.localeOf(context).languageCode,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.techniqueQuiz, style: JudoTypography.headingLarge),
        const SizedBox(height: JudoSpacing.md),
        Text(
          '${l10n.question} ${currentQuestion + 1}/${widget.quizzes.length}',
          key: const ValueKey<String>('quiz-question-progress'),
          style: JudoTypography.labelLarge.copyWith(color: JudoColors.primary),
        ),
        const SizedBox(height: JudoSpacing.md),
        JudoCard(
          padding: const EdgeInsets.all(JudoSpacing.lg),
          child: Text(
            content.question,
            key: const ValueKey<String>('quiz-question-text'),
            style: JudoTypography.bodyLarge,
          ),
        ),
        const SizedBox(height: JudoSpacing.md),
        RadioGroup<int>(
          groupValue: selectedAnswer,
          onChanged: (value) {
            if (answered) return;
            setState(() => selectedAnswer = value);
          },
          child: Column(
            children: List.generate(content.options.length, (index) {
              final isCorrect = index == quiz.correctAnswerIndex;
              final isSelected = selectedAnswer == index;
              Color? tileColor;
              if (answered && isCorrect) {
                tileColor = JudoColors.success.withValues(alpha: 0.25);
              } else if (answered && isSelected) {
                tileColor = JudoColors.danger.withValues(alpha: 0.25);
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: JudoSpacing.sm),
                child: Material(
                  color: tileColor ?? JudoColors.surface,
                  borderRadius: BorderRadius.circular(JudoRadius.md),
                  child: RadioListTile<int>(
                    key: ValueKey<String>('quiz-option-$index'),
                    value: index,
                    enabled: !answered,
                    activeColor: JudoColors.primary,
                    title: Text(
                      content.options[index],
                      style: JudoTypography.bodyMedium,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        if (answered) ...[
          const SizedBox(height: JudoSpacing.sm),
          JudoCard(
            key: const ValueKey<String>('quiz-explanation'),
            child: Text(content.explanation, style: JudoTypography.bodyMedium),
          ),
        ],
        const SizedBox(height: JudoSpacing.md),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            key: const ValueKey<String>('quiz-primary-action'),
            onPressed: answered
                ? nextQuestion
                : selectedAnswer == null
                ? null
                : checkAnswer,
            child: Text(answered ? l10n.nextQuestion : l10n.submitAnswer),
          ),
        ),
        const SizedBox(height: JudoSpacing.md),
        Text(
          '${l10n.yourScore}: $score',
          key: const ValueKey<String>('quiz-score'),
          style: JudoTypography.titleSmall.copyWith(color: JudoColors.gold),
        ),
      ],
    );
  }
}

class _ResolvedQuizContent {
  final String question;
  final List<String> options;
  final String explanation;

  const _ResolvedQuizContent({
    required this.question,
    required this.options,
    required this.explanation,
  });

  factory _ResolvedQuizContent.from(QuizModel quiz, String languageCode) {
    final normalizedLanguage = languageCode.trim().toLowerCase();
    final translation = normalizedLanguage == 'en'
        ? null
        : quiz.getTranslation(normalizedLanguage);
    final translatedOptions = translation?.options ?? const <String>[];
    final hasValidTranslatedOptions =
        translatedOptions.length == quiz.options.length &&
        translatedOptions.every((option) => option.trim().isNotEmpty);

    return _ResolvedQuizContent(
      question: _textOrFallback(translation?.question, quiz.question),
      options: List<String>.unmodifiable(
        hasValidTranslatedOptions ? translatedOptions : quiz.options,
      ),
      explanation: _textOrFallback(translation?.explanation, quiz.explanation),
    );
  }

  static String _textOrFallback(String? localized, String fallback) {
    final localizedValue = localized?.trim() ?? '';
    return localizedValue.isNotEmpty ? localizedValue : fallback.trim();
  }
}

class _ResultCard extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onRestart;

  const _ResultCard({
    required this.score,
    required this.total,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return JudoCard(
      borderColor: JudoColors.gold,
      padding: const EdgeInsets.all(JudoSpacing.xl),
      child: Column(
        children: [
          Text(l10n.quizCompleted, style: JudoTypography.headingLarge),
          const SizedBox(height: JudoSpacing.md),
          Text(
            '$score / $total',
            key: const ValueKey<String>('quiz-final-score'),
            style: JudoTypography.displayMedium.copyWith(
              color: JudoColors.gold,
            ),
          ),
          const SizedBox(height: JudoSpacing.lg),
          ElevatedButton(
            key: const ValueKey<String>('quiz-restart-action'),
            onPressed: onRestart,
            child: Text(l10n.retakeQuiz),
          ),
        ],
      ),
    );
  }
}
