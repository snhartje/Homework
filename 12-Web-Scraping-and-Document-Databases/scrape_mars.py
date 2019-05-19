# Dependencies
from bs4 import BeautifulSoup
import requests
import pymongo
from splinter import Browser
import pandas as pd

def scrape_info():
    
    # URL of page to be scraped
    url = 'https://mars.nasa.gov/news/'
    # Retrieve page with the requests module
    response = requests.get(url)
    # Create BeautifulSoup object; parse with 'lxml'
    soup = BeautifulSoup(response.text, 'lxml')
    # Find the latest news title
    news_title = soup.find("div", class_='content_title').text.strip()
    #find the latest paragraph text 
    news_p = soup.find("div", class_='rollover_description_inner').text.strip()

    executable_path = {'executable_path': 'C:\chromedrv\chromedriver.exe'}
    #executable_path = {'executable_path': 'C:\\Users\stephanieh\Documents\chromedriver.exe'}
    browser = Browser('chrome', **executable_path, headless=False)
    url = 'https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars'
    browser.visit(url)
    html = browser.html
    soup = BeautifulSoup(html, 'html.parser')
    featured_image = soup.find('a', class_='button fancybox')
    #It looks like medium is the largest size available so that's the link I pulled
    featured_image_link = featured_image["data-fancybox-href"]
    featured_image_url = f"https://www.jpl.nasa.gov{featured_image_link}"
    browser.quit()

    executable_path = {'executable_path': 'C:\chromedrv\chromedriver.exe'}
    #executable_path = {'executable_path': 'C:\\Users\stephanieh\Documents\chromedriver.exe'}
    browser = Browser('chrome', **executable_path, headless=False)
    url = 'https://twitter.com/marswxreport?lang=en'
    browser.visit(url)
    html = browser.html
    soup = BeautifulSoup(html, 'html.parser')
    tweet = soup.find('div', class_='tweet js-stream-tweet js-actionable-tweet js-profile-popup-actionable dismissible-content original-tweet js-original-tweet has-cards has-content').find('p', class_='TweetTextSize TweetTextSize--normal js-tweet-text tweet-text')
    mars_weather = tweet.text.partition(' hPapic')[0]
    browser.quit()

    url = 'https://space-facts.com/mars/'
    tables = pd.read_html(url)
    MarsFacts_df = tables[0]
    MarsFacts_df = MarsFacts_df.rename(columns={0:"Description", 1:"Values"})
    MarsFacts_df = MarsFacts_df.set_index("Description")
    MarsFacts = MarsFacts_df.to_html()

    executable_path = {'executable_path': 'C:\chromedrv\chromedriver.exe'}
    #executable_path = {'executable_path': 'C:\\Users\stephanieh\Documents\chromedriver.exe'}
    browser = Browser('chrome', **executable_path, headless=False)
    url = 'https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars'
    browser.visit(url)
    hemisphere_image_urls = []
    hemispheres = ['Cerberus', 'Schiaparelli', 'Syrtis', 'Valles']
    for hemi in hemispheres:
        browser.click_link_by_partial_text(hemi)
        # HTML object
        html = browser.html
        # Parse HTML with Beautiful Soup
        soup = BeautifulSoup(html, 'html.parser')
        # Retrieve title and url
        title = soup.find('h2', class_ = 'title').text.partition(' Enhanced')[0]
        img_url = soup.find('div', class_ ='downloads').ul.li.a['href']
        # Create dictionary
        mydict = {"title": title, "img_url": img_url}
        #add to list
        hemisphere_image_urls.append(mydict)
        browser.visit(url)
    
    browser.quit()

    post = {
    "Mars_News_Title": news_title,
    "Mars_News_Text": news_p,
    "Featured_Image": featured_image_url,
    "Mars_Weather": mars_weather,
    "Mars_Facts": MarsFacts,
    "Mars_Hemis": hemisphere_image_urls
    }

    return post