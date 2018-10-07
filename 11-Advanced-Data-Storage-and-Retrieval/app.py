import numpy as np

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func,distinct

from flask import Flask, jsonify
import datetime as dt

#################################################
# Database Setup
#################################################
engine = create_engine("sqlite:///Resources/hawaii.sqlite")

# reflect an existing database into a new model
Base = automap_base()
# reflect the tables
Base.prepare(engine, reflect=True)

# Save reference to the table
Measurement = Base.classes.measurement
Station = Base.classes.station

# Create our session (link) from Python to the DB
session = Session(engine)

#################################################
# Flask Setup
#################################################
app = Flask(__name__)

#################################################
# Global Variabels
#################################################
last_year_date =""
#################################################
# Flask Routes
#################################################
@app.route("/")
def welcome():
    """List all available api routes."""
    return (
        f"Available Routes:<br/>"
        f"/api/v1.0/precipitation<br/>"
        f"/api/v1.0/stations<br/>"
        f"/api/v1.0/tobs<br/>"
    )


@app.route("/api/v1.0/precipitation")
def precipation():
    """Return a list of all passenger names"""
    # Query all passengers
    results = session.query(Measurement.date,Measurement.prcp).all()

    results_dictionary = {date: prcp for (date, prcp) in results}
    
    return jsonify(results_dictionary)


@app.route("/api/v1.0/stations")
def stations():
    """Return a list of all  stations"""
    # Query all passengers
    stations = session.query(Station.id,Station.name,Station.station,Station.latitude).all()
    
    for station in stations:
        print(station.id)
    

    return jsonify(stations)

@app.route("/api/v1.0/tobs")
def tobs():
    """Return a list of all  stations"""
    latest_record = session.query(Measurement.id,Measurement.station,Measurement.date,Measurement.prcp,Measurement.tobs).order_by(Measurement.date.desc()).first()
    last_year_date = latest_record.date
    print(last_year_date)
    last_year_date = dt.datetime.strptime(last_year_date, "%Y-%m-%d").date()
    last_year_date = last_year_date - dt.timedelta(days=(365))
    # Query all passengers
    tobs_results = session.query(Measurement.station, Measurement.date, Measurement.tobs).filter(Measurement.date>last_year_date).all()

    return jsonify(tobs_results)

@app.route("/api/v1.0/average/<start>", defaults={'end': None})
@app.route("/api/v1.0/average/<start>/<end>")
def temperature_analysis(start,end):
    results = ""
    session = Session(engine)
    if(end!=None):
        results =session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).filter(Measurement.date >= start).filter(Measurement.date <= end).all()
    else:
        results =session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs)).filter(Measurement.date >= start).all()

    return jsonify(results)

if __name__ == '__main__':
    app.run(debug=True)