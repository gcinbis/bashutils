utils
=====

Standalone utilities and misc notes on system configuration.

Gokberk Cinbis, 2018.

## Text and TeX utilities

* `tex/`                                        Collection of Makefile and .gitignore files for LaTeX
* `aligntable`                                  Align table columns. Particularly useful for latex tables via vim & emacs.
* `alignassign`                                 Align assignment statements in source codes.
* `eq2eps,eq2png`                               Generate eps, png files for LaTeX equations.
* `strrep`                                      Find and replace patterns in stdin or files.
* `unaccent`                                    Replace accented letters with ASCII ones.
* `turkish-deasciify-selection-to-clipboard`    turkish-deasciify selection-to-clipboard.

## PDF utilities
* `catpdf`                                      Concatenate multiple pdf files into a single one.
* `mypdfdiff`                                   Diff two pdfs.
* `pdf-add-header-first-page`                   Add a custom header to the first page of a pdf file.
* `pdf-print-two-sided`                         Create and succesively open two pdf files to simplify manual double-sided printing.

## Web utilities

* `getpdfXplore`                                Download papers by ID from IEEE Xplore (requires institutional/login-free subscription).
* `minify-css`                                  Script for minifying CSS files.
* `bib2html`                                    Auto-create bibliography web page based on a jinja template and YAML-formatted data.

## Git utilities

* `git-uniqueid`                                Generate a unique id for the current source code.
* `git-writehash`                               Write git hash into a file.
* `git-checkhash`                               Check whether the current git hash to make sure the right code-base is being used for evaluating a pre-trained model.
* `git-find-deleted-file`                       A git shortcut.
* `git-remember-passwords`                      Wrapper to set-up git password cache easily.
* `gitsyncroot-nomsg-periodic`                  Periodically run gitsyncroot-nomsg in the current repository.

## System utilities

* `du-sorted`                                   Compute size of a list of files/directories, print in sorted and human readable form.
* `mvln`                                        Move and link shortcut.
* `strrep`                                      String find-and-replace.
* `psapp`                                       List user processes matching to a regular expression.
* `killapp`                                     Send KILL signal to user processes matching to a regular expression.
* `gnome-remotedesktop-toggleprompt`            Enable/disable Gnome Shell remote desktop prompt for security purposes.
* `gnome-color-temperature`                     Shortcuts to alter Gnome color temperature settings.
* `parse-path`                                  A well-designed path parsing tool.
* `mv-addmoddate`                               Add modification date to filename and move to a target directory.
* `tmux-parallel-exec`                          Execute multiple commands in parallel within tmux panes & windows.
* `tmux-parallel-exec-at-dirs`                  Execute one command in parallel at multiple directories within tmux panes & windows.

## File conversion

* `video2mp3`                                   Convert video file to mp3.
* `video2mp4`                                   Convert video file to mp4.
* `video2ipad`                                  Convert video file to iPad-compatible format (not perfect, though).
* `video2tv`                                    Convert image file into a mp4 file readable by most TVs.
* `img2canon`                                   Convert image file into a format readable by Canon printers.
* `images2powerpoint`                           Convert a series of images to a powerpoint presentation.

## Zotero-related tools

* `zotero-find-nonlinked-attachments`           Find non-linked zotero attachments using a library export.

## Misc notes

* [How to share printer from Linux to Mac](notes/LinuxToMacPrinterShare.md) 




