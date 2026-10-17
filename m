Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8EB3126DF;
	Sat, 17 Oct 2026 13:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792242844; cv=none; b=EKZB/C31w/j9mOSdwI7J5bsLlqlRaVckytWRprtpfOAc7Qw6cjictUOrPXkj4srjMCJVn5EEjLNwFqmO4YYbzBR5q4LSLN0M/EvFJSFmP7bo6l+nA0OJY4XF3MYMIuCMVcJFrN9JpSO7+Ke1LNs9PWr8P7Q+4KhAmB1Kwsdr4J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792242844; c=relaxed/simple;
	bh=QjlSGpgxfiEShBSdnAIJv21OGrR3UYoK5MYiD0WDIqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WPrRxY1dQ20mjn5BJcO7/aHsRW9M1tS1JlFN2ne8PH8wZm4mUVh1k8R9es0jqbyp4dy0FpwyjeK4TvlgcVRESMGm792RS0OwAwxUSr9PA6bFqO454J70Azc45f4C0B/McInCwpJOFIGHyyrQBc3L8QQCGYixdZazfI3d2a5GZRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=S+IeRic3; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="S+IeRic3"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792242831; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=p1OMSvKiOynWMS149XzymCG5yePx5W1zvYizF/4+cRA=;
	b=S+IeRic388kEwWitan9ctAdR0a0xp628fp6mQWadXIoA5GfdeCGzgZsWaFOocAKI+m3tZDRIfMvvEB+A2fDgi+oiuoYKGB7ppRKLpgsL4lkO/LnECtPkbkSnHMsZK5H0yYReE5Y8OkWRh3iltzleHy4fatAkjI/CqxYoMhEJnnQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=peng_wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XCxEdgs_1792242830;
Received: from localhost(mailfrom:peng_wang@linux.alibaba.com fp:SMTPD_---0XCxEdgs_1792242830 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 17 Oct 2026 21:13:50 +0800
From: Peng Wang <peng_wang@linux.alibaba.com>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Cc: Peng Wang <peng_wang@linux.alibaba.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	He Rongguang <herongguang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 0/2] tick/nohz: Add per-CPU control of non-idle tick suppression
Date: Sat, 17 Oct 2026 21:13:40 +0800
Message-ID: <cover.1792242566.git.peng_wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds per-CPU control of non-idle tick suppression within
the boot-time nohz_full set. The policy can be changed without taking
CPUs offline.

Some cloud hosts pin vCPU threads one-to-one to host CPUs. At full
allocation, housekeeping CPUs also provide vCPU capacity and always
retain their non-idle tick. Operators want comparable performance for
otherwise equivalent vCPUs, regardless of CPU placement. Retaining the
non-idle tick on nohz_full CPUs as well avoids one placement-dependent
difference in host tick interference.

With spare capacity, selected nohz_full CPUs may stop the tick to reduce
host scheduler-tick interference with vCPUs. Allocation changes as VMs
are created or destroyed while other VMs remain running. A vCPU thread
may be the only runnable task in either state, so existing tick
dependencies do not express this policy.

The per-CPU nohz_tick_allowed boolean defaults to 1 (allowed). Writing
0 prevents non-idle tick suppression; writing 1 allows it, subject to
existing dependencies. Readback reports permission, not tick state.
This leaves idle tick suppression, nohz_full membership, context
tracking, RCU offloading and housekeeping configuration unchanged.

This series depends on the separately submitted nohz kick fix [2].
Testing used that fix together with this series in x86_64 KVM guests,
with NO_HZ_FULL enabled and disabled.

Changes since v1:
- Following Greg's sysfs feedback [1], replace the global CPU list with
  a per-CPU boolean, removing the list-size and custom parsing issues.
- Rename nohz_full_allowed to nohz_tick_allowed, as suggested by Waiman.
- Explain the vCPU allocation use case and clarify permission semantics.

v1: https://lore.kernel.org/all/cover.1792067271.git.peng_wang@linux.alibaba.com/
[1] https://lore.kernel.org/all/2026101743-monotype-demeaning-f97b@gregkh/
[2] "tick/nohz: Requeue kicks flushed outside hardirq context"
    Message-ID: <43668cf88d976084e2865ec07dea82b64ad402ba.1792240863.git.peng_wang@linux.alibaba.com>

Peng Wang (2):
  tick/nohz: Add a policy dependency for full dynticks
  cpu: Add per-CPU control of non-idle tick suppression

 .../ABI/testing/sysfs-devices-system-cpu      | 27 ++++++++++
 drivers/base/cpu.c                            | 53 +++++++++++++++++++
 include/linux/tick.h                          |  8 ++-
 include/trace/events/timer.h                  |  3 +-
 kernel/time/tick-sched.c                      | 42 +++++++++++++++
 5 files changed, 130 insertions(+), 3 deletions(-)


base-commit: 70dd4ee72eb2d5793c62e71c14e3aba78e5a4e56
prerequisite-patch-id: 6036ece815f0ab92a0413d433675d5b240b7a8c1
-- 
2.47.0

