import numpy as np
import matplotlib.pyplot as plt
import pandas as pd


X = pd.read_csv(r"D:\SEM 3\SAP_Project\Review Three\data_train.csv")
y=pd.read_csv(r"D:\SEM 3\SAP_Project\Review Three\gesture_class.csv")
X = X.values*1000/4
y = y.values


from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.001, random_state = 1)




from sklearn.linear_model import LogisticRegression
classifier=LogisticRegression(random_state=0)
classifier.fit(X_train,y_train)

y_pred=np.array(classifier.predict(X_test)*30)




from sklearn.metrics import confusion_matrix
cn=confusion_matrix(y_test,y_pred)


t=[t for t in range(1,len(X_test)+1)]
plt.plot(t,X_test,color='blue')
plt.plot(t,y_pred,color='red')
plt.xlabel('Samples')
plt.ylabel('Voltage')
plt.title('Classification')
