# pylint: disable=C0103
""" Utility functions for app"""

import re

from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.impute import SimpleImputer


class PrepProcesor(BaseEstimator, TransformerMixin):
    """Preprocess data for model"""

    def __init__(self):
        """Initialize class"""
        self.ageImputer = SimpleImputer()

    def fit(self, x_value):
        """Fit data to imputer"""
        self.ageImputer.fit(x_value[["Age"]])
        return self

    def transform(self, x_value):
        """Transform data for model"""
        x_value["Age"] = self.ageImputer.transform(x_value[["Age"]])
        x_value["CabinClass"] = (
            x_value["Cabin"]
            .fillna("M")
            .apply(lambda x: str(x).replace(" ", ""))
            .apply(lambda x: re.sub(r"[^a-zA-Z]", "", x))
        )
        x_value["CabinNumber"] = (
            x_value["Cabin"]
            .fillna("M")
            .apply(lambda x: str(x).replace(" ", ""))
            .apply(lambda x: re.sub(r"[^0-9]", "", x))
            .replace("", 0)
        )
        x_value["Embarked"] = x_value["Embarked"].fillna("M")
        x_value = x_value.drop(
            ["PassengerId", "Name", "Ticket", "Cabin"], axis=1
        )
        return x_value


columns = [
    "PassengerId",
    "Pclass",
    "Name",
    "Sex",
    "Age",
    "SibSp",
    "Parch",
    "Ticket",
    "Fare",
    "Cabin",
    "Embarked",
]
