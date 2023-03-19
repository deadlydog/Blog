---
title: "Awesome Visual Studio Code extensions"
permalink: /Awesome-Visual-Studio-Code-extensions/
#date: 2099-01-15T00:00:00-06:00
#last_modified_at: 2099-01-22
comments_locked: false
toc: true
categories:
  - Visual Studio Code
  - Productivity
  - Extension
tags:
  - Visual Studio Code
  - VS Code
  - Productivity
  - Extension
---

This post is a collection of Visual Studio Code extensions that I use and think are worth installing.

## Introduction

One of the best things about Visual Studio Code is the extension ecosystem.
There are thousands of free extensions available, allowing VS Code to be highly customized and improved, and to be used for writing code in a ton of different languages.
Below I list some of the extensions that I use, and that you may want to consider installing.

> I realize that many of the extensions I list are specific to certain technologies, or may take an opinionated approach.
> Many extensions are personal preference, and you may not agree with all of my suggestions.
> I am simply listing these to make you aware of them.
> I encourage you to play around with them and see what works best for you.

### Settings Sync

If you do not have Settings Sync enabled, you should consider doing so.
It allows you to sync your extensions across multiple machines, and can also sync settings, keyboard shortcuts, user snippets and tasks, UI state, and profiles.
It is great for when you wipe your computer, or migrate to a new machine, as it brings all your customizations with you.
It used to require an extension, but is now built into VS Code.
Read more about it in [the official docs](https://code.visualstudio.com/docs/editor/settings-sync).

### Installing extensions

To view your installed extensions and search for others, click the `Extensions` icon in the Activity Bar (the left sidebar).
You can also open the Extensions view from the Command Palette using the `View: Extensions` command, or with the keyboard shortcut <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>X</kbd>.
Use the search box at the top to find extensions, and click the `Install` button to install them.
Some extensions may require a reload of VS Code to take effect.

![Extensions view and search box](/assets/Posts/2023-03-18-Awesome-Visual-Studio-Code-extensions/extensions-activity-bar-view.png)

See [the official extensions docs](https://code.visualstudio.com/docs/editor/extension-marketplace) for more info.
You can also browse extensions on the [VS Code Marketplace](https://marketplace.visualstudio.com/VSCode).

Alright, enough preamble, let's see the extensions!

If there are other great extensions you think belong on this list, please let me know in the comments.

<!-- Related: You may also be interested in this post about [Visual Studio Code extensions to install](/Visual-Studio-Code-extensions-to-install/). -->

## Editor extensions

### Code Runner

Select some lines of code and press <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>N</kbd> to run it, or use the right-click context menu.
It supports many languages, including PowerShell, JavaScript, TypeScript, Python, PHP, Go, Ruby, C#, and more.
You can also specify a default language, which will be used when you have not yet saved the file (so VS Code does not know the file type and language), or when you are working in a markdown file and want to run a code snippet.

[View the extension on the marketplace](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)

I work a lot in PowerShell, so I set the default language to `powershell`.
You may want to set it to something like `javascript`, `typescript`, `python`, `csharp`, `markdown`, etc.
The supported language identifiers are [listed here](https://code.visualstudio.com/docs/languages/identifiers#_known-language-identifiers).

GUI setting: `Code-running: Default Language` to `powershell`.

JSON setting:

```json
"code-runner.defaultLanguage": "powershell",
```
