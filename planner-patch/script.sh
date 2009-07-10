#!/bin/bash

cd ../../
patch -p0 -i planner/planner-patch/evaluation-diff.patch
patch -p0 -i planner/planner-patch/assessment-diff.patch
patch -p0 -i planner/planner-patch/forums-diff.patch
patch -p0 -i planner/planner-patch/file-storage-diff.patch
patch -p0 -i planner/planner-patch/dotlrn-diff.patch
patch -p0 -i planner/planner-patch/dotlrn-portlet-diff.patch
patch -p0 -i planner/planner-patch/theme-zen-diff.patch
