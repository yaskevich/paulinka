use HTML::HTML5::Parser qw();
use HTML::HTML5::Writer qw();
use XML::LibXML::PrettyPrint qw();

my $document = XML::LibXML->new->parse_file('in.html');
 my $pp = XML::LibXML::PrettyPrint->new(indent_string => "  ");
 $pp->pretty_print($document); # modified in-place
 print $document->toString;