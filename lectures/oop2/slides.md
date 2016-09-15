class: firstpage title

# Программирование на Perl

## Объекты и ООП

---

class:note_and_mark title

# Отметьтесь на портале!
 
---

# Процедурный код

## Программирование на императивном языке, при котором последовательно выполняемые операторы можно собрать в подпрограммы, то есть более крупные целостные единицы кода, с помощью механизмов самого языка

* центр внимания - исполняемый код, функции и их цепочки
* *`действия` производятся над `данными`*
* есть фиксированный набор функций, им на вход подают различные наборы данных
* высокая производительность - цепочки команд языка напрямую отражаются в низкоуровневые последовательности команд процессора
* крупные проекты трудно проектировать, так как мозг - не процессор

---

# Процедурный код

## Аналогии реального мира

* `Конвеер`: детали двигаются по конвееру и на каждом этапе над ними производятся действия. Конвеер, как набор функций, неизменен, детали-данные меняются.
```perl
foreach my $component (@components) {
        foreach my $tool (@tools) {
            &$tool($component);
        }
}
```
* `Хлебопечка`: засыпаем муку, молоко и другие ингридиенты (входные данные), закрываем крышку (запускаем функцию), через некоторое время получаем на выходе хлеб.
Муку можно засыпать вручную, а можно соединить вход хлебопечки с выходом мельнички для зерна, и т. д.
```perl
$bread=breadmaker($milk, $eggs, mill($grains));
```
---

# ООП

##  Методология программирования, основанная на представлении программы в виде совокупности `объектов`, каждый из которых является экземпляром определенного `класса`, а классы образуют иерархию наследования

* центр внимания - `объект` (данные и набор функций для работы с ними) и взаимодействие `объектов`
* есть фиксированный набор типов объектов (`классы`), которые описывают данные `объектов` и их средства взаимодействия (`методы`)
* *`объекты` сами знают, как себя изменять*
* удобно проектировать - аналогия объектов близка мозгу
* производительность ниже, чем в процедурных языках
* любой ООП-код может быть отражен в процедурный код

---

# ООП

## Аналогии реального мира

* `Телевизор`: может изменить состояние (канал, громкость) только при помощи пульта. Заведомо неверное состояние выставить с пульта невозможно.
Если разобрать телевизор и подать импульс на нужный элемент схемы, канал тоже переключится, но разбирать телевизор нельзя.
```perl
$tv->remote->set_channel(1);
```
* `Турникет`: на вход получает другой объект - карту. Если поездки на карте есть, турникет изменяет состояние - открывается, а чип карты
получает команду списать поездку. Добавить поездку через интефейс карты невозможно.
```perl
# $gate->open_by_card($card);
if ($card->has_passes) {
        $card->spend_pass; $gate->open;
}
```

---

# ООП: три кита

## Различные языки программирования реализуют данные сущности по-разному. Единственно верной реализации ООП не существует.

* инкапсуляция
    * свойство системы, позволяющее объединить данные и методы, работающие с ними, в классе
    * некоторые языки отождествляют инкапсуляцию с сокрытием реализации, другие различают эти понятия
* наследование
    * свойство системы, позволяющее описать новый класс на основе уже существующего с частично или полностью заимствующейся функциональностью
* полиморфизм
    * свойство системы, позволяющее использовать объекты с одинаковым интерфейсом без информации о типе и внутренней структуре объекта

---

# ООП: программные сущности

* `класс`
    * комплексный тип данных, состоящий из тематически единого набора `полей` (переменных более элементарных типов) и `методов` (функций для работы с этими полями)
    * модель информационной сущности с внутренним и внешним интерфейсами для оперирования своим содержимым (значениями полей)
    * поля часто называют `атрибутами`, `свойствами`
* `объект`
    * экземпляр `класса`
    * конкретный набор `полей`, привязанный к классу и обладающий его `методами`

---

# ООП: производительность

* динамическое связывание методов в процессе исполнения программы
* снижение скорости доступа к данным: использование аксессоров
* значительная глубина абстракции: большое количество обращений к объектам более низкого уровня
* "размытие кода" по цепочке наследования: увеличение количества вызовов в процессе работы

---

# Особенности ООП в perl

## `Объект` = `поля` с данными + набор `методов` для работы с ними

