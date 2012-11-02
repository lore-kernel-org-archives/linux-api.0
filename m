From: Michael Wang <wangyun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v3] epoll: Support for disabling items, and a self-test
 app.
Date: Fri, 02 Nov 2012 10:26:50 +0800
Message-ID: <50932F6A.6090305@linux.vnet.ibm.com>
References: <1351210112-23238-1-git-send-email-palewis@adobe.com> <5090C5F6.6000603@linux.vnet.ibm.com> <5091749B.4060605@adobe.com> <5091C5C2.8060009@linux.vnet.ibm.com> <5092C3B9.2070909@adobe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5092C3B9.2070909-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paton J. Lewis" <palewis-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jason Baron <jbaron-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Holland <pholland-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/02/2012 02:47 AM, Paton J. Lewis wrote:
> On 10/31/12 5:43 PM, Michael Wang wrote:
>> On 11/01/2012 02:57 AM, Paton J. Lewis wrote:
>>> On 10/30/12 11:32 PM, Michael Wang wrote:
>>>> On 10/26/2012 08:08 AM, Paton J. Lewis wrote:
>>>>> From: "Paton J. Lewis" <palewis-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
>>>>>
>>>>> It is not currently possible to reliably delete epoll items when
>>>>> using the
>>>>> same epoll set from multiple threads. After calling epoll_ctl with
>>>>> EPOLL_CTL_DEL, another thread might still be executing code related
>>>>> to an
>>>>> event for that epoll item (in response to epoll_wait). Therefore the
>>>>> deleting
>>>>> thread does not know when it is safe to delete resources pertaining
>>>>> to the
>>>>> associated epoll item because another thread might be using those
>>>>> resources.
>>>>>
>>>>> The deleting thread could wait an arbitrary amount of time after
>>>>> calling
>>>>> epoll_ctl with EPOLL_CTL_DEL and before deleting the item, but this is
>>>>> inefficient and could result in the destruction of resources before
>>>>> another
>>>>> thread is done handling an event returned by epoll_wait.
>>>>>
>>>>> This patch enhances epoll_ctl to support EPOLL_CTL_DISABLE, which
>>>>> disables an
>>>>> epoll item. If epoll_ctl returns -EBUSY in this case, then another
>>>>> thread may
>>>>> handling a return from epoll_wait for this item. Otherwise if
>>>>> epoll_ctl
>>>>> returns 0, then it is safe to delete the epoll item. This allows
>>>>> multiple
>>>>> threads to use a mutex to determine when it is safe to delete an
>>>>> epoll item
>>>>> and its associated resources, which allows epoll items to be deleted
>>>>> both
>>>>> efficiently and without error in a multi-threaded environment. Note
>>>>> that
>>>>> EPOLL_CTL_DISABLE is only useful in conjunction with EPOLLONESHOT,
>>>>> and using
>>>>> EPOLL_CTL_DISABLE on an epoll item without EPOLLONESHOT returns
>>>>> -EINVAL.
>>>>>
>>>>> This patch also adds a new test_epoll self-test program to both
>>>>> demonstrate
>>>>> the need for this feature and test it.
>>>>
>>>> Hi, Paton
>>>>
>>>> I'm just think about may be we could use this way.
>>>>
>>>> Seems like currently we are depending on the epoll_ctl() to indicate
>>>> the
>>>> start point of safe section and epoll_wait() for the end point, like:
>>>>
>>>>           while () {
>>>>                   epoll_wait()                    --------------
>>>>
>>>>                   fd event arrived                safe section
>>>>
>>>>                   clear fd epi->event.events
>>>>                                                   --------------
>>>>                   if (fd need stop)
>>>>                           continue;
>>>>                                                   --------------
>>>>                   ...fd data process...
>>>>
>>>>                   epoll_ctl(MOD)                  danger section
>>>>
>>>>                   set fd epi->event.events        --------------
>>>>
>>>>                   continue;
>>>>           }
>>>>
>>>> So we got a safe section and do delete work in this section won't cause
>>>> trouble since we have a stop check directly after it.
>>>>
>>>> Actually what we want is to make sure no one will touch the fd any more
>>>> after we DISABLE it.
>>>>
>>>> Then what about we add a ref count and a stop flag in epi, maintain it
>>>> like:
>>>>
>>>>           epoll_wait()
>>>>
>>>>           check user events and
>>>>           dec the ref count of fd         ---------------------------
>>>>
>>>>           ...
>>>>
>>>>           fd event arrived                safe sec if ref count is 0
>>>>
>>>>           if epi stop flag set
>>>>                   do nothing
>>>>           else
>>>>                   inc epi ref count       ---------------------------
>>>
>>> The pseudecode you provide below (for "DISABLE") seems to indicate that
>>> this "epi ref count" must be maintained by the kernel. Therefore any
>>> userspace modification of a ref count associated with an epoll item will
>>> require a new or changed kernel API.
>>>
>>>>                   send event
>>>>
>>>> And what DISABLE do is:
>>>>
>>>>           set epi stop flag
>>>>
>>>>           if epi ref count is not 0
>>>>                   wait until ref count be 0
>>>
>>> Perhaps I don't fully understand what you're proposing, but I don't
>>> think it's reasonable for a kernel API (epoll_ctl in this case) to block
>>> while waiting for a userspace action (decrementing the ref count) that
>>> might never occur.
>>>
>>> Andrew Morton also proposed using ref counting in response to my initial
>>> patch submission; my reply to his proposal might also be applicable to
>>> your proposal. A link to that discussion thread:
>>> http://thread.gmane.org/gmane.linux.kernel/1311457/focus=1315096
>>>
>>> Sorry if I am misunderstanding your proposal, but I don't see how it
>>> solves the original problem.
>>
>> I just try to find out whether we could using DISABLE with out ONESHOT :)
>>
>> My currently understanding is:
>>
>> 1. we actually want to determine the part between each epoll_wait() in a
>> while().
>>
>> 2. we can't count on epoll_wait() itself, since no info pass to kernel
>> to indicate whether it was invoked after another epoll_wait() in the
>> same while().
>>
>> 3. so we need epoll_ctl(MOD) to tell kernel: user finished process data
>> after epoll_wait(), and those data belong to which epi.
>>
>> 4. since 3 we need ONESHOT to be enabled.
>>
>>
>> Is this the reason we rely on ONESHOT to be enabled?
> 
> No, we need to use EPOLLONESHOT to ensure that only one worker thread at
> a time can ever be handling private data associated with a given fd.
> This constraint allows a deletion thread to coordinate with that worker
> thread via a mutex to cleanly and quickly delete the associated private
> data (provided that the deletion thread knows whether or not such a
> worker thread exists in that state, which the question that
> EPOLL_CTL_DISABLE answers).

So using ONESHOT is a demand for current epoll coding design, and
DISABLE is try to solve the issue of that design?

I don't have many using experience on epoll as you guys :), so allow me
to ask one question:

Will it be very useful if we can using DISABLE with out the limitation
on ONESHOT?

Which means what ever the ep is, if DISABLE return 0, we are safe to
erase that fd.

Regards,
Michael Wang
