#!/usr/bin/env python

import sys

from erdfg.writer import writer
import erdfg.generator.erdfggenerator

wr = writer(sys.argv[1])
wr.erdfg()
