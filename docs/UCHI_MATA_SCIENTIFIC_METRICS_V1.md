# Uchi Mata Scientific Metrics Specification v1

## Document Control

- Status: Approved scientific and product architecture specification
- Date: 2026-08-08
- Scope: Uchi Mata analysis across Fight Intelligence 360 Levels 1-3
- Implementation status: Specification only; this document does not claim that the metrics are implemented or validated
- Governing decisions: JM-DEC-017, JM-DEC-018 and JM-DEC-019

## 1. Purpose

This specification defines what Judo Mind may calculate, how each result must be classified, which evidence is required, and what the product must not claim. Uchi Mata is the reference technique. The same schema may be generalized only after technique-specific review.

The scientific contract is stricter than the user interface. A result is publishable only when its input, method, provenance, confidence and limitations all satisfy the level that produced it.

## 2. Non-Negotiable Provenance

| Provenance | Meaning in Judo Mind | Examples |
|---|---|---|
| `measured` | Directly observed media metadata or signal from suitable hardware | video timestamps, FPS, resolution, force-plate signal, IMU signal, EMG signal |
| `reconstructed` | Calculated from validated synchronized multi-camera geometry | triangulated 3D landmark, geometric 3D trajectory, geometric angle derived directly from reconstructed landmarks |
| `model-estimated` | Produced by a pose, anthropometric or musculoskeletal model | 2D pose landmark, 2D joint angle from estimated landmarks, 2D COM proxy, OpenSim output |
| `AI-inferred` | Technical or tactical interpretation predicted from evidence | phase label, technical error, coaching interpretation, conceptual mechanical cue |

No output may be promoted to a stronger provenance. In particular:

- Single-camera output is not reconstructed 3D.
- A pose keypoint is not a directly measured anatomical point.
- A 2D COM proxy is not true 3D whole-body COM.
- Video-only force, torque, joint moment, joint power or ground-reaction force is not measured.
- OpenSim output remains model-estimated even when its inputs include measured laboratory signals.

## 3. Official Fight Intelligence 360 Levels

### Level 1 - Single-Camera AI Analysis

Input: one ordinary training or competition video.

Allowed output: measured media metadata, projected 2D model estimates, temporal estimates and AI-inferred coaching observations. Every spatial metric must say `projected` or `image-plane` unless an independently validated planar scale is available.

Prohibited output: true or reconstructed 3D, true 3D COM, measured external force, actual joint moment, joint power, torque or measured force vector.

### Level 2 - Multi-Camera 3D Analysis

Input: two or more synchronized streams that pass camera, calibration, orientation, identity, correspondence, geometry and reconstruction-quality gates.

Pipeline:

`synchronization -> intrinsics -> extrinsics -> orientation -> cross-camera Tori/Uke identity -> landmark correspondence -> triangulation -> 3D reconstruction -> filtering -> confidence/quality gates -> 3D metrics`

Allowed output after all gates pass: reconstructed 3D skeleton and trajectories, geometric 3D joint angles, 3D relative positioning, 3D velocities, model-estimated COM and interactive 3D viewing.

`review_required` calibration is forbidden. The rejected 2026-08-07 stereo extrinsic remains blocked and its two source videos must not be tested again.

### Level 3 - Professional / Federation / Laboratory Analysis

Input may include synchronized high-speed cameras, a calibrated capture volume, marker-based or independently validated markerless capture, optional IMUs, force plates or other external-force instrumentation, EMG where approved, and OpenSim.

Allowed output: high-quality 3D kinematics and, only when instrumentation and model assumptions permit, measured external forces plus model-estimated inverse-dynamics, moment, power, work or other kinetics.

Level 3 is also the reference-validation environment for Levels 1 and 2. Laboratory branding does not by itself authorize a kinetic claim.

## 4. Phase and Event Vocabulary

The Judo Mind canonical sequence is:

