WRITE BACKUP VERSION CONTROL
===============================================================================
_by Ingo Karkat_

Version control functions (diff, restore, history navigation) for backups made
with the writebackup plugin, which have a date file extension in the format
'.YYYYMMDD[a-z]'.

DESCRIPTION
------------------------------------------------------------------------------

This plugin enhances the primitive file backup mechanism provided by
writebackup.vim with some functions of real revision control systems like
CVS, RCS or Subversion - without additional software.
Via Vim commands, you can list and go to all backup versions that exist for
the current file, check whether you have a current backup, backup the saved
version of the buffer even after you've made unsaved changes in the buffer
(which is useful for after-the-fact backups).
Within Vim, you can create a diff with the previous version, restore the
current file from its predecessor or any other backed-up version.

USAGE
------------------------------------------------------------------------------

    :WriteBackupListVersions
                            List all backup versions that exist for the current
                            file. If the file isn't the original, it is marked in
                            the version list. If the file is the original, the
                            time that has passed since the last backup is printed,
                            too.

    :[count]WriteBackupGoPrev[!]
    :[count]WriteBackupGoNext[!]
                            Open a backup file version relative to the current
                            backup or original file (with 'readonly' set to
                            prevent accidental edits) . You can skip multiple
                            backups via the optional [count]; if the resulting
                            index is out of bounds, the first / last available
                            backup version is edited.
                            Thus, :999WriteBackupGoPrev edits the very first
                            existing backup, and :999WriteBackupGoNext edits the
                            latest (i.e. most recent) backup.
                            With [!], any changes to the current version are
                            discarded.

    :WriteBackupGoOriginal[!]
                            Edit the original of the current backup file. If
                            backups are stored in a different directory, it may
                            not be possible to determine the original file. With
                            [!], any changes to the current version are discarded.

    :WriteBackupIsBackedUp
                            Check whether the latest backup is identical to the
                            (saved version of the) current file (which must be the
                            original file).

    :[count]WriteBackupDiffWithPred
                            Perform a diff of the current file (which may be the
                            original file or any backup) with the [count]'th
                            previous version. If the resulting index is out of
                            bounds, the first available backup version is used.
                            The diff is done inside Vim, with a new :diffsplit
                            being opened.

    :[count]WriteBackupViewDiffWithPred [{diff-arguments}]
                            Show the differences of the current file (which may be
                            the original file or any backup) with the [count]'th
                            previous version. If the resulting index is out of
                            bounds, the first available backup version is used.
                            The diff output is opened in a split scratch buffer.
                            Any {diff-arguments} are passed as-is to the diff
                            executable. The "icase" and "iwhite" settings of
                            'diffopt' are used, too.
                            The current working directory is used as the diff root
                            directory (in which the diff command will be invoked)
                            You can set the diff root via:
                            :lcd {diff-root} | WriteBackupViewDiffWithPred | lcd -
                            Use the :saveas command if you want to persist the
                            diff scratch buffer on disk. Rename the scratch buffer
                            via the :file command if you want to keep it and
                            prevent further updates.
              + [count]du
                            By repeating the command, an existing scratch buffer
                            is updated; no new split is created. One can also
                            update the differences by repeating
                            :WriteBackupViewDiffWithPred in the diff scratch
                            buffer itself, or through the buffer-local [count]du
                            mapping. The mapping will update with the same diff
                            options used previously; the command can be repeated
                            with the same or different {diff-arguments}. For
                            example, you can change a context diff created via
                                :WriteBackupViewDiffWithPred -c
                            into the unified format by repeating via
                                :WriteBackupViewDiffWithPred -u
                            If you repeat with a [count], a new predecessor is
                            chosen for the updated diff; the newer file is kept.

    :[count]WriteBackupDiffDaysChanges
                            Perform a diff of the current file (which may be the
                            original file or any backup) with today's (or
                            [count] - 1 days ago) first backup.
                            The diff is done inside Vim, with a new :diffsplit
                            being opened.

    :[count]WriteBackupViewDaysChanges [{diff-arguments}]
                            Show the differences of the current file (which may be
                            the original file or any backup) with today's (or
                            [count] - 1 days ago) first backup.
                            The diff output is opened in a split scratch buffer.

    :[count]WriteBackupRestoreFromPred[!]
                            Overwrite the current file (which must be the
                            original) with the [count]'th previous backup. With
                            [!] skips confirmation dialog and allows to restore
                            over readonly original file.

    :WriteBackupRestoreThisBackup[!]
                            Restore the current file as the original file, which
                            will be overwritten. With [!] skips confirmation
                            dialog and allows to restore over readonly original
                            file.

    :WriteBackupOfSavedOriginal[!]
                            Instead of backing up the current buffer, back up the
                            saved version of the buffer. This comes handy when you
                            realize you need a backup only after you've made
                            changes to the buffer.
                            With [!], creation of a new backup file is forced:
                            - even if the last backup is identical
                            - even when no more backup versions (for this day) are
                              available (the last '.YYYYMMDDz' backup gets
                              overwritten, even if it is readonly)

    :WriteBackupDeleteLastBackup[!]
                            Delete the last backup. With [!] skips confirmation
                            dialog and allows to delete readonly backup file.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-writebackupVersionControl
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim writebackupVersionControl*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the writebackup.vim plugin ([vimscript #1828](http://www.vim.org/scripts/script.php?script_id=1828)), version 2.00 or
  higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.022 or
  higher.
- External command "cmp" or "diff" (or equivalent) for comparison.
- External command "diff" or equivalent for listing of differences.
- External commands "cp" (Unix) / "copy" and "xcopy" (Windows) for restore
  and backup original file functionality.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

To change the default diffsplit from vertical to horizontal, use:

    let g:WriteBackup_DiffVertSplit = 0

The :WriteBackupIsBackedUp command uses an external compare command (either
"cmp -s" or "diff -q") to determine whether the backup is identical with the
original file. You can overwrite the auto-detected default via:

    let g:WriteBackup_CompareShellCommand = '/path/to/mycomparecmd --myoption'

The command must take two filespec arguments, return 0 for identical files, 1
for different files and anything else for trouble.

The :WriteBackupViewDiffWithPred command invokes an external diff command to
list the differences between two files. Overwrite if "diff" cannot be found
through $PATH:

    let g:WriteBackup_DiffShellCommand = '/path/to/mydiff'

Command-line arguments for the external diff command can be specified
separately. Configure any arguments that should always be passed here:

    let g:WriteBackup_DiffCreateAlwaysArguments = '-t -F "^[_a-zA-Z0-9]+ *("'

If no {diff-arguments} are passed to the :WriteBackupViewDiffWithPred
command, the default diff output format is set to the unified format. You can
for example change this to a context diff by setting:

    let g:WriteBackup_DiffCreateDefaultArguments = '-c'

The :WriteBackupViewDiffWithPred command opens the diff scratch buffer via
the :new command. You can add window command modifiers like :vertical or
:topleft to change the positioning of the window:

    let g:WriteBackup_ScratchBufferCommandModifiers = 'topleft'

IDEAS
------------------------------------------------------------------------------
- Implement s:Copy() via readfile() / writefile() Vim functions in binary mode
  as a fallback or configurable?
- Use readfile() when diff not available (or as an optimization to avoid
  spawning a shell on Windows)? Maybe just checking the first n lines?

### CONTRIBUTING

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-writebackupVersionControl/issues or email
(address below).

HISTORY
------------------------------------------------------------------------------

##### 3.22    02-Apr-2020
- FIX: Avoid "E16: Invalid range" in
  writebackupVersionControl#GetAllBackupsForFile() with a filename containing
  "[[" by escaping the filespec for wildcard characters.
- Make Unix 'cp' command configurable via g:WriteBackupCopyShellCommand.
- Support non-GNU cp command (e.g. on BSD) that doesn't support the
  --preserve=timestamp argument by making it configurable
  (g:WriteBackupCopyPreserveArgument) and implemening a heuristic that falls
  back to the POSIX -p option if the original cp command failed.
- Use ingo#compat#glob().
- ingo#buffer#scratch#Create() from ingo-library.vim version 1.024 doesn't
  position the cursor on the first line any more; explicitly do this, as the
  alternative condition of the potential original cursor position restore
  depends on this.
- :WriteBackupViewDiffWithPred: Keep the same 'iskeyword' value as the
  original buffer's. Makes it easier to search across diff and original with
  star.
- Inconsistency: :WriteBackupOfSavedOriginal keeps executable attributes,
  whereas :WriteBackup normally doesn't. The general discrepancy is that the
  'cp' command by default preserves the attributes, whereas a :write from
  within Vim doesn't. Add --no-preserve=mode to
  g:WriteBackupCopyPreserveArgument.

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.022!__

##### 3.21    29-Jan-2014
- Implement abort on error for all commands.
- CHG: writebackupVersionControl#ListVersions() now indicates no backups exist
  with 2 instead of 0.
- CHG: writebackupVersionControl#RestoreThisBackup(),
  writebackupVersionControl#RestoreFromPred(),
  writebackupVersionControl#DeleteBackupLastBackup() now indicate user decline
  with 2 instead of 0.
- Keep the same 'fileformat' as the original buffer's on
  :WriteBackupViewDiffWithPred. This matters when the diff is persisted as a
  patch.
- Add dependency to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)).

