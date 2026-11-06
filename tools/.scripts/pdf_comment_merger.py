import pymupdf #pymupdf
import random
import colorsys
import sys
import textwrap

def get_random_color():
    """Generate a random color that is readable"""
    hue = random.random()
    saturation = random.uniform(0.5,1)
    brightness = random.uniform(0.2,0.4)

    # return (r,g,b)
    return  colorsys.hls_to_rgb(hue, brightness, saturation)

# sources of comments
INPUT_FILES = ['test1.pdf','test2.pdf']
COLORS = [get_random_color() for _ in range(len(INPUT_FILES))]

# uncommented original file
OGFILE = pymupdf.open('main.pdf')
# target file to put all the comments on
TARGET = pymupdf.open()

# this is to take as a reference position
REFERENCE_X_POS = OGFILE[0].rect.width - 50 # added some padding to put a bit inside the margin
SHADOW_OFFSET = 0.5 
FONTSIZE = 10

# i will first process and make a copy of the original file
# to put into the target file for future comments
PADDING = 100
for page_num in range(OGFILE.page_count):
    # make a blank page with same dimensions
    source_page = OGFILE.load_page(page_num)
    # create a new page with extra space
    new_page = TARGET.new_page(
        width=source_page.rect.width+PADDING,
        height=source_page.rect.height
    )
    # the extra space is symmetrical, so i need to prepare a rectangle that starts at (0,0)
    content_rect = pymupdf.Rect(0, 0, source_page.rect.width, source_page.rect.height)
    
    # apply the same content
    new_page.show_pdf_page(content_rect, OGFILE, page_num)

# now that we prepared the target file,
# i can go file by file putting comments
for file,c in zip(INPUT_FILES,COLORS):
    pdf = pymupdf.open(file)
    # go page by page
    for page_num in range(pdf.page_count):

        page = pdf.load_page(page_num)
        target_page = TARGET[page_num]

        if page.annots():
            for annot in page.annots():
                # Get annotation content (comments)
                comment_text = annot.info["content"]
                if comment_text:

                    # here i will manually wrap the text, because i couldn't figure it out
                    # by using textboxes
                    wrapped_text = textwrap.fill(comment_text,width=20).splitlines()

                    for i,line in enumerate(wrapped_text):
                        coords = (REFERENCE_X_POS, annot.rect.y0-i*FONTSIZE)
                        shadow_coords = tuple(xi + SHADOW_OFFSET for xi in coords)
                        target_page.insert_text(shadow_coords, line, fontsize=FONTSIZE, color=(0.1,0.1,0.1))
                        target_page.insert_text(coords, line, fontsize=FONTSIZE, color=c)

    pdf.close()

TARGET.save('comments.pdf')
TARGET.close()
OGFILE.close()