`Preparation -> Kuzushi -> Tsukuri -> Kake -> Flight/Throw -> Landing -> Transition`

Source-specific definitions must be stored alongside canonical labels. They must not be silently remapped:

| Source | Source definition | Rule |
|---|---|---|
| DOI `10.3390/jfmk10040378` | Approach is called Tsukuri, Turning is called Kuzushi, and Throw is called Kake; each is defined by lower-limb motion events | Preserve these source labels and event definitions. Do not assume they are equivalent to Judo Mind's canonical ordering without a reviewed mapping. |
| DOI `10.34518/rjsp.16.0_10` | Uses Turning and Throwing phases with laboratory event detection | Preserve the two-phase study definition when reproducing its analysis. |
| DOI `10.5103/KJSB.2002.12.1.063` | Uses E1-E6 and subdivisions of Kake | Store original events; mapping to canonical phases requires expert annotation. |
| DOI `10.51979/KSSLS.2013.12.54.1073` | Reports E1-E4 kinetic variables | Store original events; do not infer canonical boundaries from event numbers. |
| DOI `10.11214/budo.50.S_73` | Tsukuri starts at pivot-foot lift-off and ends when both feet contact the mat; Kake extends from the end of turning until part of Uke's leg contacts the mat | Preserve this operational definition and do not treat it as a universal threshold. |

Each automated phase result must therefore contain `phase_schema_id`, event times, annotation/model version, confidence and an explicit mapping status: `native`, `expert_mapped` or `unmapped`.

## 5. Confidence and Reportability

Confidence is not a single unqualified percentage. Each metric must retain:

- landmark confidence and visibility;
- Tori/Uke identity confidence when a role is required;
- temporal/event confidence when a phase or event is required;
- camera-view suitability and out-of-plane risk;
- calibration, synchronization and reconstruction quality for Level 2;
- sensor validity and model residuals for Level 3;
- missing-data and occlusion coverage;
- the method/model version and validation status.

Until validation defines metric-specific thresholds, Judo Mind must not invent pass/fail or normative values. A metric can be `not_reportable`, `review_required` or `reportable` according to an approved versioned quality policy; the policy and evidence must be retained with the result.

## 6. Level 1 Metric Contract

All Level 1 spatial results use pose-model landmarks and are therefore `model-estimated`, even when their unit is degrees. AI phase or coaching interpretations are `AI-inferred`.

