import '../models/history_event.dart';

/// A brief timeline for the Library's "History" tab. Not exhaustive —
/// selected milestones that trace how epilepsy moved from a spiritual
/// affliction to a modern, EEG-diagnosable neurological condition.
const List<HistoryEvent> epilepsyHistory = [
  HistoryEvent(
    era: 'c. 1067–1046 BC',
    title: 'The Babylonian "Sakikkū"',
    description: 'A Babylonian medical tablet, part of the diagnostic series known as the "Sakikkū," gives what is widely regarded as the earliest surviving clinical description of seizures — cataloguing seizure types by the body part affected, while attributing them to the influence of specific gods and spirits.',
  ),
  HistoryEvent(
    era: 'c. 400 BC',
    title: '"On the Sacred Disease" (Hippocrates)',
    description: 'The Hippocratic text "On the Sacred Disease" argues that epilepsy arises from a natural disturbance of the brain rather than divine punishment or possession — an early foundation, in the surviving Western medical record, for treating epilepsy as a medical rather than a spiritual condition.',
  ),
  HistoryEvent(
    era: 'Middle Ages',
    title: 'Possession, stigma and "moonsickness"',
    description: 'Across much of medieval Europe, seizures were widely reattributed to demonic possession, witchcraft or contagion. Popular belief also linked seizures to the lunar cycle ("moonsickness"/"lunacy"), and people with epilepsy faced significant, long-lasting social stigma.',
  ),
  HistoryEvent(
    era: '19th century',
    title: 'Hughlings Jackson and cortical localization',
    description: 'British neurologist John Hughlings Jackson proposed that seizures result from sudden, excessive electrical discharges in the brain, and described the spreading focal motor seizure now known as a "Jacksonian march" — laying groundwork for modern seizure semiology and localization.',
  ),
  HistoryEvent(
    era: '1912',
    title: 'Phenobarbital',
    description: 'Phenobarbital enters use and becomes the first widely effective anti-seizure medication, opening the modern pharmacological treatment era for epilepsy.',
  ),
  HistoryEvent(
    era: '1924–1929',
    title: 'Hans Berger and the first human EEG',
    description: 'German psychiatrist Hans Berger records the first human electroencephalogram and later publishes findings on epileptiform discharges, giving clinicians an objective, physiological window into seizure activity for the first time.',
  ),
  HistoryEvent(
    era: '1909 onward',
    title: 'The International League Against Epilepsy',
    description: 'Founded in 1909, the ILAE goes on to develop the seizure and epilepsy classification systems used worldwide today, including the 2017 operational classification referenced throughout this app.',
  ),
  HistoryEvent(
    era: '1997',
    title: 'Vagus nerve stimulation',
    description: 'The vagus nerve stimulator becomes the first implantable neurostimulation device approved for drug-resistant epilepsy, opening a treatment avenue beyond medication.',
  ),
];
