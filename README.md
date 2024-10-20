# smartvolt

The intel libraries used are:-
 1) tensorflow-intel, imported normally as tensorflow
 2) scikit-learn-intelex, patched globally
 3) modin imported as modin.pandas
 4) Intel Math Kernel accelerated Numpy, imported normally as Numpy. Use pip install mkl-service
    
The models with trained data is saved as pickle file while also uploaded as .py and .ipynb file along with their corresponding datasets
Algorithms used - 
1) XGBoostClassifier with gridsearchcv to find best hyperparameters
2) Random Forest Classifier with gridsearchcv to find best hyperparameters
3) Tensorflow Keras LSTM with earlystop patience 3 and 76740 predictions when tested

Example input
for predictive maintenance model - {     "Air temperature":[298.3],     "Process temperature":[308.5],     "Rotational speed":[1629],     "Torque":[37.1],     "Vibration Levels ":[33.43548387],     "Operational Hours":[68] }



The LSTM model will generate a csv file as output when run
