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
 
sub unary_op_replace {
	my $expr = @_;
	$expr =~ s/(?<=[*^\/(+-])\+/U+/g; # Unary plus -> U+
	$expr =~ s/(?<=[*^\/(+-])\-/U-/g; # Unary minus -> U-
}

sub delete_spaces {
    my $str = shift;
    $str =~ s/\s+//g;
    return $str;
}

sub unary_transform {
    my $expr = shift;
    $expr =~ s/\+/U+/;
    $expr =~ s/-/U-/;
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

sub tokenize
{
    chomp(my $expr = shift);
    $expr = delete_spaces($expr);
    $expr = unary_transform($expr);
    my @res = split_expr($expr);
 
 
    my @operation = ('+', '-', '*', '/', '^');
    my @unar_op = ('U+', 'U-');
    my @symbols = (@operation, @unar_op, '(', ')');
    my $last = '(';
    my $i = 0;
 
    for my $i ( 0 .. $#res ) {
        if ( is_number($res[$i] ) {
	    asd;
	}
	
	
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
