## Data inspection
# Columns
- survival	Survival	0 = No, 1 = Yes
- pclass	Ticket class	1 = 1st, 2 = 2nd, 3 = 3rd
- sex	Sex	
- Age	in years	
- sibsp:	number of siblings/spouses aboard the Titanic	
- parch:	number of parents/children aboard the Titanic	
- ticket:	Ticket number	
- fare:	Passenger fare	
- cabin	Cabin number	
- embarked	Port of Embarkation	C = Cherbourg, Q = Queenstown, S = Southampton


## What is the problem?
The goal is to predict passenger survival based on demographic and travel-related features.
This is a binary classification problem.
The model could help understand which factors most influenced survival.

## EDA
# Conclusions after EDA
- Social economic status level 3 shows a clear high correlation with non-survivors.
- Passengers coming from the Southhampton port shows high correlation with non-survivers, however this is not a strong signal for the model.
- "Women & children first." That explains why the Male gender has a high correlation to non-survivors.
- Young Adults & Adults have a high correlation with Non-survivors in compared to Seniors, teens and childs.
- Travelling alone is another variable to take into consideration that can give us strong signals of high correlation with non-survivers.

## Feature Engineering
The goal was to keep everything inside the pipeline, avoid data leakage, and make the workflow easy to reason about and reproduce. A class named TitanicPreprocessor has been created to make it reusable for the test dataset. Key points:
- **Age & Fare:** group-based mean for Age, median for Fare; Embarked missing → `'N'`.  
- **From Cabin I got Deck:** first letter extracted, missing → `'U'`. Upper decks (A, B, C) might have had easier access to lifeboats.
- **From Name I got Title:** extracted titles, rare ones grouped, variants normalized. Master for example is usually a young boy hence higher survival probability if children were prioritized. 
- **Family Features:** `FamilySize` and `IsAlone` flag. Passengers alone may have had lower chances of being saved, while moderate family sizes could improve survival. 
- **Transformations:** Age binned, Fare log-transformed and quartiled.  
- **Cleanup:** dropped `PassengerId` and `Ticket`; all inside the pipeline.
