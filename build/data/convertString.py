from six.moves.html_parser import HTMLParser
import re


def convertString(text):
    h = HTMLParser()
    text = h.unescape(text)
    text = translate(text, '<sub>', '</sub>', "convertString(text)")
    text = translate(text, '<sup>', '</sup>', "convertString(text)")
    # sub_starts = [m.start() for m in re.finditer('<sub>', text)]
    # sub_stops = [m.start() for m in re.finditer('</sub>', text)]

    # sup_starts = [m.start() for m in re.finditer('<sup>', text)]
    # sup_stops = [m.start() for m in re.finditer('</sup>', text)]


def translate(text, start_tag, stop_tag, translate):
    starts = [m.start() for m in re.finditer(start_tag, text)]
    stops = [m.start() for m in re.finditer(stop_tag, text)]
    print(starts, stops)
    # print(tag)
    for idx, itm in enumerate(starts, start=0):
        #print(starts, stops)
        if itm:
            print(text[itm:stops[idx]+6])
    return text
