/// Product-owned capability contract for the Athlete Home platform shell.
///
/// This contract describes navigation only. It does not grant scientific,
/// training or communication capability and it deliberately contains no
/// fabricated destinations for unavailable journeys.
enum AthleteHomeJourneyId {
  learn,
  train,
  analyze,
  trackProgress,
  connectWithCoach,
}

enum AthleteHomeDestination {
  techniques,
  reviewedUchiMataAnalysis,
  progressOverview,
}

class AthleteHomeJourney {
  const AthleteHomeJourney({required this.id, this.destination});

  final AthleteHomeJourneyId id;
  final AthleteHomeDestination? destination;

  bool get isAvailable => destination != null;
}

abstract final class AthleteHomeCapabilities {
  const AthleteHomeCapabilities._();

  static const List<AthleteHomeJourney> journeys = [
    AthleteHomeJourney(
      id: AthleteHomeJourneyId.learn,
      destination: AthleteHomeDestination.techniques,
    ),
    AthleteHomeJourney(id: AthleteHomeJourneyId.train),
    AthleteHomeJourney(
      id: AthleteHomeJourneyId.analyze,
      destination: AthleteHomeDestination.reviewedUchiMataAnalysis,
    ),
    AthleteHomeJourney(
      id: AthleteHomeJourneyId.trackProgress,
      destination: AthleteHomeDestination.progressOverview,
    ),
    AthleteHomeJourney(id: AthleteHomeJourneyId.connectWithCoach),
  ];
}
