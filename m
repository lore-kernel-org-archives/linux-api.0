Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B363AA1A9;
	Fri, 28 Aug 2026 22:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787955852; cv=none; b=Rx0H40DUKpEocdgv/Z6GX+M+vZxsrB++FAawiGD+wpH+OCaXbePMAXTaDT0rQaYorz+Z7sBe7AOGewLgn3gFEQr/X91wxTUheSpDKr4mi51mNQ3kj22ms//ZhtsFBmE396LN4le0f1jkwq0opqMKBnZvufA/AGpvfHQ++MPMdPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787955852; c=relaxed/simple;
	bh=FE9HEPduTEIxPTgkPLJpb410zPHdhLbUT4oqpU/8vxs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l/ilYpmqC2TWQt1Ec0/KroEPYCmxwjBxYqE4w5w+Il+hZjzKHBfo6BjBPf43Jlay2R850A9bPvKROFqI47U5R6oNWbaha7AyQaEISSwojysVvVzEgeKbNxOcmpZER8Nq/J1titmXbi0DEaEizGYHl7CMx5DKtEpFWJO5EOxDpt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l807Imck; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l807Imck"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787955840; x=1819491840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FE9HEPduTEIxPTgkPLJpb410zPHdhLbUT4oqpU/8vxs=;
  b=l807Imck+cGxMHLkH/5j9TSuo/7Sh5EK0B9KMIykDSd3vAGVyeE68ELf
   ntXafwejLUqlb9dYRUeC2P1fRygqdbet1LpZ+RrdpIFEG/azopEyMqq6i
   84hdgg0IUdKaiDTo8xlg7ZEPnyZadJN9gSP6/GZUmHE8cNlMt2ikV1JDS
   1CSINH72MLCKyZCscH7ie4WN/BhIeySSH7w+AVNVusA7uMxMXmD6qcF7p
   0kkNreAz/TzJOErGvbbQReUpb9SRRxsbtFmfbscopdh/8ONJoz5o9+Hte
   fzJxYoH9BapNSeGQjiuyc5d7FUebX76dBWq1ykmxgxrYCXt3psQpVtkgD
   A==;
X-CSE-ConnectionGUID: c/1a1mt1THCvg9tOvYPVEg==
X-CSE-MsgGUID: ZT5GjM49QxOoFU9hby+Pmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11889"; a="87412398"
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="87412398"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 15:23:59 -0700
X-CSE-ConnectionGUID: t4Vn67LLSsqheMt730Ee7A==
X-CSE-MsgGUID: lTjHApJRQdOcqrCVWEZs2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,249,1779174000"; 
   d="scan'208";a="264540295"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa010.fm.intel.com with ESMTP; 28 Aug 2026 15:23:59 -0700
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
Subject: [RFC PATCH 7/7] sched/cache: Documentation: document the PR_SCHED_CACHE prctl
Date: Fri, 28 Aug 2026 15:29:14 -0700
Message-Id: <86909723689d9c496b5a67ee2a0ecfd0d63e8712.1787955777.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1787955777.git.tim.c.chen@linux.intel.com>
References: <cover.1787955777.git.tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add Documentation/scheduler/sched-cache.rst describing cache aware
scheduling and the PR_SCHED_CACHE prctl() interface: the
GET/CREATE/SHARE_FROM/DISABLE/ENABLE sub-operations, their arguments,
the ptrace_may_access() permission model, the return values and how the
per-task hint composes with the always/advise/never debugfs policy.

Hook it into the scheduler documentation toctree.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 Documentation/scheduler/index.rst       |   1 +
 Documentation/scheduler/sched-cache.rst | 175 ++++++++++++++++++++++++
 2 files changed, 176 insertions(+)
 create mode 100644 Documentation/scheduler/sched-cache.rst

diff --git a/Documentation/scheduler/index.rst b/Documentation/scheduler/index.rst
index 17ce8d76befc..5c575593723a 100644
--- a/Documentation/scheduler/index.rst
+++ b/Documentation/scheduler/index.rst
@@ -23,5 +23,6 @@ Scheduler
     sched-stats
     sched-ext
     sched-debug
+    sched-cache
 
     text_files
