#!/usr/bin/env perl
#
# Copyright (c) 2005-2006 The Trustees of Indiana University.
#                         All rights reserved.
# $COPYRIGHT$
# 
# Additional copyrights may follow
# 
# $HEADER$
#

package MTT::MPI::Get::Copytree;

use strict;
use MTT::Values;
use MTT::Messages;
use MTT::Common::Copytree;

#--------------------------------------------------------------------------

sub Get {
    my ($ini, $section, $force) = @_;
    my $ret;
    my $previous_mtime;

    # See if we got a directory in the ini section
    my $src_directory = Value($ini, $section, "directory");
    if (!$src_directory) {
        $ret->{result_message} = "No source directory specified in [$section]; skipping";
        Warning("$ret->{result_message}\n");
        return $ret;
    }

    # Do we have the tree already?  Search through $MTT::MPI::sources
    # to see if we do.
    foreach my $mpi_section (keys(%{$MTT::MPI::sources})) {
        next
            if ($section ne $mpi_section);

        my $source = $MTT::MPI::sources->{$section};
        if ($source->{module_name} eq "MTT::MPI::Get::Copytree" &&
            $source->{module_data}->{src_directory} eq $src_directory) {
            $previous_mtime = $source->{module_data}->{mtime};
            $previous_mtime = -1
                if (!$previous_mtime);
            last;
        }
    }

    # Run the back-end function
    return MTT::Common::Copytree::Get($ini, $section, $previous_mtime);
}

1;