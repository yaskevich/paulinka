#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use 5.010;
use Mojolicious::Lite;
binmode STDOUT, ':encoding(UTF-8)';


open my $fh, '<:encoding(UTF-8)', "pau.html";
open my $fh2, '>:encoding(UTF-8)', "pau_text.csv";
open my $fh3, '>:encoding(UTF-8)', "pau_stat.csv";
open my $fh4, '>:encoding(UTF-8)', "pau_freq.csv";

my $dom = Mojo::DOM->new(do { local $/; <$fh> });

my %names_stat	= ();
my %word_stat	= ();

$dom->parse ($dom->at('h4')->following->join("\n"));
print $fh2 chr(65279);

	
	
for my $e ($dom->find('p > span.ROLE')->each) {
	if (!$e->parent->attr("class")){ # ne "THEATRE-COMMENT"
		my $role = $e->text;
		my $words = $e->parent->text;
		if ($words =~ m/[А-Яа-яЁёЎўІі]/){
			$words =~ s/[^А-Яа-яЁёЎўІі\s\-]/ /ig;
			$words =~ s/\s\-\s/ /ig;
			$words =~ s/\s+/ /ig;
			$words =~ s/^\s+//;
			$words =~ s/\s+$//;

			$words = lc($words);
			my @arr = split (/\s/, $words);
			foreach my $word (@arr){
				$word =~ s/^ў/у/;
				if (exists $word_stat{$word}) {  $word_stat{$word}++; } else { $word_stat{$word} = 1; }
			}
			
			if (exists $names_stat{$role}{wqty}) {  $names_stat{$role}{wqty}++; } else { $names_stat{$role}{wqty} = 1; }
				my $curr_words_length_char = length(join("", @arr));
				my $curr_words_length_words = scalar @arr;
				$names_stat{$role}{m_char} = 0 if not defined $names_stat{$role}{m_char};
				$names_stat{$role}{m_words} = 0 if not defined $names_stat{$role}{m_words};
				
				$names_stat{$role}{all_char} = 0 if not defined $names_stat{$role}{all_char};
				$names_stat{$role}{all_words} = 0 if not defined $names_stat{$role}{all_words};
				
				$names_stat{$role}{m_char} = $curr_words_length_char if $names_stat{$role}{m_char} < $curr_words_length_char;
				$names_stat{$role}{m_words} = $curr_words_length_words if $names_stat{$role}{m_words} < $curr_words_length_words;
				
				$names_stat{$role}{all_char} += $curr_words_length_char;
				$names_stat{$role}{all_words} += $curr_words_length_words;
				
				print $fh2 $role.",".$words."\n";
		} 
	}
}
	
	
# my $format = "%-15s %-15s %-15s %-15s %-15s %-15s\n";
my $format = "%s,%s,%s,%s,%s,%s\n";
printf $fh3 $format, 'Роля', 'Рэплікі','Найдаўжэйшая (знакі)', 'Найдаўжэйшая (словы)', 'Усяго знакаў', 'Усяго словаў';

for (sort {$names_stat{$b}{wqty} <=> $names_stat{$a}{wqty}} keys %names_stat){
	printf $fh3 $format, $_ ,$names_stat{$_}{wqty}, $names_stat{$_}{m_char}, $names_stat{$_}{m_words},
	$names_stat{$_}{all_char}, $names_stat{$_}{all_words};
}

# say $fh3 '=' x 100;
for (sort {$word_stat{$b} <=> $word_stat{$a}} keys %word_stat){
	printf $fh4 "%s,%s\n", $_,$word_stat{$_};
}


