#!/bin/bash

verbose_option=""

# Uncomment for debugging of auDeep
verbose_option=" --verbose --debug"

# Uncomment for debugging of shell script
# set -x; 

export PYTHONUNBUFFERED=1
export PYTHONWARNINGS="ignore"

taskName="ft-4"

# base directory for audio files
audio_base="${taskName}/input/data_set"

## Немного красоты
RED='\033[0;41m'
GREEN='\033[1;42m'
BLUE='\033[1;44m'
NC='\033[0m' # No Color

function show_command {
	echo -e "$GREEN[PERFORM]$NC $1"
	echo ""
}

function show_error {
	echo -e "$RED[ ERROR ]$NC \033[1;31m$1$NC"
	exit 1
}

function show_info {
	echo -e "$BLUE[ INFO  ]$NC $1"
}



##########################################################
# 1. Spectrogram Extraction
##########################################################

# We use 80 ms Hann windows to compute spectrograms
window_width="0.08"

# We use 40 ms overlap between windows to compute spectrograms
window_overlap="0.04"

# Mel-scale spectrograms with 128 frequency bands are extracted
mel_bands="128"

# By setting the --fixed-length option, we make sure that all audio files are
# exactly 5 seconds long. This is achieved by cutting or zero-padding audio files as required.
fixed_length="5"

# Parser
parser="audeep.backend.parsers.esc.ESCParser"

# We filter low amplitudes in the spectrograms, which eliminates some background noise. During our preliminary
# evaluation, we found that different classes have high accuracy if amplitudes below different thresholds are
# filtered. Our system normalises spectrograms so that the maximum amplitude is 0 dB, and we filter amplitudes below
# -30 dB, -45 dB, -60 dB and -75 dB.
clip_below_values="-30 -45" # -60 -75"

# Base path for spectrogram files. auDeep automatically creates the required directories for us.
spectrogram_base="${taskName}/input/spectrograms"



##########################################################
# 2. Autoencoder Training
##########################################################

# Network topology:
# =================
# Use two RNN layers in both the encoder and decoder
num_layers="2"

# Use 256 units per RNN layer
num_units="256"

# Use GRU cells
cell="GRU"

# Use a unidirectional encoder and bidirectional decoder. Since this is set via a command line flags instead of command
# line options, we set a key value here which is translated into the correct flags below.
bidirectional_encoder_key="x"
bidirectional_decoder_key="b"
bidirectional_encoder_option=""
bidirectional_decoder_option=""

if [ ${bidirectional_encoder_key} == "b" ]; then
    bidirectional_encoder_option=" --bidirectional-encoder"
fi

if [ ${bidirectional_decoder_key} == "b" ]; then
    bidirectional_decoder_option=" --bidirectional-decoder"
fi

# Network training:
# =================
# Train for 64 epochs, in batches of 64 examples
num_epochs="32"
batch_size="32"

# Use learning rate 0.001 and keep probability 80% (20% dropout).
learning_rate="0.001"
keep_prob="0.8"

# Base path for training runs. auDeep automatically creates the required directories for us.
output_base="${taskName}/output"



##########################################################
# 4. Feature Evaluation
##########################################################

# MLP topology:
# =============
# Use two hidden layers with 150 units each
mlp_num_layers="2"
mlp_num_units="150"

# MLP training:
# =============
# Train for 400 epochs without batching
mlp_num_epochs="400"

# Use learning rate 0.001 and keep probability 60% (40% dropout)
mlp_learning_rate="0.001"
mlp_keep_prob="0.6"

# Repeat evaluation five times and report the average accuracy.
mlp_repeat="5"



##########################################################
# 5. Feature Fusion
##########################################################

# File to which we write the fused representations
fused_file="${output_base}/${taskName}-fused/representations.nc"



##########################################################
# 6. Fused Feature Evaluation
##########################################################

# File to which we write classification results on the fused representations
results_file="${output_base}/${taskName}-fused/results.csv"
