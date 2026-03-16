#!/usr/bin/env python

import sys
import os
from pathlib import Path
import pikepdf


def get_authors(doc):
    authors = []
    for author_tag in doc.xpath(".//contrib[@contrib-type='author']"):
        given_name = ''
        surname = ''
        given_name_tag = author_tag.xpath('name/given-names')
        if len(given_name_tag):
            given_name = given_name_tag[0].text.strip()
        surname_tag = author_tag.xpath('name/surname')
        if len(surname_tag):
            surname = surname_tag[0].text.strip()
        print('given name: '+given_name, flush=True)
        print('surname: '+surname, flush=True)
        if given_name and surname:
            authors.append(f'{given_name} {surname}')
        elif given_name or surname:
            authors.append(f'{given_name}{surname}')
    print(authors, flush=True)
    return authors


def get_title(doc):
    doctitle = ''
    title_tag = doc.xpath('//article-meta/title-group/article-title')
    if len(title_tag):
        doctitle = title_tag[0].text.strip()
    return doctitle
    
def get_publisher(doc):
    publisher = ''
    publisher_name_tag = doc.xpath('//front/journal-meta/publisher/publisher-name')
    if len(publisher_name_tag):
        publisher = publisher_name_tag[0].text.strip()
    return publisher

def get_year(doc):
    year = ''
    year_tag = doc.xpath("//pub-date[@pub-type='pub-date']/year")
    if len(year_tag):
        year = year_tag[0].text.strip()
    return year


def get_subject(doc):
    subject = ''
    subject_element = doc.xpath('//subject')
    if len(subject_element):
        subject_element = subject_element[0].text.strip()
    else:
        subject_element = ''

    journal_title = doc.xpath('//journal-title')
    if len(journal_title):
        journal_title = journal_title[0].text.strip()
    else:
        journal_title = ''
    
    volume = doc.xpath('.//article-meta/volume')
    if len(volume):
        volume = volume[0].text.strip()
    else:
        volume = ''

    issue = doc.xpath('.//article-meta/issue')
    if len(issue):
        issue = issue[0].text.strip()
    else:
        issue = ''

    pages = ''
    fpage = doc.xpath('.//article-meta/fpage')
    if len(fpage):
        fpage = fpage[0].text.strip()
        print("fpage: ", fpage)
    else:
        fpage = ''

    lpage = doc.xpath('.//article-meta/lpage')
    if len(lpage):
        lpage = lpage[0].text.strip()
        print("lpage: ", lpage)
    else:
        lpage = ''
        
    if fpage:
        pages = " " + fpage
        if lpage and (fpage != lpage):
            pages = f"Pages {fpage} - {lpage}"
        else:
            pages = f"Page {fpage}"
        
    year = get_year(doc)

    if subject_element:
        journal_title = f"{subject_element}: {journal_title}"

    subject = f"{journal_title}, {year} ({volume}), {pages}"
    subject = ' '.join(subject.split())
    return subject

def set_authors(pdf_file, authors):
    pdf = pikepdf.open(pdf_file, allow_overwriting_input = True)
    with pdf.open_metadata(set_pikepdf_as_editor = True, update_docinfo=True) as meta:
        meta['dc:creator'] = authors
    pdf.save()
    pdf.close()
    print('New author names: '+ ', '.join(authors), flush=True)
    return


def set_title(pdf_file, doctitle):
    pdf = pikepdf.open(pdf_file, allow_overwriting_input = True)
    with pdf.open_metadata(set_pikepdf_as_editor = True, update_docinfo=True) as meta:
        meta['dc:title'] = doctitle
#         meta['dc:date.issued'] = '2023' // This is not reliable. Adds a new attribute rather than an element.
    pdf.save()
    pdf.close()
    print('New title: '+ doctitle, flush=True)
    return

def set_subject(pdf_file, subject):
    pdf = pikepdf.open(pdf_file, allow_overwriting_input = True)
    with pdf.open_metadata(set_pikepdf_as_editor = True, update_docinfo=True) as meta:
        meta['dc:description'] = subject
    pdf.save()
    pdf.close()
    print('New Subject: '+ subject, flush=True)
    return

def set_keywords(pdf_file, keywords):
    pdf = pikepdf.open(pdf_file, allow_overwriting_input = True)
    with pdf.open_metadata(set_pikepdf_as_editor = True, update_docinfo=True) as meta:
        meta['dc:subject'] = keywords
    pdf.save()
    pdf.close()
    print('New Keywords: '+ keywords, flush=True)
    return

def set_year(pdf_file, year):
    pdf = pikepdf.open(pdf_file, allow_overwriting_input = True)
    with pdf.open_metadata(set_pikepdf_as_editor = True, update_docinfo=True) as meta:
        meta['dc:date.issued'] = year
    pdf.save()
    pdf.close()
    print('Publication year: '+ year, flush=True)
    return


def del_metadata(pdf_file):
    pdf = pikepdf.open(pdf_file, allow_overwriting_input = True)
    try:
        del pdf.Root.Metadata
    except KeyError:
        pass   
    finally:
        pass
        
    try:
        del pdf.docinfo
    except KeyError:
        pass   
    finally:
        pass
    pdf.save()
    pdf.close()
    return


def process_article(pdf_file, doc):
    result = del_metadata(pdf_file)

    authors = get_authors(doc)
    if authors:
        result = set_authors(pdf_file, authors)

    doctitle = get_title(doc)
    print("title: "+ doctitle, flush=True)
    result = set_title(pdf_file, doctitle)

    subject = get_subject(doc)
    print("subject: "+ subject, flush=True)
    result = set_subject(pdf_file, subject)

    publisher = get_publisher(doc)
    print("publisher: "+ publisher, flush=True)
    if publisher:
        result = set_keywords(pdf_file, publisher)

    year = get_year(doc)
    print("year: ", year)
    if year != '1800':
        result = set_year(pdf_file, year)

def append2pdf(pdf_file, doc):
        print(pdf_file, flush=True)
        process_article(pdf_file, doc)

