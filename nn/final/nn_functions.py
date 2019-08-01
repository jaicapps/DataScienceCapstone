#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jul 31 21:25:31 2019

@author: mikaelapisanileal
"""

    
import pandas as pd
from sklearn.model_selection import train_test_split
import tensorflow as tf
import matplotlib.pyplot as plt
import numpy as np
from sklearn.metrics import mean_squared_error, r2_score
from math import sqrt
import keras.backend as K


def generate_report(y_actual, y_pred):
    mse = round(mean_squared_error(y_actual, y_pred),3)
    rmse = round(sqrt(mean_squared_error(y_actual, y_pred)),3)
    r2 = round(r2_score(y_actual, y_pred),3)
    error = np.mean(pd.DataFrame(y_actual) - pd.DataFrame(y_pred))[0]
    print('mse',mse)
    print('RMSE', rmse)
    print('R2', r2)
    print('error', error)
    return mse,rmse,r2,error

def generate_loss_plot(history, filename=None):
    plt.plot(history.history['loss'])
    plt.plot(history.history['val_loss'])
    plt.title('loss curve')
    plt.ylabel('loss')
    plt.xlabel('epoch')
    plt.legend(['train', 'test'], loc='upper left')
    if (filename!=None):
        plt.savefig(filename)
    plt.show()

def generate_hist_plot(y_actual, y_pred, filename=None):
    y = pd.DataFrame(y_actual)
    y['new']=y.index
    pred = pd.DataFrame(y_pred)
    pred.index=y['new'].values
    y = y.drop('new',axis=1)
    pred = pred.rename(columns={0:'predicted'})
    x =pd.DataFrame(y[0]-pred['predicted'])
    x = x.rename(columns={0:'difference'})
    p = x['difference'].values
    type(p)
    plt.hist(p, bins='auto', range=(-75000, 75000))
    if (filename!=None):
        plt.savefig(filename)
    plt.show()


def get_data(filename, target): 
    df = pd.read_csv(filename)
    X = df.copy()
    X.drop(target, axis=1, inplace=True)
    predictors = X.columns
    X = X.values
    Y = df[target].values
    x_train, x_test, y_train, y_test = train_test_split(X, Y, test_size=0.2, random_state=0)
    return x_train, x_test, y_train, y_test, predictors

def root_mean_squared_error(y_true, y_pred):
        return K.sqrt(K.mean(K.square(y_pred - y_true))) 

#3)Adam combines the good properties of Adadelta and RMSprop and hence tend to do better for most of the problems.
def fit_model(model, x_train, x_test, y_train, y_test, optimizer, epochs, model_id=None):
    model.compile(loss=root_mean_squared_error, optimizer=optimizer, metrics=['mse'])
    history = model.fit(x_train, y_train, epochs=epochs, verbose=0, validation_data=(x_test, y_test))
    filename = None
    if (model_id!=None):
        filename = 'loss_plot_' + str(model_id) + '.png'
    generate_loss_plot(history, filename=filename)
    return model

def plot_compare(y_test, y_test_pred, filename=None):
    fig, ax = plt.subplots()
    ax.plot(y_test, color = 'blue')
    ax.plot(y_test_pred, color = 'red')
    ax.legend(['Real', 'Predicted'])
    if (filename!=None):
        fig.savefig(filename)
    plt.show()

def predict(model, x_train, y_train, x_test, y_test, filename=None):
    y_train_pred = model.predict(x_train)
    y_test_pred = model.predict(x_test)
    print('ERROR Training')
    generate_report(y_train, y_train_pred)
    print('ERROR Test')
    mse,rmse,r2,error = generate_report(y_test, y_test_pred)
    print('Histogram Training')
    f = None
    if (filename!=None):
        f = 'train_' + filename
    generate_hist_plot(y_train, y_train_pred, f)
    print('Histogram Test')
    f = None
    if (filename!=None):
        f = 'test_' + filename
    generate_hist_plot(y_test, y_test_pred, f)
    return y_train_pred, y_test_pred, mse,rmse,r2,error
    
def run_model(input_nodes, hidden_nodes, x_train, x_test, y_train, y_test, optimizer, epochs, model_id=None):
    model = tf.keras.models.Sequential()
    model.add(tf.keras.layers.Dense(input_nodes, tf.keras.activations.linear))
    model.add(tf.keras.layers.Dense(hidden_nodes, tf.keras.activations.relu))
    model.add(tf.keras.layers.Dense(1, tf.keras.activations.linear))
    model = fit_model(model, x_train, x_test, y_train, y_test, optimizer, epochs, model_id)
    filename = None
    if (model_id!=None):
        filename = 'hist_' + str(model_id) + '.png'
    y_train_pred, y_test_pred, mse,rmse,r2,error = predict(model, x_train, y_train, x_test, y_test, filename=filename)
    filename = None
    if (model_id!=None):
        filename = 'compare_train' + str(model_id) + '.png'
    print('Compare Training')
    plot_compare(y_train, y_train_pred, filename=filename)
    print('Compare Test')
    filename = None
    if (model_id!=None):
        filename = 'compare_train' + str(model_id) + '.png'
    plot_compare(y_test, y_test_pred, filename=filename)
    return y_train_pred, y_test_pred, mse,rmse,r2,error

