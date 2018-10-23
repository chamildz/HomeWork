from splinter import Browser
from bs4 import BeautifulSoup
from urllib.parse import urlsplit
import re
import pandas as pd
import numpy as np

executable_path = {'executable_path': 'chromedriver.exe'}
browser = Browser('chrome', **executable_path, headless=False)

def get_soup(url):
    url = url
    browser.visit(url)
    html = browser.html
    soup = BeautifulSoup(html, 'html.parser')
    return soup

def scrape():

    scrape_data = {}

    soup = get_soup('https://mars.nasa.gov/news/')
    news_title = soup.find('div', {'class': 'content_title'}).text
    news_p = soup.find('div',class_='article_teaser_body').text
    scrape_data["news_title"]=news_title
    scrape_data["news_article"]=news_p

    mars_url = 'https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars'
    soup = get_soup(mars_url)
    image_relative_url = soup.find('a',{'id':'full_image'})['data-fancybox-href']

    #Getting the base url
    base_url = "{0.scheme}://{0.netloc}/".format(urlsplit(mars_url))
    featured_image_url = base_url+ image_relative_url[1:]
    scrape_data["feature_image_url"]= featured_image_url

    url = 'https://twitter.com/marswxreport?lang=en'
    soup = get_soup(url)
    mars_weather=soup.find(text=re.compile(r'Sol \S{4}'))
    scrape_data["mars_weather"]=mars_weather

    url = 'https://space-facts.com/mars/'
    tables = pd.read_html(url)
    scrape_data['mars_facts']=tables[0].to_html()

    soup = get_soup('https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars')
    image_anchors = soup.find_all('a', class_='itemLink')

    image_links = ['https://astrogeology.usgs.gov' + anchor['href'] for anchor in image_anchors]

    unique_links = np.unique(np.array(image_links))

    hemisphere_image_urls = []

    for link in unique_links:
        browser.visit(link)
        html = browser.html
        soup = BeautifulSoup(html, 'html.parser')
        
        image_url = soup.find('a',text='Original')['href']
        title = soup.find('h2',class_='title').text
        
        hemisphere_image_urls.append({'title':title,'image_url':image_url})

    scrape_data['hemisphere_image_urls']=hemisphere_image_urls
    return scrape_data
