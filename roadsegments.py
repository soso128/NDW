from numpy import *
import datetime as dt
from itertools import groupby

class Segment_Measurement(object):
    def __init__(self, datetime_string, travel_time, speed_abs, speed_ratio, nmeas):
        self.datetime = convert_datetime(datetime_string)
        self.travel_time = float(travel_time)
        self.speed_abs = float(speed_abs)
        self.speed_ratio  = float(speed_ratio)
        self.nmeas = int(nmeas)
        # Segment length in meters
        self.length = self.speed_abs * self.travel_time/(1000 * 3600) * 1000

    def __lt__(self, other):
        return self.datetime < other.datetime

    def __gt__(self, other):
        return self.datetime > other.datetime

class Segment(object):
    def __init__(self, ID, measurements = ()):
        self.ID = ID
        if measurements:
            measurements = sorted(list(measurements))
        self.measurements = list(measurements)

    def __lt__(self, other):
        return self.ID < other.ID

    def __gt__(self, other):
        return self.ID > other.ID

def convert_datetime(datetime_string):
    [date, time] = datetime_string.split('T')
    date = list(map(int, date.split('-')))
    time = list(map(int, time.split(':')))
    datetime = dt.datetime(date[0], date[1], date[2], time[0], time[1], time[2])

def load_datafile_shortsegments(datafile, allowed = []):
    data = genfromtxt(datafile, delimiter = ';', dtype = 'str')
    segments = []
    for k, g in groupby(data, lambda x: x[1]):
        if not allowed or k in allowed:
            measurements = [Segment_Measurement(*(gg[[0, 2, 3, 4, 5]])) for gg in list(g)]
            segments.append(Segment(k, measurements))
    if allowed:
        segments = [[ s for s in segments if s.ID == a ][0] for a in allowed]
    return segments
