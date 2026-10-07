# This script will find all open staticman comment pull requests in the given repository and close them after confirmation.`
param
(
	[Parameter(Mandatory = $false, HelpMessage = 'A GitHub Personal Access Token that has permissions to read and close pull requests (i.e. full "repo" permissions).')]
	[string] $GitHubPersonalAccessToken,

	[Parameter(Mandatory = $false, HelpMessage = 'The username that contains the repository to inspect for open staticman comment pull requests.')]
	[string] $GitHubUsername = 'deadlydog',

	[Parameter(Mandatory = $false, HelpMessage = 'The repository to look for staticman comment pull requests in.')]
	[string] $GitHubRepository = 'deadlydog.github.io'
)

Process
{
	[string] $gitHubPat = Get-AndSaveGitHubPersonalAccessTokenIfNecessary -gitHubPersonalAccessToken $GitHubPersonalAccessToken
	[hashtable] $requestHeaders = Get-GitHubRequestHeaders -gitHubPat $gitHubPat

	$openPullRequests = Get-OpenStaticmanPullRequests -gitHubUsername $GitHubUsername -gitHubRepository $GitHubRepository -requestHeaders $requestHeaders

	if ($openPullRequests.Count -le 0)
	{
		Write-Information "There are no open staticman comment pull requests on the '$GitHubUsername\$GitHubRepository' repository, so exiting."
		break
	}

	[bool] $userWantsToCloseOpenPullRequests = Prompt-UserIfTheyWantToCloseOpenPullRequests -openPullRequests $openPullRequests
	if (!$userWantsToCloseOpenPullRequests)
	{
		Write-Warning "User chose to not close pull requests, so exiting."
		break
	}

	Close-OpenGitHubPullRequests -openPullRequests $openPullRequests -gitHubUsername $GitHubUsername -gitHubRepository $GitHubRepository -requestHeaders $requestHeaders
}

