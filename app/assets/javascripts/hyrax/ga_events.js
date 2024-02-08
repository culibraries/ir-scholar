/** 
 * [CUBL_CUSTOM_CODE]
 *
 * Overrides hyrax/app/assets/javascripts/hyrax/ga_events.js
 * and replaces outdated ga.js api to latest gtag.js.
 * This allows us to also support GA4 (which does not work with ga.js).
 **/

/* 
 * Track download link clicks whether on work or fileset show page.
 * This assumes there exists an analytics custom event named 'Downloaded'.
 */
//$(document).on('click', '[id^="file_download"]', function(e) {
$(document).on('click', '#file_download', function(e) {
  gtag('event', 'Downloaded', {
    'event_category': 'Files',
    'event_label': $(this).data('label'),
    'link_url': e.target.href
  });
});
