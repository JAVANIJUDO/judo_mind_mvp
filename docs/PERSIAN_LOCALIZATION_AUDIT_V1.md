# Persian Localization Audit V1

Date: 2026-08-15

Status: `COMPLETE / TARGETED SOURCE VALIDATION PENDING`

Scope: the 261 Persian messages reported as untranslated before the Full
Persian Runtime Closure block.

## Boundary and Method

The inventory is the exact set of non-metadata messages present in
`lib/l10n/app_en.arb` and absent from `lib/l10n/app_fa.arb` at block start.
Every key was searched in project-owned Dart runtime sources outside generated
localization files. Typed runtime access was found only for `profile` and
`retry`.

Classification is mutually exclusive and uses runtime reachability first.
A name that resembles a brand, proper noun or technical term is classified as
unreachable/deprecated when no runtime consumer exists. This prevents
allowlisting unused legacy surface area merely because its English text looks
invariant.

No educational, scientific, training, media or product capability content was
invented. The official 18-module registry and all scientific identifiers,
statuses, formulas, versions and provenance remain unchanged.

## Closure Counts

| Result | Exact count | Disposition |
|---|---:|---|
| Initial untranslated Persian messages | 261 | Audited individually |
| Newly translated messages | 0 | No new wording was required |
| Remapped to existing approved Persian messages | 2 | `profile`, `retry` |
| Explicit invariant/allowlisted messages | 0 | No allowlist was needed |
| Unreachable/deprecated messages retired | 259 | Removed from the template contract |
| Missing approved content / fail-closed | 0 | No absent content was promoted |
| Unresolved messages | 0 | Persian template gap is closed |
| Final English template messages | 475 | Runtime contract |
| Final Persian messages | 475 | Exact template coverage |

## Required Seven-Way Classification

### 1. User-facing Persian

Count: 2.

- `profile` was a reachable legacy alias in the Home header. It now uses
  `moduleAthleteProfileTitle`, whose approved Persian value is
  «پروفایل ورزشکار».
- `retry` was a reachable legacy alias in Progress error handling. It now
  uses `retryLabel`, whose approved Persian value is «تلاش دوباره».

The aliases themselves were retired; the approved current messages remain.

### 2. Approved invariant

Count: 0.

No missing runtime message required an invariant English value.

### 3. Scientific identifier

Count: 0.

Scientific IDs and machine-readable status/provenance values were not part of
the 261-message gap and were not changed.

### 4. Japanese Judo term with Persian context

Count: 0.

Approved Japanese Judo terminology and its Persian context already live in the
current localization contract; none of these 261 legacy messages needed this
classification.

### 5. URL, source, brand or proper noun

Count: 0.

No reachable missing message required this exception. Unused names are retired
under category 6 rather than allowlisted.

### 6. Unreachable or deprecated

Count: 259.

Exact retired keys, in their original template order:

```text
appSlogan
home
language
notifications
privacy
security
help
about
logout
save
confirm
delete
edit
add
remove
search
sort
back
next
previous
continueLabel
done
close
refresh
viewAll
learnMore
seeDetails
start
finish
submit
share
download
upload
play
pause
error
success
warning
information
noData
noResults
somethingWentWrong
internetConnectionError
tryAgain
welcome
welcomeJudoka
exploreJudoMind
continueTraining
dailyProgress
recentActivity
quickAccess
featuredContent
dashboard
sensiBot
sensiBet
monitoring
audioCast
athleteProfile
trainingCenter
championsHub
competitions
challenges
news
store
subscriptions
clubAdmin
coachForum
onlineCourses
countryJudoHistory
judoTechnique
techniqueName
technicalExplanation
setup
entry
throwingPhase
controlPhase
variations
prerequisites
competitionVideo
watchVideo
openVideo
videoUnavailable
startQuiz
previousQuestion
answer
correctAnswer
wrongAnswer
showResult
forward
backward
aiCoach
chatWithSensi
askQuestion
typeYourMessage
sendMessage
newConversation
conversationHistory
recommendation
trainingRecommendation
techniqueRecommendation
personalizedAdvice
analyzing
sensiBotWelcome
healthMonitoring
sleep
sleepQuality
sleepDuration
nutrition
fatigue
fatigueLevel
bodyMetrics
heartRate
restingHeartRate
recovery
recoveryScore
performance
mentalHealth
stressLevel
mood
hydration
weight
height
bodyFat
muscleMass
recordData
viewReport
dailyReport
weeklyReport
monthlyReport
athleteInformation
personalInformation
fullName
dateOfBirth
gender
male
female
country
nationality
club
coach
beltRank
weightCategory
ranking
worldRanking
achievements
medals
goldMedals
silverMedals
bronzeMedals
timeline
statistics
matches
wins
losses
winRate
trainingPrograms
physicalTraining
technicalTraining
tacticalTraining
mentalTraining
judoTheory
judoRules
trainingPlan
todayTraining
trainingHistory
trainingDuration
trainingIntensity
completed
inProgress
notStarted
worldChampions
olympicChampions
legendaryJudoka
championProfile
careerHighlights
biography
upcomingCompetitions
pastCompetitions
competitionDetails
register
registered
registrationClosed
startDate
endDate
location
participants
results
leaderboard
latestNews
featuredNews
readMore
publishedAt
author
episodes
latestEpisodes
podcasts
nowPlaying
episodeDetails
products
cart
addToCart
removeFromCart
checkout
order
orders
price
total
payment
paymentSuccessful
paymentFailed
subscriptionPlans
basicPlan
proPlan
elitePlan
monthly
yearly
subscribe
currentPlan
upgradePlan
cancelSubscription
clubInformation
clubMembers
coaches
athletes
manageMembers
attendance
clubReports
forum
topics
posts
comments
createPost
reply
like
courses
courseDetails
instructor
lessons
enroll
enrolled
courseProgress
certificate
history
judoHistory
importantEvents
famousJudoka
nationalFederation
selectLanguage
english
persian
arabic
japanese
french
german
russian
lightMode
darkMode
systemTheme
version
```

### 7. Missing approved content / fail closed

Count: 0.

No message in this inventory represented an approved-content gap that needed a
new capability or fabricated translation.

## Runtime and Generator Result

- `app_en.arb`: 475 non-metadata messages.
- `app_fa.arb`: 475 non-metadata messages.
- English-template messages missing from Persian: 0.
- Flutter `gen-l10n`: exit code 0.
- Persian is absent from the generator untranslated-locale report.
- Arabic, German, French, Japanese and Russian remain outside this block and
  continue to report 475 untranslated messages each; this block does not claim
  those locales complete.
- Generated Dart localization files were regenerated by Flutter tooling and
  were not edited manually.

## Validation Contract

The focused localization regression verifies that:

1. every English template message has an explicit Persian message;
2. retired `profile` and `retry` aliases are absent from the template;
3. reachable Home and Progress code use the approved current messages;
4. the prior natural-Persian, taxonomy, RTL and English-integrity checks remain
   active.

This is localization contract closure, not physical-device visual approval.
