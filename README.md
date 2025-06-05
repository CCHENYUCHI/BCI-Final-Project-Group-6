# Data Description

## _Experimental Design_

## _Data Collection_

## _Qulity Evaulation_

# BCI Framework

This project is our first time to analyze data in the field of EEG-based Auditory Attention Decoding (AAD). It also represents our initial exploration of the NJU Dataset. As a starting point, we implemented previously established methods to build a foundation for our analysis.

We selected two approaches serve as the core components for feature extraction and classification in our BCI project.

1. Filter Bank CSP
   
    The Common Spatial Pattern (CSP) technique has been widely used in AAD tasks [2–6] due to its ability to separate attention-related neural patterns. Filter Bank CSP further enhances this by applying CSP across multiple frequency bands. In the work of Geirnaert et al. [1], FB-CSP was combined with a Linear Discriminant Analysis (LDA) classifier to decode auditory attention direction. Their method achieved 90.5% accuracy in classifying between ±90° directions using both the KUL dataset and their in-house dataset.

2. Learnable Spatial Mapping CNN
   
   > ![alt text](lsm.png)
    
    The method proposed by Zhang et al. [7] is the first to introduce and analyze the NJU dataset, which is the same dataset we use in this project. As the dataset creators, their work provides an important baseline for future research on auditory attention decoding under more complex spatial conditions. For this reason, we selected their approach as our baseline method.

    Their model incorporates a Learnable Spatial Mapping (LSM) mechanism that transforms EEG channels into a 2D structure to better capture spatial relationships between electrodes. This spatial transformation allows convolutional layers to more effectively extract inter-channel patterns relevant to the listener’s directional attention.

While both studies made valuable contributions, they did not investigate subject dependency. To address this, our analysis employs a subject-independent evaluation strategy, using leave-one-group-out cross-validation to assess the model's robustness across different individuals.

## Workflow

![alt text](workflow.png)

Since the NJU dataset we use in this study has already undergone preprocessing—and our prior inspection confirmed that it contains minimal artifacts and is of high quality—we do not perform any additional preprocessing. Instead, we proceed directly with the analysis.

Unlike the original FB-CSP study [1], which used only LDA as a classifier, we extend the comparison by including SVM and Decision Tree classifiers. As a result, we evaluate four models in total:
   - FB-CSP + LDA
   - FB-CSP + SVM
   - FB-CSP + Decision Tree
   - LSM CNN (from [7])

For validation, we adopt a leave-one-group-out strategy. We first estimate the number of trials per subject and divide the entire dataset into five groups, maintaining an approximately equal distribution. Each subject appears in only one group, ensuring that the training and validation sets are composed of trials from non-overlapping subject groups. This setup allows us to assess model performance in a subject-independent manner.

## _Feature Extraction - Filter Bank Common Spatial Pattern_

> ![alt text](filter_bank_csp_.png)

FB-CSP is an extension of the Common Spatial Pattern (CSP) technique, which is widely used in EEG signal classification. Instead of applying CSP on a single frequency band, FB-CSP decomposes EEG signals into multiple frequency bands using a filter bank, then applies CSP separately on each band. The resulting spatially filtered signals are then transformed into log-variance features and concatenated into a single feature vector for classification.

## ___Experimental Design___

Our experiments are structured around three key classification tasks, each targeting a different aspect of auditory attention decoding performance. These tasks aim to evaluate model robustness and identify the most suitable configuration for potential use in a real-world BCI system.

1. Auditory Attention Direction Classification
   
   We assess the model's ability to classify the direction of auditory attention using only left vs. right trials with symmetric angular offsets. We evaluate five combinations of speaker angles:

   - All symmetric angles
   - ±90°
   - ±60°
   - ±45°
   - ±30°

2. Frequency Band Comparison for CSP-based Feature Extraction

    To identify the most effective frequency range, we compare classification performance across:

   - Single-band CSP (delta, theta, alpha, beta)

   - Two FB-CSP configurations:

     1. 2–40 Hz (14 bands, 4 Hz width, 2 Hz overlap)

      2. 12–22 Hz (4 bands, 4 Hz width, 2 Hz overlap)

3. Effect of Decision Window Length
    
    We examine how different decision window lengths affect classification accuracy, aiming to find a balance between fast detection and model performance—critical for real-time BCI applications.

The goal across all experiments is to identify the optimal configuration—in terms of frequency band, temporal resolution, and classification setting—for building a robust and responsive BCI system based on EEG auditory attention decoding.

## ___Validation_ - Leave One Group Out__

Due to the randomized angle assignment in the NJU dataset, each subject has a different number of trials for each direction. As a result, it's not feasible to ensure a fixed ratio of angles across all subjects during grouping. To address this, we divided subjects into five groups and applied a Leave-One-Group-Out (LOGO) validation strategy. We aimed to keep the groups consistent across experiments while also minimizing imbalances in the number of trials per angle.

The following table shows the percentage distribution of trial segments per angular condition within each group:

