Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4032C227B8E;
	Sun, 19 Apr 2026 07:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776583450; cv=none; b=gifiQ7Wpcl0vrWGoLT5nl6ymyuoeSXRwUS7hieWeStBqh1PujKObJkqXkKrgXK5WkpIe3FnFnVsBYT/9tdyrIMiAoH7233bkFA7xEoB9cg5oj2GMsyLs3BbShlFBgJb4mGgTKtJn7mPNSwtgNEkShBeFptaqpVrJvd0OEnLfzlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776583450; c=relaxed/simple;
	bh=fq1Pg2w7pa6VKPX5wza+N0sP6JsbH3BNSuK2KD6xzec=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E624bVWg4e439fORvYwmwXQcRHHgvWOfjn8L6VSuNQCU2Ymly0FfICxipvZ7NnY4kvLjs/ldbZbyr9e42QFeSbCkC23Xc2CUWBzGHW6HKFnZpUDNnjsG8DU/NTZ+GBrAzXYGgfkBHavYm49xSm6neSJ0417ZPohEck07e4yFCnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Jj40MzyD; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Jj40MzyD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=1m
	5ei45ZrcRKXLlMsprg/W/kkD0W4qlNlGa8sGc33rg=; b=Jj40MzyDnMLp7VexHL
	CPWQOhz3EUfZDkaTiLdylT1xTsMPDSArXqTsHs3MLLCyEhf/dC3a7SZy4fEjpLik
	yfnp+GrScEqdqosbj2I6z0yvVmjbD4tkMlSgClnNcLeiVpze85yPJqG8QwNpF/af
	eYorU+xJZ85+36yAMG/++guGA=
Received: from ubuntu.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wCXAmn2guRpNR8kAg--.64304S2;
	Sun, 19 Apr 2026 15:23:35 +0800 (CST)
From: chenheyun <chen_heyun@163.com>
To: rafael@kernel.org,
	pavel@ucw.cz
Cc: linux-pm@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenheyun <chen_heyun@163.com>
Subject: [PATCH] [PATCH] PM: docs: Add comprehensive wakeup_count documentation
Date: Sun, 19 Apr 2026 00:23:30 -0700
Message-Id: <20260419072330.101419-1-chen_heyun@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXAmn2guRpNR8kAg--.64304S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxuF4rCrWUuFWDWr1Utw4ktFb_yoWrJF1kp3
	sxKrySq3W8Ary5CFn3KF18JryfZw109F43CF1kCw10yrn8Zr90yr43KF1rtFZ0krWxAayY
	qF12g34UZ3W2ka7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRHlkcUUUUU=
X-CM-SenderInfo: xfkh0spkh130i6rwjhhfrp/xtbC8Rdxt2nkgveF-QAA3g

The current Documentation/power/wakeup-count.rst is empty and lacks
description of the race-free suspend mechanism, sysfs ABI semantics,
blocking behavior, and standard userspace usage.

Add complete documentation for /sys/power/wakeup_count, including
overview, interface semantics, usage example, and related interfaces.

Also update Documentation/power/index.rst to include the new document.

Signed-off-by: chenheyun <chen_heyun@163.com>
---
 Documentation/power/index.rst        |  1 +
 Documentation/power/wakeup-count.rst | 63 ++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)
 create mode 100644 Documentation/power/wakeup-count.rst

diff --git a/Documentation/power/index.rst b/Documentation/power/index.rst
index b4581e4ae785..901268049d7c 100644
--- a/Documentation/power/index.rst
+++ b/Documentation/power/index.rst
@@ -27,6 +27,7 @@ Power Management
     swsusp
     video
     tricks
+    wakeup-count
 
     userland-swsusp
 
diff --git a/Documentation/power/wakeup-count.rst b/Documentation/power/wakeup-count.rst
new file mode 100644
index 000000000000..5f3a1ca654ce
--- /dev/null
+++ b/Documentation/power/wakeup-count.rst
@@ -0,0 +1,63 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. Copyright (C) 2025 The Linux Foundation
+
+The wakeup_count mechanism for race-free suspend
+================================================
+
+Overview
+--------
+
+The ``/sys/power/wakeup_count`` sysfs interface provides a stable userspace
+mechanism to perform race-free system suspend transitions. It eliminates the
+well-known race condition between suspend permission check and actual system
+suspend entry.
+
+Userspace may use it in a standard three-step sequence:
+
+1. Read the current global wakeup event counter. The read operation blocks
+   until all ongoing wakeup event processing is finished, returning a stable value.
+2. Perform necessary suspend preparation steps in userspace.
+3. Write the previously-read counter value back to the interface.
+   The write operation will only succeed if no new wakeup events have occurred
+   since the read.
+
+Only after a successful write may userspace safely trigger system suspend.
+
+Interface semantics
+-------------------
+
+``/sys/power/wakeup_count``
+
+**Read**
+    Returns the global monotonically-increasing wakeup event counter.
+    This call blocks until there are no wakeup events under active processing
+    inside the kernel. If interrupted by a signal, it returns -EINTR.
+
+**Write**
+    Accepts the counter value obtained from a prior read.
+    The write succeeds only if the kernel's current counter exactly matches
+    the written value. Mismatch indicates new wakeup events arrived during
+    userspace preparation, and suspend must be aborted.
+
+Standard userspace usage example
+--------------------------------
+
+.. code-block:: shell
+
+    count=$(cat /sys/power/wakeup_count)
+    do_suspend_preparation
+    echo "$count" > /sys/power/wakeup_count && echo mem > /sys/power/state
+
+Blocking behavior
+-----------------
+
+The blocking read ensures that userspace never observes an inconsistent state
+where wakeup events are still being handled within the kernel. This stability
+is the core guarantee of the interface.
+
+Related kernel interfaces
+-------------------------
+
+- ``/sys/power/state``: System suspend state control interface.
+- ``/sys/kernel/debug/wakeup_sources``: Per-device wakeup source statistics.
+- ``Documentation/power/wakeup-events.rst``: General wakeup event framework.
\ No newline at end of file
-- 
2.25.1

