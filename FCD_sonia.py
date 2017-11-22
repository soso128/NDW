# -*- coding: utf-8 -*-
"""
Created on Thu Mar 30 11:51:07 2017

@author: dieleman
"""

#import csv
import numpy as np
from matplotlib import pyplot as plt
from matplotlib import rc 
import pandas
from datetime import datetime as dt
from dateutil import tz
import pickle


plt.rc('text', usetex=False)
rc('font',**{'family':'serif',
             'serif':['Bookman'],
             'size': 16})

basemap1 = np.loadtxt("A1_13404.csv", dtype = int)
basemap2 = np.loadtxt("A1_13440.csv", dtype = int)
map_table = dict(zip(basemap2, basemap1))

filenames_2=[]
for i in range(12,32):
    filenames_2.append('../Filter Basemap13440/2017-10-'+str(i)+'-13440.csv')

def file_to_dataframe(datafile, fileset = 1):
    print("Loading file ", datafile)
    X=pandas.read_table(datafile,
                    header=None,delimiter=';',decimal=',')       
    X.columns = ['time of day', 'segment ID','length (ms)','speed (km/h)','LoS (%)','# Meas']
    X['time of day'] = np.array(list(map(convert_datetime, X['time of day'])))
    if fileset == 2:
        X['segment ID'] = np.array(list(map(lambda x: map_table[x], X['segment ID'])))
    X['time'] = np.array(list(map(lambda x: timeday_seconds(x), X['time of day'])))
    X['date'] = np.array(list(map(lambda x: x.date(), X['time of day'])))
    X['weekday'] = np.array(list(map(lambda x: x.weekday(), X['time of day'])))
    X['working day'] = np.array(list(map(lambda x: x.weekday() < 5, X['time of day'])))
    X['freeflow'] = np.array(list(map(lambda x: freeflow(X, x), X['segment ID'])))
    return X

def convert_datetime(datetime):
    from_zone = tz.gettz('UTC')
    to_zone = tz.gettz('Europe/Amsterdam')
    utc = dt.strptime(datetime, '%Y-%m-%dT%H:%M:%S')
    utc = utc.replace(tzinfo=from_zone)
    utc = utc.astimezone(to_zone)
    return utc

def load_dataframe():
    filenames_1=[]
    for i in range(1,10):
        filenames_1.append('2017-10-0'+str(i)+'-13404.csv')

    for i in range(10,12):
        filenames_1.append('2017-10-'+str(i)+'-13404.csv')
    dataframes = pandas.concat([file_to_dataframe(file_name) for file_name in filenames_1])
    dataframes = pandas.concat([dataframes] + [file_to_dataframe(file_name, fileset = 2) 
                                            for file_name in filenames_2])
    pickle.dump(dataframes, open('dataframe_sonia.pkl', 'wb'))
    return dataframes

def load_dataframe_to_array():
    filenames_1=[]
    for i in range(1,2):
        filenames_1.append('2017-10-0'+str(i)+'-13404.csv')

    for i in range(10,12):
        filenames_1.append('2017-10-'+str(i)+'-13404.csv')
    dataframes = pandas.concat([file_to_dataframe(file_name) for file_name in filenames_1])
    dataframes = pandas.concat([dataframes] + [file_to_dataframe(file_name, fileset = 2) 
                                               for file_name in filenames_2[:1]])
    dataframes = np.array(dataframes)
    return dataframes


def timeday_seconds(datetime):
    time = datetime.time()
    time_seconds = time.hour * 3600 + time.minute * 60 + time.second
    return time_seconds

def timebin(dataframe, binsize):
    dataframe['bin'] = np.array(list(map(int, (dataframe['time'] - dataframe['time'].min())/binsize)))
    return dataframe

def std_timerange(dataframe, binsize):
    dataframe = timebin(dataframe, binsize)
    grouped_time = dataframe.groupby(['bin'])
    part_of_hour = int(3600/binsize)
    timestd = np.array([(t/part_of_hour + dataframe['time'].min()/3600, g['length (ms)'].std()) for t, g in grouped_time])
    return timestd

def std_2sigma(dataframe, binsize):
    dataframe = timebin(dataframe, binsize)
    grouped_time = dataframe.groupby(['bin'])
    part_of_hour = int(3600/binsize)
    timestd = np.array([(t/part_of_hour + dataframe['time'].min()/3600, g['length (ms)'].mean() + 2 * g['length (ms)'].std()) for t, g in grouped_time])
    return timestd

def bufindex(dataframe, binsize):
    dataframe = timebin(dataframe, binsize)
    grouped_time = dataframe.groupby(['bin'])
    part_of_hour = int(3600/binsize)
    timestd = np.array([(t/part_of_hour + dataframe['time'].min()/3600, (g['length (ms)'].quantile(q=0.95) - g['length (ms)'].mean())/dataframe['freeflow']) for t, g in grouped_time])
    return timestd

def freeflow(dataframe, segment):
    time_range = dataframe[(dataframe['time'] < 21000) & (dataframe['weekday'] > 4) & (dataframe['segment ID'] == segment)]
    return dataframe['length (ms)'].mean()

def time_planning_index(dataframe, binsize):
    dataframe = timebin(dataframe, binsize)
    grouped_time = dataframe.groupby(['bin'])
    part_of_hour = int(3600/binsize)
    timestd = np.array([(t/part_of_hour + dataframe['time'].min()/3600, g['length (ms)'].quantile(q=0.95)/dataframe['freeflow']) for t, g in grouped_time])
    return timestd


test = load_dataframe_to_array()

#dataframes = pandas.read_pickle(open('dataframe.pkl', 'rb'))

# dataframes2 = pickle.load(open('dataframe_sonia2.pkl', 'rb'))
# # dataframes = load_dataframe()

# Xfirst = dataframes2[dataframes2['segment ID'] == 957872]
# Xfirst['time'] = np.array(list(map(lambda x: timeday_seconds(x), Xfirst['time of day'])))
# Xfirst['date'] = np.array(list(map(lambda x: x.date(), Xfirst['time of day'])))
# Xfirst['weekday'] = np.array(list(map(lambda x: x.weekday(), Xfirst['time of day'])))
# Xfirst['working day'] = np.array(list(map(lambda x: x.weekday() < 5, Xfirst['time of day'])))
# monday = Xfirst[np.array(list(map(lambda x: x.weekday(), Xfirst['time of day']))) == 0]

# mondays=monday.


