# aida-doi-site PHP and XSLT code to generate:

1. An index page with a list of the DOIs issued by AIDA (SND.AIDA)
2. A landing page for each issued DOI

Pages are automatically generated from the DOI metadata available at DataCite
(and crossref for referenced articles), as well as a local json file
(issued_dois.json) that holds the link to the data set files refered to by the
DOI.

## Requirements

* PHP with [DOM extension](http://php.net/manual/en/intro.dom.php).
* Download link info available as `data/issued_dois.json` (maintained [here](github.com/AIDASweden/aida-doi-site-data))

Route all requests to /** or /doi/** to router.php. Everything following that is
assumed to be a DOI. Examples:

* https://doi.aida.medtech4health.se/10.23698/aida/drsk
* https://aida.medtech4health.se/doi/10.23698/aida/drsk
* https://localhost:8888/10.23698/aida/drsk
* https://localhost:8888/doi/10.23698/aida/drsk

You can use eg `php -S localhost:8888 router.php` for local testing. Some docs
for Apache / local development config here:

* https://stackoverflow.com/questions/5218213/create-a-catch-all-handler-in-php
* http://www.php.net//manual/en/features.commandline.webserver.php#example-413

## Acknowledgements

This site code was heavily inspired by [doi.nbis.se](https://doi.nbis.se).
Thank you for the [source code](https://github.com/NBISweden/doi-bils-site)!
