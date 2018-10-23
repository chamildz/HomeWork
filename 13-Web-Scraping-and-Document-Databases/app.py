from flask import Flask, render_template, redirect
from flask_pymongo import PyMongo
import scrape_mars

app = Flask(__name__)

# Use flask_pymongo to set up mongo connection
app.config["MONGO_URI"] = "mongodb://localhost:27017/mars_app"
mongo = PyMongo(app)

# Or set inline
# mongo = PyMongo(app, uri="mongodb://localhost:27017/craigslist_app")


@app.route("/")
def index():
    mars_scrape_data = mongo.db.mars_data.find_one()
    print(mars_scrape_data)
    return render_template("index.html", mars_data=mars_scrape_data)


@app.route("/scrape")
def scraper():
    mars_data = mongo.db.mars_data
    mars_scrape_data = scrape_mars.scrape()
    mars_data.update({}, mars_scrape_data, upsert=True)
    return redirect("/", code=302)

@app.route("/scrape_data")
def scrape_data():
    mars_scrape_data = mongo.db.mars_data.find_one()
    print(mars_scrape_data)
    return mars_scrape_data.news_title


if __name__ == "__main__":
    app.run(debug=True)