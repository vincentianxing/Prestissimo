eval 'exec perl -x $0 ${1+"$@"}' # -*-perl-*-
    if 0;
#!perl -w

# Program to convert new Prestissimo data file into old file format

use strict;
use warnings;
use diagnostics;

#my $magic='dept desc|dept code|crse|sect|crn|module|lect/lab/disc|term|title|long title|prim instructor|2nd instructor|3rd instructor|hours|standard letter|credit/no entry|pass/no pass|audit|ssci|arhu|nsci|fc|hc|cc|wint|wadv|qfr|ex|cul div|writ prof|quant prof|instr consent|dean consent|class limits|cur enroll|major|level|days|start time|end time|bldg code|room code|page|xlist dept 1|xlist crse 1|xlist cap 1|xlist act 1|xlist rem 1|xlist dept 2|xlist crse 2|xlist cap 2|xlist act 2|xlist rem 2|xlist dept 3|xlist crse 3|xlist cap 3|xlist act 3|xlist rem 3|text narrative|prereqs and notes';

my $magic='dept desc|dept code|crse|sect|crn|module|lect/lab/disc|term|title|long title|prim instructor|2nd instructor|3rd instructor|hours|standard letter|credit/no entry|pass/no pass|audit|ssci|arhu|nsci|fc|hc|cc|wint|wadv|qfr|ex|cul div|writ prof|quant prof|instr consent|dean consent|class limits|cur enroll|major|level|days|start time|end time|bldg code|room code|page|xl cap|xl act|xl rem|xlist dept 1|xlist crse 1|xlist crn 1|xlist dept 2|xlist crse 2|xlist crn 2|xlist dept 3|xlist crse 3|xlist crn 3|text narrative|prereqs and notes';

my @magicarray = split('\|', $magic, -1);
#my $magiclength = @magicarray;

my $firstlinematch = 0;

while (<>) {
    chomp;
    # handle the first line
    if ($_ eq $magic) {
        warn "ERROR: Header seen after first line" if $. > 1;

        $firstlinematch = 1 if $. == 1;

        my @temp = split('\|', $_, -1); 

        print join('|', @temp[0..20,27..42,46..56]);
        print "\n";
        next;
    }

    # sanity check
    die "First line wasn't the header" if not $firstlinematch;

    # Break things down by fields
    my @fields = split('\|', $_, -1);
    if (@fields != @magicarray) {
        warn "ERROR: skipping line  $. with ". scalar(@fields). " fields: $_\n";
        next;
    }

    # Slice out the fields I care about
    my @output = @fields[0..20,27..42,46..56];

    # New fields for course credit
    my $fc = $fields[21];
    my $hc = $fields[22];
    my $cc = $fields[23];

    # New fields for crosslisting
    my $xlcap = 0;
    my $xlenr = 0;
    $xlcap = int($fields[43]) if $fields[43] ne '';
    $xlenr = int($fields[44]) if $fields[44] ne '';

    # New fields for attributes
    my $wint = $fields[24];
    my $wadv = $fields[25];
    my $qfr  = $fields[26];

    # Transfer QFR to QP
    $output[24] = 'QP-F' if $qfr ne '';

    # Transfer to Writing
    $output[23] = 'N' if $output[23] eq ''; # doesn't seem needed, but...
    $output[23] = 'Y' if $wint ne '';
    $output[23] = 'Y' if $wadv ne '';

    $output[47] .= " (Writing Intensive)" if $wint ne '';
    $output[47] .= " (Writing Advanced)"  if $wadv ne '';

    # Transfer caps
    $output[27] = $xlcap if $xlcap > 0;
    $output[28] += $xlenr if $xlenr > 0; # testing cap

    # Print things out
    print join('|', @output);
    print "\n";
}


            #     # ####### ####### #######  #####
            ##    # #     #    #    #       #     #
            # #   # #     #    #    #       #
            #  #  # #     #    #    #####    #####
            #   # # #     #    #    #             #
            #    ## #     #    #    #       #     #
            #     # #######    #    #######  #####


###################################
# New file field number reference #
###################################

