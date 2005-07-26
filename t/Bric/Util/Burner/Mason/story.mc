<h1><% $story->get_title %></h1>
<h2><% $story->get_cover_date('%Y.%m.%d') %></h2>
<%perl>;
for my $e ($element->get_elements(qw(header para _pull_quote_))) {
    my $kn = $e->get_key_name;
    if ($kn eq 'para') {
        $m->print('<p>', $e->get_data, "</p>\n");
    } elsif ($kn eq 'header') {
        # Test sdisplay_element().
        $m->print('<h3>', $burner->sdisplay_element($e), "</h3>\n");
    } else {
        # Test display_element().
        $burner->display_element($e);
    }
}
$burner->display_pages('_page_');
</%perl>