| Metric ID | Coaching name / scientific variable | Role and phase/event | Required landmarks, sensors or inputs | Formula, method and unit | Required setup / confidence | Source | Allowed interpretation | Prohibited interpretation |
|---|---|---|---|---|---|---|---|---|
| `UM-TIM-001` | Execution duration / elapsed time between reviewed events | Tori/Uke interaction; selected event pair | measured frame timestamps plus reviewed or inferred event boundaries | `t_end - t_start`, seconds | Level 1+, adequate FPS; boundary confidence required. Provenance is `AI-inferred` for automatic boundaries and `measured` only for the underlying time base | All five sources use temporal events; especially `10.3390/jfmk10040378`, `10.5103/KJSB.2002.12.1.063` | Compare the same athlete and same event schema over repeated trials | Claim that shorter always means better; compare unlike phase schemas |
| `UM-PHS-001` | Technical-event sequence / ordered phase-event labels | Both athletes; full action | stable temporal tracks, interaction cues, reviewed annotation schema | ordered events with start/end time and duration; seconds and categorical labels | Level 1+; event confidence and schema mapping required. `AI-inferred` | Source phase definitions above | Navigate video and describe likely temporal organization | Present an inferred phase as directly measured or force a source phase into canonical labels |
| `UM-ANG-001` | Projected trunk inclination / image-plane trunk-axis angle to vertical | Tori; Turning/Tsukuri/Kake according to declared schema | shoulders and hips, or a validated trunk axis | `atan2` of projected trunk vector relative to image vertical; degrees | Level 1+; suitable near-planar view, low roll, stable Tori track. `model-estimated` | `10.34518/rjsp.16.0_10` | Describe visible timing and magnitude of projected trunk lean | Call it true 3D trunk angle or apply the paper's group values as a universal target |
| `UM-ANG-002` | Projected support-leg knee angle | Tori; entry and Kake | support-side hip, knee, ankle plus support-leg classification | image-plane angle `hip-knee-ankle`; degrees | Level 1+; support leg and Tori identity must be stable. `model-estimated` | `10.5103/KJSB.2002.12.1.063` and `10.34518/rjsp.16.0_10` | Describe projected flexion/extension pattern | Claim anatomical 3D knee angle, load, moment or injury risk |
| `UM-ANG-003` | Projected attacking-leg knee angle | Tori; entry and Kake | attacking-side hip, knee, ankle plus attacking-leg classification | image-plane angle `hip-knee-ankle`; degrees | Level 1+; attacking leg and Tori identity stable. `model-estimated` | `10.5103/KJSB.2002.12.1.063` | Describe visible attacking-leg shape and timing | Claim true 3D angle or a universal ideal angle |
| `UM-ANG-004` | Projected attacking-leg hip angle | Tori; entry and Kake | trunk/pelvis proxy, attacking hip and knee | declared image-plane segment angle; degrees | Level 1+; view suitability and segment visibility required. `model-estimated` | `10.3390/jfmk10040378`, `10.5103/KJSB.2002.12.1.063` | Describe projected hip flexion/extension pattern | Claim 3D hip rotation or joint loading |
| `UM-GRP-001` | Hikite/Tsurite and shoulder-elbow configuration | Tori and Uke; Turning/entry | bilateral shoulders, elbows, wrists, stable roles; grip-contact evidence when visible | joint angles plus wrist/hand displacement and temporal pattern; degrees and normalized displacement | Level 1+; high occlusion risk must lower reportability. `model-estimated` for geometry and `AI-inferred` for grip interpretation | `10.34518/rjsp.16.0_10`, `10.5103/KJSB.2002.12.1.063` | Describe visible pull/lift coordination as a coaching hypothesis | Claim measured hand force, torque, grip strength or guaranteed lever action |
| `UM-DSP-001` | Projected attacking-foot elevation | Tori; Kake/Throw | attacking ankle/heel/foot and a declared image reference | vertical pixel displacement; preferably normalized by a stable body or mat reference; px or dimensionless ratio | Level 1+; fixed camera and suitable view. `model-estimated` | `10.3390/jfmk10040378` | Track relative elevation within the same setup | Report meters without valid scale/plane calibration or treat paper heights as a universal target |
| `UM-DSP-002` | Projected hip/knee/foot displacement | Tori; declared phase | stable joint tracks and event boundaries | 2D path or axis displacement; px or normalized body-length units | Level 1+; camera must be fixed and out-of-plane risk stated. `model-estimated` | `10.3390/jfmk10040378` | Compare projected movement amplitude in controlled repeat trials | Call it 3D displacement or compare arbitrary zoom/camera setups in meters |
| `UM-VEL-001` | Projected angular velocity | Tori; declared phase | smoothed projected angle series and reliable timestamps | central difference or fitted derivative of angle; degrees/second | Level 1+; sufficient FPS, smoothing method and uncertainty required. `model-estimated` | `10.3390/jfmk10040378` | Describe image-plane rate of joint/segment rotation | Claim true 3D angular velocity or angular momentum |
| `UM-VEL-002` | Projected linear velocity | Tori or Uke; declared point and phase | smoothed 2D landmark trajectory and timestamps | default: px/s or normalized body-length/s; m/s only with validated fixed-plane scale and negligible depth motion | Level 1+; scale, plane, FPS and out-of-plane evidence required. `model-estimated` | `10.3390/jfmk10040378` | Describe projected speed under the declared conditions | Report physical m/s from ordinary uncalibrated video or infer force/power |
| `UM-BOS-001` | Projected foot placement and base-of-support proxy | Tori; entry/Turning | both ankles, heels/feet and mat plane if visible | projected inter-foot distance, support-foot position and optional normalized support polygon; px or ratio | Level 1+; stable Tori identity. `model-estimated` | `10.11214/budo.50.S_73`, `10.34518/rjsp.16.0_10` | Describe visible placement and one-foot support timing | Claim a physical stability margin, pressure distribution or measured balance |
| `UM-REL-001` | Projected Tori/Uke relative position | Both; all relevant events | persistent Tori and Uke tracks, pelvis/trunk/foot proxies | image-plane relative vectors/distances normalized by a declared reference; px or ratio | Level 1+; both identities must remain stable. `model-estimated` | `10.34518/rjsp.16.0_10`, `10.5103/KJSB.2002.12.1.063` | Describe visible closing, alignment and relative placement | Claim 3D distance, depth or contact force |
| `UM-COM-001` | 2D COM proxy | Tori or Uke; declared phase | visible body landmarks, documented segment-mass model | weighted sum of projected segment COM proxies; image coordinates or normalized ratio | Level 1+; sufficient whole-body coverage and model disclosure. `model-estimated` | `10.5103/KJSB.2002.12.1.063` supports COM analysis in 3D; Level 1 is explicitly a weaker proxy | Describe projected whole-body motion trend | Call it true 3D COM, center of pressure, balance measurement or mass transfer |
| `UM-BAL-001` | Uke projected balance displacement | Uke relative to projected foot support; Kuzushi/Turning | stable Uke track, Uke COM proxy and foot landmarks | projected COM-proxy displacement and relation to projected foot span; px or ratio | Level 1+; identity and foot visibility required. `model-estimated`; coaching conclusion is `AI-inferred` | `10.34518/rjsp.16.0_10`, `10.5103/KJSB.2002.12.1.063` | Describe visible displacement consistent with a balance-breaking cue | Claim measured balance, COP, GRF or force direction |

