---
title: COMP723 Lecture 6.2 - Sound and Speech Processing
type: source-summary
sources: [raw/lecture-notes/COMP723/Lecture6.pptx]
related: [COMP723, Deep Neural Networks (DNN), Recurrent Neural Networks (RNN), Confusion Matrix Metrics]
created: 13-06-2026
last-updated: 13-06-2026
---

# COMP723 Lecture 6.2 - Sound and Speech Processing

> [!tip] Going Deeper
> This lecture is a survey of audio/speech processing as an application domain for data mining — it introduces vocabulary (sampling rate, spectrograms, MFCC, ASR) without deep formulas, so this note captures it Cornell-style without a new concept page. [[Deep Neural Networks (DNN)]] covers the classifier architecture referenced for audio classification, and [[Recurrent Neural Networks (RNN)]] (supplemented further in Lecture 10) covers the sequence models used for speech recognition.

## Cues & Questions

> Use this column for self-testing. Cover the Notes section and try to answer each cue from memory.

- **What are 4 applications of sound classification mentioned in the lecture?**
- **What's the difference between uncompressed, lossy-compressed, and lossless-compressed audio formats? Give an example of each.**
- **What is a "sampling rate", and what does a typical value (44.1 kHz) mean?**
- **What 4 preprocessing steps does Librosa perform on audio data?**
- **What is a spectrogram, and how does MFCC differ from a plain spectrogram?**
- **Define: speaker diarization, speech recognition, paralinguistic aspects, speech understanding — how do these four differ?**
- **List 3 reasons speech recognition is hard from a machine-learning perspective.**
- **What are the three sub-problems any speech recognition system must solve (representation, modelling, search)?**

---

## Notes

### Sound Classification: Applications

The lecture lists real-world applications of sound classification:

- **Content-based multimedia indexing and retrieval**
- **Assisting deaf individuals** in daily activities
- **Smart home / security** systems
- **Industrial predictive maintenance**
- Most importantly: **speech processing**

### Audio File Formats

- **File types**: `.wav`, `.mp3`, FLAC, AAC, AIFF, etc.
- **Uncompressed**: WAV/AIFF — store the raw waveform directly.
- **Lossy compressed**: MP3 — discards some information to reduce file size.
- **Lossless compressed**: FLAC — reduces file size without discarding information.

### Digitizing Audio

- **Sampling rate** — typically **44.1 kHz**, meaning samples are taken **44,100 times per second**.
- Each **sample** records the **amplitude of the analogue wave** at that time instant.
- The result is **digitized into an array** of amplitude values — the raw representation audio ML pipelines start from.

### Audio Preprocessing with Librosa

**Librosa** is a Python package for music/audio processing (by Brian McFee). Typical preprocessing steps:

- Loads audio data into a **numpy array**.
- **Converts the sample rate** (commonly to 22.05 kHz).
- **Normalizes** amplitude data to a bit depth between **-1 and 1**.
- **Flattens audio channels into mono.**

Relevant preprocessing parameters: **number of audio channels, sample rate, bit depth**.

### Extracting Features: Spectrograms and MFCC

To classify urban sounds (air conditioner, car horn, children playing, dog bark, drilling, engine idling, gun shot, jackhammer, siren, street music), features are extracted via:

- **Spectrograms** — visualise the **frequency spectrum** of audio over time (an "image" of amplitude over time vs. frequency).
- **Mel-Frequency Cepstral Coefficients (MFCC)** — similar to a spectrogram but with **more distinguishable detail**, using a **logarithmically-spaced** frequency scale (matching human pitch perception) instead of a linear one.

Because spectrograms/MFCCs are image-like representations, the **image representation of an audio file can be fed into image-based machine learning models**.

### Building a Classifier

The standard pipeline: **label the data**, **split into train/test sets**, and feed feature vectors into a **Deep Neural Network** — see [[Deep Neural Networks (DNN)]] for the architecture. The lecture's example reached **91.92% accuracy** on urban sound classification.

> Reference: much of this material draws from Jurafsky & Martin, chapter 7 (especially sections 7.4-7.5).

### What Is Speech Recognition?

The lecture distinguishes several related but distinct tasks:

