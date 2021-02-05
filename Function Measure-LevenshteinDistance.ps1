<#
.Synopsis
	Measures the Levenshtein Distance between two strings.
.Description
	The Levenshtein Distance is the number of edits it takes to get from one string to another.	This is one way of measuring the differences between 2 strings.
	Many useful purposes that can help in determining if 2 strings are similar possibly with different punctuation or misspellings/typos.
.Inputs
	2 strings to be compared and their dissimilarities counted.
.Outputs
	[int32]		no [switch]Percent
	[double]	if [switch]PercentParameter First
.Parameter First
	The first string to be compared.
.Parameter Second
	The second string to be compared.
.Parameter IgnoreCase
	Switch indicating that differences in capital and small letters only should be ignored.
.Parameter Percent
	Switch specifying that the percentage of edits relative to the longest string should be returned instead of the number of edits required.
.Example
	Measure and output the number of edits required to get from one string to the other.
	Measure-LevenshteinDistance -First 'test' -Second 'Testx'					==> 2 (t>T, +x)
	Measure-LevenshteinDistance -First 'test' -Second 'Testx' -IgnoreCase		==> 1 (+x)
	Measure-LevenshteinDistance 'test' 'Hello'									==> 4 (t>H, s>l, t>l, +o)
.Example
	Funny way to check how much 2 strings differ.
	if	((Measure-LevenshteinDistance 'test' 'Test') -gt 0) {'Different'}		==> 'Different' (t>T)
.Example
	Interprete the percentage of similarity returned to make a (more or less) educated guess about the reasons for that result.
	switch	((Measure-LevenshteinDistance $LongText1 $LongText2 -Percent)
			{
			{$_ -eq 0}		{'Same text!; break}
			{$_ -le 2}		{'Probably just typos'; break}
			{$_ -le 30}		{'Different text, same language?'; break}
			{$_ -le 60}		{'Many differences'; break}
			{$_ -le 90}		{'Very few similarities, other language?'; break}
			{$_ -le 100}	{'Very unlikely, other alphabet?'}
			}
.NOTES
	Author: geve.one2one@gmail.com
#>
Function Measure-LevenshteinDistance
{
[CmdletBinding()]
param	(
		[String]$First,
		[String]$Second,
		[Switch]$IgnoreCase,
		[Switch]$Percent
		)
# No NULL check needed:  PowerShell parameter handling converts Nulls into empty strings (length=0)
$Len1 = $First.Length
$Len2 = $Second.Length

# If either string has length=0, the number of edits/distance between them is simply the length of the other string
if	($Len1 -eq 0)	{if	($Percent)	{Return 100} else	{Return $Len2}}
if	($Len2 -eq 0)	{if	($Percent)	{Return 100} else	{Return $Len1}}

# Make everything lowercase if ignoreCase switch is set
If	($IgnoreCase)	{$First = $First.ToLowerInvariant(); $Second = $Second.ToLowerInvariant()}

# Create 2d Array to store the "distances".
$Dist = New-Object -Type 'int[,]' -arg ($Len1+1),($Len2+1)

# Initialize the first row and first column which represent the 2 strings we're comparing
for	($i = 0; $i -le $Len1; $i++) 	{$Dist[$i,0] = $i}
for	($j = 0; $j -le $Len2; $j++) 	{$Dist[0,$j] = $j}
 
for	($i = 1; $i -le $Len1;$i++)
	{for	($j = 1; $j -le $len2;$j++)
			{
			$Cost = @(0,1)[($Second[$j-1] -cne $First[$i-1])]
			# The value going into the cell is the min of 3 possibilities:
			# 1. The cell immediately above plus 1
			# 2. The cell immediately to the left plus 1
			# 3. The cell diagonally above and to the left plus the 'cost'
			$Dist[$i,$j] = [System.Math]::Min([System.Math]::Min(($Dist[($i-1),$j]+1),($Dist[$i,($j-1)]+1)),($Dist[($i-1),($j-1)]+$Cost))
			}
	}

# The actual distance is stored in the bottom right cell
if		($Percent)
		{$MaxLen = [System.Math]::Max($Len1,$Len2)
		 if	($MaxLen -eq 0) {$MaxLen = 1}
		 return $Dist[$Len1,$Len2]/$MaxLen*100}
else	{return $Dist[$Len1,$Len2]}
}