The green visual layer may show balance, COM-proxy and conceptual mechanical direction in Level 1. It must label directional arrows as `AI-inferred coaching cue`; it must not depict a measured force vector.

## 7. Stable Tori/Uke Tracking Dependency

The following metrics require stable role identity rather than per-frame person order:

- `UM-ANG-001` through `UM-ANG-004` when attributed to Tori;
- `UM-GRP-001`;
- `UM-DSP-001`, `UM-DSP-002`, `UM-VEL-001`, `UM-VEL-002`;
- `UM-BOS-001`, `UM-REL-001`, `UM-COM-001`, `UM-BAL-001`;
- automatic `UM-TIM-001` and `UM-PHS-001` when the event model uses athlete interaction.

If identity is uncertain, the metric must be withheld or shown as `review_required`; the system must not silently swap Tori and Uke.

## 8. Level 2 Metric Contract

All Level 2 outputs require the complete JM-DEC-018 fail-closed gate chain.

| Metric ID | Scientific variable | Role / method / unit | Provenance | Allowed interpretation | Prohibited interpretation |
|---|---|---|---|---|---|
| `UM-3D-001` | 3D anatomical landmark/skeleton | Tori and Uke; triangulated correspondences in calibrated coordinates; meters | `reconstructed` | Validated 3D pose geometry with per-point uncertainty | Direct measurement, anatomy-grade motion or OpenSim readiness by calibration alone |
| `UM-3D-002` | 3D joint trajectories and displacement | Tori/Uke; filtered landmark paths; meters | `reconstructed` | Spatial path after sync, identity and reconstruction gates | Force, power or laboratory equivalence |
| `UM-3D-003` | Geometric 3D joint/segment angles | Tori; vectors between reconstructed landmarks; degrees | `reconstructed`; anatomical-model refinement is `model-estimated` | 3D kinematic geometry with stated method | Joint moment, loading or clinical interpretation |
| `UM-3D-004` | 3D Tori/Uke relative positioning | Both; relative pelvis/trunk/foot vectors; meters/degrees | `reconstructed` | Valid 3D relative geometry and trajectory | Contact pressure, grip force or causal tactical certainty |
| `UM-3D-005` | 3D linear/angular velocity | Tori/Uke; derivatives of filtered reconstructed paths/angles; m/s and degrees/s | `reconstructed` for geometric derivative; filtering/model contribution retained | 3D rate of motion with propagated uncertainty | Momentum, force or power without mass/model/instrument support |
| `UM-3D-006` | 3D whole-body COM estimate | Tori/Uke; segment model applied to reconstructed kinematics; meters | `model-estimated` | Model-based COM trajectory with reconstruction and anthropometric uncertainty | Directly measured COM or COP |
| `UM-3D-007` | 3D phase-specific comparison to reference | athlete motion and approved reference; time-normalized aligned trajectories | `reconstructed` inputs plus `AI-inferred` interpretation | Visualize angle/time/position differences after compatible protocol and schema checks | Declare correctness from one champion, one trial or incompatible capture protocols |

