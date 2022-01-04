import sys
import os
import time
import re
from uvmf_gen import UserError
import yaml
from uvmf_yaml import dumper, RegenValidator

from voluptuous import Invalid,MultipleInvalid
from voluptuous.humanize import humanize_error

from shutil import copyfile

class Merge:

  def __init__(self,outdir,skip_missing_blocks,root,quiet=False):
    self.regen = Regen(root)
    self.skipped_files = 0
    self.copied_files = 0
    self.root = root
    self.copied_old_files = 0
    self.found_blocks = 0
    self.ignored_blocks = 0
    self.outdir = os.path.abspath(os.path.normpath(outdir))
    self.missing_blocks = {}
    self.skip_missing_blocks = skip_missing_blocks
    self.quiet = quiet
    self.new_directories = []

  def replace_basedir(self, p, old_basedir, new_basedir):
    r = re.sub(r"^"+old_basedir+os.sep+r"(.*)",r"{0}{1}\1".format(new_basedir,os.sep),p)
    return os.path.normpath(r)

  def load_yaml(self,fname):
    try:
      fs = open(fname)
    except IOError:
      raise UserError("Unable to open config file {0}".format(fname))
    d = yaml.safe_load(fs)
    fs.close()
    try:
      self.load_data(d['uvmf']['regen_data'])
    except:
      raise UserError("Contents of {0} does not contain valid UVMF regeneration information".format(fname))

  def load_data(self,data):
    try:
      RegenValidator().schema(data)
    except MultipleInvalid as e:
      resp = humanize_error(rd,e).split('\n')
      raise UserError("Validation of regeneration YAML failed:\n{0}".format(pprint.pformat(resp,indent=2)))
    self.rd = data

  def file_begin(self,fname):
    ## Figure out path of this new file in the 'old' directory structure
    self.old_fname = self.replace_basedir(fname,self.root,self.old_root)
    ## Figure out path of this new file to be placed in 'merged' directory structure
    outfile = self.replace_basedir(fname,self.root,self.outdir)
    ## Check if 'merged' file exists, skip if it does and we're not overwriting
    if os.path.exists(outfile) & (self.overwrite == False):
      if (self.quiet == False):
        print("SKIPPED file {0}, already exists in output directory".format(fname))
      self.skipped_files += 1
      return False
    ## Check to see if the 'old' file we're looking for is in the data structure
    if not self.old_fname in self.rd:
      ## If it isn't there, this will need to be copied. Try to create necessary
      ## path structure in 'merged' output directory area if it isn't already there
      if not os.path.exists(os.path.dirname(outfile)):
        try:
          os.makedirs(os.path.dirname(outfile))
        except OSError as e:
          raise UserError("Unable to create path to new output file {0}: {1}".format(outfile,e.strerror))
      try:
        ## and then copy the file over from 'old' to 'merged'
        copyfile(fname,outfile)
      except IOError:
        raise UserError("Unable to copy file {0} to {1}".format(fname,outfile))
      if (self.quiet == False):
        print("COPIED new file from {0}".format(fname))
      self.copied_files += 1
      return False
    ## Even if the file is in the data structure, path in 'merged' directory may not exist yet.
    if not os.path.exists(os.path.dirname(outfile)):
      try:
        os.makedirs(os.path.dirname(outfile))
      except OSError as e:
        raise UserError("Unable to create path to new output file {0}: {1}".format(outfile,e.strerror))
    ## Log the directory in 'new' for later use when determining what to copy
    fname_dir = os.path.dirname(fname)
    if not fname_dir in self.new_directories:
      self.new_directories.append(fname_dir)
    ## As a last step, open the file in the 'merged' output space
    try:
      self.ofs = open(outfile,'w')
    except IOError:
      raise UserError("Unable to create output file {0}".format(outfile))
    ## Function returns true if we are now processing the file contents
    return True

  def block_begin(self,fname,line,label_name,begin_line):
    self.ofs.write(line)
    if not label_name in self.rd[self.old_fname]:
      # This labeled block was not in the data structure. Note this and move on
      if (self.quiet == False):
        print("Found new block \"{0}\" in file {1}, wasn't in old source".format(label_name, fname))
      self.ignored_blocks += 1
    else:
      self.found_blocks += 1
      self.ofs.write(self.rd[self.old_fname][label_name]['content'])
      self.block_copied = True
      self.rd[self.old_fname][label_name]['block_used'] = True

  def block_end(self,fname,line,label_name,end_line):
    self.block_copied = False
    self.ofs.write(line)

  def block_inside(self,fname,label_name,content,lnum):
    if self.block_copied == False:
      self.ofs.write(content)

  def block_outside(self,fname,line,lnum):
    self.ofs.write(line)

  def file_end(self,fname):
    self.ofs.close()
    # At the end of each file, check to see if any blocks from the data structure went unused.
    # Error if option skip_missing_blocks is FALSE, otherwise produce a warning and move on.
    # Do this by looping through all of the labels in the data structue for the given file
    # and look for the 'block_used' entry.  If that is there, all is good. Otherwise, problem.
    for l in self.rd[self.old_fname]:
      try:
        used = self.rd[self.old_fname][l]['block_used']
      except KeyError:
        if self.skip_missing_blocks == True:
          if self.old_fname not in self.missing_blocks:
            self.missing_blocks[self.old_fname] = [ l ]
          else:
            self.missinb_blocks[self.old_fname].append(l)
        else:
          raise UserError('Label "{0}" in file "{1}" was not found in new output "{2}"'.format(l,self.old_fname,fname))

  def parse_file(self,fname,overwrite=False):
    self.overwrite=overwrite
    self.regen.parse_file(fname,pre_open_fn=self.file_begin,block_begin_fn=self.block_begin,block_end_fn=self.block_end,block_inside_fn=self.block_inside,block_outside_fn=self.block_outside,post_open_fn=self.file_end)

  def traverse_dir(self,fname,overwrite=False):
    self.overwrite=overwrite
    self.regen.traverse_dir(fname,pre_open_fn=self.file_begin,block_begin_fn=self.block_begin,block_end_fn=self.block_end,block_inside_fn=self.block_inside,block_outside_fn=self.block_outside,post_open_fn=self.file_end)

  def copy_old_files(self,dname,overwrite=False):
    ## Input is the 'new' directory. Make sure it's absolute before proceeding (we don't really need this)
    new_root = os.path.abspath(dname)
    ## Iterate through all of the directories we found when parsing through the 'new' directory tree
    for dir in self.new_directories:
      # Find the equivalent path in the 'old' directory
      od = self.replace_basedir(dir, self.root, self.old_root)
      ## Walk through all of the files in each of these 'old' directories
      root,dirs,files = next(os.walk(od))
      for f in files:
        # Go through all files listed in each 'old' directory . If they do not exist in the input (new) directory then copy the original
        # into the merged output directory. Don't do it if the file is already there unless --overwrite
        # Important note, we are only going to copy 'old files from underenath structure that matches directories in
        # 'new'. If there is any adjacent directory structure in 'old' it will not be copied over to 'merged'
        newfile = dir+os.sep+f
        oldfile = root+os.sep+f
        outfile = self.replace_basedir(oldfile, self.old_root,self.outdir)
        if not os.path.exists(newfile):
          if (not os.path.exists(outfile)) | (overwrite==True):
            if not os.path.exists(os.path.dirname(outfile)):
              try:
                os.makedirs(os.path.dirname(outfile))
              except OSError as e:
                raise UserError("Unable to create path to copied file {0}: {1}".format(outfile, e.strerror))
            try:
              copyfile(oldfile, outfile)
            except IOError as e:
              raise UserError("Unable to copy file {0} to {1}: {2}".format(oldfile, outfile, e.strerror))
            self.copied_old_files += 1
            if (self.quiet == False):
              print("COPIED old file from {0}".format(oldfile))


