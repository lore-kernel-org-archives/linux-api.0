From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] fs: fsnotify: account fsnotify metadata to kmemcg
Date: Tue, 24 Oct 2017 08:42:04 +0300
Message-ID: <CAOQ4uxiVbA1HxPt9mjn-AL0XzMuOYU5dMeMoHxZbxHLzaS=niQ@mail.gmail.com>
References: <1508448056-21779-1-git-send-email-yang.s@alibaba-inc.com>
 <CAOQ4uxhPhXrMLu18TGKDA=ezUVHara95qJQ+BTCio8BHm-u6NA@mail.gmail.com>
 <b530521e-5215-f735-444a-13f722d90e40@alibaba-inc.com> <CAOQ4uxhFOoSknnG-0Jyv+=iCDjVNnAg6SiO-msxw4tORkVKJGQ@mail.gmail.com>
 <5b80a088-05f1-c9af-5b71-e1128fbb36a7@alibaba-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5b80a088-05f1-c9af-5b71-e1128fbb36a7-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yang Shi <yang.s-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 24, 2017 at 7:12 AM, Yang Shi <yang.s-gPhfCIXyaqCqndwCJWfcng@public.gmane.org> wrote:
>
>
> On 10/22/17 1:24 AM, Amir Goldstein wrote:
>>
>> On Sat, Oct 21, 2017 at 12:07 AM, Yang Shi <yang.s-gPhfCIXyaqCqndwCJWfcng@public.gmane.org> wrote:
>>>
>>>
>>>
>>> On 10/19/17 8:14 PM, Amir Goldstein wrote:
>>>>
>>>>
>>>> On Fri, Oct 20, 2017 at 12:20 AM, Yang Shi <yang.s-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>
>>>> wrote:
>>>>>
>>>>>
>>>>> We observed some misbehaved user applications might consume significant
>>>>> amount of fsnotify slabs silently. It'd better to account those slabs
>>>>> in
>>>>> kmemcg so that we can get heads up before misbehaved applications use
>>>>> too
>>>>> much memory silently.
>>>>
>>>>
>>>>
>>>> In what way do they misbehave? create a lot of marks? create a lot of
>>>> events?
>>>> Not reading events in their queue?
>>>
>>>
>>>
>>> It looks both a lot marks and events. I'm not sure if it is the latter
>>> case.
>>> If I knew more about the details of the behavior, I would elaborated more
>>> in
>>> the commit log.
>>
>>
>> If you are not sure, do not refer to user application as "misbehaved".
>> Is updatedb(8) a misbehaved application because it produces a lot of
>> access
>> events?
>
>
> Should be not. It sounds like our in-house applications. But, it is a sort
> of blackbox to me.
>

If you know which process is "misbehaving" you can look at
ls -l /proc/<pid>/fd |grep notify
and see the anonymous inotify/fanotify file descriptors

then you can look at  /proc/<pid>/fdinfo/<fd> file of those
file descriptors to learn more about the fanotify flags etc.

...

>
>>
>> But I think there is another problem, not introduced by your change, but
>> could
>> be amplified because of it - when a non-permission event allocation fails,
>> the
>> event is silently dropped, AFAICT, with no indication to listener.
>> That seems like a bug to me, because there is a perfectly safe way to deal
>> with
>> event allocation failure - queue the overflow event.
>
>
> I'm not sure if such issue could be amplified by the accounting since once
> the usage exceeds the limit any following kmem allocation would fail. So, it
> might fail at fsnotify event allocation, or other places, i.e. fork, open
> syscall, etc. So, in most cases the generator even can't generate new event
> any more.
>

To be clear, I did not mean that kmem limit would cause a storm of dropped
events. I meant if you have a listener outside memcp watching a single file
for access/modifications and you have many containers each with its own
limited memcg, then event drops probability goes to infinity as you run more
of those kmem limited containers with event producers.

> The typical output from my LTP test is filesystem dcache allocation error or
> fork error due to kmem limit is reached.

And that should be considered a success result of the test.
The only failure case is when producer touches the file and event is
not delivered
nor an overflow event delivered.
You can probably try to reduce allocation failure for fork and dentry by:
1. pin dentry cache of subject file on test init by opening the file
2. set the low kmem limit after forking

Then you should probably loop the test enough times
in some of the times, producer may fail to access the file
in others if will succeed and produce events properly
and many some times, producer will access the file and event
will be dropped, so event count is lower than access count.



>
>> I am not going to be the one to determine if fixing this alleged bug is a
>> prerequisite for merging your patch, but I think enforcing memory limits
>> on
>> event allocation could amplify that bug, so it should be fixed.
>>
>> The upside is that with both your accounting fix and ENOMEM = overlflow
>> fix, it going to be easy to write a test that verifies both of them:
>> - Run a listener in memcg with limited kmem and unlimited (or very
>> large) event queue
>> - Produce events inside memcg without listener reading them
>> - Read event and expect an OVERFLOW even
>>
>> This is a simple variant of LTP tests inotify05 and fanotify05.
>
>
> I tried to test your patch with LTP, but it sounds not that easy to setup a
> scenario to make fsnotify event allocation just hit the kmem limit, since
> the limit may be hit before a new event is allocated, for example allocating
> dentry cache in open syscall may hit the limit.
>
> So, it sounds the overflow event might be not generated by the producer in
> most cases.
>

Right. not as simple, but maybe still possible as I described above.
Assuming that my patch is not buggy...

Thanks,
Amir.
