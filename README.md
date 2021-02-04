# Measure-LevenshteinDistance
Measures the Levenshtein Distance between two strings.

The Levenshtein Distance is the number of changes it takes to get from one string to another.	This is one way of measuring the differences between 2 strings.
This is a (slightly extended) PowerShell implementation of that algorithm, which is available also in other programming languages.

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
