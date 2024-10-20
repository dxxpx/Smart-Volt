# -*- coding: utf-8 -*-
"""Untitled3.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1vw--7j_Lz6MIMfK97yqt-oF3za7Gh5q_
"""

import pickle
import pandas as pd
import numpy as np
df = pd.read_csv('Renewable.csv')
df['Time'] = pd.to_datetime(df['Time'])
df = df[df['Energy delta[Wh]'] != 0]
df1 = df[['Time','Energy delta[Wh]']].copy('Deep')
df1 = df1.set_index('Time')

years = [2017, 2018, 2019, 2020, 2021, 2022]
df2 = df1.reset_index('Time')
from sklearn.preprocessing import MinMaxScaler
scaler = MinMaxScaler()
scaler_data = scaler.fit_transform(df1)
#scaler_data = scaler_data[:, 0]  # Assuming filtered_dfx has only one column


print("NaNs after scaling:", np.isnan(scaler_data).any())


index = np.arange(0, len(scaler_data), 1)
scaler_df = pd.DataFrame(scaler_data, index=index, columns=['Energy delta[Wh]'])


train_size = int(len(scaler_df) * 0.8)
train, test = scaler_df.iloc[0:train_size], scaler_df.iloc[train_size:len(scaler_df)]

print("Train size:", len(train), "Test size:", len(test))
def create_dataset(X, y, time_steps=1):
    Xs, ys = [], []
    for i in range(len(X) - time_steps):
        v = X.iloc[i:(i + time_steps)].values
        Xs.append(v)
        ys.append(y.iloc[i + time_steps])
    return np.array(Xs), np.array(ys)

# Define the time steps
n_steps = 24

X_train, y_train = create_dataset(train, train['Energy delta[Wh]'], n_steps)

X_test, y_test = create_dataset(test, test['Energy delta[Wh]'], n_steps)

print("Training data shape:", X_train.shape, y_train.shape)
print("Test data shape:", X_test.shape, y_test.shape)

import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.layers import LSTM, Dense, Dropout
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint
from tensorflow.keras.layers import SimpleRNN, Dense, Dropout
from tensorflow.keras.models import Sequential
lstm_model = keras.Sequential([
    LSTM(units=128, input_shape=(X_train.shape[1], X_train.shape[2]), return_sequences=True),
    Dropout(0.2),
    LSTM(units=64),
    Dropout(0.2),
    Dense(units=1)
])

lstm_model.compile(
    loss='mean_squared_error',
    optimizer=keras.optimizers.Adam(0.001)
)

# Callbacks (Corrected)
early_stopping = EarlyStopping(monitor='val_loss', patience=3, restore_best_weights=True) # patience=10
model_checkpoint = ModelCheckpoint('best_lstm_model.keras', monitor='val_loss', save_best_only=True)
history = lstm_model.fit(
    X_train, y_train,
    epochs=250,
    batch_size=24,
    validation_split=0.1,
    verbose=1,
    shuffle=False,
    callbacks=[early_stopping, model_checkpoint]
)

lstm_pred = lstm_model.predict(X_test)
df_lstm_final = test[lstm_pred.shape[0]*-1:].copy()
df_lstm_final['Prediction'] = lstm_pred[:,0]
df_reset_index = df1.reset_index()
df_lstm_final['Date'] = df_reset_index['Time']
df_lstm_final = df_lstm_final.set_index(["Date"], drop=True)

#df_lstm_final.head()
df_lstm_final.to_csv('lstm_final.csv')
train2 = train.copy()
train2.index = df2.index[:len(train)]
train2['Energy delta[Wh]'] = scaler.inverse_transform(train2['Energy delta[Wh]'].to_numpy().reshape(-1, 1))
train2['Time'] = df2['Time']
train2 = train2.set_index(['Time'])
train2.to_csv('train2.csv')
lstm_model.save('lstm_model11.h5')

with open('scaler11.pkl', 'wb') as scaler_file:
    pickle.dump(scaler, scaler_file)