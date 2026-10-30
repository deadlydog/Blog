# Copilot Instructions for Daniel Schroeder's Programming Blog

## Project Overview

Jekyll-based personal programming blog hosted on GitHub Pages at [blog.danskingdom.com](https://blog.danskingdom.com). Uses the [Minimal Mistakes theme](https://github.com/mmistakes/minimal-mistakes) with extensive customizations. Migrated from WordPress in 2019 (posts before this have additional front matter).

## Architecture

- __Theme__: Remote theme via `remote_theme: mmistakes/minimal-mistakes@4.27.3` pinned to specific version for stability
- __Comments__: Staticman v2 for static comments (config in [staticman.yml](/staticman.yml), hosted instance: https://github.com/deadlydog/deadlydog.github.io-staticman)
- __Build__: Jekyll with Bundler, kramdown for markdown, Rouge for syntax highlighting
- __Deployment__: GitHub Pages, production builds enable ads and analytics

## Critical Workflows

### Create new blog post

```powershell
# Use VS Code task "Create new blog post" OR:
./Scripts/NewBlogPost.ps1
```

- Creates draft in `_drafts/` with filename `YYYY-MM-DD-Sanitized-Title.md`
- Creates corresponding assets directory in `assets/Posts/YYYY-MM-DD-Sanitized-Title/`
- Uses [_drafts/2099-01-15-Template-post.md](/_drafts/2099-01-15-Template-post.md) as template

### Rename blog post

```powershell
# Use VS Code task "Rename blog post" OR:
./Scripts/RenameBlogPost.ps1
```

- Renames file, updates internal references (permalink, title, asset paths)
- Renames corresponding assets directory

### Local development

```bash
# Standard (drafts not shown):
bundle exec jekyll serve --livereload

# With drafts:
bundle exec jekyll serve --livereload --draft

# Production mode (enables ads/comments):
# PowerShell:
$Env:JEKYLL_ENV='production'; bundle exec jekyll serve
# Bash:
JEKYLL_ENV=production bundle exec jekyll serve
```

- Site runs at http://127.0.0.1:4000/
- Use `--incremental` for faster builds (but skips site-wide changes like layout/styles)

## Blog Post Conventions

### Front matter (from [template](/_drafts/2099-01-15-Template-post.md))

```yaml
---
title: "Post Title With Capitals"
permalink: /Post-Title-With-Capitals/
#date: 2099-01-15T00:00:00-06:00  # Uncomment when publishing
#last_modified_at: 2099-01-22     # Optional
comments_locked: false
toc: false                        # true for long posts
categories:
  - Category Name
tags:
  - Should all
  - Start with
  - Capitals
---
```

### Content patterns

- __Opening__: Brief description to entice readers
- __Images__: Include at least one for preview (first image used in social previews)
  - Path: `/assets/Posts/YYYY-MM-DD-Post-Title/image-name.png`
- __Paragraphs__: Keep short (4-5 sentences max) for readability
- __Line numbers in code__: Use Liquid syntax instead of backticks:

  ```liquid
  {% highlight powershell linenos %}
  Your code here
  {% endhighlight %}
  ```

- __Markdown__: Use standard markdown syntax.
  Avoid HTML unless necessary.
  Use underscores for emphasis, not asterisks.

## Customization Patterns

### Finding customizations

Search for `Dan's Customizations` to find all theme overrides. Custom files use __PascalCase__ naming; theme overrides use __lowercase-kebab-case__.

### Key overridden files (see [ReadMe.md](/ReadMe.md) for full list)

- [_includes/analytics-providers/google-gtag.html](/_includes/analytics-providers/google-gtag.html): Cookie consent wrapper
- [_includes/footer/custom.html](/_includes/footer/custom.html): Donations, advertisements
- [_includes/masthead.html](/_includes/masthead.html): Light/dark mode toggle
- [_layouts/default.html](/_layouts/default.html): Cookie notice, custom scripts
- [_layouts/single.html](/_layouts/single.html): Ads above/below post content

### Custom code location

All custom components in `_includes/_DansCustomFiles/`:

- CookieNotice.html
- DonationButtonAndModal.html
- MicrosoftClarityAnalytics.html
- RunThirdPartyCodeThatUsesCookies.js

## Theme Updates

When updating `remote_theme` tag in [_config.yml](/_config.yml):

1. Find latest stable tag from [theme changelog](https://github.com/mmistakes/minimal-mistakes/blob/master/CHANGELOG.md)
1. Update `remote_theme` to new tag
1. Checkout theme repo at that tag
1. Search this repo for `Dan's Customizations`
1. Copy updated code from theme while preserving customization blocks
1. Test locally, commit changes

## Environment Setup

### DevContainer (recommended)

Open repo in VS Code with DevContainer support—automatic setup via [.devcontainer/devcontainer.json](/.devcontainer/devcontainer.json).

### Manual setup (Windows)

1. Install [Ruby + Devkit v3.3](https://rubyinstaller.org/downloads/) with MSYS2
2. `gem update --system`
3. Handle SSL issues if needed (see [ReadMe.md](/ReadMe.md) for Cisco Umbrella Root CA fix)
4. `gem install jekyll bundler`
5. `bundle install`

### Keeping dependencies updated

```bash
bundle update  # Update all gems periodically
```

## Configuration Notes

- [_config.yml](/_config.yml): Main site config (author bio, social links, analytics IDs, Staticman settings)
- [_data/navigation.yml](/_data/navigation.yml): Top navigation menu (has custom Home item)
- Syntax highlighting: Rouge (supports csharp, powershell, json, yaml, etc.—see [supported languages](https://simpleit.rocks/ruby/jekyll/what-are-the-supported-language-highlighters-in-jekyll/))
- Markdown processor: Kramdown (options at [kramdown docs](https://kramdown.gettalong.org/options.html))

## Important Paths

- __Posts__: `_posts/YYYY-MM-DD-title.md` (published)
- __Drafts__: `_drafts/YYYY-MM-DD-title.md` (not shown unless `--draft` flag)
- __Assets__: `assets/Posts/YYYY-MM-DD-title/`
- __Pages__: `_pages/*.md` (About, Privacy, Kudos, etc.)
- __Comments__: `_data/comments/` (Staticman-generated YAML files)