## 9. Level 3 Metric Contract

| Metric ID | Scientific variable | Required instrumentation / method / unit | Provenance | Evidence source | Product boundary |
|---|---|---|---|---|---|
| `UM-LAB-001` | Ground-reaction force and force vector | synchronized force plate; newtons and normalized N/body-weight where approved | `measured` | `10.34518/rjsp.16.0_10` used force plates at 1000 Hz | Only display as measured when the relevant foot/contact is validly captured; never estimate it from Level 1 arrows |
| `UM-LAB-002` | Center of pressure | calibrated force plate; meters or normalized platform coordinates | `measured` | laboratory force-platform workflow | Not interchangeable with COM or a 2D balance proxy |
| `UM-LAB-003` | IMU acceleration/angular velocity | synchronized, calibrated body-worn IMU; m/s^2 and degrees/s or rad/s | `measured` signal; fused biomechanical state may be `model-estimated` | Level 3 architecture | Sensor attachment, drift, frame and synchronization must be reported |
| `UM-LAB-004` | Uke resultant momentum and angular momentum | high-quality 3D kinematics plus segment inertial model; kg.m/s and kg.m^2/s | `model-estimated` | `10.11214/budo.50.S_73` used 94 markers, 24 VICON-MX cameras at 250 Hz | The cited single-athlete pattern and approximately 32% observation are not a universal target |
| `UM-LAB-005` | Joint moment/torque | 3D kinematics, body model and valid external forces through inverse dynamics; N.m | `model-estimated` | `10.51979/KSSLS.2013.12.54.1073` reports event-specific joint moments | Never label as measured joint torque or compute from ordinary video alone |
| `UM-LAB-006` | Joint/segment power and mechanical work | joint moment plus angular velocity; W and J | `model-estimated` | `10.51979/KSSLS.2013.12.54.1073` reports shoulder/elbow/wrist/trunk/lower-limb work or power factors | Requires valid kinetics; no Level 1/2 claim from motion alone |
| `UM-LAB-007` | EMG activity | synchronized approved EMG instrumentation; volts or normalized amplitude | `measured` signal; muscle-state interpretation may be `model-estimated` | future validation architecture | Do not equate EMG amplitude with muscle force or OpenSim activation |

## 10. Scientific Source Register