__You need to separately
  install ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.013 (or higher)!__

##### 3.20    14-Dec-2012
- ENH: Allow to override g:WriteBackup\_DiffCreateAlwaysArguments and
  g:WriteBackup\_DiffCreateDefaultArguments with buffer-local variables; e.g.
  to provide a filetype-specific "--show-function-list" diff argument.
- ENH: When the current window is in diff mode, "inherit" the participation in
  the diff to the next backup file on :WriteBackupGo\* commands, as the user
  probably wants to continue comparing them.
- BUG: On Windows, when file backups exist in different upper-/lowercase
  versions, the ordering of :WriteBackupListVersions and
  :WriteBackupGoPrev/Next are broken.

##### 3.10    20-Feb-2012
- ENH: Add :WriteBackupDiffDaysChanges and :WriteBackupViewDaysChanges.

##### 3.00    16-Feb-2012
- ENH: New writebackup.vim default "redate" for
g:WriteBackup\_AvoidIdenticalBackups that renames an identical backup from an
earlier date to be the first backup of today is also used for
:WriteBackupOfSavedOriginal. The changes now require version 3.00 of both
plugins.

##### 2.30    14-Feb-2012
- ENH: On Windows, :WriteBackupOfSavedOriginal now updates the modification
  date (via a "copy" trick), and on Unix, :WriteBackupRestoreThisBackup /
  :WriteBackupRestoreFromPred now keep the backup's modification date.
