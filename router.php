<?php
// // Debugging stuff
// ini_set('display_errors', 'On');
// error_reporting(E_ALL | E_STRICT);

// the issued dois json file name
// NB! This file is not part of this git repo. Must be checked out from a separate git repo
$doi_json_file = "data/issued_dois.json";

$xslt_file = ""; // the stylesheet file to use for the xslt transform
$xml = ""; // the xml DOMDocument to transform

// We can serve this repo from / or /doi/.
$doi = strtolower(preg_replace('/^\/(doi\/)?/', '', $_SERVER['REQUEST_URI']));
//$doi = substr($_SERVER['REQUEST_URI'], 1);

// We don't use uppercase characters in the DOIs we issue.
$doi = strtolower($doi);

if( ! $doi ) { // Produce the list of issued DOIs
	// URI for all SND.AIDA issued DOIs
	$xml_uri = "https://search.datacite.org/api?q=*&fq=datacentre_facet%3A%22SND.AIDA+-+Analytic+Imaging+Diagnostics+Arena%22&fl=doi,creator,title,publisher,publicationYear,datacentre&fq=is_active:true&fq=has_metadata:true&wt=xml&indent=true";
	$xml = new DOMDocument;
	$xml->load($xml_uri);

	// Lowercase DOIs. This old datacite API at search.datacite.org/api insists on
	// returning uppercased DOIs no matter the case they were issued in. We do not
	// use uppercase in DOIs, and the new api at api.datacite.org does not change
	// case of issued dois. Hence, we lowercase the DOIs in this response.
	$xpath = new DomXpath($xml);
	foreach ($xpath->query('//str[@name="doi"]') as $rowNode) {
		$rowNode->nodeValue = strtolower($rowNode->nodeValue);
	}
	$xslt_file = "index_page.xsl";

} else { // Produce the landing page for the specified DOI

	// only display our own DOIs
	if (!(substr($doi, 0, 14) === "10.23698/aida/")) {
		echo "<br/>No such doi found: $doi. <br/><em>Is it an AIDA DOI? AIDA DOIs are on the form 10.23698/aida/...</em>";
		exit();
	}

	// URI for the specified DOI
	$uri_prefix = "https://data.datacite.org/application/vnd.datacite.datacite+xml";
	$xml_uri = "$uri_prefix/" . urlencode($doi);
	// get local file for testing/development
	//$xml_uri = preg_split('/\//', $doi)[2] . '.xml';

	$xml = new DOMDocument;
	$load_ok = $xml->load($xml_uri);
	if (!$load_ok) {
		echo "<br/>No such doi found: $doi";
		exit();
	}
	$top_element = $xml->getElementsByTagName("resource")->item(0);

	// Lowercase DOI. This old datacite API at search.datacite.org/api insists on
	// returning uppercased DOIs no matter the case they were issued in. We do not
	// use uppercase in DOIs, and the new api at api.datacite.org does not change
	// case of issued dois. Hence, we lowercase the DOI in this response.
	$doi_element = $xml->getElementsByTagName("identifier")->item(0);
	$doi_element->nodeValue = strtolower($doi_element->nodeValue);

	// read resource info from issued_dois.json and insert in xml
	$data = json_decode(file_get_contents($doi_json_file));
	if (isset($data->{'DOIs'}->{$doi})) {
		$data_links_element = $xml->createElement("data-links");
		$top_element->appendChild($data_links_element);

		$data_link_arr = $data->{'DOIs'}->{$doi}->{'data-links'};
		foreach ($data_link_arr as $link) {
			$link_element = $xml->createElement("data-link", $link );
			$data_links_element->appendChild($link_element);

		}
		$access_request_link_arr = $data->{'DOIs'}->{$doi}->{'access-request-links'};
		foreach ($access_request_link_arr as $link) {
			$link_element = $xml->createElement("access-request-link", $link );
			$data_links_element->appendChild($link_element);
		}
	}

	// Find references to publications and get doi metadata for these
	// and insert in xml

	// Get the refence doi from the xml
	$ref_element = $top_element->getElementsByTagName("relatedIdentifier")->item(0);
	// This gets the first relatedIdentifier and ignores the rest.
	// Should possibly be improved to handle more than one relatedIdentifier
	// and different types as well.
	// NB! The xsl would also have to be changed for that to work properly
	if (isset($ref_element)) {
		$ref_doi = trim($ref_element->nodeValue);

		// Fetch the metadata for the reference from crossref.org
		$crossref_uri = "http://search.crossref.org/dois?q=" . urlencode($ref_doi);
		$ref_json_data = file_get_contents($crossref_uri);
		$ref_data = json_decode($ref_json_data);

		$ref =  $ref_data[0]->{'fullCitation'} ;
		// remove any html formating in the output
		$ref = preg_replace('/<i>/', '', $ref);
		$ref = preg_replace('/<\/i>/', '', $ref);

		// Add appropriate bits to the xml
		$full_citation_element = $xml->createElement( "fullCitation", $ref );
		$ref_attr = $xml->createAttribute("citation_doi");
		$ref_attr->value = $ref_doi;
		$full_citation_element->appendChild($ref_attr);
		$top_element->appendChild($full_citation_element);
	}

	// Set XSLT transform stylesheet file
	$xslt_file = "landing_page.xsl";
}

// Load XSL file
$xsl = new DOMDocument;
$xsl->load($xslt_file);

// Configure the transformer
$proc = new XSLTProcessor;

// Attach the xsl rules
$proc->importStyleSheet($xsl);

echo $proc->transformToXML($xml);

?>
