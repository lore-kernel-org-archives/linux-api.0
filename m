From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 0/2] Add epoll round robin wakeup mode
Date: Tue, 17 Feb 2015 11:46:14 -0800
Message-ID: <CALCETrWAH7SbQm0T+_7wviiU6pJ0isBdWE-cQBGk-joAx2OzFw@mail.gmail.com>
References: <cover.1424200151.git.jbaron@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <cover.1424200151.git.jbaron@akamai.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jason Baron <jbaron@akamai.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Eric Wong <normalperson@yhbt.net>, Davide Libenzi <davidel@xmailserver.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 11:33 AM, Jason Baron <jbaron@akamai.com> wrote:
> When we are sharing a wakeup source among multiple epoll fds, we end up with
> thundering herd wakeups, since there is currently no way to add to the
> wakeup source exclusively. This series introduces 2 new epoll flags,
> EPOLLEXCLUSIVE for adding to a wakeup source exclusively. And EPOLLROUNDROBIN
> which is to be used in conjunction to EPOLLEXCLUSIVE to evenly
> distribute the wakeups. This patch was originally motivated by a desire to
> improve wakeup balance and cpu usage for a listen socket() shared amongst
> multiple epoll fd sets.
>
> See: http://lwn.net/Articles/632590/ for previous test program and testing
> resutls.
>
> Epoll manpage text:
>
> EPOLLEXCLUSIVE
>         Provides exclusive wakeups when attaching multiple epoll fds to a
>         shared wakeup source. Must be specified with an EPOLL_CTL_ADD operation.
>
> EPOLLROUNDROBIN
>         Provides balancing for exclusive wakeups when attaching multiple epoll
>         fds to a shared wakeup soruce. Depends on EPOLLEXCLUSIVE being set and
>         must be specified with an EPOLL_CTL_ADD operation.
>
> Thanks,

What permissions do you need on the file descriptor to do this?  This
will be the first case where a poll-like operation has side effects,
and that's rather weird IMO.

--Andy

>
> -Jason
>
>
> Jason Baron (2):
>   sched/wait: add round robin wakeup mode
>   epoll: introduce EPOLLEXCLUSIVE and EPOLLROUNDROBIN
>
>  fs/eventpoll.c                 | 25 ++++++++++++++++++++-----
>  include/linux/wait.h           | 11 +++++++++++
>  include/uapi/linux/eventpoll.h |  6 ++++++
>  kernel/sched/wait.c            | 10 ++++++++--
>  4 files changed, 45 insertions(+), 7 deletions(-)
>
> --
> 1.8.2.rc2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Andy Lutomirski
AMA Capital Management, LLC
