From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET] workqueue: Show the latest workqueue name in /proc/PID/{comm,stat,status}
Date: Wed, 16 May 2018 21:34:42 -0700
Message-ID: <20180517043448.3152269-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, jiangshanlai@gmail.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, kernel-team@fb.com, csmall@enc.com.au
List-Id: linux-api@vger.kernel.org

There can be a lot of workqueue workers and they all show up with the
cryptic kworker/* names making it difficult to understand which is
doing what and how they came to be.

 # ps -ef | grep kworker
 root           4       2  0 Feb25 ?        00:00:00 [kworker/0:0H]
 root           6       2  0 Feb25 ?        00:00:00 [kworker/u112:0]
 root          19       2  0 Feb25 ?        00:00:00 [kworker/1:0H]
 root          25       2  0 Feb25 ?        00:00:00 [kworker/2:0H]
 root          31       2  0 Feb25 ?        00:00:00 [kworker/3:0H]
 ...

This patchset makes workqueue workers report the latest workqueue it
was executing for through /proc/PID/{comm,stat,status}.  The extra
information is appended to the kthread name with intervening '+' if
currently executing, otherwise '-'.

 # cat /proc/25/comm
 kworker/2:0-events_power_efficient
 # cat /proc/25/stat
 25 (kworker/2:0-events_power_efficient) I 2 0 0 0 -1 69238880 0 0...
 # grep Name /proc/25/status
 Name:   kworker/2:0-events_power_efficient

For details on the design decisions, please refer to the following
thread.

 http://lkml.kernel.org/r/20180516153939.GH2368884@devbig577.frc2.facebook.com

This patchset contains the following six patches.

 0001-proc-Don-t-allow-empty-proc-PID-cmdline-for-user-tas.patch
 0002-workqueue-Replace-pool-attach_mutex-with-global-wq_p.patch
 0003-workqueue-Make-worker_attach-detach_pool-update-work.patch
 0004-workqueue-Set-worker-desc-to-workqueue-name-by-defau.patch
 0005-proc-Consolidate-task-comm-formatting-into-proc_task.patch
 0006-workqueue-Show-the-latest-workqueue-name-in-proc-PID.patch

I'm applying the patches to wq/for-4.18.  Please let me know if the
patchset need updates (the branch doesn't have any other changes
anyway).  diffstat follows.  Thanks.

 fs/proc/array.c             |   33 +++++++-----
 fs/proc/base.c              |   27 +++++++---
 fs/proc/internal.h          |    2 
 include/linux/workqueue.h   |    1 
 kernel/workqueue.c          |  117 ++++++++++++++++++++++++++++----------------
 kernel/workqueue_internal.h |    3 -
 6 files changed, 122 insertions(+), 61 deletions(-)

--
tejun