* `поля` - элементы базовой структуры (скаляр, поля хеша или массива, и т. д.)
* `класс` - пакет, связанный с базовой структурой
* `методы` - функции, объявленные в пакете
* `объект` - ссылка (!) на базовую структуру, связанная с классом

---

# Особенности ООП в perl

* набор атрибутов не описывается в классе и ограничивается лишь базовой структурой
    * вы можете использовать любые поля хеша в качестве атрибутов
    * нельзя ограничить набор атрибутов конкретным списком
    * сокрытие реализации отсутствует: нет возможности сделать private-атрибуты, все атрибуты доступны снаружи и могут быть изменены
    * любой дятел может разрушить цивилизацию
* неявная типизация
    * "если это выглядит как утка, плавает как утка и крякает как утка, то это возможно и есть утка"
    * набор методов объекта определяет границы его использования
    * если нужно использовать некий объект там же, где уже используется объект совсем другого типа, добавьте ему недостающие свойства и методы
    * нет возможности создавать private- или protected-методы

---

# Базовый синтаксис

## Переделываем `Local::User` из предыдущей лекции

* базовая структура - хеш
* атрибуты:
```perl
    first_name => 'Василий',
    last_name  => 'Пупкин',
    gender     => 'm',
    email      => 'vasily@pupkin.ru',
    passwd     =>
      '$1$f^34d*$24cc1e0d198dbf6bbfd812a30f1b4460',
```

---

# Базовый синтаксис

## Переделываем `Local::User` из предыдущей лекции

* никакого `Exporter`!
* методы:
```perl
  get_by_email
  name
  welcome_string
  is_password_valid
```

---

# Базовый синтаксис

## Переделываем `Local::User` из предыдущей лекции

```perl
# `first` imported from List::Util
sub get_by_email {
  my $email = shift;
  my $user_data =
    first { $_->{email} eq $email } @USERS;
* # ????
  return $user_object;
}
```

---

# Базовый синтаксис

```perl
$object = bless \%data, $class;
# $object = \%data linked to package $class
```

```perl
$obj = \%data;
bless $obj, $class;
# the same as $obj = bless \%data, $class
```

```perl
bless \%data, $class;
bless \@data, $class;
bless \$data, $class;
```

```perl
bless \%data;
# same as bless \%data, __PACKAGE__;
```

---

# Базовый синтаксис

```perl
my $obj = \%data;
print ref $obj;               # HASH

bless $obj, "Local::User";
print ref $obj;               # Local::User
```

```perl
use Scalar::Util 'blessed';

my $obj = \%data;
print blessed $obj;           # undef

bless $obj, "Local::User";
print blessed $obj;           # Local::User
```

---

# Базовый синтаксис

## Методы класса

```perl
sub new {
  my ($class) = shift;
  my %params = @_;
  $params{name} =
    "$params{first_name} $params{last_name}";
  bless \%params, $class;
}
```

```perl
$user = Local::User->new(
    email => 'vasily@pupkin.ru',
    gender => 'm',
    # ...
);
$class = "Local::User";
$user = $class->new;
```

---

# Базовый синтаксис

## Методы объекта

```perl
sub name {
  my $self = shift;
  return join ' ',
    grep { length $_ }
      map { $self->{$_} }
        qw/first_name middle_name last_name/;
}
print $user->name;           # Василий Пупкин
# print $user->name();       # same
```

```perl
sub some_method {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    ...
}
```

---

# Базовый синтаксис

## Непрямой вызов методов

```perl
new Local::User(email => 'vasily@pupkin.ru');
# Local::User->new(email => 'vasily@pupkin.ru');
```

```perl
is_valid_password $user("123");
# $user->is_valid_password("123");
```

---

# Базовый синтаксис

## Непрямой вызов методов

```perl
use strict;
use warnings;

Syntax error!

exit 0;
```

---

# Базовый синтаксис

## Переделываем `Local::User` из предыдущей лекции

```perl
# $user_obj = Local::User->get_by_email($email);

sub get_by_email {
  my ($class, $email) = @_;
  my $user_data =
    first { $_->{email} eq $email } @USERS;
* my $user_object = bless $user_data, $class;
  return $user_object;
}
```

---

# Базовый синтаксис

## Переделываем `Local::User` из предыдущей лекции

