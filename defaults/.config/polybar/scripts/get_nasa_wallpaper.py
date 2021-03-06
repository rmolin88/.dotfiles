#!/usr/bin/env python

import time
import logging
from datetime import datetime
from random import random
from subprocess import run
from sys import exit as sys_exit
from urllib.request import urlretrieve
from pathlib import Path
from requests import get


def strTimeProp(start, end, format, prop):
    """Get a time at a proportion of a range of two formatted times.

    start and end should be strings specifying times formated in the
    given format (strftime-style), giving an interval [start, end].
    prop specifies how a proportion of the interval to be taken after
    start.  The returned time will be in the specified format.
    """

    stime = time.mktime(time.strptime(start, format))
    etime = time.mktime(time.strptime(end, format))

    ptime = stime + prop * (etime - stime)

    return time.strftime(format, time.localtime(ptime))


def randomDate(start, end, prop):
    return strTimeProp(start, end, '%Y-%m-%d', prop)


def get_request(url):
    """Use requests.get to make the query to the url"""
    if not url:
        return dict()

    try:
        resp = get(url)
    except Exception:
        logging.error('Failed to make get request')
        return dict()

    try:
        return resp.json()
    except Exception:
        logging.error('Failed to parse json response')
        return dict()


def main():
    """main"""
    logging.basicConfig(
        filename='/tmp/get_nasa_wallpaper.log', level=logging.DEBUG)
    today = datetime.now().strftime("%Y-%m-%d")
    rdate = randomDate("2008-1-1", today, random())
    api = 'https://api.nasa.gov/planetary/apod?hd=true&api_key=DEMO_KEY&date=' + rdate
    wall_url = ['hdurl', 'url']

    logging.info('api: Getting picture from date: "%s"' % rdate)

    logging.info('api: Get Request: "%s"' % api)
    response = get_request(api)

    if not response:
        sys_exit(1)

    # Download image
    for _ in wall_url:
        if _ not in response:
            continue
        logging.info('api: Image quality "%s"', _)
        link = response.get(_)
        logging.info('api: Downloading "%s"...', link)
        break

    # Set it as wallpaper
    wall_cmd = ['feh', '--quiet', '--no-fehbg', '--bg-fill', link]
    logging.info('api: Setting wallpaper "%s"...', wall_cmd)
    try:
        run(wall_cmd)
    except:
        pass

    print("   ")


if __name__ == '__main__':
    main()
