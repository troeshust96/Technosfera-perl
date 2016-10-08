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
    my $len = length($str);
    for my $i ( 0 .. $len ) {
       if (  
    }
}

sub tokenize
{
    chomp(my $expr = shift);
    check_CBS($expr); # correct bracket sequence
    $expr = delete_spaces($expr);
    $expr = unary_transform($expr);
    my @res = split_expr($expr);
 
 
    my @operation = ('+', '-', '*', '/', '^');
    my @unar_op = ('U+', 'U-');
    my @symbols = (@operation, @unar_op, '(', ')');
    my $last = '(';
    my $i = 0;
 
    for my $i ( 0 .. $#res ) {
        $cur_element = $res[$i];
	$prev_element = ( $i ) ? ( $i ) : ( "(" );
	if ( is_number($cur_element) ) {
	    $cur_element = unary_transform($cur_element);
	    check_number($cur_element);
	    $cur_element = normalize($cur_element);
	}
	check_sequence($prev_element, $cur_element);	
	
	if($res[$i] eq "" or $res[$i] =~ /\s+/)
        {
            splice(@res, $i, 1);
            next;
        }
 
 
        if ($res[$i] eq "+" and $last ~~ @symbols and (!($last eq ')')))
        {
            $res[$i] = 'U+';
        }
        if ($res[$i] eq "-" and $last ~~ @symbols and !($last eq ')'))
        {
            $res[$i] = 'U-';
        }
        if (!($res[$i] ~~ @symbols))
        {
            if($res[$i] =~ /[^e+0-9.-]/)
            {
                die "Err: $res[$i]";
            }
            if ($res[$i] =~ /.*e.*e.*/)
            {
                die "Err: $res[$i]"
            }
            if ($res[$i] =~ /.*\..*\..*/)
            {
                die "Err: $res[$i]"
            }
            my $p = 0 + $res[$i];
            $res[$i] = "$p";
        }
 
        if($res[$i] ~~ @operation)
        {
            if  ($last ~~ @unar_op
            or  $last ~~ @operation or $last eq '('
            or  $i == $#res)
            {
                die "Err";
            }
        }
        if(!($res[$i] ~~ @symbols) and !($last ~~ @symbols))
        {
            die "Err";
        }
 
 
        if($res[$i] eq ')' and ($last ~~ @operation or $last ~~ @unar_op))
        {
            die "Err";
        }
 
        if($res[$i] ~~ @unar_op and $i == $#res)
        {
            die "Err";
        }
 
        $last = $res[$i];
        $i++;
    }
    return \@res;
}
1;