class Parse:

  def __init__(self,root,quiet=False,cleanup=False):
    self.data = {}
    self.root = root
    self.block_count = 0
    self.quiet = quiet
    self.regen = Regen(root)
    self.cleanup = cleanup

  def str_presenter(self, dumper, data):
    if len(data.splitlines()) > 1:
      return dumper.represent_scalar('tag:yaml.org,2002:str', data, style='|')
    return dumper.represent_scalar('tag:yaml.org,2002:str', data)

  def dump(self,fname):
    # Clean up data so it'll represent in YAML properly. Remove whitespace at end of lines
    # and all but the final newline. Only do this if we're dumping YAML (cleanup==True)
    for f,labels in self.data.iteritems():
      for label,ldata in labels.iteritems():
        c = ldata['content']
        if (self.cleanup):
          c = re.sub(r"\s+$", "", c)
          c = re.sub(r"\s+\n", "\n", c)
          c = re.sub(r"\n$","", c)
        self.data[f][label]['content'] = c
    d = {'uvmf': {'regen_data': self.data}}
    yaml.add_representer(str, self.str_presenter)
    dumper.YAMLGenerator(d, fname)

  def parse_file(self,fname):
    self.regen.parse_file(fname,pre_open_fn=self.file_begin,block_begin_fn=self.block_begin,block_end_fn=self.block_end,block_inside_fn=self.block_inside)

  def traverse_dir(self,dname):
    self.regen.traverse_dir(dname,pre_open_fn=self.file_begin,block_begin_fn=self.block_begin,block_end_fn=self.block_end,block_inside_fn=self.block_inside)

  def file_begin(self,fname):
    self.data[fname] = {}

  def block_begin(self,fname,line,label_name,begin_line):
    self.data[fname][label_name] = {'content':'', 'begin_line':begin_line}
    self.block_count += 1

  def block_end(self,fname,line,label_name,end_line):
    self.data[fname][label_name]['end_line'] = end_line

  def block_inside(self,fname,label_name,content,lnum):
    self.data[fname][label_name]['content'] += content

