From: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Subject: Re: [PATCH v5] cgroup: Add new capability to allow a process to
 migrate other tasks between cgroups
Date: Tue, 13 Dec 2016 10:32:14 -0800
Message-ID: <b23a2c1f-d720-e299-caea-45a642ee0981@schaufler-ca.com>
References: <1481593143-18756-1-git-send-email-john.stultz@linaro.org>
 <CAKgNAkhGSYmtqLnCyXH8-dbmBJreo9mbVGRMyd_9hZ5D1F7q4g@mail.gmail.com>
 <221e80bd-3d99-6c35-dcd3-b2547f0abb11@schaufler-ca.com>
 <CALAqxLWaJT=a1Cc2Ja8ZuazjJYi3a2WW9ATB0NFP8670Dyq6bg@mail.gmail.com>
 <f7ccb39f-bad8-4a78-c796-90927b839494@schaufler-ca.com>
 <CALAqxLUgmeNxt5B5k720YRM=pUh=a-b2cg+mCM1n1QG-un2ofQ@mail.gmail.com>
 <4c60e1be-c00a-5f26-f5de-7d32b9cb0f62@schaufler-ca.com>
 <CALAqxLUbrO+vzrwgK8_yZS-uru7redOdJCAe2=yA34gwPGC2CQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALAqxLUbrO+vzrwgK8_yZS-uru7redOdJCAe2=yA34gwPGC2CQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Rom Lemarchand <romlem-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Todd Kjos <tkjos-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christian Poetzsch <christian.potzsch-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Amit Pundir <amit.pundir-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/13/2016 10:13 AM, John Stultz wrote:
> On Tue, Dec 13, 2016 at 9:48 AM, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> wrote:
>> On 12/13/2016 9:24 AM, John Stultz wrote:
>>> On Tue, Dec 13, 2016 at 9:17 AM, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> wrote:
>>>> On 12/13/2016 8:49 AM, John Stultz wrote:
>>>>> On Tue, Dec 13, 2016 at 8:39 AM, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> wrote:
>>>>>> On 12/13/2016 1:47 AM, Michael Kerrisk (man-pages) wrote:
>>>>>>> How about CAP_CGROUP_CONTROL or some such, with the idea that this
>>>>>>> might be a capability that allows the holder to step outside usual
>>>>>>> cgroup rules? At the moment, that capability would allow only one such
>>>>>>> step, but maybe there would be others in the future.
>>>>>> I agree, but want to put it more strongly. The granularity of
>>>>>> capabilities can never be fine enough for some people, and this
>>>>>> is an example of a case where you're going a bit too far. If the
>>>>>> use case is Android as you say, you don't need this. As my friends
>>>>>> on the far side of the aisle would say, "just write SELinux policy"
>>>>>> to correctly control access as required.
>>>>> So.. The trouble is that while selinux is good for restricting
>>>>> permissions, the in-kernel permission checks here are already too
>>>>> restrictive.
>>>> Why did the original authors of cgroups make it that restrictive?
>>>> If there isn't a good reason, loosen it up. If there is a good
>>>> reason, then pay heed to it.
>>> That's what this patch is proposing. And I agree with Michael that the
>>> newly proposed cap was a bit to narrowly focused on my immediate use
>>> case, and broadening it to CGROUP_CONTROL is smart. Then that
>>> capability could be further restricted w/ selinux policy, as you
>>> suggest.
>> Adding a new capability is unnecessary. The current use of CAP_SYS_NICE,
>> while arguably obscure, provides as much "security" as a new capability
>> does. While cgroups are a wonderful thing, they don't need a separate
>> capability.
> The trouble is that CAP_SYS_NICE or _RESOURCE (which was tried in an
> earlier version of this patch) aren't necessarily appropriate for
> non-android systems. See Andy's objection here:
> https://lkml.org/lkml/2016/11/8/946

Then we need to see what those as-yet-unimplemented systems
require and how to address them. I don't think that taking
the "someone might want it" approach is really appropriate.

>
> thanks
> -john
>
