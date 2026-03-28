---
title: "The part of the SDLC nobody talks about, and many companies don't do properly"
permalink: /The-part-of-the-SDLC-nobody-talks-about--and-many-companies-dont-do-properly/
#date: 2099-01-15T00:00:00-06:00
#last_modified_at: 2099-01-22
comments_locked: false
toc: false
categories:
  - Software Development
tags:
  - Software Development
---

The most neglected phase of the software development lifecycle (SDLC) is often the decommissioning phase.
An app has reached end-of-life, users are no longer using it, and everything should be shut down and deleted.
It seems straightforward enough, but many companies overlook this phase, or do it poorly.

Failing to properly decommission services can lead to significant costs, both obvious and hidden.

## TL;DR

## Zombie resources

If teams are diligent, they'll remember to remove all of the resources their application used.
However, it's common for teams to clean up some resources, but forget others.
The resources left behind and not doing anything are referred to as "zombie resources".

For example, teams may delete the app service, but forget to delete the database, or the backups.
They might remove their application from a Virtual Machine (VM), but leave the VM running.
They might delete the app, but forget to remove the DNS records, load balancer rules, or monitoring alerts.

[Recent statistics](https://n2ws.com/blog/cloud-computing-statistics) show that roughly 30% of cloud spend is wasted on unused or underutilized resources.
The cost of these zombie resources can really add up over time, especially if teams just keep adding more of them.

## Why services remain running after they are no longer needed

It's easy to understand why people rush through the decommissioning phase and do not do it properly, or why sometimes it gets skipped altogether:

- Product and development teams want to focus on creating new features and fixing bugs; things that add value and bring in more revenue.
  Deleting things may not feel feel like it adds value, so it may get deprioritized.
- Org restructures may result in services being handed off to different teams, and the new team may not even realize the service exists.
- Sometimes a solo developer is responsible for a service, and when they leave the company, the service gets forgotten about.
- Developers will often spin up sandbox environments for testing and experimentation, and then forget to clean them up when they are done.

There are likely many other reasons, but these are the common ones I've seen.

## Obvious costs of not decommissioning properly

![Forgotten cloud service makes man poor](/assets/Posts/2026-01-29-The-part-of-the-SDLC-nobody-talks-about--and-many-companies-dont-do-properly/cloud-service-makes-man-poor.jpeg)

If you have a cloud service that is no longer in use, but still running, you are likely paying monthly for:

- The compute resources (VMs, containers, app services, functions/lambdas, etc)
- Storage costs (databases, file storage, backups)
- Networking costs (data transfer, load balancers, etc)
- Software licensing costs (per user or per instance licenses)
- Monitoring and alerting costs (pay per node, or ingestion rates for logs and metrics)

These monetary costs can be easy to identify, if you think to go looking for them.
Some companies have a dedicated FinOps team whose job is to identify and eliminate these kinds of wasteful expenses.
Many companies don't though.

Often times cloud costs are lumped together into one single number, rather than broken down by departments, project, or team.
It's not always easy for a dev team to identify which costs are theirs, especially if they are not organizing their resources properly or using tags/labels.

Sometimes the only people who even see the costs are the finance team when paying the bill.
They won't have the context to know if the amount is reasonable or not; they'll just pay it.

Even if the workloads are all on-premises, there are still potential monetary costs associated with keeping unused services around.
They take up compute and storage resources that could be used for other things.
Infrastructure teams may think they need to purchase additional hardware sooner than they actually do.

## Hidden costs of not decommissioning properly

Aside from the monetary hosting costs, there are hidden costs of not decommissioning apps, or only partially decommissioning them, that can be just as expensive.

### System load and performance costs

- You might have a cron job or processor service running that's no longer necessary, making unnecessary requests, generating logs, and putting additional load on the system.
- The service might be a noisy neighbour that causes performance issues for other services still in use on the same infrastructure.
- It can create noise in monitoring and alerting systems, making it harder to identify real issues and lead to alert fatigue.

### Mental costs of keeping old services around

- It creates a larger inventory of things to keep track of, creating additional mental overhead and cognitive load for teams.
- It can be worrying to have a bunch of unknown services running in your environment, especially if you don't know what they are for or who is responsible for them.
  - If they do eventually get assigned to a team, the team may feel stressed about having to be responsible for something they don't understand or have any knowledge around.
- It can lead to a hesitancy of making changes for fear of breaking something, slowing progress.

### People time costs

- You may need to have several meetings with different teams to figure out what a service is for, who is using it, and whether it can be safely decommissioned.
  Taking time out of people's days is costly in terms of their hourly wages, but more importantly, it introduces context switching and lost productivity where they could have been working on something else.

  If things are not properly decommissioned, these conversations tend to happen repeatedly, year after year, as new people join the company and discover the same old services again.
- Updating dependencies (e.g. the .NET version or 3rd party libraries) can take a lot of time, especially if the service requires manual testing and deployment.
- Unnecessary components may be needlessly migrated during platform migrations.
  If you have a service that is no longer needed, but you don't know it, time and effort will likely be spent migrating it to the new platform.
  This could be migrating it to a new hosting environment (e.g. Azure App Service to Kubernetes), or updating the app to send logs and metrics to a new monitoring platform (e.g. New Relic to Azure Monitor).

  It might not even be an entire service; maybe something small like load balancer routing rules, or a storage account.
  These things still take time out of people's days to determine what should be done with them.
- Leads to inaccurate reports about what is in their current infrastructure, which may impact planning and decision making for things like capacity planning, budgeting, migrations, etc.
- Automated jobs take longer to run (e.g. managing resources with scripts, IaC deployments, etc), so people wait longer for them to complete.

### Security costs

- [Dangling DNS](https://learn.microsoft.com/en-us/azure/security/fundamentals/subdomain-takeover) vulnerabilities when DNS is not decommissioned properly.
- Paying for security scanning and monitoring of unused services.
- More services that need to be patched to avoid vulnerabilities and attacks.
- It can create noise in security monitoring and vulnerability scanning, making it harder to identify real threats and leading to security fatigue.

## Decommissioning checklist

Ideally you have everything defined in a central place as infrastructure as code; this makes deleting it easy.
The next best thing is to have all of the infrastructure components documented somewhere, such as docs in the app's git repo.

- How to decommission safely
  - Check logs for activity
  - Take offline before deleting it (for how long? A few days, a week, a month, several months? It depends on the app/service). Essentially a scream test
  - Take a backup before deleting it

- Decommission checklist to make sure everything gets deleted
  - Database and caches
  - DNS records
  - Load balancer rules
  - File storage
  - CDN
  - Service Bus Topic subscriptions
  - Etc

## Conclusion

If people don't know what a service is for, they will be hesitant to change or remove it, which can lead to it being left around indefinitely and incurring all of the above costs.
This is true not only for entire apps or systems, but also for individual components and resources.

The best way to ensure all parts of a service get decommissioned properly is to have a clear process and checklist for doing so.
I've presented a starting checklist that you can build off of, but it should be customized to fit your company's processes and infrastructure.

It's unlikely that the checklist will be perfect on the first try, so be sure to continually update it as you learn from each decommissioning experience.