Begin
{
	$InformationPreference = 'Continue'

	[string] $StaticmanCommentPrefix = "Dear human,`n`nHere's a new entry for your approval. :tada:`n`nMerge the pull request to accept it, or close it to send it away.`n`n:heart: Your friend [Staticman](https://staticman.net) :muscle:`n`n---`n"

	[string] $GitHubPersonalAccessTokenEnvironmentVariableName = 'StaticmanGitHubPat'

	function Get-AndSaveGitHubPersonalAccessTokenIfNecessary([string] $gitHubPersonalAccessToken)
	{
		[string] $gitHubPat = $gitHubPersonalAccessToken
		if ([string]::IsNullOrWhiteSpace($gitHubPat))
		{
			$gitHubPat = Get-GitHubPersonalAccessToken
		}
		Save-GitHubPersonalAccessTokenIfNecessary -gitHubPersonalAccessToken $gitHubPat

		return $gitHubPat
	}

	function Get-GitHubPersonalAccessToken
	{
		[string] $gitHubPat = Get-GitHubPersonalAccessTokenEnvironmentVariable

		if ([string]::IsNullOrWhiteSpace($gitHubPat))
		{
			$gitHubPat = Read-Host -Prompt "Enter the GitHub personal access token to use"
		}

		return $gitHubPat
	}

	function Save-GitHubPersonalAccessTokenIfNecessary([string] $gitHubPersonalAccessToken)
	{
		[string] $savedGitHubPat = Get-GitHubPersonalAccessTokenEnvironmentVariable

		if ([string]::Equals($savedGitHubPat, $gitHubPersonalAccessToken, [System.StringComparison]::OrdinalIgnoreCase))
		{
			return
		}

		[string] $answer = Read-Host -Prompt "The saved GitHub personal access token is different than the one provided. Do you want to save this token instead? (y/n)"

		if ($answer.StartsWith('y', [System.StringComparison]::OrdinalIgnoreCase))
		{
			Set-GitHubPersonalAccessTokenEnvironmentVariable -gitHubPersonalAccessToken $gitHubPersonalAccessToken
		}
	}

	function Get-GitHubPersonalAccessTokenEnvironmentVariable
	{
		[string] $pat = [System.Environment]::GetEnvironmentVariable($GitHubPersonalAccessTokenEnvironmentVariableName, "Machine")
		return $pat
	}

	function Set-GitHubPersonalAccessTokenEnvironmentVariable([string] $gitHubPersonalAccessToken)
	{
		[System.Environment]::SetEnvironmentVariable($GitHubPersonalAccessTokenEnvironmentVariableName, $gitHubPersonalAccessToken, "Machine")
	}

	function Get-GitHubRequestHeaders([string] $gitHubPat)
	{
		[hashtable] $requestHeaders = @{
			'Content-Type' = 'application/json'
			Accept = 'application/json'
			Authorization = 'Bearer ' + $gitHubPat
		}
		return $requestHeaders
	}

	function Get-OpenStaticmanPullRequests([string] $gitHubUsername, [string] $gitHubRepository, [hashtable] $requestHeaders)
	{
		[string] $getPullRequestsUrl = "https://api.github.com/repos/$gitHubUsername/$gitHubRepository/pulls?state=open&page=1&per_page=100"

		$openPullRequests = Invoke-RestMethod -Method 'Get' -Uri $getPullRequestsUrl -Headers $requestHeaders

		$staticmanPullRequests = $openPullRequests | Where-Object { $_.body.Contains($StaticmanCommentPrefix) }

		[int] $openCommentsPullRequestsCount = $staticmanPullRequests.Count
		Write-Information "There are '$openCommentsPullRequestsCount' open Staticman comment pull requests."

		return $staticmanPullRequests
	}

	function Prompt-UserIfTheyWantToCloseOpenPullRequests($openPullRequests)
	{
		$pullRequestConfirmationDetails = $openPullRequests |
			Select-Object -Property Number, @{ name = 'Name'; expression = { $_.title.Replace('New comment by ', '') }}, @{ name = 'Comment'; expression = { $_.body.Replace($StaticmanCommentPrefix, '') }}

		Write-Information "Review open pull requests in grid view window, and close it when ready to proceed."
		$pullRequestConfirmationDetails | Out-GridView -Wait

		[string] $answer = Read-Host -Prompt 'Do you want to close all of the open Staticman comment pull requests (y/n)'

		[bool] $userWantsToDeletePrs = $answer.StartsWith('y', [System.StringComparison]::OrdinalIgnoreCase)
		return $userWantsToDeletePrs
	}

	function Close-OpenGitHubPullRequests($openPullRequests, [string] $gitHubUsername, [string] $gitHubRepository, [hashtable] $requestHeaders)
	{
		$openPullRequests | ForEach-Object {
			[string] $pullRequestUrl = $_.Url
			[string] $gitBranch = $_.head.ref
			Write-Information "Closing pull request '$pullRequestUrl' and deleting it's branch '$gitBranch'."
			Close-PullRequest -pullRequestUrl $pullRequestUrl -requestHeaders $requestHeaders
			Remove-GitHubBranch -gitBranch $gitBranch -gitHubUsername $GitHubUsername -gitHubRepository $GitHubRepository -requestHeaders $requestHeaders
		}
	}

	function Close-PullRequest([string] $pullRequestUrl, [hashtable] $requestHeaders)
	{
		[string] $closePullRequestBody = @{
			state = 'closed'
		} | ConvertTo-Json -Depth 99

		Invoke-RestMethod -Method 'Patch' -Uri $pullRequestUrl -Headers $requestHeaders -Body $closePullRequestBody > $null
	}

	function Remove-GitHubBranch([string] $gitBranch, [string] $gitHubUsername, [string] $gitHubRepository)
	{
		[string] $branchUrl = "https://api.github.com/repos/$gitHubUsername/$gitHubRepository/git/refs/heads/$gitBranch"
		Invoke-RestMethod -Method 'Delete' -Uri $branchUrl -Headers $requestHeaders
	}

	# Display the time that this script started running.
	[datetime] $startTime = Get-Date
	Write-Verbose "Starting script at '$startTime'." -Verbose
}

End
{
	# Display the time that this script finished running, and how long it took to run.
	[datetime] $finishTime = Get-Date
	[timespan] $elapsedTime = $finishTime - $startTime
	Write-Verbose "Finished script at '$finishTime'. Took '$elapsedTime' to run." -Verbose
}
