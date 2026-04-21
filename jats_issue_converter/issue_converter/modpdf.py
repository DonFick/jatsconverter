#!/usr/bin/env python

import sys
import os
from pathlib import Path
import pikepdf


def get_authors(doc):
    authors = []
    for author_tag in doc.xpath(".//contrib[@contrib-type='author']"):
        prefix = ''
        given_name = ''
        surname = ''
        suffix = ''
        name = ''
        prefix_tag =  author_tag.xpath('name/prefix')
        given_name_tag = author_tag.xpath('name/given-names')
        surname_tag = author_tag.xpath('name/surname')
        suffix_tag =  author_tag.xpath('name/suffix')
        if len(prefix_tag):
            prefix = prefix_tag[0].text.strip()
        if len(given_name_tag):
            given_name = given_name_tag[0].text.strip()
        if len(surname_tag):
            surname = surname_tag[0].text.strip()
        if len(suffix_tag):
            suffix = suffix_tag[0].text.strip()
        name = ' '.join(filter(None,[prefix, given_name, surname, suffix]))
        authors.append(name)
    print(authors, flush=True)
    return authors


# def get_title(doc):
#     doctitle = ''
#     title_tag = doc.xpath('//article-meta/title-group/article-title')
#     if len(title_tag):
#         doctitle = title_tag[0].text.strip()
#     return doctitle

def get_title(doc):
    title_tag = doc.xpath('//article-meta/title-group/article-title')
    if len(title_tag):
        return ''.join(title_tag[0].itertext()).strip()
    return ''
    
def get_publisher(doc):
    publisher_name_tag = doc.xpath('//front/journal-meta/publisher/publisher-name')
    if len(publisher_name_tag):
        return ''.join(publisher_name_tag[0].itertext()).strip()
    return ''

def get_year(doc):
    year_tag = doc.xpath("//pub-date[@pub-type='pub-date']/year")
    if not len(year_tag):
        year_tag = doc.xpath("//pub-date[@date-type='pub']/year")
    if len(year_tag):
        return year_tag[0].text.strip()
    return ''


def get_subject(doc):
    subject = ''
    subject_element = doc.xpath('//subject')
    if len(subject_element):
        subject_element = subject_element[0].text.strip()
    else:
        subject_element = ''

    journal_title = ''
    journal_title_tag = doc.xpath('//journal-title')
    if len(journal_title_tag):
        journal_title = journal_title_tag[0].text.strip()

    volume = ''
    volume_tag = doc.xpath('.//article-meta/volume')
    if len(volume_tag):
        volume = volume_tag[0].text.strip()

    issue = ''
    issue_tag = doc.xpath('.//article-meta/issue')
    if len(issue_tag):
        issue = issue_tag[0].text.strip()

    fpage=''
    lpage=''
    pages = ''
    fpage_tag = doc.xpath('.//article-meta/fpage')
    if len(fpage_tag):
        fpage = fpage_tag[0].text.strip()
    print("fpage: ", fpage)

    lpage_tag = doc.xpath('.//article-meta/lpage')
    if len(lpage_tag):
        lpage = lpage_tag[0].text.strip()
    print("lpage: ", lpage)

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