diff --git a/Documentation/scheduler/sched-cache.rst b/Documentation/scheduler/sched-cache.rst
new file mode 100644
index 000000000000..3144934ffa88
--- /dev/null
+++ b/Documentation/scheduler/sched-cache.rst
@@ -0,0 +1,175 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=======================
+Cache Aware Scheduling
+=======================
+
+Overview
+========
+
+On a machine with several last level caches (LLCs), it can pay off to keep
+a set of cooperating tasks on CPUs that share one LLC, so that the data
+they pass between each other stays cache hot instead of bouncing across
+the interconnect.
+
+The scheduler tracks, per group of tasks, how much runtime the group spends
+on each LLC and nudges the group's members towards the LLC where it is most
+active, as long as that LLC is not already overcommitted. This is enabled by
+CONFIG_SCHED_CACHE.
+
+The unit that is aggregated is a *cache group* (struct sched_cache_group).
+By default every address space (mm) gets its own cache group, so the threads
+of a process are aggregated together and nothing else is. That default is a
+good fit for a classic multi-threaded process, but not for every workload:
+
+  - A workload split across cooperating *processes* rather than threads - a
+    database with a process per connection, a browser with a renderer per
+    site, a server and its worker helpers - shares data through shared memory
+    or pipes but never shares an mm, so the default never aggregates it.
+
+  - A process whose threads do not actually share data is aggregated anyway,
+    just because the threads live in one address space.
+
+To cover those cases a process can manage cache group membership explicitly
+through prctl(2).
+
+The prctl() interface
+=====================
+
+::
+
+    int prctl(int option, unsigned long subop, unsigned long pid,
+              unsigned long arg4, unsigned long pid_type);
+
+with ``option`` set to ``PR_SCHED_CACHE``. The remaining arguments are:
+
+``subop``
+    Which operation to perform (see below).
+
+``pid``
+    The task the operation applies to. ``0`` means the calling task.
+
+``arg4``
+    Only used by ``PR_SCHED_CACHE_GET`` (output pointer) and
+    ``PR_SCHED_CACHE_SHARE_FROM`` (source pid). Must be ``0`` for every
+    other sub-operation.
+
+``pid_type``
+    One of ``PIDTYPE_PID``, ``PIDTYPE_TGID`` or ``PIDTYPE_PGID`` (0, 1, 2).
+    It selects whether the operation affects just the named thread, its whole
+    thread group, or its process group. ``PR_SCHED_CACHE_GET`` requires
+    ``PIDTYPE_PID``.
+
+The cache group itself is a kernel object. User space never invents or
+passes a group id; it only names tasks by pid and asks the kernel to create
+a group or to copy one task's group onto another. This follows core
+scheduling, where the cookie is a kernel object and only an obfuscated
+identifier is returned by ``PR_SCHED_CACHE_GET``.
+
+Sub-operations
+--------------
+
+``PR_SCHED_CACHE_GET``
+    Read back the cache group id of ``pid``. ``arg4`` is a
+    ``__u64 __user *`` that must be 8-byte aligned; the kernel writes an
+    obfuscated hash of the task's cache group there (0 if the task currently
+    has no group). ``pid_type`` must be ``PIDTYPE_PID``.
+
+``PR_SCHED_CACHE_CREATE``
+    Allocate a fresh cache group and install it on the target task(s). This
+    operation is *not* idempotent: each call creates a new group. A caller
+    that wants several tasks in one group should ``CREATE`` once and then
+    ``SHARE_FROM`` for the rest.
+
+``PR_SCHED_CACHE_SHARE_FROM``
+    Copy the cache group of the task named by ``arg4`` (the source) onto the
+    task(s) named by ``pid``. This is how a task joins an existing group.
+
+``PR_SCHED_CACHE_DISABLE`` / ``PR_SCHED_CACHE_ENABLE``
+    Opt the target's cache group out of / back into LLC aggregation. Because
+    the flag lives on the (shared) group, changing it for one member changes
+    it for every task in the group.
+
+Permissions
+-----------
+
+The caller must be able to ``ptrace_may_access(PTRACE_MODE_READ_REALCREDS)``
+every task it touches. For the ``PIDTYPE_TGID`` and ``PIDTYPE_PGID`` scopes
+the access of *all* tasks in the group is checked before *any* task is
+changed, so the operation either applies to the whole group or fails with
+-EPERM without touching anyone. ``PR_SCHED_CACHE_SHARE_FROM`` additionally
+requires access to the source task.
+
+Kernel threads cannot be targeted.
+
+Return value
+------------
+
+Returns 0 on success. On error one of:
+
+``-EINVAL``
+    Unknown sub-operation, out-of-range ``pid``/``pid_type``, ``arg4`` given
+    for a sub-operation that does not take one, misaligned ``GET`` pointer,
+    ``GET`` with a ``pid_type`` other than ``PIDTYPE_PID``, or the target is
+    a kernel thread.
+
+``-ESRCH``
+    The target (or, for ``SHARE_FROM``, the source) task does not exist.
+
+``-EPERM``
+    The caller is not allowed to access the target (or source) task.
+
+``-ENOENT``
+    The source task (``SHARE_FROM``) or target task (``DISABLE``/``ENABLE``)
+    has no cache group.
+
+``-ENOMEM``
+    ``CREATE`` could not allocate a new group.
+
+``-EFAULT``
+    ``GET`` could not write to the ``arg4`` pointer.
+
+Interaction with the system-wide policy
+=======================================
+
+A system-wide policy composes with the per-task hint the same way THP does.
+It is set through debugfs::
+
+    /sys/kernel/debug/sched/llc_balancing/enabled
+
+and takes one of three modes:
+
+``always``
+    Always aggregate, ignoring the per-group disable flag (the default).
+
+``advise``
+    Honour the per-group flag set through ``PR_SCHED_CACHE_DISABLE`` /
+    ``PR_SCHED_CACHE_ENABLE``.
+
+``never``
+    Disable cache aware scheduling entirely.
+
+For backward compatibility the knob still accepts the old boolean spelling on
+write (``1``/``y``/``on`` map to ``always``, ``0``/``n``/``off`` to
+``never``); reads show ``[always] advise never`` with the active mode in
+brackets.
+
+The same three modes can be selected at boot time, before any process has
+had a chance to use the prctl, with the kernel command line parameter::
+
+    sched_cache={always|advise|never}
+
+The debugfs knob can still be written afterwards to change the mode at
+runtime.
+
+Example
+=======
+
+Put a helper process into the same cache group as its parent::
+
+    /* In the parent, once per instance. */
+    prctl(PR_SCHED_CACHE, PR_SCHED_CACHE_CREATE, 0, 0, PIDTYPE_TGID);
+
+    /* In (or on behalf of) each helper. */
+    prctl(PR_SCHED_CACHE, PR_SCHED_CACHE_SHARE_FROM,
+          helper_pid, parent_tgid, PIDTYPE_PID);
-- 
2.32.0