- **Speech-to-text transcription** — transform recorded audio into a sequence of words. "Just the words, no meaning" — but must still resolve **acoustic ambiguity** (e.g. "Recognise speech?" vs. "Wreck a nice beach?").
- **Speaker diarization** — *who* spoke *when*?
- **Speech recognition** — *what* did they say?
- **Paralinguistic aspects** — *how* did they say it (timing, intonation, voice quality)?
- **Speech understanding** — *what does it mean*?

### Speech Recognition: A Machine Learning Perspective

The lecture frames why ASR is a hard ML problem:

- As a **classification problem**: a very **high-dimensional output space** (the vocabulary).
- As a **sequence-to-sequence problem**: very long input sequences, with limited re-ordering between acoustic and word sequences.
- Data is **noisy**, with many "nuisance" factors of variation.
- **Very limited training data** (in terms of words) compared to text-based NLP.
- **Manual transcription is expensive** — roughly **10x real time**.
- Speech production/comprehension is **hierarchical and compositional**, making it hard to handle with a single model.

### The Speech Recognition Problem, Formally

Recorded speech is represented as a sequence of **acoustic feature vectors (observations) `X`**, and the output as a **word sequence `W`**. At recognition time, the goal is to find the **most likely `W` given `X`**. Statistical or neural-network models are trained on a corpus of labelled utterances `(X_n, W_n)`.

### Why Speech Is a Natural, Useful Interface

The lecture lists characteristics of speech as a communication channel:

- **Natural** — requires no training such as literacy.
- **Flexible** — leaves hands and eyes free.
- **Efficient** — high data rate and information transmission.
- **Economical** — can be transmitted inexpensively over telephone, and used when only a telephone is available.

**Application areas for speech interfaces**: recognition-only, command and control, data entry over phone, dictation, subscribing/agreeing, interactive conversation, information kiosks, transactional processing, intelligent agents, chatbots.

### What Makes Speech Recognition Hard?

- **Phonological variation** — the acoustic realisation of a phoneme depends strongly on its context.
- **Local and global contexts.**
- **Individual differences** — anatomy, socio-linguistic factors.
- **Environmental factors** — transducers, noise.
- **Diversity of language use** — syntax, semantics, discourse.
- **Real-world issues** — new words, disfluencies (breaks/disruptions in the flow of speech).

### Components of a Speech Recognition System

Every ASR system must solve three sub-problems:

1. **Representation** — how to represent the signal.
2. **Modelling** — how to model the constraints (of language, acoustics, etc.).
3. **Search** — how to search for the most optimal answer (the most likely word sequence).

The lecture notes that **high-performance, speaker-independent speech recognition is now commercially available** (e.g. Scansoft, IBM, AT&T, SpeechWorks/TellMe), within a general **Conversational System Architecture**.

The lecture closes with demo code for processing sound files and for ASR, using "Urban Sounds" and "Dog Sitting" datasets.

---

## Summary

This lecture surveys **audio and speech processing** as a data mining domain. Audio files (WAV/MP3/FLAC/etc.) are digitized via **sampling rate** into arrays of amplitude values; **Librosa** preprocesses these (resampling, normalization, mono-flattening); and **spectrograms**/**MFCC** convert audio into image-like frequency representations suitable for [[Deep Neural Networks (DNN)|DNN]]-based classification (91.92% accuracy on urban sounds). The second half pivots to **speech recognition**: distinguishing diarization, recognition, paralinguistics, and understanding; framing ASR as predicting the most likely word sequence `W` from acoustic observations `X`; and explaining why ASR is hard (high-dimensional output, long sequences, noisy/scarce data, hierarchical structure, phonological variation). Every ASR system must address **representation, modelling, and search** — setting up the sequence-modelling themes ([[Recurrent Neural Networks (RNN)|RNNs]], attention, Transformers) developed later in the course (Lecture 10).

---

## Sources & Verification

| Claim / Topic | Source | Status |
|---|---|---|
| DNN-based audio classification pipeline | [[Deep Neural Networks (DNN)]] | ✓ Verified |
| Sequence models for speech (RNN, later Transformers) | [[Recurrent Neural Networks (RNN)]] | ✓ Verified |
| Evaluation framing (accuracy) | [[Confusion Matrix Metrics]] | ✓ Verified |
