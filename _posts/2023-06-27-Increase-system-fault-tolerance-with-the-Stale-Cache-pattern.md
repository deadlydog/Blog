---
title: "Increase system fault tolerance with the Stale Cache pattern"
permalink: /Increase-system-fault-tolerance-with-the-Stale-Cache-pattern/
#date: 2099-01-15T00:00:00-06:00
last_modified_at: 2023-12-15
comments_locked: false
toc: false
categories:
  - DotNet
  - CSharp
  - Cache
  - Design patterns
  - Software Engineering
tags:
  - DotNet
  - CSharp
  - Cache
  - Design patterns
  - Software Engineering
---

Caching is used to improve the performance of an application.
When applied properly, caches can also help increase an application's fault tolerance, helping to prevent outages and improve the user experience.

In this post I introduce the `Stale Cache` pattern and show how to apply it to time-based caches to further increase the fault tolerance of your applications.
This pattern has helped prevent production outages in several systems I've worked on, and I hope it can help you too.

## TL;DR

The `Stale Cache` pattern retains stale cache items and returns them if needed until they can be replaced with fresh items.
It is not a replacement for other time-based caching strategies, but rather an enhancement that can be applied to them to help make your applications and systems more fault tolerant.

## What is a cache?

[Wikipedia defines a cache](https://en.wikipedia.org/wiki/Cache_(computing)) as,

> A hardware or software component that stores data so that future requests for that data can be served faster.

Basically, a cache is a place to store data that is used frequently so that it can be accessed faster than if it were retrieved (or calculated) from the original source every time, improving the speed of the application.

Caching is a huge topic with many considerations, such as:

- Where in your application stack should you do the caching? In the client application, the web server, the database, or a separate component such as a Redis server or CDN.
- What type of cache to use? In-memory, disk, or distributed.
- What caching strategy to use? Cache-aside, read-through, write-through, write-around, write-back, refresh-ahead, etc.
- How do you handle cache invalidation? Expiration (absolute time, sliding window, etc.), eviction (least recently used, least frequently used, random, etc.), or something else.

Depending on your application, you may implement several different caches at different layers, each with different strategies and configurations.

There are tons of great articles on caching and the pros and cons of various strategies, like [this](https://dev.to/kalkwst/database-caching-strategies-16in) and [this](https://medium.com/geekculture/overview-of-caching-distributed-cache-caching-patterns-techniques-6130a116820) and [this](https://levelup.gitconnected.com/6-caching-strategies-for-system-design-interviews-8cf22193b360) and [this](https://www.neovolve.com/2008/10/08/cache-expiration-policies/) and [this](https://www.linkedin.com/pulse/exploring-caching-patterns-microservices-architecture-saeed-anabtawi/) and [this](https://hazelcast.com/blog/a-hitchhikers-guide-to-caching-patterns/), so I won't go into any more detail here.
I make reference to the cache-aside, read-through, and refresh-ahead strategies later, so you can see these resources for more information on them if needed.
Remember to finish this article first before falling down the external links rabbit hole 😅.

## What is fault tolerance?

[Wikipedia defines Fault tolerance](https://en.wikipedia.org/wiki/Fault_tolerance) as,

> The ability of a system to continue operating properly in the event of the failure of some of its components.
> ...
> A fault-tolerant design enables a system to continue its intended operation, possibly at a reduced level, rather than failing completely, when some part of the system fails.

In this article, I'm focusing on having your application remain operational when an external service that it retrieves data from is unavailable, such as a database or web service.

## What is the Stale Cache pattern?

### Story time

Let's illustrate the pattern through a short story.

Imagine you want to make a sandwich.
You go to your kitchen and get some bread.
You notice that while the bread is not moldy, it has passed its best-before date and is a bit stale.
Fresh bread always makes a sandwich taste way better, so you toss the stale bread in the garbage and walk to the bakery to get some fresh bread.
When you arrive at the bakery you find they are closed because a water pipe burst and they will not be open until tomorrow.
There are no other bakeries nearby, so you go back home.
Now you are home, still hungry, and unable to make a sandwich because you have no bread.

You might say, well just pull the stale bread out of the garbage and make a sandwich with that.
Even if you are the type to pull food out of the garbage ([like George Costanza](https://www.youtube.com/watch?v=t36jwyVncmQ) 😂), in this hypothetical scenario let's say that your roommate already _collected the garbage_ and took it out (see what I did there 😛), so the bread really is gone.

With no bread for a sandwich and your stomach growling, you reflect on what you could have done to avoid this unhappy situation.
The answer is simple; you should not have thrown out the stale bread until you had fresh bread to replace it.
This is the `Stale Cache` pattern.

### How is this different from traditional time-based caching?

Most time-based caching implementations only allow a single expiration time.
When the expiration time is reached, the item is removed from the cache.
The next time something tries to access the item, it is not found in the cache and the item must be retrieved from the source, such as a database or another web service.
If the source is unavailable, then the item cannot be retrieved and the application fails or has to perform some additional compensating action.

By holding on to the stale cache item until a fresh item is available, the cache can return the stale item to the caller and the application can continue to function even when the source is unavailable, making the application more fault tolerant.

> Retaining stale cache items until they can be replaced with fresh ones makes your application more fault tolerant.

### Cache item staleness and expiry

You likely want to remove stale items from the cache eventually though, as using data that is too old may cause other problems in your application.
Just like how you wouldn't want to make a sandwich with bread that was molding, you may not want to use data that is too old.
We call the date that the cached item is no longer safe to use the Expiry date.

There are 3 states for a cache item in the Stale Cache pattern:

- __Fresh__: The item has not yet reached its Stale (or best-before) date.
  The item is not stale yet and can be used without any additional actions.
- __Stale__: The item has passed its Stale date, but not its Expiry date.
  The item is stale, but can still be used safely.
  A fresh item should be requested from the source and the cache updated with the fresh item.
- __Expired__: The item has passed both its Stale and Expiry date.
  The item is expired and cannot be used safely.
  The expired item should be removed from the cache and discarded.
  A fresh item should be requested from the source and the cache updated with the fresh item.

As with any cache, you still need to be mindful of how long in the future you set the Stale and Expiry dates.
Different pieces of data likely have different freshness requirements.

### How it improves fault tolerance

The image below shows an example of how the Stale Cache pattern can be leveraged in a cache-aside strategy, allowing the application to continue to function even when the external source is unavailable.

![Cache-aside strategy using the Stale Cache pattern where application works even when the source is not available](/assets/Posts/2023-06-27-Increase-system-fault-tolerance-with-the-Stale-Cache-pattern/stale-cache-pattern-with-synchronous-cache-aside-strategy.drawio.png)

In an ideal scenario:

- Step 2 would have returned a fresh item from the cache and there would be no need to make a request to the external source, or
- Step 3 would have reached the external source and a fresh item would have been returned to the application.
  The application then could have updated the cache with the fresh item, and then used it for the current request.

The Stale Cache pattern allows the application to get the best of both worlds; use a fresh item when available, but still be able to function when the external source is unavailable.

### Preferring speed over freshness

In our earlier story, you may have been too hungry to wait for fresh bread.
An alternative would have been to make your sandwich using the stale bread, and ask your roommate to go to the bakery for fresh bread while you eat.
When your roommate returns with the fresh bread, you can throw out the stale bread and use the fresh bread for your next sandwich.

This is another way to implement the Stale Cache pattern, where you return the stale cache item right away to improve speed, and request a fresh item in the background, allowing the cache to be updated with the fresh item asynchronously so it can be used for future cache requests.

![Cache-aside strategy using the Stale Cache pattern asynchronously to improve application speed](/assets/Posts/2023-06-27-Increase-system-fault-tolerance-with-the-Stale-Cache-pattern/stale-cache-pattern-with-asynchronous-cache-aside-strategy.drawio.png)

In our example above, the cache may have been in-memory or distributed.
A different strategy could be used in place of the cache-aside strategy, such as the read-through strategy.
Those changes may require slight implementation changes, but the idea of the Stale Cache pattern remains the same; use both a Stale and Expiry date to allow stale, but still safe, data to be used when fresher data is not available.

## When to use the Stale caching pattern

### - Enhance existing caching strategies

The Stale Cache pattern is not meant to replace any caching strategies, but rather is meant to be used in conjunction with them, when applicable.
This is shown in the examples above where it is used with the cache-aside strategy.

### - Enhance existing fault tolerance strategies

Similarly, the Stale Cache pattern is not meant to replace other fault tolerance strategies, like retries.
They can be used together to make your application even more fault tolerant.
For example, you may return a stale cache item while also retrying failed requests to the source multiple times in the background to retrieve a fresh item.

### - When cache item eviction is based on age

The Stale Cache pattern is by nature centered around time expiration, so it is not applicable when using non-time based cache invalidation strategies, such as least-recently-used or least-frequently-used eviction algorithms where items are evicted when the cache reaches a certain size, rather than when each cache item reaches a certain age.

### - Read-only operations

The Stale Cache pattern is only applicable to read operations, not write operations.

### - Can improve speed at the expense accuracy

The Stale Cache pattern is a good fit for applications that value speed over accuracy.
As shown above, the implementation may allow applications to return stale cached data right away and then fetch updated data in the background.
Be aware though that retrieving data asynchronously in the background may come at the expense of more complicated code.

A variation of this strategy is known as refresh-ahead.
The refresh-ahead strategy however is typically focused on performance, rather than fault tolerance, with some implementations trying to predict when a cache item will be requested and refreshing it before it is requested.
Other variations simply refresh all cache items on a schedule.
Both of these implementations may result in more requests, and thus load, to the external service, which may not be desirable.
The refresh-ahead strategy also typically has the cache manage refreshing its own items, whereas strategies like cache-aside still have the application managing refreshing the cache items.

### - Data that is not extremely time sensitive

The Stale Cache pattern provides fault tolerance when the external source is unavailable for a period of time.
The greater the expiry time of the data, the more fault tolerance the Stale Cache pattern can provide.

If the data is considered expired after a very short amount of time though, such as a few seconds, then the Stale Cache pattern is not likely to provide much benefit since when there are problems, chances are the external source will be unavailable for more than just a few seconds.

The Stale Cache pattern is highly suited for data that is not extremely time sensitive, and that does not change frequently, as typically data that does not change often can have a longer expiry time.
Examples of this type of data include:

- Auth tokens (typically have an expiry of 1 hour or more)
- Product names, descriptions, and images (typically change infrequently, so could mark as stale after 1 hour, but not expire for 48 hours)
- Product prices (if the business values making a sale over selling the item at a slightly out-of-date price)
- Countries, provinces / states, cities, postal / zip codes, etc. (typically change infrequently)
- Lists of clients or users (typically change infrequently)

## Example implementation of the Stale Cache pattern

Below is a basic example of incorporating the Stale Cache pattern into an in-memory cache that uses the cache-aside strategy in C#.
In-memory cache-aside caches are very popular for client applications, and web services that do not need to horizontally scale greatly.
I build upon the .NET MemoryCache class in this example.

```csharp
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Internal;
using Microsoft.Extensions.Logging;

namespace Caching;

public enum StaleMemoryCacheResult
{
  ValueFound,      // Item is still fresh.
  StaleValueFound, // Item is stale, but still usable.
  ValueNotFound    // Item is not in cache, so it expired or was never added.
}

public class StaleMemoryCache
{
  private readonly ILogger<StaleMemoryCache> _logger;
  private readonly IMemoryCache _memoryCache;

  public StaleMemoryCache(ILogger<StaleMemoryCache> logger, IMemoryCache memoryCache)
  {
    _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    _memoryCache = memoryCache ?? throw new ArgumentNullException(nameof(memoryCache));
  }

  public StaleMemoryCacheResult TryGetValue<T>(object key, out T? value)
  {
    bool hasValue = _memoryCache.TryGetValue(key, out CacheItem<T>? item);
    if (!hasValue || item == null)
    {
      _logger.LogDebug("Cache miss for key '{key}'. Item was either never added to cache or it expired.", key);
      value = default;
      return StaleMemoryCacheResult.ValueNotFound;
    }

    bool isStale = item.StaleDate < DateTimeOffset.UtcNow;
    if (isStale)
    {
      _logger.LogDebug("Cache hit for key '{key}', but item is stale.", key);
      value = item.Value;
      return StaleMemoryCacheResult.StaleValueFound;
    }

    _logger.LogDebug("Cache hit for key '{key}'.", key);
    value = item.Value;
    return StaleMemoryCacheResult.ValueFound;
  }

  public void Set<T>(object key, T value, TimeSpan timeUntilItemIsStale, TimeSpan timeUntilItemExpires)
  {
    var cacheItem = new CacheItem<T>
    {
      Value = value,
      StaleDate = DateTimeOffset.UtcNow.Add(timeUntilItemIsStale)
    };
    var expiryDate = DateTimeOffset.UtcNow.Add(timeUntilItemExpires);
    _memoryCache.Set(key, cacheItem, expiryDate);
  }

  private class CacheItem<T>
  {
    public T Value { get; set; } = default!;
    public DateTimeOffset StaleDate { get; set; } = DateTimeOffset.MinValue;
  }
}
```

The main differences between this and your typical time-based expiration cache are:

- To `Set` an item in the cache you must provide _two_ time values; the time until the item is considered stale, and the time until the item expires (is removed from the cache).
  Current cache libraries typically only allow you to specify the expiry time.
- The cache returns a `StaleMemoryCacheResult` enum instead of a boolean.
  This allows the caller to know if the item was found in the cache, if the item was found but is stale, or if the item was not found in the cache.
  There are other ways to implement this, such as having explicit functions for checking if an item is stale or not, or returning a more complex object that contains more information instead of returning an enum.
  This choice was just a personal preference.

If you are not a fan of the variable names `timeUntilItemIsStale` and `timeUntilItemExpires`, alternatives could be `minTtl` and `maxTtl` respectively (TTL = Time To Live).

An example of using the above in-memory cache with the cache-aside strategy might look like this:

```csharp
private readonly TimeSpan TimeBeforeFetchingFreshAuthToken = TimeSpan.FromMinutes(30);
private readonly TimeSpan MaxTimeToUseStaleAuthTokenFor = TimeSpan.FromMinutes(120);

public async Task<string> GetAuthToken()
{
  string? authToken;
  var cacheResult = _staleMemoryCache.TryGetValue(AuthTokenCacheKey, out authToken);

  // If we have a fresh auth token in the cache, return it.
  if (cacheResult == StaleMemoryCacheResult.ValueFound)
  {
    return authToken;
  }

  // Otherwise, we either don't have an auth token or it is stale, so try to get a fresh one.
  // (An alternative approach could be to return the stale auth token right away and try to get a fresh one in the background)
  var authItem = await GetFreshAuthTokenFromExternalService();

  // If we successfully retrieved a fresh auth token, add it to the cache and return it.
  bool authRetrievedSuccessfully = (authItem is not null);
  if (authRetrievedSuccessfully)
  {
    authToken = authItem.Token;
    _staleMemoryCache.Set(AuthTokenCacheKey, authToken, TimeBeforeFetchingFreshAuthToken, MaxTimeToUseStaleAuthTokenFor);
    return authToken;
  }

  // Otherwise we could not get a fresh auth token, so if we have a stale auth token in the cache, return it.
  bool weHaveACachedAuthToken = (cacheResult == StaleMemoryCacheResult.StaleValueFound);
  if (weHaveACachedAuthToken)
  {
    _logger.LogWarning("Could not retrieve a fresh auth token, so using a stale cached one instead.");
    return authToken;
  }

  // Otherwise we could not get a fresh auth token and we do not have one in the cache, so throw an exception.
  throw new Exception("Could not retrieve an auth token and there are no cached ones to use.");
}
```

Check out [this gist](https://gist.github.com/deadlydog/3169ff35abc95c4607acf5730a12932b) for more complete example code, including unit tests.

In this example you can see that `TimeBeforeFetchingFreshAuthToken` is set to 30 minutes, and `MaxTimeToUseStaleAuthTokenFor` to 120 minutes.
Let's say 120 minutes was chosen because that is how long a new auth token is valid for.
With this in place and assuming the application is being used constantly, the auth token will refresh every 30 minutes.

Consider what would happen if the application retrieves an auth token at 1pm, and then the external auth service goes down from 2pm - 3pm.
In a typical cache-aside strategy, a single expiry time must be chosen.
The developer may choose to expire the cache item after 90 minutes, since that's close to the max lifetime of the auth token.
Or perhaps they ignore the auth token lifetime and simply expire the cache item every 30 minutes.
In both cases the application would end up unable to retrieve a fresh auth token at 2:30pm and suffer an outage.
Using the Stale Cache with the values in the example code above however would allow the application to always have a valid auth token, as it would obtain a new auth token at 2pm which would be good until 4pm.

![Example of traditional caches failing and Stale Cache succeeding](/assets/Posts/2023-06-27-Increase-system-fault-tolerance-with-the-Stale-Cache-pattern/example-of-traditional-cache-failing-and-stale-cache-succeeding.drawio.png)

The above is only one possible implementation of the Stale Cache pattern.
I chose to keep it simple for the sake of this example, but there are many other things you could do to improve it.
You may want to have it fetch fresh items in the background and return stale items immediately.
You may want to store a delegate with the cache item that the `StaleMemoryCache` class can call to refresh the cache item, and move the date and `StaleMemoryCacheResult` comparison logic of when to retrieve a fresh item into the cache class itself.

While this example shows how to use the Stale Cache pattern with an in-memory cache-aside strategy, it can be similarly incorporated into distributed caches, side-car caches, and other cache strategies as well.

## Considerations

- While the Stale Cache pattern can help make your systems more fault tolerant, without proper observability it may also hide external system failures.
Consider adding telemetry on how often stale items are used, in addition to cache hits (fresh) and misses (expired).
This may help identify when external services are down or slow, or when your cache is not working as expected, even though the application works.
It also feels great to see your implementation working as expected and knowing when it saved your system from failing and causing an outage.

- Adding the Stale Cache pattern to your caches does not mean you should throw away other good caching practices.
  For example, if you decide to use a distributed cache, you likely still want a locking mechanism in place to prevent [a cache stampede](https://en.wikipedia.org/wiki/Cache_stampede).

- As mentioned earlier, consider if you want to block while retrieving fresh items, or retrieve them in the background; accuracy vs speed.

- While the Stale Cache pattern is more forgiving, you should still give careful consideration to the Stale and Expiry times that you choose for each type of data in the cache.

- Allowing stale items may not make sense in every scenario, such as when data is only allowed to be cached for a second or two.
  For those situations, you can achieve the traditional cache behaviour by setting the Stale and Expiry dates to the same value.

- In general, the optimal configuration is to use a short Stale time and a long Expiry time.
  This will allow your application to be more fault tolerant, while still keeping the data as fresh as possible.
  When choosing the Stale duration, you should consider both the impact of stale data on your application, and the performance impact on the external service of frequently retrieving fresh data, and try to find a happy medium.

## Is this a new pattern?

I thought up this pattern many years ago after one of our services whose data did not change very often had an extended outage and it impacted many other services.
I have used and recommended it many times since.
I think it is a relatively straight-forward (and kind of obvious) solution, but I have not seen it documented anywhere, either by this name, `Stale Cache` pattern, or any other.
If you know of it by a different name, please let me know in the comments below.

The only implementation I have seen of it in any caching libraries is the refresh-ahead strategy.
However, it can be applied to other caching strategies as well, such as the cache-aside and read-through strategies, giving the fault tolerance advantages without the complexities of refresh-ahead.
So simply saying that the refresh-ahead strategy is the Stale Cache pattern is not accurate; that is just one implementation of it.

[RFC 5861](https://datatracker.ietf.org/doc/html/rfc5861) introduced the `stale-while-revalidate` and `stale-if-error` HTTP Cache Control header directives, which are also implementations of Stale Cache pattern.
Even though the spec was proposed in 2010, many web browsers and web services [still do not support it](https://caniuse.com/?search=stale-while-revalidate).
Some of the products that do support these cache control headers though give good guidance on how and when to use it, such as the [Fastly docs](https://developer.fastly.com/learning/concepts/stale/) and [Amazon CloudFront docs](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Expiration.html), which you may find applicable to your own applications when implementing the Stale Cache pattern.

I was actually quite surprised when I could not find any articles naming this pattern.
Obviously, I am not the first person to think of it, but I was not able to find any other references to it.
Perhaps I was just searching for the wrong terms.
If you know of any other articles describing this general pattern (not just an implementation of it, like refresh-ahead), please let me know in the comments below.

> Update December 2023: I came across [the FusionCache .NET library](https://github.com/ZiggyCreatures/FusionCache) that implements the Stale Cache pattern, calling it the [`Fail-Safe` mechanism](https://github.com/ZiggyCreatures/FusionCache/blob/main/docs/FailSafe.md).

## Conclusion

> There are only two hard things in Computer Science: cache invalidation and naming things.

While the `Stale Cache` pattern does not completely solve cache invalidation, it helps make time-based cache invalidation more forgiving by allowing you to pick a time range instead of a single point in time.

The pattern is not overly complicated or complex, making it fairly easy to understand and implement.
Time-based cache-aside strategies are one of the most common types of caches, and as I've shown in this post, extending their functionality to include the Stale Cache pattern is not difficult and can have huge payoffs.

The Stale Cache pattern can make your apps and services more resilient by reducing the amount of time that they depend on external services to be up for.
This is especially important in microservice architectures where the number of external service dependencies are often very high.

The pattern can also help give your apps and services a speed boost by returning stale items immediately instead of blocking while retrieving fresh items from the external source.

I hope this pattern eventually becomes standard functionality in all caching libraries that offer time-based expiration, and that you find it useful in your applications.

Happy caching!
