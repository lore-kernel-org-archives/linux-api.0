From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH v2 0/2] Add epoll round robin wakeup mode
Date: Tue, 17 Feb 2015 19:33:36 +0000 (GMT)
Message-ID: <cover.1424200151.git.jbaron@akamai.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: peterz@infradead.org, mingo@redhat.com, viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, normalperson@yhbt.net, davidel@xmailserver.org, mtk.manpages@gmail.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

When we are sharing a wakeup source among multiple epoll fds, we end up with
thundering herd wakeups, since there is currently no way to add to the
wakeup source exclusively. This series introduces 2 new epoll flags,
EPOLLEXCLUSIVE for adding to a wakeup source exclusively. And EPOLLROUNDROBIN
which is to be used in conjunction to EPOLLEXCLUSIVE to evenly
distribute the wakeups. This patch was originally motivated by a desire to
improve wakeup balance and cpu usage for a listen socket() shared amongst
multiple epoll fd sets.

See: http://lwn.net/Articles/632590/ for previous test program and testing
resutls.

Epoll manpage text:

EPOLLEXCLUSIVE
        Provides exclusive wakeups when attaching multiple epoll fds to a
        shared wakeup source. Must be specified with an EPOLL_CTL_ADD operation.

EPOLLROUNDROBIN
        Provides balancing for exclusive wakeups when attaching multiple epoll
        fds to a shared wakeup soruce. Depends on EPOLLEXCLUSIVE being set and
        must be specified with an EPOLL_CTL_ADD operation.

Thanks,

-Jason


Jason Baron (2):
  sched/wait: add round robin wakeup mode
  epoll: introduce EPOLLEXCLUSIVE and EPOLLROUNDROBIN

 fs/eventpoll.c                 | 25 ++++++++++++++++++++-----
 include/linux/wait.h           | 11 +++++++++++
 include/uapi/linux/eventpoll.h |  6 ++++++
 kernel/sched/wait.c            | 10 ++++++++--
 4 files changed, 45 insertions(+), 7 deletions(-)

-- 
1.8.2.rc2
