class Candidate
{
  [String]$word
  [String]$kind
  [String]$menu
}

function Serialize-Candidate([Candidate]$candidate)
{
  return ($list | )
}

$parsedInput = [System.Management.Automation.CommandCompletion]::MapStringInputToParsedInput("W", 1)

$result = [System.Management.Automation.CommandCompletion]::CompleteInput($parsedInput.Item1, $parsedInput.Item2, $parsedInput.Item3, $null, [System.Management.Automation.PowerShell]::Create()).CompletionMatches

$items = $result | % {New-Object Candidate $_.CompletionText.Replace("'", "") $_.ResultType.ToString() $_.ToolTip.Replace("\r\n", "")}

$list = New-Object System.Collections.Generic.List<Candidate>

$out = "[" + ($list | % {'"word":"' + $_.word + '","kind"'}) + "]"

return $out
