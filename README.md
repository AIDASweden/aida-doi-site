# aida-doi-site

Dockerfile for Apache/PHP/XSLT site to generate:

1. An index page at / or /doi/ listing all DOIs issued by AIDA (SND.AIDA)
2. Landing pages for each issued DOI

Pages are automatically generated from the DOI metadata available at DataCite
(and crossref for referenced articles), as well as a local json file
(issued_dois.json) that holds the link to the data set files refered to by the
DOI.

Examples:

* https://doi.aida.medtech4health.se/10.23698/aida/drsk
* https://aida.medtech4health.se/doi/10.23698/aida/drsk
* https://localhost:8888/10.23698/aida/drsk
* https://localhost:8888/doi/10.23698/aida/drsk

## Setup
Edit Apache config 000-default.conf to your liking. Then:

```
sudo docker build -t aida-doi-site .
git clone git@github.com:AIDASweden/aida-doi-site-data.git
sudo docker run -d -p 443:443 -v "$PWD"/aida-doi-site-data:/var/www/html/data aida-doi-site:latest
```

You can use eg `ln -s /path/to/data; php -S localhost:8888 index.php` for local testing
([docs](http://www.php.net//manual/en/features.commandline.webserver.php#example-413)).

## Acknowledgements

This site code was heavily inspired by [doi.nbis.se](https://doi.nbis.se).
Thank you for the [source code](https://github.com/NBISweden/doi-bils-site)!
