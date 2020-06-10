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

echo "ACCURACY,UAR" > ${results_file}
show_command "audeep mlp evaluate --quiet --input ${fused_file} --cross-validate --shuffle --num-epochs ${mlp_num_epochs} --learning-rate ${mlp_learning_rate} --keep-prob ${mlp_keep_prob} --num-layers ${mlp_num_layers} --num-units ${mlp_num_units} --repeat ${mlp_repeat} | tee -a ${results_file}"

audeep mlp evaluate \
	--quiet \
	--input ${fused_file} \
	--cross-validate \
	--shuffle \
	--num-epochs ${mlp_num_epochs} \
	--learning-rate ${mlp_learning_rate} \
	--keep-prob ${mlp_keep_prob} \
	--num-layers ${mlp_num_layers} \
	--num-units ${mlp_num_units} \
	--repeat ${mlp_repeat} | tee -a ${results_file}
