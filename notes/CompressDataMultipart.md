How to compress data folder into a multi-part archive
=====================================================

Below is a tar-bz2 based example. Avoid the zip format, which requires attention to avoid problems with
large-files.

'''
tar -cvjf - data | split -b 24M - data_compressed/data.tar.bz2.part # compress
cat data_compressed/data.tar.bz2.part* | tar -xvjf - # uncompress
'''

