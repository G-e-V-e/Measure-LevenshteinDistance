# Measure-LevenshteinDistance
Measures the Levenshtein Distance between two strings.

The Levenshtein Distance is the number of changes it takes to get from one string to another.	This is one way of measuring the differences between 2 strings.
This script is a (slightly extended) PowerShell implementation of that algorithm, which is available also in other programming languages.

If either string is omitted (has length = 0), the number of changes/distance between them is simply the length of the other string.

Differences between capital and small letters can be ignored with the -IgnoreCase switch.

If you're interested in the percentage of required changes (relative to the longest string) rather than the number of changes, use the -Percent switch.

Examples:

    Measure-LevenshteinDistance -First 'test' -Second 'Testx'
    2
    
    Measure-LevenshteinDistance -First 'test' -Second 'Testx' -IgnoreCase
    1
    
    Measure-LevenshteinDistance 'test' 'Hello'
    4
    
    Measure-LevenshteinDistance 'test' 'testx' -Percent
    20

Performance warning: the 2 input strings will result in a (First.length x Second.length) matrix being generated and calculated. For moderate string lengths (such as 1000 x 1000) performance stays within a few seconds at most, but VERY long strings tend to take forever to get compared/measured with this algorithm. There are certainly (compiled) implementations that work faster, or other ways to handle that situation.

Capacity warning: while performance will hit the wall first for day-to-day usage, capacity could become an issue for EXTEMELY long strings. The largest book in the world contains around 65 million characters, this [int] (integer) type implementation allows for strings over 33.000 bigger, but it's still a limit. To extend that limit further, replacing type [int] by [uint32] will double the capacity, replacing type [int] by [int64] or even [uint64] will put the capacity to unrealistic limits.
