Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3AE358D32;
	Fri, 28 Aug 2026 22:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787955832; cv=none; b=nKZNrRPwTw71LX4J8wZogCURdgyuls9EqoZY4QbZoJt/EmvNaLy0yCpQ10g0dRt3o2tlHCQ4BGkSswqznl5zFLyXrZHU8IDTQZRotUxBaFhiHe4+1W1jMrigh6t7tTPrQLt8Wm84l9aBCgU4ETiqLyKoKSqCBalEOqDfQ7zdU+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787955832; c=relaxed/simple;
	bh=/1GTrB3TOT/arG1iykl2fKr/FaK0TAW1jHcQ/zElh6I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jGABT2PRAsp6EdmJEloB1Uta6KINNVl94Ds6K5UXQUHEysqSqAacCS7QLmlImyM51ujVEViz4VoC3GvqYIx3oHOjn9rGsSGKfQE0BuMx3S8cuWe5ZXdEl9mcUvnp+sFM/AQ2O1fuWyCqbyQddwgPS+OKfDz29ZWquOlAR7BXpec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KIGzw9Z6; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KIGzw9Z6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787955830; x=1819491830;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/1GTrB3TOT/arG1iykl2fKr/FaK0TAW1jHcQ/zElh6I=;
  b=KIGzw9Z6nTrI3EbC8Jot6CAvXvbD6ns1OfGJ4WB7lJxHWsbN9I1sctrC
   TDYBfGGOCAWA3OKWwcI2ltphQ0XFiCbLAf32SF2RCkRD4il48D6+Uc1Jg
   iT514QmB9KoGf0hnpZdsAuUUZcCpWeUmC2yBz7uLTTG7e3/G3JHvcqPBM
   3izbcnv/NYT5S8ebv09m69V1s5emzQtWyc6ZU08DZM/Xx9Snr09LuVM6T
   j/uQBO7tAjPHYwwvzWlkzvJn7wBE6g7bNAxBU3A82H9mmkFS09x+3tAyL
   T7Qj+gHc/BrUeWVUoPVsllnNH9PVNsNKLt+P54FxNUTrynZbe6KU35x/K
   A==;
X-CSE-ConnectionGUID: FeJksW2sTYqyLEpWsAXCqQ==
X-CSE-MsgGUID: YFWWP6eZTNKWWwcr2zCuCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="87412263"
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="87412263"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 15:23:49 -0700
X-CSE-ConnectionGUID: uIh/ETrYSaKvNwFx66zpzg==
X-CSE-MsgGUID: +TJjBMUkQO6Zxz9WFM4BzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="264540261"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa010.fm.intel.com with ESMTP; 28 Aug 2026 15:23:48 -0700
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Qais Yousef <qyousef@layalina.io>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Madadi Vineeth Reddy <vineethr@linux.ibm.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Jianyong Wu <jianyong.wu@outlook.com>,
	Yangyu Chen <cyy@cyyself.name>,
	Tingyin Duan <tingyin.duan@gmail.com>,
	Vern Hao <vernhao@tencent.com>,
	Vern Hao <haoxing990@gmail.com>,
	Len Brown <len.brown@intel.com>,
	Aubrey Li <aubrey.li@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Chen Yu <yu.chen.surf@gmail.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Adam Li <adamli@os.amperecomputing.com>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Tim Chen <tim.c.chen@intel.com>,
	Josh Don <joshdon@google.com>,
	Luo Gengkun <luogengkun2@huawei.com>,
	Gavin Guo <gavinguo@igalia.com>,
	Yi Lai <yi1.lai@intel.com>,
	Ricardo Neri <ricardo.neri@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: [RFC PATCH 0/7] sched/cache: Per-task control of cache aware scheduling via prctl
Date: Fri, 28 Aug 2026 15:29:07 -0700
Message-Id: <cover.1787955777.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Cache aware scheduling today groups tasks by their mm: the LLC aggregation
target lives in mm_struct, so the address space is the unit of grouping.
That works, but in some scenarios that is too coarse and too eager, and the
only knob we have over it is a single system-wide debugfs switch.

It's too coarse because plenty of workloads share data across cooperating
*processes* rather than threads - a database with a process per connection,
a browser with a renderer per site, a server and its worker helpers. They
pass data through shm or pipes and would love to be pulled onto the same
LLC, but they never share an mm, so today they can't be. And it's too eager
in the other direction: a process whose threads don't actually share
anything gets aggregated anyway, just because they happen to sit in one
address space.

So the core idea of this series is simple: allow other groupings than
the mm, make the grouping an object in its own right, and let user space
say "put these tasks together" explicitly.

What the series does
====================

Patches 1-3 are pure preparation, no behavior change. They turn the
per-mm statistics into a standalone, refcounted sched_cache_group, reach
it from task_struct instead of from p->mm, and pull the allocation out into
a helper. Once the group stands on its own, membership no longer has to
follow the mm address space.

Patch 4 adds the actual interface:

    int prctl(PR_SCHED_CACHE, subop, pid, arg4, pid_type);

    PR_SCHED_CACHE_GET         read back a task's (obfuscated) cookie id
    PR_SCHED_CACHE_CREATE      create a fresh group and install it
    PR_SCHED_CACHE_SHARE_FROM  copy the group of arg4 onto pid
    PR_SCHED_CACHE_DISABLE     opt this group out of LLC aggregation
    PR_SCHED_CACHE_ENABLE      opt it back in

