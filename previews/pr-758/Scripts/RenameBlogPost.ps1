# This script prompts the user for the post file to rename, what the new name of the post should be, then
# renames the post file and related asset directory and opens the post in VS Code.

[System.IO.FileInfo[]] $existingPostFiles = Get-ChildItem -Path "$PSScriptRoot\..\_drafts" -Filter "*.md"
$existingPostFiles += Get-ChildItem -Path "$PSScriptRoot\..\_posts" -Filter "*.md"

$postToRename = $existingPostFiles |
	Select-Object -Property Name, FullName |
	Sort-Object -Property Name -Descending |
	Out-GridView -Title "Select the post to rename" -OutputMode Single

Write-Output "The following post will be renamed: $($postToRename.Name)"

[string] $newPostTitle = Read-Host -Prompt "What is the new title of the blog post? (with spaces, capitalization, apostrophes, etc.). Leave blank to use the current title, but potentially a different date"
[string] $newPostDate = Read-Host -Prompt "What should the date of the blog post be? (yyyy-MM-dd). Leave blank to use today's date"

if ([string]::IsNullOrWhiteSpace($newPostTitle)) {
	$newPostTitle =
		Get-Content -Path $postToRename.FullName |
		Select-String -Pattern '^title: \"(.+)\"' | # Capture the title line of the post.
		Select-Object -First 1 | # Only get the first 'title: ' line match.
		ForEach-Object { $_.Matches.Groups[1].Value } # Return the captured title.
}

if ([string]::IsNullOrWhiteSpace($newPostDate)) {
	$newPostDate = Get-Date -Format 'yyyy-MM-dd'
}

[string] $specialCharactersRemovedTitle = $newPostTitle -replace "[+']", ""
[string] $doubleSpacesRemovedTitle = $specialCharactersRemovedTitle -replace "\s+", " "
[string] $sanitizedTitle = $doubleSpacesRemovedTitle -replace "[^a-zA-Z0-9-]", "-"
[string] $newPostFileNameWithoutExtension = "$newPostDate-$sanitizedTitle"
[string] $newPostFilePath = $postToRename.FullName.Replace($postToRename.Name, "$newPostFileNameWithoutExtension.md")

[string] $oldPostFileNameWithoutExtension = $postToRename.Name.Replace(".md", '')
[string] $oldPostSanitizedTitle = $oldPostFileNameWithoutExtension.Substring(11) # Trim the date of the front.
[string] $oldPostAssetDirectoryPath = "$PSScriptRoot\..\assets\Posts\$oldPostFileNameWithoutExtension"

# Rename the post file.
Rename-Item -Path $postToRename.FullName -NewName "$newPostFileNameWithoutExtension.md"

# Update the post content with the new post title.
$fileContent = Get-Content -Path $newPostFilePath
$fileContent = $fileContent -replace $oldPostFileNameWithoutExtension, $newPostFileNameWithoutExtension
$fileContent = $fileContent -replace '^title: \".+\"', "title: ""$newPostTitle""" # Regex replace the entire title line since we don't know the exact format of the post title.
$fileContent = $fileContent -replace $oldPostSanitizedTitle, $sanitizedTitle
Set-Content -Path $newPostFilePath -Value $fileContent

# Rename the post asset directory.
if (Test-Path -Path $oldPostAssetDirectoryPath) {
	Rename-Item -Path $oldPostAssetDirectoryPath -NewName $newPostFileNameWithoutExtension
}

# Open the new post file in Visual Studio Code.
code $newPostFilePath
