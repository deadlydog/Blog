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

- Unused services and resources are costly in many ways, including money, creating noise in monitoring and alerting systems, adding mental overhead for teams, and potentially creating security vulnerabilities.
- It's best to decommission services as soon as you know they are no longer needed.
- It's important to have a clear process and checklist for decommissioning services, to ensure all of the resources get cleaned up properly and nothing gets missed.
  - This article provides a starting process and checklist that you can build off of.
- Decommissioning a service is not free, but the costs of not doing it properly are much higher in the long run.

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

There are many other reasons, but these are the common ones I've seen.

## Obvious costs of not decommissioning properly

![Forgotten cloud service makes man poor](/assets/Posts/2026-01-29-The-part-of-the-SDLC-nobody-talks-about--and-many-companies-dont-do-properly/cloud-service-makes-man-poor.jpeg)

If you have a cloud service that is no longer in use, but still running, you are likely paying monthly for:

- The compute resources (VMs, containers, app services, functions/lambdas, etc.)
- Storage costs (databases, file storage, backups, etc.)
- Networking costs (data transfer, load balancers, etc.)
- Software licensing costs (per user or per instance licenses)
- Monitoring and alerting costs (pay per node, or ingestion rates for logs and metrics)

These monetary costs can be easy to identify, but only if you think to go looking for them.
Some companies have a dedicated FinOps team whose job is to identify and eliminate these kinds of wasteful expenses.
Many companies don't though.

Often times cloud costs are lumped together into one single number, rather than broken down by department, project, or team.
It's not always easy for a dev team to identify which costs are theirs and know how much they are spending, especially if they are not organizing their resources properly or using tags/labels.

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

## Decommissioning safely

If you're able to decommission a service that you know is no longer used, you can often move straight to deleting the resources.

If you're not certain whether anything still relies on a service or component though, you likely want to take a few precautions before deleting it.

A typical decommission flow might look something like this:

1. Review logging and monitoring data to ensure the service is no longer being used.
   - If things are still calling the service, you should get those updated first to stop calling it.
1. Notify the relevant teams and stakeholders of the decommission plans, including when it will be disabled.
1. Disable any alerts associated with the service to avoid false paging or notifications.
1. Disable the service in a way that is quick and easy to revert to perform a scream test (i.e. turn it off any see if anybody screams).
   - e.g. Stop the Azure Web App, disable the cron job, update the k8s manifest, turn the Virtual Machine off, remove the DNS hostname, etc.
1. Wait a period of time to ensure nothing blows up (e.g. a week), or perform a [brownout schedule](https://en.wikipedia.org/wiki/Brownout_(software_engineering)).
   - Depending on the service, consider waiting longer if needed.
   e.g. Do month-end reports call the service?
   If so, leave it disabled over the month-end period before deleting it.
1. Delete the service and all of the infrastructure supporting it.
1. Delete any monitoring and alerting associated with the service.
1. Backup and delete any data stores associated with the service.
1. Delete or archive the code and any metadata associated with the service.

You would want to perform the above steps in your non-production environments first, to minimize the risk of unexpected consequences when doing it in production.

## Decommission checklist

Ideally you have everything defined in a central place as infrastructure as code; this makes finding and deleting everything easy.

That's often not a reality for many teams though.
The next best thing is to have all of the infrastructure components documented somewhere, such as docs in the app's git repo.

Below is a non-exhaustive list of things to consider deleting when decommissioning a service, to hopefully ensure nothing is missed.

### Monitoring and observability

- Remove endpoints/nodes from availability checks (e.g. New Relic Synthetics, SolarWinds Orion, Azure Application Insights, etc.).
  - Do this first so on-call personnel don't get paged unnecessarily.
- Delete related dashboards, alerts, SLIs, and SLOs (e.g. Application Insights, Hosted Graphite, SolarWinds, Honeycomb, Datadog, etc.).

### Infrastructure

- Delete compute resources, such as Web Apps, Cloud Services, Functions/Lambas, Virtual Machines, etc.
- Delete empty App Service Plans and/or shuffle them if they are unbalanced after deleting a Web App.
- Delete empty resource groups and subscriptions.
- Delete Kubernetes resources and namespace (if applicable).
- Delete secret stores (e.g. Azure Key Vault).
- Delete service principals (e.g. Enterprise Application and Application Registrations from Azure Entra ID).
- Delete traffic manager profiles, load balancer rules, and DNS records.
- Delete any related API Management resources (e.g. Azure API Management).
- Remove integrations with any other 3rd party services.

### Data

- Backup (if necessary) and delete databases and data stores (e.g. Azure storage accounts, SQL databases, Redis caches, Elasticsearch, etc.).
- Delete service bus queues, topics, and subscribers.
- Delete CDN endpoints (e.g. Azure CDN, Azure Front Door)
- Delete API keys from 3rd party services (e.g. SendGrid, Honeycomb, Azure DevOps)
- Remove Active Directory groups and users related to the service

### Builds, deployments, repositories, and documentation

- Archive, disable, or delete build and deployment pipelines.
- Update the git repo ReadMe to mention the service is now decommissioned, and archive the git repository.
- Archive or delete any wiki pages related to the service.

## Conclusion

Decommissioning a service is not free; it takes time and effort to do it properly.
The longer you leave it though, the more it will cost you and your company.

If you are unsure of what the service is for and whether it is still being used, it can take a lot of time to investigate and confirm that it is safe to decommission.
So it's important to invest the time upfront and decommission it as soon as you know a service is no longer needed.

If people don't know what a service is for, they will be hesitant to change or remove it, which can lead to it being left around indefinitely and repeatedly incurring the above mentioned costs.
This is true not only for entire apps or systems, but also for individual components and resources.

The best way to ensure all parts of a service get decommissioned properly is to have a clear process and checklist for doing so.
I've presented a starting checklist that you can build off of, but it should be customized to fit your company's processes and infrastructure.

It's unlikely that the checklist will be perfect on the first try, so be sure to continually update it as you learn from each decommissioning experience.

I hope this article has encouraged you to think about the decommissioning phase of the SDLC, and to hopefully save you and your company from the costs of neglecting it.

Happy decommissioning!
