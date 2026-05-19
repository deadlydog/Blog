---
title: "Prevent NuGet package vulnerabilities from breaking the build"
permalink: /Prevent-NuGet-package-vulnerabilities-from-breaking-the-build/
#date: 2099-01-15T00:00:00-06:00
#last_modified_at: 2099-01-22
comments_locked: false
toc: false
categories:
  - DotNet
  - NuGet
  - Visual Studio
tags:
  - DotNet
  - NuGet
  - Visual Studio
---

__TL;DR__: If you enable "Treat warnings as errors" in your .NET projects, NuGet audit warnings for security vulnerabilities may break your build, but there are ways to work around it if needed.

Visual Studio 2022 v17.8 and NuGet 6.8 introduced a wonderful security feature that will generate warnings for NuGet packages that your projects reference that have known security vulnerabilities.
Visual Studio v17.12 and NuGet v6.12 took this further by also generating warnings for vulnerable transitive dependencies those packages depend on ([see the VS release notes](https://learn.microsoft.com/en-us/visualstudio/releases/2022/release-notes#net)).
This gives developers better insight into potential security risks in their software, and can prompt them to update NuGet packages to a more secure version.
Read more about [the NuGet audit features on the MS docs here](https://learn.microsoft.com/en-us/nuget/concepts/auditing-packages).

Here's an example of a NuGet audit warning message for a package with a known vulnerability:

```text
NU1904: Warning As Error: Package 'log4net' 2.0.8 has a known critical severity vulnerability, https://github.com/advisories/GHSA-2cwj-8chv-9pp9
```

## The problem

NuGet generating warnings for security vulnerabilities in direct and transitive dependencies is great, but it can have an unintended side-effect of breaking the build if your projects are configured to treat warnings as errors.
Treating warnings as errors is not on by default, but enabling it is a common practice to help ensure code quality and security.

This new NuGet audit feature means that if you have `TreatWarningsAsErrors` enabled, your code may no longer compile, even if you haven't changed the code.
Some examples of when this could happen include:

- You update Visual Studio / NuGet on your local machine to a version that generates new vulnerability warnings, so you can no longer build the code locally.
- Your build server updates Visual Studio / NuGet, so the build server can no longer build the code.
  Hosted platforms like GitHub and Azure DevOps agents often install new versions without any notice.
- A vulnerability is discovered in a NuGet package that your project uses and it is added to <https://github.com/advisories/>.

A common problem developers encounter sooner or later is when code compiles one day, but not the next, even though you haven't changed the code.
It can be very frustrating.

## The solutions

There are a few ways to work around the problem of NuGet audit warnings breaking the build.

The best solution is to:

- Update your NuGet package reference to a version that doesn't have a vulnerability.

While this is the simplest and best solution, it may not always be possible.
A few reasons why include:

- The latest version of the NuGet package (or one of its dependencies) has a vulnerability.
- The NuGet package is no longer maintained, so there is no new version to update to.
- Newer versions of the NuGet package (or one of its dependencies) have a breaking change that would require significant code changes, and you do not have the time or resources to dedicate to making and testing those changes right now.

### When updating the NuGet package is not a viable solution

If updating the NuGet package is not possible, there are a few other solutions you can try.
These are listed in order of most recommended to least recommended:

- __Do not treat NuGet audit warnings as errors by using WarningsNotAsErrors__: This is the best solution, as it will allow your code to compile, and you will still be notified of the security vulnerabilities as a warning.
  [See the MS docs here for how to enable or disable it](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options/errors-warnings#warningsaserrors-and-warningsnotaserrors)
  - Add the following to your project file (.csproj) to treat the NuGet audit warnings as warnings instead of errors:

    ```xml
    <WarningsNotAsErrors>NU1901,NU1902,NU1903,NU1904</WarningsNotAsErrors>
    ```

    These are the 4 NuGet audit warning codes that I encountered, but there may be others.

    If you are editing the .csproj file by hand, you will want to add it to the `<PropertyGroup>` section of both your `Debug` and `Release` configurations.

    Here is a screenshot of modifying the project properties in Visual Studio to enable "Treat warnings as errors" and prevent NuGet audit warnings from being treated as errors (I forgot to add NU1901 in the screenshot):

    ![Screenshot of modifying the .csproj file in Visual Studio](/assets/Posts/2024-11-16-Prevent-NuGet-package-vulnerabilities-from-breaking-the-build/enable-treat-warnings-as-errors-and-ignore-nuget-audit-warnings-in-visual-studio.png)

- __Suppress specific NuGet audit advisories__: The next best solution is to ignore just the specific NuGet package advisory that you are not able to workaround.
  A potential downside is that because you will no longer get a warning, you may forget the package has a vulnerability.
  Here is an example of the code to add to your .csproj file to exclude the specific log4net advisory mentioned earlier:

  ```xml
  <Project Sdk="Microsoft.NET.Sdk">
    <!--  other parts of the project left out of this example -->
    <ItemGroup>
      <NuGetAuditSuppress Include="https://github.com/advisories/GHSA-2cwj-8chv-9pp9" />
    </ItemGroup>
  </Project>
  ```

  See [the NuGet audit docs](https://learn.microsoft.com/en-us/nuget/concepts/auditing-packages#excluding-advisories) for more information.

- __Disable TreatWarningsAsErrors__: This is not ideal, as it will prevent you from being _forced_ to fix code quality issues and security vulnerabilities, which some people and companies prefer.
  [See the MS docs for how to enable or disable it](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options/errors-warnings#treatwarningsaserrors)
- __Disable the NuGet audit feature__: This is not recommended, as it will prevent you from being notified of security vulnerabilities.
  [See the MS docs for how to disable it, or have it ignore transitive dependencies](https://learn.microsoft.com/en-us/nuget/concepts/auditing-packages#configuring-nuget-audit).

All of these solutions require making changes to the project file (.csproj).
If you only have a few offending projects, updating each project file isn't too troublesome.
If you have 10s or 100s of projects though, it can be a pain to update them all.

A better solution is to leverage a `Directory.Build.props` file to apply the changes to all projects in a directory.
You can read more about Directory.Build.props and how to use it [on the MS docs here](https://learn.microsoft.com/en-us/visualstudio/msbuild/customize-by-directory).

[This MS doc](https://learn.microsoft.com/en-us/dotnet/core/compatibility/sdk/9.0/nugetaudit-transitive-packages) has more information on some of the workarounds mentioned above.

You can find more information about potential actions to take when you encounter a vulnerable dependency in [the NuGet audits docs here](https://learn.microsoft.com/en-us/nuget/concepts/auditing-packages#actions-when-packages-with-known-vulnerabilities-are-reported), and [this MS blog post](https://devblogs.microsoft.com/nuget/nugetaudit-2-0-elevating-security-and-trust-in-package-management/).

## Conclusion

The NuGet audit feature is a great addition to help developers be aware of security vulnerabilities in their projects.
However, it can have the unintended side-effect of breaking the build if you treat warnings as errors.
By updating your NuGet packages to versions that do not have vulnerabilities, or by using one of the workarounds mentioned above, you can prevent the build from breaking and still be notified of security vulnerabilities in your projects.

I hope this article helps you keep your code compiling and secure.
If you have any questions or comments, please leave them below.

Happy coding!
