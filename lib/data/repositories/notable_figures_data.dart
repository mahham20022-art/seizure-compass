import '../models/notable_figure.dart';

/// Shown in the Library's "Notable Figures" tab, split into people who
/// documented or publicly disclosed their own epilepsy, and historical
/// figures for whom epilepsy is a debated retrospective hypothesis rather
/// than a settled diagnosis — the [FigureConfidence] on each entry marks
/// which is which.
const List<NotableFigure> notableFigures = [
  NotableFigure(
    name: 'Fyodor Dostoevsky',
    years: '1821–1881',
    description: 'The Russian novelist lived with epilepsy for most of his adult life and wrote some of literature\'s most detailed first-person accounts of an epileptic aura — the "ecstatic aura" he describes in The Idiot and elsewhere is still discussed in neurology and is widely considered consistent with temporal lobe epilepsy.',
    confidence: FigureConfidence.documented,
  ),
  NotableFigure(
    name: 'Harriet Tubman',
    years: 'c. 1822–1913',
    description: 'The American abolitionist developed seizures, severe headaches and hypersomnolence after being struck in the head as a teenager — an injury and its after-effects that are well documented in her biographies and that she lived with for the rest of her life.',
    confidence: FigureConfidence.documented,
  ),
  NotableFigure(
    name: 'Neil Young',
    years: 'b. 1945',
    description: 'The musician has spoken publicly in interviews about being diagnosed with epilepsy and experiencing seizures.',
    confidence: FigureConfidence.documented,
  ),
  NotableFigure(
    name: 'Lil Wayne',
    years: 'b. 1982',
    description: 'The rapper has spoken publicly about having epilepsy and experiencing seizures since childhood, including hospitalizations reported in the press.',
    confidence: FigureConfidence.documented,
  ),
  NotableFigure(
    name: 'Julius Caesar',
    years: '100–44 BC',
    description: 'Ancient historians including Suetonius and Plutarch describe episodes of "falling sickness." Modern historians and physicians continue to debate whether this reflected epilepsy, another medical condition, or was partly political characterization — an unresolved retrospective question, not a confirmed diagnosis.',
    confidence: FigureConfidence.historical,
  ),
  NotableFigure(
    name: 'Vincent van Gogh',
    years: '1853–1890',
    description: 'Van Gogh\'s physicians and later scholars have proposed numerous, competing explanations for his psychiatric and physical crises, including temporal lobe epilepsy, bipolar disorder and other conditions. No single diagnosis is settled, and epilepsy remains one hypothesis among several.',
    confidence: FigureConfidence.historical,
  ),
  NotableFigure(
    name: 'Joan of Arc',
    years: 'c. 1412–1431',
    description: 'Some historians and neurologists have speculated that Joan of Arc\'s visions could be consistent with a temporal lobe epilepsy aura. This is a retrospective hypothesis debated among historians, not a confirmed diagnosis by any contemporary or modern clinical standard.',
    confidence: FigureConfidence.historical,
  ),
  NotableFigure(
    name: 'Alexander the Great',
    years: '356–323 BC',
    description: 'Ancient sources describe convulsive collapses attributed to Alexander. As with other ancient figures, this is debated by historians and cannot be confirmed as epilepsy by modern criteria.',
    confidence: FigureConfidence.historical,
  ),
];
