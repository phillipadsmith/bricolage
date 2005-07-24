package Bric::Util::Coll::ICInclude;
###############################################################################

=head1 NAME

Bric::Util::Coll::ICInclude - Interface for managing Input Channels includes.

=head1 VERSION

$LastChangedRevision$

=cut

require Bric; our $VERSION = Bric->VERSION;

=head1 DATE

$LastChangedDate$

=head1 SYNOPSIS

See Bric::Util::Coll.

=head1 DESCRIPTION

See Bric::Util::Coll.

=cut

################################################################################
# Dependencies
################################################################################
# Standard Dependencies
use strict;

################################################################################
# Programmatic Dependences
#use Bric::Biz::InputChannel;
use Bric::Util::DBI qw(:standard);

################################################################################
# Inheritance
################################################################################
use base qw(Bric::Util::Coll);

################################################################################
# Function and Closure Prototypes
################################################################################

################################################################################
# Constants
################################################################################
use constant DEBUG => 0;

################################################################################
# Fields
################################################################################
# Public Class Fields

################################################################################
# Private Class Fields

################################################################################

################################################################################
# Instance Fields
BEGIN { }

################################################################################
# Class Methods
################################################################################

=head1 INTERFACE

=head2 Constructors

Inherited from Bric::Util::Coll.

=head2 Destructors

=over 4

=item $org->DESTROY

Dummy method to prevent wasting time trying to AUTOLOAD DESTROY.

B<Throws:> NONE.

B<Side Effects:> NONE.

B<Notes:> NONE.

=back

=cut

sub DESTROY {}

################################################################################

=head2 Public Class Methods

=over 4

=item Bric::Util::Coll->class_name()

Returns the name of the class of objects this collection manages.

B<Throws:> NONE.

B<Side Effects:> NONE.

B<Notes:> NONE.

=cut

sub class_name { 'Bric::Biz::InputChannel' }

################################################################################

=back

=head2 Public Instance Methods

=over 4

=item $self = $coll->save

=item $self = $coll->save($ic_id)

Saves the list of included Input Channels, associated them with their parent.
Pass in the parent ID to make sure all the Bric::Biz::InputChannel objects are
properly associated with the parent.

B<Throws:>

=over 4

=item *

Bric::_get() - Problems retrieving fields.

=item *

Unable to connect to database.

=item *

Unable to prepare SQL statement.

=item *

Unable to execute SQL statement.

=item *

Unable to select row.

=item *

Incorrect number of args to _set.

=item *

Bric::_set() - Problems setting fields.

=back

B<Side Effects:> NONE.

B<Notes:> NONE.

=cut

sub save {
    my ($self, $ic_id) = @_;
    my ($new_objs, $del_objs) = $self->_get(qw(new_obj del_obj));

    if (%$del_objs) {
        my $del = prepare_c(qq{
            DELETE FROM input_channel_include
            WHERE  input_channel__id = ?
                   AND include_ic_id = ?
        }, undef);
        execute($del, $ic_id, $_->get_id) for values %$del_objs;
        %$del_objs = ();
    }

    if (@$new_objs) {
        my $next = next_key('input_channel_include');
        my $ins = prepare_c(qq{
            INSERT INTO input_channel_include (id, input_channel__id,
                                                include_ic_id)
            VALUES($next, ?, ?)
        }, undef);

        foreach my $new (@$new_objs) {
            execute($ins, $ic_id, $new->get_id);
            $new->_set(['_include_id'], [last_key('input_channel_include')]);
        }
        $self->add_objs(@$new_objs);
        @$new_objs = ();
    }
    return $self;
}

=back

=head1 PRIVATE

=head2 Private Class Methods

=over 4

=item Bric::Util::Coll->_sort_objs($objs_href)

Sorts a list of objects into an internally-specified order. This implementation
overrides the default, sorting the action objects by their '_include_id'
property, which is a private property of Input Channels.

B<Throws:> NONE.

B<Side Effects:> NONE.

B<Notes:> NONE.

=cut

sub _sort_objs {
    my ($pkg, $objs) = @_;
    return ( map { $objs->{$_} }
             sort { $objs->{$a}{_include_id} <=> $objs->{$b}{_include_id} }
             keys %$objs);
}

=back

=head2 Private Instance Methods

NONE.

=head2 Private Functions

NONE.

=cut

1;
__END__

=head1 NOTES

NONE.

=head1 AUTHOR

David Wheeler <david@wheeler.net>
Marshall Roch <marshall@exclupen.com>

=head1 SEE ALSO

L<Bric|Bric>,
L<Bric::Util::Coll|Bric::Util::Coll>,
L<Bric::Biz::InputChannel|Bric::Biz::InputChannel>

=cut