# Import packages
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn import svm
from sklearn import metrics

# Load dataset
dataframe = pd.read_csv (r'csv_20_precent_train_test.csv')

# Prepare and split dataset
D = dataframe.values

x = D[:,0:37]
y = dataframe["'class'"].values

x_tr, x_ts, y_tr, y_ts = train_test_split(x,y,test_size = 0.3199) 

# Classifier training using SVM
model = svm.SVC(kernel='rbf', gamma=0.01) 
model.fit(x_tr, y_tr)

# Check classifier accuracy on test data
predict_ddos = model.predict(x_ts)
print('Accuracy: ', metrics.accuracy_score(y_ts, predict_ddos)) 