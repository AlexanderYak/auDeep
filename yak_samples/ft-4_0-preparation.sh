#!/bin/bash
# Copyright (C) 2017-2018 Michael Freitag, Shahin Amiriparian, Sergey Pugachevskiy, Nicholas Cummins, Björn Schuller
#
# This file is part of auDeep.
#
# auDeep is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# auDeep is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with auDeep. If not, see <http://www.gnu.org/licenses/>.

. config.sh

#########################################################
# 0. PREPARATION
#########################################################

# Check if the ESC-10 data set is present at the expected location. 
if [ ! -d ${audio_base} ]; then
    show_error "ft-4 data set not present at ${audio_base}"
fi

show_info "Data set present at ${audio_base}"

# Check if auDeep has been properly installed
show_command "audeep --version > /dev/null || (show_error \"Could not execute 'audeep --version' - please check your installation\"; exit 1)"
