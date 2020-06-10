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
# 2. Autoencoder Training
##########################################################

# Время при запуске скрипта
started=$SECONDS

# Train one autoencoder on each type of spectrogram
for clip_below_value in ${clip_below_values}; do
    # The file containing the extracted spectrograms
    spectrogram_file="${spectrogram_base}/${taskName}-${window_width}-${window_overlap}-${mel_bands}${clip_below_value}.nc"

    # Base directory for the training run
    run_name="${output_base}/${taskName}-${window_width}-${window_overlap}-${mel_bands}${clip_below_value}/t-${num_layers}x${num_units}-${bidirectional_encoder_key}-${bidirectional_decoder_key}"

    # Directory for storing temporary files. The spectrograms are temporarily stored as TFRecords files, in order to
    # be able to leverage TensorFlows input queues. This substantially improves training speed at the cost of using
    # additional disk space.
    temp_dir="${run_name}/tmp"

    if [ ! -d ${run_name} ]; then
        show_command "audeep${verbose_option} t-rae train --input ${spectrogram_file} --run-name ${run_name} --tempdir ${temp_dir} --num-epochs ${num_epochs} --batch-size ${batch_size} --learning-rate ${learning_rate} --keep-prob ${keep_prob} --cell ${cell} --num-layers ${num_layers} --num-units ${num_units}${bidirectional_encoder_option}${bidirectional_decoder_option}"
    
        audeep${verbose_option} t-rae train \
            --input ${spectrogram_file} \
            --run-name ${run_name} \
            --tempdir ${temp_dir} \
            --num-epochs ${num_epochs} \
            --batch-size ${batch_size} \
            --learning-rate ${learning_rate} \
            --keep-prob ${keep_prob} \
            --cell ${cell} \
            --num-layers ${num_layers} \
            --num-units ${num_units}${bidirectional_encoder_option}${bidirectional_decoder_option}
    fi
done

took_seconds=$(( $SECONDS - $started ))
show_info "Training took $took_seconds seconds"
