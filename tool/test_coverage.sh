#!/bin/bash

dart test --coverage='coverage' && format_coverage --lcov --in=coverage --out=coverage.lcov --report-on=lib && genhtml coverage.lcov -o coverage/