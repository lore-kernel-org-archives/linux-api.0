From: Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 6/6] selftests/futex: Add .gitignore
Date: Tue, 12 May 2015 21:07:57 -0700
Message-ID: <c767d524b21b430a3c10462d2da8e6588f59fa5f.1431489408.git.dvhart@linux.intel.com>
References: <077301628833a25c85ee597cd8f4b8fcc3f30714.1431489408.git.dvhart@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <077301628833a25c85ee597cd8f4b8fcc3f30714.1431489408.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1431489408.git.dvhart@linux.intel.com>
References: <cover.1431489408.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: chrubis@suse.cz, Darren Hart <dvhart@linux.intel.com>, Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Davidlohr Bueso <dave@stgolabs.net>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
List-Id: linux-api@vger.kernel.org

Add the futex/functional targets to .gitignore.

Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
---
 tools/testing/selftests/futex/functional/.gitignore | 7 +++++++
 1 file changed, 7 insertions(+)
 create mode 100644 tools/testing/selftests/futex/functional/.gitignore

diff --git a/tools/testing/selftests/futex/functional/.gitignore b/tools/testing/selftests/futex/functional/.gitignore
new file mode 100644
index 0000000..a09f570
--- /dev/null
+++ b/tools/testing/selftests/futex/functional/.gitignore
@@ -0,0 +1,7 @@
+futex_requeue_pi
+futex_requeue_pi_mismatched_ops
+futex_requeue_pi_signal_restart
+futex_wait_private_mapped_file
+futex_wait_timeout
+futex_wait_uninitialized_heap
+futex_wait_wouldblock
-- 
2.1.4
