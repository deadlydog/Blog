---
title: "Communicate intent more effectively with Conventional Commit and Comment messages"
permalink: /2022-01-23-Conventional-Commit-and-Comment-messages/
#date: 2099-01-15T00:00:00-06:00
#last_modified_at: 2099-01-22T00:00:00-06:00
comments_locked: false
categories:
  - Software Engineering
tags:
  - Comment
  - Commit
  - Pull Request
---

Conventional Commits and Conventional Comments can save you and your team time and prevent miscommunications by expressing intent more clearly.
Let's look at what they are and why you would want to adopt them.

## ✅ Conventional Commits

[Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) is a convention for making your source control commit messages clearer and easier to understand by using standard labels in your commit messages.
It allows you to, at a glance, tell if the commit is a bug fix, a new feature, a refactor, etc.
From what I understand, it basically took what [Commitizen](https://github.com/commitizen/cz-cli) was doing and formalized it into a standard spec.

Here's an example of a regular commit message:

> Show subtotal of items in cart

And what the same commit message might look like using Conventional Commit messages:

> feat (cart): Show subtotal of items in cart

or

> fix (cart): Show subtotal of items in cart

Notice how in the first example it wasn't clear if the change was introducing a new feature or fixing a bug, but it's obvious in the second and third examples by use of the `feat` and `fix` labels.

Similarly, simply by looking at commit messages like:

> test: Ensure cart total is correct

and

> docs: Update outdated hyperlink

you know that the commits are making changes to tests and documentation, by use of the `test` and `docs` labels respectively, meaning no application or business logic code has been changed and the changes should be safe to promote to production.

Commit messages like:

> feat!: Allow regex in search
>
> BREAKING CHANGE

use the `!` and `BREAKING CHANGE` labels to make it obvious that the change is breaking backward compatibility, and further considerations should be made before merging the change into production.

In addition to making commit messages more human understandable, it also allows tooling to be built around them, like [automatic semantic versioning from commit messages](https://medium.com/agoda-engineering/automating-versioning-and-releases-using-semantic-release-6ed355ede742) where the tool is able to calculate what the next [semantic version](https://semver.org) should be based on the commit messages and the types of changes in them, removing the burden from a human having to figure out the new version number manually.

I also find using Conventional Commit messages helpful for Pull Request (PR) descriptions.
It allows reviewers to quickly scan the description and know what types of changes are included in the PR.
Azure DevOps has a handy feature that allows the commit messages to easily be copied into the PR description, which I'm hoping GitHub adopts soon.

I've been using Conventional Commit messages for years and find it very useful.
Be sure to [check out the spec](https://www.conventionalcommits.org/en/v1.0.0/) to see the expected formatting and all of the defined labels.

## 💬 Conventional Comments

[Conventional Comments](https://conventionalcomments.org) is a similar concept to Conventional Commits, but it proposes labels to use in your Pull Request (PR) comments, with the goal being to make the intent of your code review comments more clear to other readers.

Here's an example of a typical code review comment:

> This code is so compact

And what the same comment might look like using Conventional Comments:

> praise: This code is so compact

or

> nitpick (non-blocking): This code is so compact

Code styling is often a personal choice, and in the first example it's not clear if the commenter likes how compact the code is, or if they would prefer it changed to be more readable.
In the second example, it's clear the commenter is a fan of how compact the code is because they used the `praise` label.
In the third example, you can tell the commenter doesn't like how compact the code is and would prefer it be changed, but that it shouldn't be considered a blocker to getting the pull request merged in, since it's using the `(non-blocking)` decorator.

Here's some more example Conventional Comments:

> issue: We should hide the checkout button

Using the `issue` label makes it clear that there will be a problem if the checkout button is not hidden, and that it's not just a "nice to have" suggestion.

> thought: We could show a list of related products

The `thought` label indicates that this comment shouldn't block the PR, but that it's something we should consider for a future change.

> suggestion (if-minor): Add validation to the checkout form

The `if-minor` decorator indicates to only consider the `suggestion` for this PR if it's a minor change that's easy to make, helping to avoid scope creep.

Be sure to [check out the Conventional Comments spec](https://conventionalcomments.org) to see all of the defined labels.

Also be sure to check out [this blog post on Conventional Comments](https://a-hemdan.medium.com/conventional-comments-1f83f56a7a48) which explains the concept further, and also contains some code that you can copy into GitHub to quickly create GitHub saved replies for each of the Conventional Comments labels.

There's even [a Chrome extension](https://chrome.google.com/webstore/detail/conventional-comments/pagggmojbbphjnpcjeeniigdkglamffk) ([GitHub](https://github.com/AbdallahHemdan/Conventional-Buttons)) to help easily use them in your PR comments.

I only recently discovered this concept of Conventional Comments so I haven't been using it as long, but it's an excellent idea and I thought I'd share it 🙂.

## Conclusion

One thing I really like about both Conventional Commits and Conventional Comments is that the labels are intuitive enough that everyone can understand them, even people who have never heard of these concepts before.

When writing commit and comment messages, it can take a bit of time to remember the various different labels and decorators, but once you've used them for a short while it quickly becomes muscle memory.

Providing additional clarity to your messages by adding a simple label is an easy win, and it's well worth the small time investment to learn and use the labels.

In short, Conventional Commits and Conventional Comments are great because they:

- Make it easier for others (and your future self) to understand the intent of your code / comment.
- Allow you to quickly know at a glance what to expect in the rest of the message by setting the context.
- Enable tooling to be put in place to do things like automate manual tasks, collect metrics, etc.
- Are succinct, intuitive, easy to learn, and easy to use.

Happy code committing and reviewing!
