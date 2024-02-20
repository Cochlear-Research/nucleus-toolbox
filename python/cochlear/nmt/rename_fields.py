""" Python script to rename fields from previous versions of NMT to NMT 5.0
"""
################################################################################
# Authors: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

from replace_in_files import Replacement, main

################################################################################

# fmt: off
renames = [
    ("agc_attack_time",     "agc_attack_time_s"),
    ("agc_release_time",    "agc_release_time_s"),
    ("audio_sample_rate",   "audio_sample_rate_Hz"),
    ("analysis_rate",       "analysis_rate_Hz"),
    ("band_widths",         "band_widths_Hz"),
    ("bin_freq",            "bin_freq_Hz"),
    ("bin_freqs",           "bin_freqs_Hz"),
    ("channel_stim_rate",   "channel_stim_rate_Hz"),
    ("char_freqs",          "best_freqs_Hz"),
    ("comfort_levels",         "upper_levels"),
    ("crossover_freqs",     "crossover_freqs_Hz"),
    ("period",              "period_us"),
    ("periods",             "periods_us"),
    ("phase_gap",           "phase_gap_us"),
    ("phase_gaps",          "phase_gaps_us"),
    ("phase_width",         "phase_width_us"),
    ("phase_widths",        "phase_widths_us"),
    ("response_freqs",      "response_freqs_Hz"),
    ("RF_clock",            "RF_clock_Hz"),
    ("sample_rate",         "sample_rate_Hz"),
    ("threshold_levels",       "lower_levels"),
]
# fmt: on

replacements = [Replacement(r"([.'])" + old + r"\b", r"\1" + new) for (old, new) in renames]
main(replacements, "**/*.m")


