#!/usr/bin/perl -w
# -*- perl -*-

#
# Author: Slaven Rezic
#
# Copyright (C) 2001,2014 Slaven Rezic. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# Mail: slaven@rezic.de
# WWW:  http://bbbike.de
#

use Inline::MakeMaker;

use Config;
use Cwd;

my $thisdir = getcwd();
chdir("../..");
my $root = getcwd();
chdir($thisdir);

# ***FILTER=1***
my $inlinedistpm = "InlineDist.pm";
my $inlinepm     = "Inline.pm";
# ***FILTER=2***
#my $inlinedistpm = "Inline2Dist.pm";
#my $inlinepm     = "Inline2.pm";
# ***FILTER=all***

if (! -e $inlinedistpm) {
    open(FH, ">> $inlinedistpm") or die $!;
    close FH;
    utime 0,0, $inlinedistpm;
}

WriteMakefile
  (
# ***FILTER=1***
   'NAME'	   => 'Strassen::Inline',
   #'OBJECT'        => 'heap$(OBJ_EXT)',
# ***FILTER=2***
#   'NAME'	   => 'Strassen::Inline2',
#   #'OBJECT'        => '../Strassen-Inline/heap$(OBJ_EXT)',
# ***FILTER=all***
   'VERSION_FROM'  => $inlinepm,
   'AUTHOR'        => 'Slaven Rezic (slaven@rezic.de)',

   ## XXX was used with the heap implementation
   #'CCFLAGS'       => "$Config{ccflags} -ffast-math -fomit-frame-pointer",
  );

sub MY::install {
    my $rule = "";
    if ($] >= 5.006) {
	$rule .= <<EOF;
install:	all
	@\$(MOD_INSTALL) \\
		\$(INST_LIB) $root/lib \\
		\$(INST_ARCHLIB) $root/lib/$Config{'version'}/$Config{'archname'} \\

EOF
    } else {
	$rule .= <<EOF;
install:	all
	@\$(MOD_INSTALL) \\
		\$(INST_LIB) $root/lib \\
		\$(INST_ARCHLIB) $root/lib/$Config{'archname'} \\

EOF
    }

    $rule .= <<EOF;
$inlinedistpm:	$inlinepm
	\$(PERL) ../inline2dist.pl \$(NAME)

EOF

    $rule;
}


__END__
