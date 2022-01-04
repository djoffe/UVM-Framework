package require fileutil
variable recursion_check
variable tcdict
variable builddict 
variable file_read
variable root_dir
proc initTcl {rd} {
  global file_read
  global root_dir
  set file_read 0
  set root_dir $rd
}
## Top level test list parser invocation.  Sets up some globals and then
## fires off the internal reader (for purposes of nesting)
proc ReadTestlistFile {file_name {collapse 0} {debug 0} {init 0}} {
  global recursion_check
  global tcdict
  global file_read
  if {$file_read == 1} {
    return ""
  }
  set recursion_check ""
  set tcdict [dict create]
  set builddict [dict create]
  ReadTestlistFile_int $file_name $collapse $debug
  if {$debug == 1} {
    print_tcdict
  }
  set file_read 1
  return ""
}
proc print_tcdict {} {
  global tcdict
  puts "DEBUG: tcdict contents:"
  dict for {top testnames} $tcdict {
    dict for {test seeds} $testnames {
      foreach seed $seeds {
        puts "\t$top-$test-$seed"
      }
    }
  }
}
proc print_builddict {} {
  global builddict
  if {![info exists builddict]} {
    return
  }
  dict for {buildname entry} $builddict {
    puts [format "%s - %s" $buildname $entry]
  }
} 
## Actual test list file reader.  See embedded comments for more detail
proc ReadTestlistFile_int {file_name collapse {debug 0}} {
  global recursion_check
  global tcdict
  global builddict
  global root_dir
  set tops ""
  ## Elaborate "^" at beginning of $file_name and expand with $root_dir
  regsub -- {^\^} $file_name $root_dir file_name
  ## Recursion is checked for, i.e. if a test list includes itself
  if {[lsearch $recursion_check $file_name] >= 0} {
    puts [format "ERROR RECURSION : %s" $file_name]
    exit
  }
  if {$debug==1} {
    puts [format "DEBUG: Opening file \"%s\"" $file_name]
  }
  lappend recursion_check $file_name
  if {![file isfile $file_name]} {
    puts [format "ERROR INVALID FILE : %s" $file_name]
    exit
  }  
  set tfile [open $file_name r]
  set rootdir [file dirname $file_name]
  while {![eof $tfile]} {
    gets $tfile line
    ## Skip comment lines in testlist file - first column a # sign
    if {[string range $line 0 0] != "#"} {
      ## Skip whitespace
      if {[llength $line] != 0} {
        ##
        ## Process TB_INFO lines, which has information regarding how to
        ## build a particular testbench
        ##
        if {[string match "TB_INFO" [lindex $line 0]]} {
          if {[llength $line] != 4} {
            puts [format "ERROR TB_INFO ARGS : %s" $line]
            exit
          }
          dict set builddict [lindex $line 1] "buildcmd" [lindex $line 2]
          dict set builddict [lindex $line 1] "runcmd" [lindex $line 3]
          dict set builddict [lindex $line 1] "builddir" $rootdir
          if {$debug==1} {
            puts [format "DEBUG: Registering testbench %s" [lindex $line 1]]
          }
        ##
        ## Process TB lines, which should contain a unique build label
        ##
        } elseif {[string match "TB" [lindex $line 0]]} {
          if {[llength $line] != 2} {
            puts [format "ERROR TB ARGS : %s" $line]
            exit
          }
          if {![info exists builddict] || ![dict exists $builddict [lindex $line 1]]} {
            puts [format "ERROR TB - No TB_INFO entry for %s" [lindex $line 1]]
            print_builddict
            exit
          }
          set tops [lindex $line 1]
          if {$debug == 1} {
            puts [format "DEBUG: Current top \"%s\"" $tops]
          }
        ##
        ## Process TEST lines, which will be stored according to the last TB seen
        ## Each TEST line contains a test name, a repeat count, and some number of
        ## seeds.
        ##
        } elseif {[string match "TEST" [lindex $line 0]]} {
          if {[llength $tops] == 0} {
            puts [format "ERROR TEST NO TOP SPECIFIED : %s" $line]
            exit
          }
          if {[llength $line] == 1} {
            puts [format "ERROR TEST NOT ENOUGH ARGS : %s" $line]
            exit
          }
          if {[llength $line] == 2} {
            set num 1;
          } else {
            set num [lindex $line 2]
          }
          set seedlist ""
          if {$collapse == 0} {
            for {set repeat 0} {$repeat < [expr $num]} {incr repeat} {
              if {[lindex $line [expr $repeat + 3]] == ""} {
                lappend seedlist "[expr {int(rand() * 10000000000000000) % 4294967296}]"
              } else {
                lappend seedlist [lindex $line [expr $repeat + 3]]
              }
            }
          } else {
            lappend seedlist "0"
          }
          dict set tcdict $tops [lindex $line 1] $seedlist 
          if {$debug == 1} {
            puts [format "DEBUG: Added %d test %s for build %s" [llength $seedlist] [lindex $line 1] $tops]
          }
        ##
        ## Process INCLUDE lines, which is another file to parse.  
        ##
        } elseif {[string match "INCLUDE" [lindex $line 0]]} {
          if {$debug == 1} {
            puts [format "DEBUG: Including file %s" [lindex $line 1]]
          }
          ReadTestlistFile_int [lindex $line 1] $collapse $debug
        } else {
          puts [format "ERROR UNKNOWN CMD: %s" $line]
          exit
        }
      }
    }
  }
  set recursion_check [lrange $recursion_check 0 end-1]
  if {$debug==1} {
    puts [format "DEBUG: Finished with file \"%s\"" $file_name]
  }
}

## Called by the runnables, returns a list of testbenches to
## build, produces the top-level of runnable hierarchy  
proc GetBuilds {args} {
  global tcdict
  return [dict keys $tcdict]
}
## Called by the runnables, returns the build command unique to
## this particular build.
proc GetBuildCmd {build} {
  global builddict
  return [dict get $builddict $build "buildcmd"]
}
## Called by the runnables, returns the run command for this particular build.
proc GetRunCmd {build} {
  global builddict
  return [dict get $builddict $build "runcmd"]
}
proc GetBuildDir {build} {
  global builddict
  return [dict get $builddict $build "builddir"]
}
## Called by the runnables, returns a list of tests to run for
## a specified build.  If collapse is set, only return one 
## instance of each test.  Otherwise, return one instance for
## each seed.
proc GetTestcases {build collapse} {
  global tcdict
  set ret ""
  dict for {test seeds} [dict get $tcdict $build] {
    if {$collapse == 1} {
      lappend ret [format "%s-%s-0-%s" $build $test [lindex $seeds 0]]
    } else {
      for {set repeat 0} {$repeat < [llength $seeds]} {incr repeat} {
        lappend ret [format "%s-%s-%d-%s" $build $test $repeat [lindex $seeds $repeat]]
      }
    }
  }
  return $ret
}
proc FindMVCHome { Makefile_name } {
  set matchcnt [llength [fileutil::grep "mvchome" $Makefile_name]]
  return $matchcnt
}
## This will cause all UCDBs to be merged regardless of test status.  Default is to not merge in failing tests.
## If a test does not pass, strip all coverage information except for assertions but include it in the merge.  The
## intent is to ensure that test pass/fail information is maintained but bad tests do not contribute towards
## coverage
proc OkToMerge {userdata} {
  upvar $userdata data
  set passfail $data(passfail)
  set ucdbfile $data(ucdbfile)
  if { ![ string match "passed" $passfail ] } {
    exec vsim -c -viewcov $ucdbfile -do "coverage edit -keeponly -assert; coverage save $ucdbfile; quit"
  }
  return 1
}