```perl
# $user = Local::User->new(field => val, ...);
# $user = Local::User->new({ field => val, ... });
sub new {
  my ($class) = shift;
  bless { @_ }, $class;
}

# $user_obj = Local::User->get_by_email($email);
sub get_by_email {
  my ($class, $email) = @_;
  my $user_data =
    first { $_->{email} eq $email } @USERS;
  $class->new(%$user_data);
}
```

---

# Базовый синтаксис

## Переделываем `Local::User` из предыдущей лекции

```perl
# print $self->welcome_string;
sub welcome_string {
  my $self = shift;
  return
  (
    $self->{gender} eq 'm' ?
    "Уважаемый " : "Уважаемая "
  ) . $self->name . "!";
}

# if ($self->is_password_valid($passwd)) {....}
sub is_password_valid {
  my ($self, $passwd) = @_;
  # ...
}
```

---

# Базовый синтаксис

## name - атрибут или метод?

```perl
print $user->{first_name};        # Василий
print $user->{last_name};         # Пупкин
print $user->name();              # Василий Пупкин
```

---

# Базовый синтаксис

## Аксессоры (accessors)

```perl
sub first_name {
    my $self = shift;
    return $self->{first_name};
}
```

## getters/setters

```perl
sub get_first_name { $_[0]->{first_name} }
sub set_first_name {
    my $self = shift;
    $self->{first_name} = $_[0] if @_;
    return $self->{first_name};
}
```

---

# Базовый синтаксис

## Аксессоры (accessors)

* **Class::XSAccessor**
* Class::Accessor::Fast
* Class::Accessor
* ...

```perl
package Local::User;

# no passwd accessor - it is private!
use Class::XSAccessor {
  accessors => [qw/
    gender email first_name middle_name last_name
  /],
};
...
```

---

# Базовый синтаксис

## Переделываем `Local::User` из предыдущей лекции

```perl
sub name {
  my $self = shift;
  return join ' ',
    grep { length $_ }
*     map { my $m="${_}_name"; $self->$m }
        qw/first middle last/;
}
```

---

# Базовый синтаксис

## Наследование

```perl
package Local::Student;
*BEGIN { our @ISA = ('Local::User'); }
```

```perl
package Local::Teacher;
*use base 'Local::User';
```

```perl
package Local::Professor;
*use parent 'Local::Teacher';
```

```perl
say Local::Professor->isa("Local::Teacher");# 1
say Local::Professor->isa("Local::User");   # 1
say Local::Professor->isa("Local::Student");# undef
```

---

# Базовый синтаксис

## Наследование: класс UNIVERSAL

```perl
# ???
say Local::Professor->isa("UNIVERSAL");     # 1
```

```perl
my $professor = Local::Professor->new;
say $professor->isa("Local::Teacher");      # 1

say UNIVERSAL::isa({}, "Local::User");      # undef
```

```perl
say ref Local::Professor->can("new");       # CODE
say $professor->can("scream");              # undef
```

```perl
say Local::User->VERSION;                   # 1.4
```

---

# Базовый синтаксис

## Переделываем `Local::User` из предыдущей лекции

```perl
package Local::Teacher;
use strict;
use warnings;
use base 'Local::User';

sub welcome_string {
  my $self = shift;
  return
  (
    $self->gender eq 'm' ?
    "Уважаемый " : "Уважаемая "
  ) . "преподаватель " . $self->name . "!";
}
```

---

# Базовый синтаксис

## Переделываем `Local::User` из предыдущей лекции

```perl
package Local::Teacher;
use strict;
use warnings;
use base 'Local::User';

sub welcome_string {
  my $self = shift;
  my $str = $self->SUPER::welcome_string;
  $str =~ s/ / преподаватель /;
  return $str;
}
```

---

# Множественное наследование

```perl
package Local::Resident;
use Class::XSAccessor {
  accessors => [qw/
    name snils inn
    passport_id passport_emission passport_date
  /],
};
```

---

# Множественное наследование

```perl
package Local::ResidentStudent;
use parent qw/
    Local::Student
    Local::Resident
/;
```

```perl
$resident_user->name(); # ???
# Local::Student->name or Local::Resident->name?
```

---

# Множественное наследование

## Method Resolution Order

```
       Animal
         |
        Pet   Barkable
       /   \   /
      Cat   Dog
       \   /
        Lynx
```

```perl
Lynx->method();
# Lynx->Cat->Pet->Animal->Dog->Barkable
```

```perl
$self->Barkable::method(@params);

$self->SUPER::method(@params);
```