class Regen:

  def __init__(self,root):
    self.root = root

  def traverse_dir(self,dname,pre_open_fn=None,block_begin_fn=None,block_end_fn=None,block_inside_fn=None,post_open_fn=None,block_outside_fn=None):
    dname = os.path.normpath(dname)
    if not os.path.exists(dname):
      raise UserError("Input directory {0} does not exist".format(dname))
    for root,dirs,files in os.walk(dname):
      for file in files:
        self.parse_file(os.path.abspath(root+os.sep+file),pre_open_fn,block_begin_fn,block_end_fn,block_inside_fn,block_outside_fn,post_open_fn)

  def parse_file(self,fname,pre_open_fn=None,block_begin_fn=None,block_end_fn=None,block_inside_fn=None,block_outside_fn=None,post_open_fn=None):
    fname = os.path.normpath(fname)
    in_block = False
    label_name = ""
    if (pre_open_fn != None):
      if pre_open_fn(fname)==False:
        return
    try:
      with open(fname,'r') as fs:
        for lnum,line in enumerate(fs):
          match = re.search(r"^\s*(\/{2}|#+) pragma uvmf custom (\w+) (begin|end)",line)
          if match:
            # Found a pragma
            label_type = match.group(3)
            # Determine if label type + current state is valid or not
            if (label_type == 'begin') & (in_block == True):
              raise UserError("Detected beginning of nested custom block:\n  File: {0}\n  Line number: {1}\n  Previous label: {2}\n  New label: {3}".format(fname,lnum+1,label_name,match.group(2)))
            elif (label_type == 'end') & (in_block == False):
              raise UserError("Detected end of custom block with no begin:\n  File: {0}\n  Line number: {1}\n  Label: {2}".format(fname,lnum+1,match.group(2)))
            elif label_type == 'begin':
              # Beginning of new label. Log it and move on to next line
              label_name = match.group(2)
              in_block = True
              begin_line = lnum+1
              # Call function for beginning of label
              if (block_begin_fn != None):
                block_begin_fn(fname,line,label_name,begin_line)
            else:
              # End of label
              in_block = False
              # Check that the name of the end label matches the begin
              if match.group(2) != label_name:
                raise UserError("Detected end of custom block with incorrect label:\n  File: {0}\n  Line number: {1}\n  Previous begin label: {2}\n  Incorrect end label: {3}".format(fname,lnum+1,label_name,match.group(2)))
              if (block_end_fn != None):
                if block_end_fn(fname,line,label_name,lnum+1)==False:
                  continue
          elif in_block == True:
            if (block_inside_fn != None):
              block_inside_fn(fname,label_name,line,lnum+1)
          else:
            if (block_outside_fn != None):
              block_outside_fn(fname,line,lnum+1)
    except UnicodeDecodeError:
      # This can occur if reading a binary file with Python3. It's OK, just give up and move
      # to the next file.
      return
    # If we finish parsing the file and we still think we're in a pragma block, flag it as an error
    if (in_block==True):
      raise UserError("Reached end of file while still in custom block:\n  File: {0}\n  Label: {1}\n  Label start line:{2}".format(fname,label_name,begin_line))
    if (post_open_fn != None):
      post_open_fn(fname)
