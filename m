From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: [RFC PATCH 00/14] kthread: Use kthread worker API more widely
Date: Tue, 28 Jul 2015 16:39:17 +0200
Message-ID: <1438094371-8326-1-git-send-email-pmladek@suse.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Kthreads are currently implemented as an infinite loop. Each
has its own variant of checks for terminating, freezing,
awakening. Sometimes, it is hard to say if they are done
correctly. They are also harder to maintain if there is
a generic problem found in the area.

I have proposed a so-called kthread iterant API to improve the situation,
see https://lkml.org/lkml/2015/6/5/555. The RFC opened and/or answered
several questions.

This RFC is reaction on Tejun's suggestion to use the existing kthread
worker API instead of a new one, see https://lkml.org/lkml/2015/6/9/77.
I wanted to give it a try.


Structure of this patch set:
----------------------------

1st..6th patches: improve the existing kthread worker API

7th, 8th, 11th patches: converts three kthreads into the new API,
     namely: RCU gp kthreas, khugepaged, my favorite ring buffer
     benchmark

12th..14th patches: show how we could further improve the API

9th, 10th patches:  do some further clean up of the ring buffer
     benchmark; they allow easier conversion into the new API;
     but they might be applied independently


TODO:
-----

If people like the kthread worker API, it will need more love.
The following ideas come to my mind:

  + allow to pass void *data via struct kthread_work;
  + hide struct kthread_worker in kthread.c and make the API
    more safe
  + allow to cancel work


I have tested this patches against today's Linux tree, aka 4.2.0-rc4+.

Petr Mladek (14):
  kthread: Allow to call __kthread_create_on_node() with va_list args
  kthread: Add create_kthread_worker*()
  kthread: Add drain_kthread_worker()
  kthread: Add destroy_kthread_worker()
  kthread: Add wakeup_and_destroy_kthread_worker()
  kthread: Add kthread_worker_created()
  mm/huge_page: Convert khugepaged() into kthread worker API
  rcu: Convert RCU gp kthreads into kthread worker API
  ring_buffer: Initialize completions statically in the benchmark
  ring_buffer: Fix more races when terminating the producer in the
    benchmark
  ring_buffer: Use kthread worker API for the producer kthread in the
    benchmark
  kthread_worker: Better support freezable kthread workers
  kthread_worker: Add set_kthread_worker_user_nice()
  kthread_worker: Add set_kthread_worker_scheduler*()

 include/linux/kthread.h              |  29 +++
 kernel/kthread.c                     | 359 +++++++++++++++++++++++++++++++----
 kernel/rcu/tree.c                    | 182 +++++++++---------
 kernel/rcu/tree.h                    |   4 +-
 kernel/trace/ring_buffer_benchmark.c | 150 ++++++++-------
 mm/huge_memory.c                     |  83 ++++----
 6 files changed, 584 insertions(+), 223 deletions(-)

-- 
1.8.5.6
