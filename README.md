utils
=====

Standalone utilities and misc notes on system configuration.

Gokberk Cinbis, 2018.

## Text and TeX utilities

* `alignassign`                                 Align assignment statements in source codes.
* `aligntable`                                  Align table columns. Particularly useful for latex tables via vim & emacs.
* `bibrmfield`                                  Clean-up bib files easily.
* `eq2eps,eq2png`                               Generate eps, png files for LaTeX equations.
* `pdflatex-remote`                             Compile tex project via a remote server.
* `strrep`                                      Find and replace patterns in stdin or files.
* `tex/`                                        Collection of useful files (Makefile, .gitignore, macros) for LaTeX documents.
* `turkish-deasciify-selection-to-clipboard`    turkish-deasciify selection-to-clipboard.
* `unaccent`                                    Replace accented letters with ASCII ones.
* `vip`                                         Open files containing <pattern> in vim as tabs.

## PDF utilities

* `catpdf`                                      Concatenate multiple pdf files into a single one.
* `mypdfdiff`                                   Diff two pdfs.
* `pdf-add-header-all-pages`                    Add a custom header to all pages of a pdf file.
* `pdf-add-header-first-page`                   Add a custom header to the first page of a pdf file.
* `pdf-print-two-sided`                         Create and succesively open two pdf files to simplify manual double-sided printing.

## Web utilities

* `bib2html`                                    Auto-create bibliography web page based on a jinja template and YAML-formatted data.
* `getpdfXplore`                                Download papers by ID from IEEE Xplore (requires institutional/login-free subscription).
* `minify-css`                                  Script for minifying CSS files.

## Git utilities

* `git-checkhash`                               Check whether the current git hash to make sure the right code-base is being used for evaluating a pre-trained model.
* `git-find-deleted-file`                       A git shortcut.
* `git-remember-passwords`                      Wrapper to set-up git password cache easily.
* `git-uniqueid`                                Generate a unique id for the current source code.
* `git-writehash`                               Write git hash into a file.
* `gitsyncroot-nomsg-periodic`                  Periodically run gitsyncroot-nomsg in the current repository.

## System utilities

* `du-sorted`                                   Compute size of a list of files/directories, print in sorted and human readable form.
* `findgrep`                                    Easy to use find and grep combinator.
* `gnome-color-temperature`                     Shortcuts to alter Gnome color temperature settings.
* `gnome-remotedesktop-toggleprompt`            Enable/disable Gnome Shell remote desktop prompt for security purposes.
* `killapp`                                     Send KILL signal to user processes matching to a regular expression.
* `mv-addmoddate`                               Add modification date to filename and move to a target directory.
* `mvln`                                        Move and link shortcut.
* `parse-path`                                  A well-designed path parsing tool.
* `psapp`                                       List user processes matching to a regular expression.
* `strrep`                                      String find-and-replace.
* `tmux-parallel-exec-at-dirs`                  Execute one command in parallel at multiple directories within tmux panes & windows.
* `tmux-parallel-exec`                          Execute multiple commands in parallel within tmux panes & windows.

## File conversion

* `images2powerpoint`                           Convert a series of images to a powerpoint presentation.
* `img2canon`                                   Convert image file into a format readable by Canon printers.
* `video2ipad`                                  Convert video file to iPad-compatible format (not perfect, though).
* `video2mp3`                                   Convert video file to mp3.
* `video2mp4`                                   Convert video file to mp4.
* `video2tv`                                    Convert image file into a mp4 file readable by most TVs.

## Zotero-related tools

* `zotero-find-nonlinked-attachments`           Find non-linked zotero attachments using a library export.

## Academic tools

* `proceedings/`                                Scripts to download/collect some conferences' bibliographies.

## Python tools

* `assert-conda`                                Verifies that the conda environment is fully active.

## Misc notes

* [How to share printer from Linux to Mac](notes/LinuxToMacPrinterShare.md) 




