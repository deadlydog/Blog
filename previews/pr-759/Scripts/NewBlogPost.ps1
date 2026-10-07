# Run this script to create a new blog post in the _drafts directory and create a directory for its assets as well.

[string] $title = Read-Host -Prompt "What is the title of the new blog post? (with spaces, capitalization, apostrophes, etc.)"

[string] $specialCharactersRemovedTitle = $title -replace "[+']", ""
[string] $doubleSpacesRemovedTitle = $specialCharactersRemovedTitle -replace "\s+", " "
[string] $sanitizedTitle = $doubleSpacesRemovedTitle -replace "[^a-zA-Z0-9-]", "-"
[string] $newPostFileNameWithoutExtension = "$(Get-Date -Format 'yyyy-MM-dd')-$sanitizedTitle"
[string] $newPostFilePath = "$PSScriptRoot\..\_drafts\$newPostFileNameWithoutExtension.md"
[string] $newPostAssetDirectoryPath = "$PSScriptRoot\..\assets\Posts\$newPostFileNameWithoutExtension"

[string] $templatePostFileNameWithoutExtension = '2099-01-15-Template-post'
[string] $templatePostFilePath = "$PSScriptRoot\..\_drafts\$templatePostFileNameWithoutExtension.md"

# Create the new post file from the template.
Copy-Item -Path $templatePostFilePath -Destination $newPostFilePath

# Update the template content with the new post title.
$fileContent = Get-Content -Path $newPostFilePath
$fileContent = $fileContent -replace $templatePostFileNameWithoutExtension, $newPostFileNameWithoutExtension
$fileContent = $fileContent -replace "Template post", $title
$fileContent = $fileContent -replace "Template-post", $sanitizedTitle
Set-Content -Path $newPostFilePath -Value $fileContent

# Create a directory to store the assets for the new post.
New-Item -Path $newPostAssetDirectoryPath -ItemType Directory

# Open the new post file in Visual Studio Code.
code $newPostFilePath
