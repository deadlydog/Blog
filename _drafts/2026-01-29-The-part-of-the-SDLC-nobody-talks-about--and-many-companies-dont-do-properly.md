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

It's easy to understand why people rush through the decommissioning phase, or skip it altogether.
Product and development teams want to focus on creating new features and fixing bugs; things that add value and bring in more revenue.
However, failing to properly decommission services can lead to significant costs, both obvious and hidden.

## TL;DR



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

If teams are diligent, they'll remember to remove all of the resources their application used.
However, it's common for teams to clean up some resources, but forget others.
For example, they may delete the app service, but forget to delete the database, or the backups.
They might remove their application from a Virtual Machine (VM), but leave the VM running, incurring costs.

[Recent statistics](https://n2ws.com/blog/cloud-computing-statistics) show that roughly 30% of cloud spend is wasted on unused or underutilized resources.
The cost of these zombie resources can really add up over time, especially if teams just keep adding more of them.

Even if the workloads are all on-premises, there are still potential monetary costs associated with keeping unused services around.
They take up compute and storage resources that could be used for other things.
Infrastructure teams may think they need to purchase additional hardware sooner than they actually do.

## Hidden costs of not decommissioning properly

Aside from the monetary hosting costs, there are hidden costs that can be just as costly:



- Costs of keeping old services around (hosting/operational costs, migrating platform costs, mental/knowledge costs)
  - Pay to host it
  - Pay for software licensing or monitoring node
  - Extra things to be migrated when changing platforms
  - If people don't know what a service is for they are scared/hesitant to remove it
  - People asking questions about it when they discover it (have same conversations again year after year)
  - Jobs take longer to run (e.g. managing on-prem things with scripts, IaC deployments, etc)

- Security costs
  - Dangling DNS (add link)
  - Paying for security scanning and monitoring of unused services
  - Forgotten services that are unpatched and vulnerable to attack

- People time costs
  - Creates confusion about what is in use and what is not
  - People have to spend time investigating what a service is for, which may involve meetings with several other people or teams, wasting all their time
  - Leads to inaccurate reports about what is in their current infrastructure, which may impact planning and decision making for things like capacity planning, budgeting, migrations, etc.
  - Makes it harder to find the services that are actually in use, leading to wasted time and effort

Ideally you have everything defined in a central place as infrastructure as code; this makes deleting it easy.
The next best thing is to have all of the infrastructure components documented somewhere, such as docs in the app's git repo.

## Decommissioning checklist

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
