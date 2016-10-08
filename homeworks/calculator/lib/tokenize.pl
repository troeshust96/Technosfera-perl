=head1 DESCRIPTION
Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, состоящий из отдельных токенов.
Токен - это отдельная логическая часть выражения: число, скобка или арифметическая операция
В случае ошибки в выражении функция должна вызывать die с сообщением об ошибке
Знаки '-' и '+' в первой позиции, или после другой арифметической операции стоит воспринимать
как унарные и можно записывать как "U-" и "U+"
Стоит заметить, что после унарного оператора нельзя использовать бинарные операторы
Например последовательность 1 + - / 2 невалидна. Бинарный оператор / идёт после использования унарного "-"
=cut
 
use 5.010;
use strict;
use warnings;
use diagnostics;
 
use Data::Dumper;
 
BEGIN
{
    if ($] < 5.018)
    {
        package experimental;
        use warnings::register;
    }
}
no warnings 'experimental';
 
tokenize(<>);
 
sub del_element {
    my ($array, $idx) = @_;
    splice(@$array, $idx, 1);
}
 
sub del_empty_elements {
    my $array = @_;
    for my $i ( 0 .. $#@$array) {
        if ( @$array[$i] eq "" ) {
            del_element($array, $i);
        }
    }
}

sub delete_spaces {
    my $str = shift;
    $str =~ s/\s+//g;
    return $str;
}

sub unary_transform {
    my $expr = shift;
    $expr =~ s/(?<=[-(+*\/^]|^)-/U-/g;
    $expr =~ s/(?<=[-(+*\/^]|^)\+/U+/g;
    return $expr;
}

sub split_expr {
    my $expr = shift;
    my @res = split m{((?<!e)[-+]|[*^/()])}, $expr;
    return @res;
}

sub is_number {
    my $expr = shift;
    return $expr =~ /[0-9]/g;
}

sub normalize {
    my $expr = shift;
    my $val = 0 + $expr;
    return "$val";
}

#correct bracket sequence
sub check_CBS {
    my $cap = 0;
    my $str = shift;
    my @expr = split("", $str);
    for my $i ( 0 .. $#expr ) {
    	if ( $expr[$i] eq "(" ) {
	    ++$cap;
	}
	if ( $expr[$i] eq ")" ) {
	    --$cap;
	}
	if ( $cap < 0 ) {
	    die "Wrong bracket sequence";
	}
    }
}

sub tokenize
{
    chomp(my $expr = shift);
    $expr = delete_spaces($expr);
    check_CBS($expr); # correct bracket sequence
    $expr = unary_transform($expr);
    my @res = split_expr($expr);

    for my $i ( 0 .. $#res ) {
        $cur_element = $res[$i];
	$prev_element = ( $i ) ? ( $i ) : ( "(" );
	if ( is_number($cur_element) ) {
	    check_number($cur_element);
	    $cur_element = normalize($cur_element);
	}
	check_sequence($prev_element, $cur_element);	
    }
    return \@res;
}
1;
