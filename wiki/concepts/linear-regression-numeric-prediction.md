---
title: Linear Regression and Numeric Prediction
type: concept
sources: [raw/lecture-notes/COMP723/Lecture1.pptx, raw/lecture-notes/COMP723/Lecture2.pptx, https://mlu-explain.github.io/linear-regression/, https://www.geeksforgeeks.org/machine-learning/ml-linear-regression/]
related: [Classification (Supervised Learning), Loss Functions, Stochastic Gradient Descent (SGD), Overfitting and Underfitting]
created: 12-06-2026
last-updated: 12-06-2026
---

# Linear Regression and Numeric Prediction

> [!check] Verified
> Confirmed via [MLU-Explain: Linear Regression](https://mlu-explain.github.io/linear-regression/) and [GeeksforGeeks: Linear Regression in Machine Learning](https://www.geeksforgeeks.org/machine-learning/ml-linear-regression/)

## The Core Idea

**Numeric prediction** is the sibling of [[Classification (Supervised Learning)|classification]]: it's also supervised (the training data includes the "correct answer" for each record), but the **target value is a continuous number** rather than a category. **Linear regression** is the simplest and most common technique for numeric prediction — it models the target `Y` as a linear (weighted-sum) function of the input attributes `X`:

```
Y = a₁X₁ + a₂X₂ + ... + aₙXₙ + b
```

Training means finding the coefficients (`a₁...aₙ`, `b`) that make this line/plane fit the training data as closely as possible — typically by minimising the **sum of squared errors** between predicted and actual `Y` values.

## Worked Example: Predicting Fuel Efficiency (mpg)

The lecture's example uses a dataset of 398 cars described by `cylinders, engine size, power output, weight, acceleration`, with the target `mpg` (miles per gallon). The fitted linear regression model was:

```
mpg = -0.3499·cylinders - 0.0013·engine_size - 0.0394·power_output
      - 0.0054·weight - 0.0154·acceleration + 46.024
```

Every coefficient is **negative** here, which makes intuitive sense: heavier cars, bigger engines, more cylinders, more power, and faster acceleration all tend to *reduce* fuel efficiency. The `+46.024` intercept is the model's baseline prediction when all attributes are zero (not realistic for real cars, but mathematically necessary to fit the line).

## Intuition: The Best Straight Line Through the Data

Imagine scattering all your data points on a graph (one axis per attribute, plus the target). Linear regression searches for the single straight line (or, with multiple attributes, a flat plane/hyperplane) that passes as close as possible to *all* the points at once — "best" meaning it minimises the total squared vertical distance between each point and the line. Points exactly on the line have zero error; points far from it are penalised more heavily because the error is *squared* (a point twice as far off contributes four times the penalty).

## In Practice: scikit-learn

```python
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

model = LinearRegression()
model.fit(X_train, y_train)

print("Coefficients:", model.coef_)   # the a_1 ... a_n above
print("Intercept:", model.intercept_)  # the b above

predictions = model.predict(X_test)
print("RMSE:", mean_squared_error(y_test, predictions, squared=False))
print("R^2:", r2_score(y_test, predictions))
```

Note the **evaluation metrics are different from classification**: there's no "accuracy" for a continuous target. Common choices are **RMSE** (root mean squared error — same units as the target, easy to interpret) and **R²** (proportion of variance in the target explained by the model, 0 to 1).

## Common Pitfalls & Practical Tips

- **Scale matters for interpretation, not just fitting.** A coefficient of `-0.3499` for `cylinders` (which ranges roughly 4–8) and `-0.0054` for `weight` (which ranges in the thousands) aren't directly comparable — the *units* of each attribute affect the coefficient's magnitude. Don't read coefficient size alone as "importance" without considering scale (see [[Data Preprocessing and Data Quality|normalization]]).
- **Linear regression assumes a linear relationship.** If the true relationship between attributes and target is curved, a straight-line/plane fit will systematically under- or over-predict in different regions — this is a form of [[Overfitting and Underfitting|underfitting]] (the model is too simple to capture the pattern).
- **Outliers have outsized influence.** Because errors are *squared*, a single extreme data point can pull the fitted line noticeably toward itself.
- **Don't confuse with logistic regression.** Despite the name, *logistic* regression is a *classification* technique (predicts a category via a probability), not numeric prediction.

## Related Concepts

- [[Classification (Supervised Learning)]] — the categorical-target sibling of numeric prediction; same train/test workflow, different target type and evaluation metrics.
- [[Loss Functions]] — sum of squared errors is the loss function linear regression minimises; compare with the loss functions used for classification.
- [[Stochastic Gradient Descent (SGD)]] — for large datasets, the optimal coefficients are found iteratively via gradient descent rather than solved exactly.
- [[Overfitting and Underfitting]] — a linear model that's too simple for the true relationship underfits; adding many irrelevant attributes can overfit.

**Source:** [MLU-Explain: Linear Regression](https://mlu-explain.github.io/linear-regression/); [GeeksforGeeks: Linear Regression in Machine Learning](https://www.geeksforgeeks.org/machine-learning/ml-linear-regression/)
