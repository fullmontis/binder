Binder -- A Tool for Printing bindable books
============================================

Binder is a simple shell script that reoders any pdf file so that it can be printed and folded in booklets. It always considers an A5 paper format, so that it can be printed on standard A4 paper and then folded. This means each sheet of paper will actually have 4 pages in it.  

This tools requires the `convert` command for creating an empty pdf, and `pdftk` to reorder the pages.

It is reccomended to use `pdfnup` to merge two pages in one with the following command: 

    $ pdfnup --nup 2x1 INFILE

How to use the command:

    Usage: binder.sh INFILE OUTFILE SHEETS_PER_BOOKLET

`SHEETS_PER_BOOKLET` stands for how many sheets of paper each booklet will hold. The reccomended range is between 4-6.

For example the following command:

    $ binder.sh test.pdf test_binded.pdf 6

Will use 6 sheets per booklet, meaning that each boooklet will hold 24 pages of the document, considering 4 pages per sheet.

If the file is 43 pages long, for example, it will create a file with 48 pages. This is because the minimum number of booklets required is 2, and since each holds 24 pages, 5 blank pages are added. 

***

Additional info
---------------

Generic header used for exporting in org-mode:

    #+TITLE: Book Title
    #+Author: Author Name
    #+latex_header: \usepackage[a5paper,top=2cm,bottom=1cm,left=2cm, right=1cm,twoside]{geometry} 
    #+latex_header: \usepackage{fancyhdr} 
    #+latex_header: \pagestyle{fancy}
    #+latex_header: \fancyhf{}
    #+latex_header: \fancyhead[R]{\thepage}
    #+options: toc:nil, date:nil
