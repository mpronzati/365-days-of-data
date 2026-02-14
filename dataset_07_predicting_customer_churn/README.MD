## Dataset Overview
- id / CustomerId / Surname – Unique identifiers for each customer (not used for modeling).
- CreditScore – Numerical measure of creditworthiness; higher scores indicate lower risk.
- Geography – Customer’s country of residence.
- Gender – Customer’s gender (Male / Female).
- Age – Customer’s age in years.
- Tenure – Number of years the customer has been with the bank.
- Balance – Account balance in the customer’s bank account.
- NumOfProducts – Number of bank products the customer uses.
- HasCrCard – Indicates whether the customer has a credit card (1 = yes, 0 = no).
- IsActiveMember – Indicates whether the customer is an active bank member (1 = yes, 0 = no).
- EstimatedSalary – Customer’s estimated annual salary.
- Exited – Target variable: whether the customer left the bank (1 = yes, 0 = no).

## Model
After the first training run, the model performs very well on class 0, achieving high precision and recall, while being more cautious when predicting class 1. An analysis of the classification report suggests that this behavior is not due to overfitting, but rather to a bias toward the majority class, driven by class imbalance and the use of a default prediction threshold. Highlights of my first training:

- High Recall(0) = 0.96 + High Precision(0) = 0.92 → strong majority-class dominance.
- Precision(1) = 0.80 + Recall(1) = 0.66 → cautious predictions for class 1 (many false negatives).
- Support(0) = 2389 ≫ Support(1) = 611 → class imbalance driving decision boundary.
- Weighted F1 = 0.89 > Macro F1 = 0.83 → performance inflated by majority class.
- Accuracy ≈ 0.90 + Recall(1) = 0.66 → high accuracy masking minority-class under-detection.