- Expose many internal functions and make all autoload functions behind the
  various commands now also indicate their success via a boolean / numeric
  return value.

##### 2.25    07-Oct-2011 (unreleased)
- Use ingodate#HumanReltime() for a more human output of elapsed time since last
backup.

##### 2.24    12-Feb-2010
- ENH: Define a local 'du' mapping to quickly update the diff (of the same
  version and with the same options as this time), unless [count] is given,
  which sets a different version).
- :WriteBackupViewDiffWithPred not just checks for empty scratch buffer, but
  also considers the diff command exit code.
- BUG: :WriteBackupViewDiffWithPred can cause E121: Undefined variable:
  l:predecessor. Similar issue with a:filespec showing scratch buffer name in
  place of the original file name. Now using l:oldFile and l:newFile instead.
- BUG: WriteBackupViewDiffWithPred didn't always go back to the original
  window when no differences, but fell back to the next one.

##### 2.23    26-Oct-2009
- ENH: :WriteBackupRestoreFromPred now takes an optional [count] to restore an
earlier predecessor.

##### 2.22    19-Aug-2009
- BF: escapings#shellescape() caused E118 on Vim 7.1. The shellescape({string})
function exists since Vim 7.0.111, but shellescape({string}, {special}) was
only introduced with Vim 7.2. Enhanced wrapper function.