| Group (Subjects) | Group 1 (S02~S07) | Group 2 (S08~S15) | Group 3 (S16~S19) | Group 4 (S21~S23) | Group 5 (S25~S27) |
|:-:|:-:|:-:|:-:|:-:|:-:|
|All (6755)|21.3%|17.3%|21.0%|21.9%|18.4%|
|±90° (1172)|13.9%|12.9%|14.1%|31.4%|27.7%|
|±60° (1235)|13.9%|12.0%|15.6%|28.0%|30.4%|
|±45° (1205)|15.4%|13.4%|14.5%|31.3%|25.4%|
|±30° (1141)|17.2%|13.4%|14.5%|33.9%|20.9%|

For the final accuracy calculation, we compute the classification accuracy at the segment level. However, to report variability, we compute the standard deviation across the five validation groups based on their individual accuracy scores.

## _Result_

1. **Different Direction**

    The attention angel in NJU dataset have 15 direction we choice the all 對應的角度來預測 (ex. -90/90, -30/30, ...). And is a binary classification the label with left and right.

    **Note**: FB CSP with Filter bank in 12~22 hz, and each band 4 hz with overlap 2 hz.

    | Direction (Segments numbers) | FB CSP + SVM | FB CSP + LDA | FB CSP + Decision Tree | Learnable Sptail Mapping CNN|
    |:-:|:-:|:-:|:-:|:-:|
    | All (6755)|49.5±1.4|48.8±2.6|48.6±1.7|54.4±1.7|
    | ±90° (1172)|**62.4±6.6**|**57.1±3.3**|**58.0±4.5**|**58.6±4.6**|
    | ±60° (1235)|47.9±5.3|48.9±6.6|47.4±5.6|53.3±2.1|
    | ±45° (1205)|40.7±5.6|44.2±7.1|48.6±11.0|52.8±3.1|
    | ±30° (1141)|38.6±10.0|35.8±11.0|44.7±6.5|52.6±3.1|
    
2. **±90 Classification with Different Band CSP**

    | Filter Bands (1172) | FB CSP + SVM | FB CSP + LDA | FB CSP + Decision Tree |
    |:-:|:-:|:-:|:-:|
    |Filter Bank (1~40, 14 Bank)|58.0±8.4|56.2±8.5|56.2±11.1|
    |1−4 Hz (δ)|55.5±3.3|52.6±3.3|52.2±6.4|
    |4−8 Hz (θ)|56.1±3.0|55.0±2.3|54.4±4.6|
    |8−12 Hz (α)|54.0±9.6|**57.9±7.4**|56.7±5.8|
    |12~20 Hz|**66.2±7.5**|56.7±5.9|53.2±7.5|
    |Filter Bank (12~22, 4 Bank)|62.4±6.6|57.1±3.3|**58.0±4.5**|
    |12−30 Hz (β)|56.7±1.6|57.7±9.1|57.3±8.3|

3. **Decision Windows**

   **Note**: FB CSP with Filter bank in 12~22 hz, and each band 4 hz with overlap 2 hz.

    | Window Size (Segments numbers) | FB CSP + SVM | FB CSP + LDA | FB CSP + Decision Tree | Learnable Sptail Mapping CNN|
    |:-:|:-:|:-:|:-:|:-:|
    |10 (476)|**63.4±8.0**|58.4±6.9|51.7±6.9|58.6±4.6|
    |4 (1172)|**62.4±6.6**|57.1±3.3|58.0±4.5|58.6±4.6|
    |2 (2380)|**59.3±6.7**|56.6±3.5|55.8±6.7|59.2±5.5|
    |1 (4760)|**57.7±6.8**|56.6±3.2|56.8±5.5|55.6±5.2|


## _Usage and Demo Video_


## Reference

1. Geirnaert, S., Francart, T., & Bertrand, A. (2020). Fast EEG-based decoding of the directional focus of auditory attention using common spatial patterns. IEEE Transactions on Biomedical Engineering, 68(5), 1557-1568.
2. Yang, K., Xie, Z., Di Zhou, L. W., & Zhang, G. (2023). Auditory attention detection in real-life scenarios using common spatial patterns from eeg. In INTERSPEECH.
3. Cai, S., Su, E., Song, Y., Xie, L., & Li, H. (2020, October). Low Latency Auditory Attention Detection with Common Spatial Pattern Analysis of EEG Signals. In INTERSPEECH (pp. 2772-2776).
4. Rotaru, I., Geirnaert, S., Heintz, N., Van de Ryck, I., Bertrand, A., & Francart, T. (2024). What are we really decoding? Unveiling biases in EEG-based decoding of the spatial focus of auditory attention. Journal of Neural Engineering, 21(1), 016017.
5. Rotaru, I., Geirnaert, S., Heintz, N., Van de Ryck, I., Bertrand, A., & Francart, T. (2023). EEG-based decoding of the spatial focus of auditory attention in a multi-talker audiovisual experiment using Common Spatial Patterns. bioRxiv, 2023-07.
6. Zhang, Y., Ruan, H., Yuan, Z., Du, H., Gao, X., & Lu, J. (2023, June). A learnable spatial mapping for decoding the directional focus of auditory attention using EEG. In ICASSP 2023-2023 IEEE International Conference on Acoustics, Speech and Signal Processing (ICASSP) (pp. 1-5). IEEE.