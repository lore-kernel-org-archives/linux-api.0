From: "Yang Shi" <yang.s-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
Subject: Re: [RFC PATCH] fs: fsnotify: account fsnotify metadata to kmemcg
Date: Tue, 24 Oct 2017 12:12:37 +0800
Message-ID: <5b80a088-05f1-c9af-5b71-e1128fbb36a7@alibaba-inc.com>
References: <1508448056-21779-1-git-send-email-yang.s@alibaba-inc.com>
 <CAOQ4uxhPhXrMLu18TGKDA=ezUVHara95qJQ+BTCio8BHm-u6NA@mail.gmail.com>
 <b530521e-5215-f735-444a-13f722d90e40@alibaba-inc.com>
 <CAOQ4uxhFOoSknnG-0Jyv+=iCDjVNnAg6SiO-msxw4tORkVKJGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOQ4uxhFOoSknnG-0Jyv+=iCDjVNnAg6SiO-msxw4tORkVKJGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 10/22/17 1:24 AM, Amir Goldstein wrote:
> On Sat, Oct 21, 2017 at 12:07 AM, Yang Shi <yang.s-gPhfCIXyaqCqndwCJWfcng@public.gmane.org> wrote:
>>
>>
>> On 10/19/17 8:14 PM, Amir Goldstein wrote:
>>>
>>> On Fri, Oct 20, 2017 at 12:20 AM, Yang Shi <yang.s-gPhfCIXyaqCqndwCJWfcng@public.gmane.org> wrote:
>>>>
>>>> We observed some misbehaved user applications might consume significant
>>>> amount of fsnotify slabs silently. It'd better to account those slabs in
>>>> kmemcg so that we can get heads up before misbehaved applications use too
>>>> much memory silently.
>>>
>>>
>>> In what way do they misbehave? create a lot of marks? create a lot of
>>> events?
>>> Not reading events in their queue?
>>
>>
>> It looks both a lot marks and events. I'm not sure if it is the latter case.
>> If I knew more about the details of the behavior, I would elaborated more in
>> the commit log.
> 
> If you are not sure, do not refer to user application as "misbehaved".
> Is updatedb(8) a misbehaved application because it produces a lot of access
> events?

Should be not. It sounds like our in-house applications. But, it is a 
sort of blackbox to me.

> It would be better if you provide the dry facts of your setup and slab counters
> and say that you are missing information to analyse the distribution of slab
> usage because of missing kmemcg accounting.

Yes, sure. Will add such information in the commit log for the new version.

> 
> 
>>
>>> The latter case is more interesting:
>>>
>>> Process A is the one that asked to get the events.
>>> Process B is the one that is generating the events and queuing them on
>>> the queue that is owned by process A, who is also to blame if the queue
>>> is not being read.
>>
>>
>> I agree it is not fair to account the memory to the generator. But, afaik,
>> accounting non-current memcg is not how memcg is designed and works. Please
>> see the below for some details.
>>
>>>
>>> So why should process B be held accountable for memory pressure
>>> caused by, say, an FAN_UNLIMITED_QUEUE that process A created and
>>> doesn't read from.
>>>
>>> Is it possible to get an explicit reference to the memcg's  events cache
>>> at fsnotify_group creation time, store it in the group struct and then
>>> allocate
>>> events from the event cache associated with the group (the listener)
>>> rather
>>> than the cache associated with the task generating the event?
>>
>>
>> I don't think current memcg design can do this. Because kmem accounting
>> happens at allocation (when calling kmem_cache_alloc) stage, and get the
>> associated memcg from current task, so basically who does the allocation who
>> get it accounted. If the producer is in the different memcg of consumer, it
>> should be just accounted to the producer memcg, although the problem might
>> be caused by the producer.
>>
>> However, afaik, both producer and consumer are typically in the same memcg.
>> So, this might be not a big issue. But, I do admit such unfair accounting
>> may happen.
>>
> 
> That is a reasonable argument, but please make a comment on that fact in
> commit message and above creation of events cache, so that it is clear that
> event slab accounting is mostly heuristic.

Yes, will add such information in the new version.

> 
> But I think there is another problem, not introduced by your change, but could
> be amplified because of it - when a non-permission event allocation fails, the
> event is silently dropped, AFAICT, with no indication to listener.
> That seems like a bug to me, because there is a perfectly safe way to deal with
> event allocation failure - queue the overflow event.

I'm not sure if such issue could be amplified by the accounting since 
once the usage exceeds the limit any following kmem allocation would 
fail. So, it might fail at fsnotify event allocation, or other places, 
i.e. fork, open syscall, etc. So, in most cases the generator even can't 
generate new event any more.

The typical output from my LTP test is filesystem dcache allocation 
error or fork error due to kmem limit is reached.

> I am not going to be the one to determine if fixing this alleged bug is a
> prerequisite for merging your patch, but I think enforcing memory limits on
> event allocation could amplify that bug, so it should be fixed.
> 
> The upside is that with both your accounting fix and ENOMEM = overlflow
> fix, it going to be easy to write a test that verifies both of them:
> - Run a listener in memcg with limited kmem and unlimited (or very
> large) event queue
> - Produce events inside memcg without listener reading them
> - Read event and expect an OVERFLOW even
> 
> This is a simple variant of LTP tests inotify05 and fanotify05.

I tried to test your patch with LTP, but it sounds not that easy to 
setup a scenario to make fsnotify event allocation just hit the kmem 
limit, since the limit may be hit before a new event is allocated, for 
example allocating dentry cache in open syscall may hit the limit.

So, it sounds the overflow event might be not generated by the producer 
in most cases.

Thanks,
Yang

> 
> I realize that is user application behavior change and that documentation
> implies that an OVERFLOW event is not expected when using
> FAN_UNLIMITED_QUEUE, but IMO no one will come shouting
> if we stop silently dropping events, so it is better to fix this and update
> documentation.
> 
> Attached a compile-tested patch to implement overflow on ENOMEM
> Hope this helps to test your patch and then we can merge both, accompanied
> with LTP tests for inotify and fanotify.
> 
> Amir.
> 