##### 2.21    16-Jul-2009
- Replaced simple filespec quoting with built-in shellescape() function (or
  emulation for Vim 7.0 / 7.1) via escapings.vim wrapper.
- Keeping cursor position when only refreshing the diff scratch buffer.
- Window position of the diff scratch buffer can now be configured.
- ENH: Now issuing a warning that there are no differences and closing the
  useless diff scratch buffer if it is empty.
- BF: Forgot {special} in shellescape() call for
  writebackupVersionControl#ViewDiffWithPred(); the scratch buffer uses the !
  command.

##### 2.20    09-Jul-2009
- ENH: Added :WriteBackupViewDiffWithPred command to show the diff output in a
scratch buffer. With this, one can get a quick overview of what has changed
since the last backup without performing a diffsplit within Vim.

##### 2.11    24-Jun-2009
- ENH: :WriteBackupDiffWithPred now takes an optional [count] to diff with an
earlier predecessor.

##### 2.10    27-May-2009
- Replaced simple filespec escaping with built-in fnameescape() function (or
emulation for Vim 7.0 / 7.1) via escapings.vim wrapper.

##### 2.01    11-May-2009
- Backup versions are now opened read-only (through :WriteBackupGoPrev/Next and
:WriteBackupDiffWithPred commands) to prevent the user from accidentally
editing the backup instead of the original.

##### 2.00    22-Feb-2009
- Using separate autoload script to help speed up Vim startup. This is an
  incompatible change that also requires the corresponding writebackup plugin
  version.

__PLEASE UPDATE writebackup ([vimscript #1828](http://www.vim.org/scripts/script.php?script_id=1828)), too__
- BF: :WriteBackupListVersions now handles (and reports) backup files with a
  future date.
- ENH: Allowing to configure compare shell command via
  g:WriteBackup\_CompareShellCommand.
- ENH: Added :WriteBackupDeleteLastBackup command.
- ENH: Added [!] to the following commands to disable confirmation dialog and
  override readonly target files: :WriteBackupRestoreFromPred,
  :WriteBackupRestoreThisBackup, :WriteBackupOfSavedOriginal,
  :WriteBackupDeleteLastBackup

##### 1.41    16-Feb-2009
- Split off documentation into separate help file. Now packaging as VimBall.

##### 1.40    11-Feb-2009
- Renamed configuration variable from g:writebackup\_DiffVertSplit to
  g:WriteBackup\_DiffVertSplit.

__PLEASE UPDATE YOUR CONFIGURATION__
- ENH: Added :WriteBackupGoPrev, :WriteBackupGoNext and :WriteBackupGoOriginal
  commands.
- ENH: :WriteBackupListVersions now includes backup dirspec if backups aren't
  done in the original file's directory.
- BF: :WriteBackupDiffWithPred failed to open the predecessor with the ':set
  autochdir' setting if the CWD has been (temporarily) changed. Now using
  absolute path for the :split command.
- :WriteBackupDiffWithPred doesn't jump to the predecessor window; it now
  moves the cursor back to the originating window; this feels more natural.
- :WriteBackupDiffWithPred now avoids that a previous (open) fold status at
  the cursor position is remembered and obscures the actual differences.
- Added Windows detection via has('win64').

##### 1.20    30-Dec-2007
- Small Enhancement: :WriteBackupListVersions and :WriteBackupDiffWithPred
claimed "no backups exist" if option 'wildignore' hides the backup files. Now
temporarily resetting the option before glob().

##### 1.20    18-Sep-2007
- ENH: Added support for writing backup files into a different directory
  (either one static backup dir or relative to the original file). Now
  requires writebackup version 1.20 or later.
- Command :WriteBackupOfSavedOriginal now checks that the file is an original
  one.
- BF: :WriteBackupIsBackedUp doesn't deal correctly with filenames that
  contain special Ex characters [%#!].

##### 1.00    07-Mar-2007
- Added documentation. First release.

##### 0.01    30-Oct-2006
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2007-2020 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