'pid' is the task the operation applies to, with 0 meaning the caller, and
'pid_type' picks whether we touch just the thread, the whole thread group,
or the process group. Permissions follow core scheduling: every task we
touch has to pass ptrace_may_access(PTRACE_MODE_READ_REALCREDS), and for
the group scopes we check *all* of them before changing *any* of them, so
the operation is all-or-nothing.

Two subops need a word on their fourth argument:

  - GET writes the cookie id to arg4, which is a u64 __user * and must be
    8-byte aligned (misaligned pointers are rejected with -EINVAL). As in
    core scheduling the value handed out is an obfuscated hash of the
    kernel object, not a real pointer or a user-supplied number.

  - SHARE_FROM reads arg4 as the *source* pid and copies its group onto
    'pid'. CREATE is deliberately not idempotent - it always allocates a
    new group - so a caller that wants many tasks in one group does CREATE
    once and SHARE_FROM for the rest.

Patches 5-6 build on that. Patch 5 wires up DISABLE/ENABLE, and patch 6
turns the old debugfs boolean into a THP-style always/advise/never mode so
that the system policy and the per-task hint compose the same way THP's do:
'always' aggregates regardless of the per-task hint, 'advise' honors it,
'never' turns the whole thing off. The write side still accepts the old
0/1 (and y/n, on/off) spelling so existing scripts don't break; only the
read format grows to "[always] advise never".

Patch 7 documents the prctl and debugfs interface for cache aware
scheduling in kerneldoc.

Relation to sched QoS
=====================

This patch set is also inspired by Qais' sched QoS tool for finer-grained
control:

  https://lore.kernel.org/lkml/20260415000910.2h5misvwc45bdumu@airbuntu/
  https://github.com/qais-yousef/schedqos

There are two deliberate differences from the sched QoS interface:

1. The cookie is owned by the kernel. User space never invents or passes a
   cookie value - it only names tasks by pid and asks the kernel to create
   a group or link one task's group to another. That mirrors core
   scheduling, where PR_SCHED_CORE_GET only hands back an obfuscated id.
   It also relieves userspace the burden of cookie lifecycle management and
   avoiding duplicate cookies between separate entities doing the grouping.
   We think that it will make schedqos easier to implement.
   The cookie value is only meant to identify whether two tasks belong
   in the same cache scheduling group.

2. It's prctl() rather than sched_setattr(). Group membership isn't really
   an attribute value, and core scheduling already set a prctl-shaped
   precedent for "put these tasks together", so we reuse its subop layout,
   pid_type scoping and ptrace_may_access() permission model.

On the schedqos side the change would live in apply_thread_qos(): create
the group once per app instance and let the rest of the app join it -
roughly:

    if (!appi->grouped) {
        /* CREATE is not idempotent, do it once per instance */
        err = prctl(PR_SCHED_CACHE, PR_SCHED_CACHE_CREATE,
                    tgid, 0, PIDTYPE_TGID);
        appi->grouped = !err;
    } else {
        prctl(PR_SCHED_CACHE, PR_SCHED_CACHE_SHARE_FROM,
              pid, tgid, PIDTYPE_PID);
    }

Yangyu Chen also proposed exposing per-process parameters via prctl:
https://lore.kernel.org/all/tencent_93116D14C771DC8C988C10E3C634BE0CC107@qq.com/
That fits naturally on top of this if people agree the direction is right.

And in theory cgroup could offer per-cgroup cache aware scheduling with the
same mechanism - but we'd want input from the cgroup maintainers before
going anywhere near that.

Still to do
===========

  - Documentation for the new prctl (a prctl(2) man-page
    update).
  - A selftest under tools/testing/selftests exercising the subops and the
    permission checks - likewise TODO.

Feedbacks very welcome, especially on the interface shape (prctl vs. a QoS
attribute), the kernel-owned-cookie choice, and whether the always/advise/
never policy composition is the right model.

The series applies on v7.2-rc6.

Tim Chen and Chen Yu

Chen Yu (1):
  sched/cache: Extend the enabled debugfs to more modes

Tim Chen (6):
  sched/cache: Decouple sched_cache_group from mm
  sched/cache: Introduce task_struct->sched_cache_grp
  sched/cache: Extract sched_cache_alloc_group() helper
  sched/cache: Add prctl to manage per process cache scheduling groups
  sched/cache: Allow a process to enable cache aware scheduling via
    prctl
  sched/cache: Documentation: document the PR_SCHED_CACHE prctl

 .../admin-guide/kernel-parameters.txt         |   3 +
 Documentation/scheduler/index.rst             |   1 +
 Documentation/scheduler/sched-cache.rst       | 175 ++++++++
 fs/exec.c                                     |  24 ++
 include/linux/mm_types.h                      |  15 +-
 include/linux/sched.h                         |  18 +-
 include/uapi/linux/prctl.h                    |   9 +
 kernel/exit.c                                 |  35 +-
 kernel/fork.c                                 |  38 ++
 kernel/sched/build_utility.c                  |   4 +
 kernel/sched/cache_sched.c                    | 374 ++++++++++++++++++
 kernel/sched/debug.c                          |  63 ++-
 kernel/sched/fair.c                           | 188 +++++----
 kernel/sched/sched.h                          |  24 +-
 kernel/sched/topology.c                       |  32 +-
 kernel/sys.c                                  |   5 +
 16 files changed, 895 insertions(+), 113 deletions(-)
 create mode 100644 Documentation/scheduler/sched-cache.rst
 create mode 100644 kernel/sched/cache_sched.c

-- 
2.32.0

