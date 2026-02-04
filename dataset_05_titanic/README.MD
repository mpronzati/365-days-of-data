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

## Feature Engineering
- **Age & Fare:** group-based mean for Age, median for Fare; Embarked missing → `'N'`.  
- **From Cabin I got Deck:** first letter extracted, missing → `'U'`.  
- **From Name I got Title:** extracted titles, rare ones grouped, variants normalized.  
- **Family Features:** `FamilySize` and `IsAlone` flag.  
- **Transformations:** Age binned, Fare log-transformed and quartiled.  
- **Cleanup:** dropped `PassengerId` and `Ticket`; all inside the pipeline.
