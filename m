Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50490522696;
	Thu, 15 Oct 2026 12:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792068222; cv=none; b=FNZvssBtDQ73OIi0ThkWs2LKrIBQ2yBTvJjAj2sPRq7iZB9gQvMnMYkc3vRj44kK8xG+DXIP4zisf27PRDY3F/E4MmO9Y0IuwNw2NI+Kz1/YWqK74DtRRFjmOjIHJRr32xc6gEuFeuOZMUGexAax9ERY91F9u2eUQ6lujkO6kxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792068222; c=relaxed/simple;
	bh=UsMU3icn0QTwqlxftcsv20B9+dw26KCfY6bdqomu2P8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GIwJZW4OdDq1obRIG89c1QHV7T417VnB8Bk9AiAeM8EG7J+bD7qApLQ6lyFD3okLMjPJs5LzsRdJ8lZ4ou9jb9nx2/aAaKm8MrW/8dVXc/irNwJmz2yrRYJXQfbst5Y1UyasHz3R7Igtdkn03xuXY7Ob/SxD74A4pgL6pWhjrZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=jqDnjaak; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="jqDnjaak"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792068214; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=WjpzvHXfTqZTVgcM3J2LTgAAvToedHvsUz3PQS7B0BU=;
	b=jqDnjaakfeeDrFWAqWlyLxwKmFwAz5m/tw8e7wtB6qqXKmUdIUIBHpTbx6pCNpuevDBJ7QTXHSkaBWAe/zwnDIoddaB4JdkiAUdzSn5UyvpOf0q0JNv1fLI4bvZOYNl3xDltxb5GC4zljx2mra99JUEXQihCS5SAHdluL2WfYOc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=peng_wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0XCrq.Qw_1792068212;
Received: from localhost(mailfrom:peng_wang@linux.alibaba.com fp:SMTPD_---0XCrq.Qw_1792068212 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 15 Oct 2026 20:43:33 +0800
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
Subject: [RFC PATCH 0/2] tick/nohz: Add runtime control of non-idle tick suppression
Date: Thu, 15 Oct 2026 20:43:07 +0800
Message-ID: <cover.1792067271.git.peng_wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Workloads and their need for periodic ticks can change after boot.
This series lets userspace choose at runtime which CPUs in the boot-time
nohz_full set retain the non-idle scheduler tick and which are permitted
to stop it, while preserving the existing isolation configuration.

The first patch adds a per-CPU tick dependency; the second exposes a
sysfs CPU list. Permission defaults to all nohz_full CPUs. Revocation
uses the existing asynchronous kick. Idle tick suppression is unchanged,
and policy persists across hotplug.

Existing cpuset partition modes do not express this independent tick
policy. Feedback on the proposed interface is welcome.

Thanks,
Peng

Peng Wang (2):
  tick/nohz: Add a policy dependency for full dynticks
  cpu: Add sysfs control of full dynticks policy

 .../ABI/testing/sysfs-devices-system-cpu      | 40 ++++++++++++
 drivers/base/cpu.c                            | 46 ++++++++++++++
 include/linux/tick.h                          |  8 ++-
 include/trace/events/timer.h                  |  3 +-
 kernel/time/tick-sched.c                      | 62 +++++++++++++++++++
 5 files changed, 156 insertions(+), 3 deletions(-)


base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
