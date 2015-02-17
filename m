From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v2 0/2] Add epoll round robin wakeup mode
Date: Tue, 17 Feb 2015 13:09:08 -0800
Message-ID: <CALCETrWg9sdyoKg0-BkwKQgyANvJybQ_wqjTfvYEGW1+S1J5Bw@mail.gmail.com>
References: <cover.1424200151.git.jbaron@akamai.com> <CALCETrWAH7SbQm0T+_7wviiU6pJ0isBdWE-cQBGk-joAx2OzFw@mail.gmail.com>
 <54E3A591.2050806@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54E3A591.2050806-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Wong <normalperson-rMlxZR9MS24@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 12:33 PM, Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:
> On 02/17/2015 02:46 PM, Andy Lutomirski wrote:
>> On Tue, Feb 17, 2015 at 11:33 AM, Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:
>>> When we are sharing a wakeup source among multiple epoll fds, we end up with
>>> thundering herd wakeups, since there is currently no way to add to the
>>> wakeup source exclusively. This series introduces 2 new epoll flags,
>>> EPOLLEXCLUSIVE for adding to a wakeup source exclusively. And EPOLLROUNDROBIN
>>> which is to be used in conjunction to EPOLLEXCLUSIVE to evenly
>>> distribute the wakeups. This patch was originally motivated by a desire to
>>> improve wakeup balance and cpu usage for a listen socket() shared amongst
>>> multiple epoll fd sets.
>>>
>>> See: http://lwn.net/Articles/632590/ for previous test program and testing
>>> resutls.
>>>
>>> Epoll manpage text:
>>>
>>> EPOLLEXCLUSIVE
>>>         Provides exclusive wakeups when attaching multiple epoll fds to a
>>>         shared wakeup source. Must be specified with an EPOLL_CTL_ADD operation.
>>>
>>> EPOLLROUNDROBIN
>>>         Provides balancing for exclusive wakeups when attaching multiple epoll
>>>         fds to a shared wakeup soruce. Depends on EPOLLEXCLUSIVE being set and
>>>         must be specified with an EPOLL_CTL_ADD operation.
>>>
>>> Thanks,
>> What permissions do you need on the file descriptor to do this?  This
>> will be the first case where a poll-like operation has side effects,
>> and that's rather weird IMO.
>>
>
> So in the case where you have both non-exclusive and exclusive
> waiters, all of the non-exclusive waiters will continue to get woken
> up. However, I think you're getting at having multiple exclusive
> waiters and potentially 'starving' out other exclusive waiters.
>
> In general, I think wait queues are associated with a 'struct file',
> so I think unless you are sharing your fd table, this isn't an issue.
> However, there may be cases where this is not true? In which
> case, perhaps, we could limit this to CAP_SYS_ADMIN...

There's also SCM_RIGHTS, which can be used in conjunction with file
sealing and such.

In general, I feel like this patch series solves a problem that isn't
well understood and does it by adding a rather strange new mechanism.
Is there really a problem that can't be addressed by more normal epoll
features?

--Andy

>
> Thanks,
>
> -Jason
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
