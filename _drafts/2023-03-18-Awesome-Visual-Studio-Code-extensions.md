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

Many of the extensions listed are specific to certain technologies, so I've tried to categorize as such.
Some extensions will also be more helpful depending on the type of work you do.
For example, web developers may find certain extensions more useful than PowerShell developers, so keep that in mind.

> Many extensions are personal preference, and you may not agree with all of my suggestions.
> I am simply listing these to make you aware of them.
> I encourage you to play around with them and see what works best for you.

If you enjoy this post, you may also be interested in my [VS Code default settings to change post](https://blog.danskingdom.com/Visual-Studio-Code-default-settings-to-change/).

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

![Extensions view and search box](/assets/Posts/2023-03-18-Awesome-Visual-Studio-Code-extensions/extensions-activity-bar-view.png)

To ensure you find the exact extension mentioned in this post, search for the provided `Extension ID`.
Some extensions require restarting VS Code to take effect.
You can do this quickly using the `Developer: Reload Window` command from the Command Palette, or the `Reload` button in the Extensions view if one is provided.

See [the official extensions docs](https://code.visualstudio.com/docs/editor/extension-marketplace) for more info.
You can also browse extensions on the [VS Code Marketplace](https://marketplace.visualstudio.com/VSCode).

Alright, enough preamble, let's see the extensions!

If there are other great extensions you think belong on this list, please let me know in the comments.

## Editor extensions

### advanced-new-file

Extension ID: `patbenatar.advanced-new-file`

Create files without your hands leaving the keyboard, using the keyboard shortcut or command palette.

![advanced-new-file extension](https://media.giphy.com/media/l3vRfRJO7ZX6WNJQs/source.gif)

[View advanced-new-file on the marketplace](https://marketplace.visualstudio.com/items?itemName=patbenatar.advanced-new-file)

### Auto Close Tag

Extension ID: `formulahendry.auto-close-tag`

Automatically add closing tags for a bunch of languages, including HTML, XML, PHP, JavaScript, TypeScript, and more.

![Auto Close Tag extension](https://github.com/formulahendry/vscode-auto-close-tag/raw/HEAD/images/usage.gif)

[View Auto Close Tag on the marketplace](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-close-tag)

### Auto Rename Tag

Extension ID: `formulahendry.auto-rename-tag`

Automatically rename paired HTML/XML tags.

![Auto Rename Tag extension](https://github.com/formulahendry/vscode-auto-rename-tag/raw/HEAD/images/usage.gif)

[View Auto Rename Tag on the marketplace](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-rename-tag)

### Better Comments

Extension ID: `aaron-bond.better-comments`


























### Code Runner

Extension ID: `formulahendry.code-runner`

Select some lines of code and easily run them, using the keyboard shortcut, command palette, or the right-click context menu.
It supports many languages, including PowerShell, JavaScript, TypeScript, Python, PHP, Go, Ruby, C#, and more.
You can also specify a default language, which will be used when you have not yet saved the file (so VS Code does not know the file type and language), or when you are working in a markdown file and want to run a code snippet.

![Code Runner extension](https://github.com/formulahendry/vscode-code-runner/raw/HEAD/images/usage.gif)

[View Code Runner on the marketplace](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)

## Python extensions

### AREPL for python

Extension ID: `almenon.arepl`

Allows you to run your Python code in a REPL (Read-Evaluate-Print-Loop) environment.
This creates a super fast feedback loop, which is great for experimenting with code, and for learning Python.

![AREPL for python extension](https://raw.githubusercontent.com/Almenon/AREPL-vscode/master/areplDemoGif2.gif)

[View AREPL for python on the marketplace](https://marketplace.visualstudio.com/items?itemName=almenon.arepl)

### autoDocstring - Python Docstring Generator

Extension ID: `njpwerner.autodocstring`

Automatically generate docstring templates for Python functions, methods, and classes.

![autoDocstring - Python Docstring Generator extension](https://github.com/NilsJPWerner/autoDocstring/raw/HEAD/images/demo.gif)

[View autoDocstring - Python Docstring Generator on the marketplace](https://marketplace.visualstudio.com/items?itemName=njpwerner.autodocstring)

## ARM (Azure Resource Manager) template extensions

### Azure Resource Manager (ARM) Tools

Extension ID: `msazurermtools.azurerm-vscode-tools`

Provides a number of features for working with ARM templates, including language support, resource snippets, auto-completion, validation, refactoring tools, and more.

![Azure Resource Manager (ARM) Tools extension](https://github.com/Microsoft/vscode-azurearmtools/raw/main/images/arm-snippets.png)

[View Azure Resource Manager (ARM) Tools on the marketplace](https://marketplace.visualstudio.com/items?itemName=msazurermtools.azurerm-vscode-tools)

### ARM Template Viewer

Extension ID: `bencoleman.armview`

A graphical preview of ARM templates, showing all resources with the official Azure icons and linkage between the resources.

![ARM Template Viewer extension](https://github.com/benc-uk/armview-vscode/raw/HEAD/assets/readme/screen1.png)

[View ARM Template Viewer on the marketplace](https://marketplace.visualstudio.com/items?itemName=bencoleman.armview)

## AutoHotkey extensions

### AutoHotkey Plus Plus

Extension ID: `mark-wiemer.vscode-autohotkey-plus-plus`

Provides language support, syntax highlighting, intellisense, code formatting, a debugger, and more for AutoHotkey scripts.

![AutoHotkey Plus Plus extension](https://github.com/mark-wiemer/vscode-autohotkey-plus-plus/raw/HEAD/image/debug.gif)

[View AutoHotkey Plus Plus on the marketplace](https://marketplace.visualstudio.com/items?itemName=mark-wiemer.vscode-autohotkey-plus-plus)

## Conclusion

There are so many awesome extensions available for Visual Studio Code.
If you have any suggestions for extensions that you think should be on this list, please let me know in the comments.

If you enjoyed this post, check out my [VS Code default settings to change post](https://blog.danskingdom.com/Visual-Studio-Code-default-settings-to-change/).

Happy coding!
