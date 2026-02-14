After the first training run, the model performs very well on class 0, achieving high precision and recall, while being more cautious when predicting class 1. An analysis of the classification report suggests that this behavior is not due to overfitting, but rather to a bias toward the majority class, driven by class imbalance and the use of a default prediction threshold. Highlights:

- High Recall(0) = 0.96 + High Precision(0) = 0.92 → strong majority-class dominance.
- Precision(1) = 0.80 + Recall(1) = 0.66 → cautious predictions for class 1 (many false negatives).
- Support(0) = 2389 ≫ Support(1) = 611 → class imbalance driving decision boundary.
- Weighted F1 = 0.89 > Macro F1 = 0.83 → performance inflated by majority class.
- Accuracy ≈ 0.90 + Recall(1) = 0.66 → high accuracy masking minority-class under-detection.
