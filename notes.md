<%= f.input :resource_type, as: :select, collection: Hyrax::ResourceTypesService.select_options,
    input_html: { class: 'form-control', multiple: true } %> 
    


# _attribute_rows.html.erb

<%= presenter.attribute_to_html(:replaces,render_as: :faceted, html_dl: true) %>
:embargo_reason


[':abstract', ':academic_affiliation', ':additional_information', ':alt_title', ':bibliographic_citation', ':conference_location', ':conference_name', 
':contributor', ':contributor_advisor', ':contributor_committeemember', ':creator', ':date_available', ':date_issued', ':date_modified', ':date_uploaded', 
':degree_field', ':degree_grantors', ':degree_name', ':depositor', ':doi', ':editor', ':embargo_reason', ':file_extent', ':file_format', 
':graduation_year', ':has_journal', ':has_number', ':has_volume', ':identifier', ':in_series', ':is_referenced_by', ':isbn', ':issn', ':keyword', 
':language', ':license', ':location', ':other_affiliation', ':peerreviewed', ':publisher', ':replaces', ':resource_type', ':rights_statement', ':title']