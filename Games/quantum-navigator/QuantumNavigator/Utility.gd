# SPDX-License-Identifier: MIT

# (C) Copyright 2020
# Diversifying Talent in Quantum Computing, Geering Up, UBC

extends Node

# Utility class containing useful methods/definitions

const stats = OtterStats

# Enum definitions for entanglement bit states
enum {
	RED,
	BLUE
}

# Determines whether the otter has available entanglement bits
static func hasBitsToUse() -> bool:
	return hasRedBits() or hasBlueBits()

# Determines whether the otter has available red entanglement bits
static func hasRedBits() -> bool:
	return stats.red_bits >= 1

# Determines whether the otter has available blue entanglement bits
static func hasBlueBits() -> bool:
	return stats.blue_bits >= 1
