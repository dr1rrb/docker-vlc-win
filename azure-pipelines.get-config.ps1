# $Env:BUILD_ARTIFACTSTAGINGDIRECTORY = "C:\test"
# $Env:VLC_VERSION = "3.0.6";
# $Env:VLC_LATEST = "3.0.7.1";

$version = $Env:VLC_VERSION;
$latest = $Env:VLC_LATEST;
$tags = $Env:VLC_TAGS;

# Capture all variables prefixed by VLC
# $variables = "Env:VLC_*" | Get-Item | Select @{l="Key";e={$_.Name.ToString().Split('_')[1].ToLower()}}, Value
$variables = @{}
"Env:VLC_*" | Get-Item | ForEach { $variables[$_.Name.ToString().Split('_')[1].ToLower()] = $_.Value }

# Coalesce inputs
if ( $variables['version'] -like '') { $variables['version'] = $latest }
if ( $variables['tags'] -like '') { 
    if ($variables['version'] -like $latest) { $variables['tags'] = 'latest' }
    else { $variables['tags'] = '' }
}

# Set build variables (And dump to file for release pipeline)
$variables.keys | ForEach { "##vso[task.setvariable variable=vlc."+$_+"]"+ $variables[$_] | Write-Host }
$variables.keys | ForEach { "##vso[task.setvariable variable=vlc."+$_+"]"+ $variables[$_] } > "config.txt"

# Dump to ouput
$variables