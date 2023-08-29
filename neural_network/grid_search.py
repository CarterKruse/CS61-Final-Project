# CS 61 - Final Project
# Database Systems
# Carter Kruse

import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error, r2_score

def grid_search(features, target):
    max_avg_R2 = 0

    for nodes_layer_1 in [32, 64, 128]:
        for nodes_layer_2 in [32, 64, 128]:
            for nodes_layer_3 in [32, 64, 128]:
                for epochs in [300, 400]:
                    R2_values = []
                    iterations = 20

                    for _ in range(iterations):
                        x_train, x_test, y_train, y_test = train_test_split(features, target, test_size = 0.2)

                        scaler = StandardScaler()
                        x_train_scaled = scaler.fit_transform(x_train)
                        x_test_scaled = scaler.transform(x_test)

                        y_train = y_train.values.reshape(-1, 1)
                        y_test = y_test.values.reshape(-1, 1)

                        model = Sequential()

                        model.add(Dense(nodes_layer_1, activation = 'relu', input_shape = (x_train_scaled.shape[1], )))
                        model.add(Dense(nodes_layer_2, activation = 'relu'))
                        model.add(Dense(nodes_layer_3, activation = 'relu'))

                        model.add(Dense(1))

                        model.compile(optimizer = 'adam', loss = 'mean_squared_error')
                        model.fit(x_train_scaled, y_train, epochs = epochs, batch_size = 16, verbose = 0)

                        predictions = model.predict(x_test_scaled)
                        r2 = r2_score(y_test, predictions)
                        R2_values.append(r2)
                    
                    avg_R2 = sum(R2_values) / iterations

                    if avg_R2 > max_avg_R2:
                        max_avg_R2 = avg_R2
                        print()
                        print('Nodes Layer 1: ' + str(nodes_layer_1))
                        print('Nodes Layer 2: ' + str(nodes_layer_2))
                        print('Nodes Layer 3: ' + str(nodes_layer_3))
                        print('Epochs: ' + str(epochs))
                        print("R2: " + str(avg_R2))
                    else:
                        print()
