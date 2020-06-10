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

##########################################################
# 1. Spectrogram Extraction
##########################################################

for clip_below_value in ${clip_below_values}; do
    spectrogram_file="${spectrogram_base}/${taskName}-${window_width}-${window_overlap}-${mel_bands}${clip_below_value}.nc"

    if [ ! -f ${spectrogram_file} ]; then
        show_command "audeep preprocess${verbose_option} --basedir ${audio_base} --output ${spectrogram_file} --window-width ${window_width} --window-overlap ${window_overlap} --fixed-length ${fixed_length} --center-fixed --clip-below ${clip_below_value} --mel-spectrum ${mel_bands} --parser ${parser}"
        audeep preprocess${verbose_option} \
        	--basedir ${audio_base} \
        	--output ${spectrogram_file} \
        	--window-width ${window_width} \
        	--window-overlap ${window_overlap} \
        	--fixed-length ${fixed_length} \
        	--center-fixed \
        	--clip-below ${clip_below_value} \
        	--mel-spectrum ${mel_bands} \
        	--parser ${parser}
    else
        show_info "Spectrogram in ${spectrogram_file} already exists"
    fi
done

