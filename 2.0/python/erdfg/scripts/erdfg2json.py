#!/usr/bin/env python

import sys

from erdfg.writer import writer
import erdfg.generator.jsongenerator

wr = writer(sys.argv[1])
wr.json()