1. [Brito et al., Kinematic Analysis of the Lower Limb in Uchi-Mata](https://doi.org/10.3390/jfmk10040378) - 40 international-level athletes; marker-based photogrammetry; timing, hip/knee angular velocity and acceleration, foot linear velocity and acceleration, and hip/knee/foot displacement. Its phase naming differs from the Judo Mind canonical order.
2. [Hamaguchi et al., A Study on the Teaching Method of "uchimata" in Judo](https://doi.org/10.34518/rjsp.16.0_10) - 20 male university judokas; Mac3D at 250 Hz and force plate at 1000 Hz; trunk inclination timing and Hikite/Tsurite-related joint configuration. Group findings are research evidence, not product thresholds.
3. [Lee et al., Biomechanical Analysis of the Determinant Factors on Uchi-Mata](https://doi.org/10.51979/KSSLS.2013.12.54.1073) - expert/novice comparison; event-specific joint moments, work and power. These are Level 3 kinetic/model outputs, not single-video metrics.
4. [Kim et al., Kinematic Analysis by Kumi-kata Types](https://doi.org/10.5103/KJSB.2002.12.1.063) - small study using two-camera 3D DLT videography at 30 fps; temporal, upper/lower joint-angle and COM variables. Its small sample and grip-specific conditions prohibit universal normative thresholds.
5. [Ishii et al., Kinematic Characteristics in an Olympic Gold Medalist](https://doi.org/10.11214/budo.50.S_73) - one-page case comparison using 94 markers and 24 VICON-MX cameras at 250 Hz; Uke momentum/angular momentum and Tori inter-ankle distance. The champion-specific pattern is a reference hypothesis, not a universal ideal.

## 11. Interactive 3D / 360 Architecture

Interactive 3D is available only after `UM-3D-001` passes all Level 2 gates. The product language is `3D reconstruction + 360 viewing`, never `360-camera capture` unless a future capture system actually uses that method.

Required components:

1. versioned reconstructed-motion asset with calibration and provenance identifiers;
2. separate Tori and Uke skeleton/mesh bindings with identity confidence;
3. phase/event timeline and synchronized source-video references;
4. virtual-camera controller with Front, Side, Rear, Top and Free 360 views;
5. uncertainty/quality overlay and a visible reconstruction-quality state;
6. optional athlete-versus-reference comparison using compatible phase schemas, handedness, scale and capture protocol;
7. visual differences for angle, timing and position without converting them automatically into correctness claims.

If reconstruction quality becomes invalid, the 3D/360 result must not load as a scientific result. A Level 1 annotated-video result may be offered separately under its own provenance.

## 12. Fight Intelligence Result Experience

The official result experience remains a coordinated system:

- AI Sensi coaching;
- annotated video;
- voice coaching;
- scientific report;
- interactive 3D/360 only when Level 2 or 3 evidence permits.

Annotated-video color semantics:

- Blue: movement, position and joint geometry.
- Gold: grip, Hikite, Tsurite, pull and upper-body control.
- Green: balance, COM and mechanical direction. In Level 1, any directional cue is `AI-inferred` and conceptual, not a force vector. Measured external-force vectors require Level 3 instrumentation.

Each finding must contain:

`Metric ID, Metric, Value, Unit, Athlete Role, Phase/Event, Level, Provenance, Confidence Components, Quality State, Limitation, Scientific Source, Method Version, Coaching Interpretation, Prohibited Interpretation`

AI Sensi is an independent Judo Mind character. It may be inspired by Mohammad Javani's visual identity without copying his full face. Its voice may be deep, classic, authoritative, athletic, energetic and nostalgic, but no real narrator or third party may be cloned without permission. Synchronized coaching follows:

`pause/slow motion -> relevant frame -> overlay -> spoken coaching -> scientific explanation`

## 13. First Implementation Recommendation

After persistent Tori identity and a reviewed event-annotation protocol exist, the first three scientific metrics should be:

1. `UM-TIM-001` execution duration using a declared event pair;
2. `UM-ANG-001` projected trunk inclination;
3. `UM-ANG-002` projected support-leg knee angle.

Why these first:

- they do not require metric spatial scale;
- they have clear units and interpretable frame overlays;
- they connect directly to reviewed Uchi Mata literature;
- they can be validated frame-by-frame against expert annotations;
- their Level 1 limits are easy to state without implying 3D or kinetics.

## 14. V2A Implementation Record

JM-DEC-022 implements the first software layer for `UM-TIM-001`, `UM-ANG-001`
and `UM-ANG-002` under schema `2.0.0` / variant `single_attempt_v2a`.

Versioned methods:

- `reviewed-event-elapsed-time-1.0.0`: reviewed source timestamp difference in
  seconds;
- `projected-trunk-inclination-1.0.0`: shoulder/hip midpoint vector with
  normalized landmarks converted to source-image pixel coordinates, then
  `degrees(atan2(abs(dx), -dy))` relative to image vertical-up;
- `projected-knee-angle-1.0.0`: support-side image-plane internal
  hip-knee-ankle angle in source-image pixel coordinates using bounded dot
  product and arccos.

The implementation requires human-selected attempt boundaries,
human-confirmed Tori and support leg, a human-selected angle frame/event and
human-reviewed view suitability/low roll. Automatic Tori/Uke and
Kuzushi/Tsukuri/Kake remain unavailable. Model landmark visibility may be
preserved but is not scientific confidence or pose accuracy.

Current tests are synthetic software/math validation only. No real
scientifically validated metric result or normative coaching threshold has
been established.

Acceptance for a future implementation requires, at minimum:

- stable Tori identity across the reported window;
- declared phase schema and event-boundary confidence;
- camera-view suitability checks;
- versioned formula and smoothing method;
- metric-specific synthetic tests plus annotated real-video validation;
- Flutter rendering of value, provenance, confidence, source and limitation;
- no 3D, force, torque, moment or power claim.

## 14. Judo Mind Lab Path

1. Define expert-labelled Uchi Mata event and role datasets with left/right, body-size, judogi, occlusion and competition-speed diversity.
2. Establish repeatability and inter-rater reliability for Level 1 events and projected angles.
3. Validate Level 1 metrics against synchronized Level 3 reference capture and publish error distributions by view and occlusion condition.
4. Establish a professional multi-camera protocol and validate Level 2 reconstruction against marker-based 3D reference trajectories.
5. Add force plates and optional IMUs/EMG only under synchronized laboratory protocols.
6. Validate OpenSim scaling, inverse kinematics and, where external forces permit, inverse dynamics against reference systems.
7. Version every model, metric, capture protocol and quality policy; retain raw evidence and audit trails.
8. Collaborate with universities, federations and elite training centers before making federation/laboratory-grade claims.

The target is scientific comparability and transparent error characterization, not cosmetic imitation of laboratory systems.


## UM-ANG-003 Implementation Record

`UM-ANG-003 ? Projected attacking-leg knee angle` is now implemented in
Single Attempt V2A.

Implementation constraints:

- attacking leg: human-confirmed;
- Tori identity: human-confirmed;
- input landmarks: attacking-side hip, knee and ankle;
- method: `projected-knee-angle-1.0.0`;
- unit: degrees;
- provenance: `model-estimated`;
- Level 1 image-plane interpretation only;
- boundary-normalized required landmarks cannot automatically produce a
  reportable result;
- missing attacking-leg confirmation causes the metric to be withheld.

Run 01 reference result:

- attacking leg: left;
- projected attacking-leg knee angle: `157.99 deg`;
- status: `reportable`.



## UM-ANG-004 Method Definition Gate

`UM-ANG-004` remains an approved planned Level 1 metric, but implementation is
deferred.

Before implementation, the project must explicitly declare and version:

1. the trunk or pelvis proxy used as the proximal reference;
2. the reference axis or segment against which the attacking thigh is measured;
3. the exact 2D angle convention and valid range;
4. required landmarks;
5. view and occlusion requirements;
6. boundary-normalization behavior.

Until that method is approved, no numeric `UM-ANG-004` result may be produced.
