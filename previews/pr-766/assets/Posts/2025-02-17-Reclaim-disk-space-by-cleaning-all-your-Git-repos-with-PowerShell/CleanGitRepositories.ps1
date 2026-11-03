[string] $rootDirectoryPath = 'C:\dev\Git'

# Find all '.git' directories below the given path.
Get-ChildItem -Path $rootDirectoryPath -Recurse -Depth 3 -Force -Directory -Filter '.git' |
	# Get the directory path of the Git repository.
	ForEach-Object {
		$gitDirectoryPath = $_.FullName
		$gitRepositoryDirectoryPath = Split-Path -Path $gitDirectoryPath -Parent
		Write-Output $gitRepositoryDirectoryPath
	} |
	# Only include Git repositories that do not have untracked files.
	Where-Object {
		$gitOutput = Invoke-Expression "git -C ""$_"" status" | Out-String
		[bool] $hasUntrackedFiles = $gitOutput.Contains('Untracked files')
		if ($hasUntrackedFiles) {
			Write-Warning "Skipping Git repository with untracked files: $_"
		}
		Write-Output (-not $hasUntrackedFiles)
	} |
	# Clean the Git repository.
	ForEach-Object {
		Write-Output "Cleaning Git repository: $_"
		Invoke-Expression "git -C ""$_"" clean -xdf"
	}
