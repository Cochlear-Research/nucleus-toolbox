""" Current law calculations for CIC3 and CIC4 implants.
The methods and functions can be passed either scalar values (float or int)
or numpy arrays, and return the corresponding type.
"""
################################################################################
# Authors: Brett Swanson
# Copyright (c) Cochlear Ltd
################################################################################

from abc import ABC
import numpy as np

################################################################################


class Current(ABC):
    """Abstract base class for implant current level calculations.
    There is no need to create instances of its subclasses,
    as all methods are classmethods.
    CIC3 and CIC4 current laws are similar enough that they both can be implemented by
    the set of methods in this class.
    The sub-classes define appropriate constants.
    """

    MAX_CURRENT_LEVEL = 255
    MAX_CURRENT_uA = 1750.0

    @classmethod
    def calc_ratio_from_CL(cls, current_level: int) -> float:
        """Calculate the ratio that the current is multiplied by
        for a specified change in current_level.

        Args:
            current_level (int): the change in current level.
        Returns:
            float: the ratio that the current is multiplied by.
        """
        return cls.BASE ** (current_level / cls.MAX_CURRENT_LEVEL)

    @classmethod
    def calc_CL_from_ratio(cls, ratio: float) -> float:
        """Calculate the number of current level steps
        that multiplies the current by the specified ratio.

        Args:
            ratio (float): the current ratio.
        Returns:
            float: the number of current level steps.
        """
        return cls.MAX_CURRENT_LEVEL * np.emath.logn(cls.BASE, ratio)

    @classmethod
    def calc_uA_from_CL(cls, current_level: int) -> float:
        """Convert current level to microamps.

        Args:
            current_level (int): the current level.
        Returns:
            float: the current (in microamps).
        """
        return cls.MIN_CURRENT_uA * cls.calc_ratio_from_CL(current_level)

    @classmethod
    def calc_CL_from_uA(cls, current_uA: float, rint: bool = True) -> int:
        """Convert microamps to current level.

        Args:
            current_uA (float): the current (in microamps).
            rint (bool): whether to round and return integers (default: True)
        Returns:
            int: the current level.
        """
        cl = cls.calc_CL_from_ratio(current_uA / cls.MIN_CURRENT_uA)
        if rint:
            cl = np.rint(cl).astype(int)
        return cl

    @classmethod
    def calc_impedance(cls, voltage: float, current_level: int) -> float:
        """Calculate electrode impedance.
        Raises ZeroDivisionError if current_level is zero for CIC4.

        Args:
            voltage (float): the electrode voltage (in volts).
            current_level (int): the current level.
        Returns:
            float: the impedance (in ohms).
        """
        current_uA = cls.calc_uA_from_CL(current_level)
        return calc_impedance(voltage, current_uA)

    @classmethod
    def calc_CL_for_voltage(cls, impedance: float, voltage: float) -> int:
        """Calculate the current level needed to produce an electrode voltage.

        Args:
            impedance (float): the electrode impedance (in ohms).
            voltage (float): the electrode voltage (in volts).
        Returns:
            int: the current level.
        """
        current_uA = voltage * 1e6 / impedance
        return cls.calc_CL_from_uA(current_uA)


################################################################################


class CIC3(Current):
    """Concrete class implementing CIC3 current law."""

    MIN_CURRENT_uA = 10.0
    BASE = Current.MAX_CURRENT_uA / MIN_CURRENT_uA


################################################################################


class CIC4Ideal(Current):
    """Concrete class implementing idealised CIC4 current law."""

    MIN_CURRENT_uA = 17.5
    BASE = Current.MAX_CURRENT_uA / MIN_CURRENT_uA


################################################################################


class CIC4(CIC4Ideal):
    """Concrete class implementing actual CIC4 current law.
    CL = 0 is treated specially and gives zero current.
    """

    @classmethod
    def calc_uA_from_CL(cls, current_level: int) -> float:
        """Convert current level to microamps.

        Args:
            current_level (int): the current level.
        Returns:
            float: the current (in microamps).
        """
        ua = CIC4Ideal.calc_uA_from_CL(current_level)
        return ua * (current_level > 0)


################################################################################


def calc_impedance(voltage: float, current_uA: float) -> float:
    """Calculate impedance (standard formula).

    Args:
        voltage (float): the electrode voltage (in volts).
        current_uA (float): the current (in microamps).
    Returns:
        float: the impedance (in ohms).
    """
    return 1.0e6 * voltage / current_uA
