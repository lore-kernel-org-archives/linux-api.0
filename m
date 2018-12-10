From: Waiman Long <longman@redhat.com>
Subject: [PATCH v5 4/5] sched/core: Make cpu cgroup controller bypassable
Date: Mon, 10 Dec 2018 16:40:57 -0500
Message-ID: <1544478058-24252-5-git-send-email-longman@redhat.com>
References: <1544478058-24252-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1544478058-24252-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, Roman Gushchin <guro@fb.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Shakeel Butt <shakeelb@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Waiman Long <longman@redhat.com>
List-Id: linux-api@vger.kernel.org

Make the cpu cgroup controller bypassable in the default hierarchy so
that cpu controller could be activated only in those cgroups that really
need it instead of all the cgroups down to the lowest level that need it.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/sched/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f12225f..ba4550c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7000,6 +7000,7 @@ struct cgroup_subsys cpu_cgrp_subsys = {
 	.dfl_cftypes	= cpu_files,
 	.early_init	= true,
 	.threaded	= true,
+	.bypassable	= true,
 };
 
 #endif	/* CONFIG_CGROUP_SCHED */
-- 
1.8.3.1