# NEW #  0     dept desc
# NEW #  1     dept code
# NEW #  2     crse
# NEW #  3     sect
# NEW #  4     crn
# NEW #  5     module
# NEW #  6     lect/lab/disc
# NEW #  7     term
# NEW #  8     title
# NEW #  9     long title
# NEW #  10    prim instructor
# NEW #  11    2nd instructor
# NEW #  12    3rd instructor
# NEW #  13    hours
# NEW #  14    standard letter
# NEW #  15    credit/no entry
# NEW #  16    pass/no pass
# NEW #  17    audit
# NEW #  18    ssci
# NEW #  19    arhu
# NEW #  20    nsci
# NEW #  21    fc
# NEW #  22    hc
# NEW #  23    cc
# NEW #  24    wint
# NEW #  25    wadv
# NEW #  26    qfr
# NEW #  27    ex
# NEW #  28    cul div
# NEW #  29    writ prof
# NEW #  30    quant prof
# NEW #  31    instr consent
# NEW #  32    dean consent
# NEW #  33    class limits
# NEW #  34    cur enroll
# NEW #  35    major
# NEW #  36    level
# NEW #  37    days
# NEW #  38    start time
# NEW #  39    end time
# NEW #  40    bldg code
# NEW #  41    room code
# NEW #  42    page
# NEW #  43    xl cap
# NEW #  44    xl act
# NEW #  45    xl rem
# NEW #  46    xlist dept 1
# NEW #  47    xlist crse 1
# NEW #  48    xlist crn 1
# NEW #  49    xlist dept 2
# NEW #  50    xlist crse 2
# NEW #  51    xlist crn 2
# NEW #  52    xlist dept 3
# NEW #  53    xlist crse 3
# NEW #  54    xlist crn 3
# NEW #  55    text narrative
# NEW #  56    prereqs and notes

###################################
# Old file field number reference #
###################################

# OLD #  0  dept desc
# OLD #  1  dept code
# OLD #  2  crse
# OLD #  3  sect
# OLD #  4  crn
# OLD #  5  module
# OLD #  6  lect/lab/disc
# OLD #  7  term
# OLD #  8  title
# OLD #  9  long title
# OLD #  10 prim instructor
# OLD #  11 2nd instructor
# OLD #  12 3rd instructor
# OLD #  13 hours
# OLD #  14 standard letter
# OLD #  15 credit/no entry
# OLD #  16 pass/no pass
# OLD #  17 audit
# OLD #  18 ssci
# OLD #  19 arhu
# OLD #  20 nsci
# OLD #  21 ex
# OLD #  22 cul div
# OLD #  23 writ prof
# OLD #  24 quant prof
# OLD #  25 instr consent
# OLD #  26 dean consent
# OLD #  27 class limits
# OLD #  28 cur enroll
# OLD #  29 major
# OLD #  30 level
# OLD #  31 days
# OLD #  32 start time
# OLD #  33 end time
# OLD #  34 bldg code
# OLD #  35 room code
# OLD #  36 page
# OLD #  37 xlist dept 1
# OLD #  38 xlist crse 1
# OLD #  39 xlist crn 1
# OLD #  40 xlist dept 2
# OLD #  41 xlist crse 2
# OLD #  42 xlist crn 2
# OLD #  43 xlist dept 3
# OLD #  44 xlist crse 3
# OLD #  45 xlist crn 3
# OLD #  46 text narrative
# OLD #  47 prereqs and notes

# NNN #0   dept desc
# NNN #1   dept code
# NNN #2   crse
# NNN #3   sect
# NNN #4   crn
# NNN #5   module
# NNN #6   lect/lab/disc
# NNN #7   term
# NNN #8   title
# NNN #9   long title
# NNN #10  prim instructor
# NNN #11  2nd instructor
# NNN #12  3rd instructor
# NNN #13  hours
# NNN #14  standard letter
# NNN #15  credit/no entry
# NNN #16  pass/no pass
# NNN #17  audit
# NNN #18  ssci
# NNN #19  arhu
# NNN #20  nsci
# NNN #21  fc
# NNN #22  hc
# NNN #23  cc
# NNN #24  wint
# NNN #25  wadv
# NNN #26  qfr
# NNN #27  ex
# NNN #28  cul div
# NNN #29  writ prof
# NNN #30  quant prof
# NNN #31  instr consent
# NNN #32  dean consent
# NNN #33  class limits
# NNN #34  cur enroll
# NNN #35  major
# NNN #36  level
# NNN #37  days
# NNN #38  start time
# NNN #39  end time
# NNN #40  bldg code
# NNN #41  room code
# NNN #42  page
# NNN #43  xlist dept 1
# NNN #44  xlist crse 1
# NNN #45  xlist cap 1
# NNN #46  xlist act 1
# NNN #47  xlist rem 1
# NNN #48  xlist dept 2
# NNN #49  xlist crse 2
# NNN #50  xlist cap 2
# NNN #51  xlist act 2
# NNN #52  xlist rem 2
# NNN #53  xlist dept 3
# NNN #54  xlist crse 3
# NNN #55  xlist cap 3
# NNN #56  xlist act 3
# NNN #57  xlist rem 3
# NNN #58  text narrative
# NNN #59  prereqs and notes
