= Oyster

http://github.com/jcoglan/oyster

=== Description

Oyster is a command-line input parser that doesn't hate you. It provides a simple
API that you use to write a spec for the user interface to your program, and it
handles mapping the input to a hash for you. It supports both long and short option
names, subcommands, and various types of input data.

=== Features

* Parses command line options into a hash for easy access
* Supports long (--example) and short (-e) names, including compound (-zxvf) short options
* Supports subcommand recognition
* Can parse options as booleans, strings, arrays, files, globs
* Automatically handles single-letter shortcuts for option names
* Allows shortcuts to be specified for common groupings of flags
* Is easily extensible to support custom input types
* Automatically outputs man-page-style help for your program

=== Usage

You begin your command-line script by writing a spec for its options, layed out
like a Unix manual page. This spec will be used to parse input and to generate
help text using the --help flag. This example demonstrates a wide range of the
spec API. You can use as much or as little of it as you like, none of the fields
are required.

  require 'rubygems'
  require 'oyster'
  
  spec = Oyster.spec do
    name  'myprog -- something to move files around'
    
    synopsis <<-EOS
      myprog [options] --sources SCR --dest DEST
      myprog [options] --sources SRC --exec SCRIPT
    EOS
    
    description <<-EOS
      myprog is a command-line utility for moving files around or executing
      scripts against them. It can be invoked from any directory.
    EOS
    
    flag    :verbose,   :default => false,
    :desc => 'Print verbose output'
    
    flag    :recurse,   :default => true,
    :desc => 'Enter directories recursively'
    
    string  :type,      :default => 'f',
    :desc => 'Which type of files to move'
    
    glob    :files,     :desc => <<-EOS
    Pattern for selecting which files to move. For example, to select all the
    JavaScript files, you might use:
    
      --files ./*.js    (this directory)
      --files **/*.js   (search recursively)
    EOS
    
    array   :sources,   :desc => 'List of files to move'
    
    string  :dest,      :desc => 'Location of directory to move to'
    
    file    :exec,      :desc => 'File to read script from'
    
    notes <<-EOS
      This program may make destructive changes to your files. Make
      sure you have a full backup before running any dangerous scripts.
    EOS
    
    author    'James Coglan <jcoglan@nospam.com>'
    
    copyright <<-EOS
      (c) 2008 James Coglan. This program is free software, distributed under
      the MIT license. You are free to use it for whatever purpose you see fit.
    EOS
  end

Having defined your spec, you can use it to parse user input. Input is specified
as an array of string tokens, and defaults to ARGV. If the program is invoked using
--help, Oyster will throw a <tt>Oyster::HelpRendered</tt> exception that you can
use to halt your program if necessary. An example taking input from the command
line:

  begin; opts = spec.parse
  rescue Oyster::HelpRendered; exit
  end
  
<tt>spec.parse</tt> will return a <tt>Hash</tt> containing the values of the options
as specified by the user. For example:

  Input:    --verbose
  Output:   opts[:verbose] == true
  
  Input:    --no-recurse
  Oupput:   opts[:recurse] == false
  
  Input:    --dest /path/to/mydir
  Output:   opts[:dest] == '/path/to/mydir'
  
  Input:    --sources foo bar baz -d somewhere
  Output:   opts[:sources] == ['foo', 'bar', 'baz']
            opts[:dest] == 'somewhere'

=== Requirements

* Rubygems
* Oyster gem

=== Installation

  sudo gem install oyster

=== License

(The MIT License)

Copyright (c) 2008 James Coglan

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
