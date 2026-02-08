## Train dataset
- PassengerId - A unique Id for each passenger. Each Id takes the form gggg_pp where gggg indicates a group the passenger is travelling with and pp is their number within the group. People in a group are often family members, but not always.
- HomePlanet - The planet the passenger departed from, typically their planet of permanent residence.
- CryoSleep - Indicates whether the passenger elected to be put into suspended animation for the duration of the voyage. Passengers in cryosleep are confined to their cabins.
- Cabin - The cabin number where the passenger is staying. Takes the form deck/num/side, where side can be either P for Port or S for Starboard.
- Destination - The planet the passenger will be debarking to.
- Age - The age of the passenger.
- VIP - Whether the passenger has paid for special VIP service during the voyage.
- RoomService, FoodCourt, ShoppingMall, Spa, VRDeck - Amount the passenger has billed at each of the Spaceship Titanic's many luxury amenities.
- Name - The first and last names of the passenger.
- Transported - Whether the passenger was transported to another dimension. This is the target, the column you are trying to predict.

## Exploratory Data Analysis
EDA Conclusions:
- Most of the columns present data cleaning issues.
- All the numeric columns are right-skewed.
- Taking Categorical columns into account: High correlation between passengers coming from the earth and those transported.
- High correlation between passengers without cryosleep and transported.
- Young Adults & Adults show higher levels or being transforped or not.

## Feature Engineering
To improve model performance, I created several additional features based on passenger grouping, spending behavior, and age structure. These features aim to capture social context and behavior patterns that are not explicitly present in the raw dataset.
New Features:
- Add social context (group_size, is_alone)
- Capture behavioral signals (total_spend, has_spend)
- Simplify demographic patterns (age_bin)

The Titanic Preprocessor class has been created to code and impute the categorical variables with the mode (most frequent value) & numerical variables with the median.
The Cabin column is decomposed into more meaningful components using a custom transformer. CabinTransformer: Splits Cabin values of the form Deck/Number/Side into: deck (categorical), num (numeric, coerced to float), side (categorical). Drops the original Cabin column after transformation.
A domain-specific rule is applied before preprocessing: If CryoSleep == True, all amenity spending values are set to 0. This reflects the real-world assumption that passengers in cryo-sleep do not spend time onboard.

## Model
The model chosen was XGBoost, and I've got an accuracy rate of 82.52%.

## Final test
I submitted the results of my model on Kaggle, and the prediction level was 80.10%, with strong results and no concerns about overfitting/underfitting.