---

# Множественное наследование

## Method Resolution Order

```
       Animal
         |
        Pet   Barkable
       /   \   /
      Cat   Dog
       \   /
        Lynx
```

```perl
use mro 'c3';

Lynx->method();
# Lynx->Cat->Dog->Pet->Animal->Barkable
```

```perl
$self->next::method(@params);
```

---

# Композиция объектов

```perl
package Local::Resident;
use Class::XSAccessor {
    accessors => [qw/snils inn passport/],
};

package Local::Passport;
use Class::XSAccessor {
    accessors => [qw/id emission date/],
};
```

```perl
$passport = Local::Passport->get_by_id($id);
$resident_user->passport($passport);
print $resident_user->passport->emission;

```

---

# Деструкторы

```perl
package Local::User;

sub DESTROY {
  my ($self) = @_;
  print 'DESTROYED: ', $self->name;
}
```

```perl
{
  my $user =
    Local::User->get_by_email('vasily@pupkin.ru');
  # ...
}                      # DESTROYED: Василий Пупкин
```

---

# Деструкторы — сложности

* `die`
* `local`
* `AUTOLOAD`
* `${^GLOBAL_PHASE} eq 'DESTRUCT'`

```perl
sub DESTROY {
  my ($self) = @_;
  $self->{handle}->close() if $self->{handle};
}
```

---

# Модуль `overload`

```perl
package Local::User;
use overload '""' => 'to_string';
sub to_string {
    my ($self) = @_;
    return $self->name.' <'.$self->email.'>';
}
```

```perl
print $user;   # Василий Пупкин <vasily@pupkin.ru>
```

---

# Модуль `overload`

```perl
package Local::Vector;
use overload '+' => 'add', '0+' => 'len';
sub new {
    my ($class, $x, $y) = @_;
    bless { x=>$x, y=>$y }, $class;
}
sub add {
    my ($vec1, $vec2) = @_;
    __PACKAGE__->new(
        $vec1->{x} + $vec2->{x},
        $vec1->{y} + $vec2->{y},
    );
}
sub len {
    my ($self) = @_;
    return sqrt($self->{x}**2 + $self->{y}**2);
}
```

---

# Модуль `overload`

```perl
$vec1 = Local::Vector->new(1, 2);
$vec2 = Local::Vector->new(3, 1);
print $vec1+$vec2;    # 5

```

---

# Примеры

## tied objects

```perl
$hash{x} = 'vasily@pupkin.ru';

print $hash{x};
# Василий Пупкин <vasily@pupkin.ru>

print ref $hash{x};
# Local::User

# WTF???
```

---

# Примеры

## tied objects

```perl
package Local::UserHash;

use Tie::Hash;
use base 'Tie::StdHash';

use Local::User;

sub STORE {
  my ($self, $key, $value) = @_;
  $self->{$key} = 
    Local::User->get_by_email($value);
}
```

---

# Примеры

## tied objects

```perl
my %hash;
tie %hash, 'Local::UserHash';

$hash{x} = 'vasily@pupkin.ru';

print $hash{x};
# Василий Пупкин <vasily@pupkin.ru>
```

---

# Примеры

## Пакеты

```perl
use Some::Package qw(a b c);
# Some::Package->import(qw(a b c));

no Some::Package;
# Some::Package->unimport;

use Some::Package 10.01
# Some::Package->VERSION(10.01);
```

---

# Примеры

## JSON::XS

```perl
use JSON::XS;

JSON::XS->new->utf8->decode('...');

decode_json '...';
```

---

# Примеры

## Исключения (exceptions)

```perl
eval {
  die Local::Exception->new();
  1;
} or do {
  my $error = $@;

  if (
    blessed($error) &&
    $error->isa('Local::Exception')
  ) {
     # ...
  } else {
    die $error;
  }
};
```

---

# Примеры

## Исключения (exceptions)

```perl
use Try::Tiny;
try {
  die 'foo';
} catch {
  warn "caught error: $_"; # not $@
};
```

```perl
use Error qw(:try);
try {
    throw Error::Simple 'Oops!';
}
catch Error::Simple with { say 'Simple' }
except                   { say 'Except' }
otherwise                { say 'Otherwise' }
finally                  { say 'Finally' };
```














---

class:lastpage title

# Спасибо за внимание!

## Оставьте отзыв

.teacher[![teacher]()]
