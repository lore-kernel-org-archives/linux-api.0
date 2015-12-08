From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH] epoll: add exclusive wakeups flag
Date: Mon,  7 Dec 2015 22:23:46 -0500
Message-ID: <cover.1449523436.git.jbaron@akamai.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: mingo@kernel.org, peterz@infradead.org, viro@ftp.linux.org.uk, mtk.manpages@gmail.com, normalperson@yhbt.net, m@silodev.com, corbet@lwn.net, luto@amacapital.net, torvalds@linux-foundation.org, hagen@jauu.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

Re-post of an old series addressing thundering herd issues when sharing
an event source fd amongst multiple epoll fds. Last posting was here
for reference: https://lkml.org/lkml/2015/2/25/56
 
The patch herein drops the core scheduler 'rotate' changes I had previously
proposed as this patch seems performant without those.

I was prompted to re-post this because Madars Vitolins reported some good
speedups with this patch using Enduro/X application. His writeup is here:
https://mvitolin.wordpress.com/2015/12/05/endurox-testing-epollexclusive-flag/

Thanks,

-Jason

Sample epoll_clt text:

EPOLLEXCLUSIVE
        Sets an exclusive wakeup mode for the epfd file descriptor that is
	being attached to the target file descriptor, fd. Thus, when an
	event occurs and multiple epfd file descriptors are attached to the
	same target file using EPOLLEXCLUSIVE, one or more epfds will receive
	an event with epoll_wait(2). The default in this scenario (when
	EPOLLEXCLUSIVE is not set) is for all epfds to receive an event.
	EPOLLEXLUSVIE may only be specified with the op EPOLL_CTL_ADD.

Jason Baron (1):
  epoll: add EPOLLEXCLUSIVE flag

 fs/eventpoll.c                 | 24 +++++++++++++++++++++---
 include/uapi/linux/eventpoll.h |  3 +++
 2 files changed, 24 insertions(+), 3 deletions(-)

-- 
2.6.1
