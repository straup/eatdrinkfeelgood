#!/usr/bin/env python

import sys

from erdfg.writer import writer

wr = writer(sys.argv[1])
wr.text()
