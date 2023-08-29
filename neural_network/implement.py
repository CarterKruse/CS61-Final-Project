# CS 61 - Final Project
# Database Systems
# Carter Kruse

import numpy as np

import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error, r2_score

import matplotlib.pyplot as plt

def implement(features, target):
    iterations = 30
    dropout_rate = 0.2
    R2_values = [[], [], []]

    nodes_layers = [[32, 128, 64], [64, 128, 64], [32, 128, 32]]
    colors = ['b', 'r', 'g']

    for i in range(3):
        for _ in range(iterations):
            x_train, x_test, y_train, y_test = train_test_split(features, target, test_size = 0.2)

            scaler = StandardScaler()
            x_train_scaled = scaler.fit_transform(x_train)
            x_test_scaled = scaler.transform(x_test)

            y_train = y_train.values.reshape(-1, 1)
            y_test = y_test.values.reshape(-1, 1)
            
            model = Sequential()

            model.add(Dense(nodes_layers[i][0], activation = 'relu', input_shape=(x_train_scaled.shape[1], )))
            model.add(Dropout(dropout_rate))
            model.add(Dense(nodes_layers[i][1], activation = 'relu'))
            model.add(Dropout(dropout_rate))
            model.add(Dense(nodes_layers[i][2], activation = 'relu'))
            model.add(Dropout(dropout_rate))
            model.add(Dense(1))

            model.compile(optimizer = 'adam', loss = 'mean_squared_error')
            model.fit(x_train_scaled, y_train, epochs = 400, batch_size = 16, verbose = 0)

            predictions = model.predict(x_test_scaled)
            r2 = r2_score(y_test, predictions)
            R2_values[i].append(r2)
    
        plt.plot(R2_values[i], marker = 'o', color = colors[i], label = 'R2')
        plt.axhline(np.nanmean(R2_values[i]), color = colors[i])
    
    plt.xlabel('Iteration')
    plt.ylabel('R2')

    plt.show()
