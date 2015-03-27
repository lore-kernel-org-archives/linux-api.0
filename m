From: Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 4/5] selftest: Add futex tests to the top-level Makefile
Date: Fri, 27 Mar 2015 15:17:44 -0700
Message-ID: <dbaaa8da375e3192733ac7f7c7d92e1cfaa14c87.1427493640.git.dvhart@linux.intel.com>
References: <597c9eabcac5da9456d6cfd6de9117591d73385e.1427493640.git.dvhart@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <597c9eabcac5da9456d6cfd6de9117591d73385e.1427493640.git.dvhart@linux.intel.com>
In-Reply-To: <cover.1427493640.git.dvhart@linux.intel.com>
References: <cover.1427493640.git.dvhart@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Davidlohr Bueso <dave@stgolabs.net>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
List-Id: linux-api@vger.kernel.org

Enable futex tests to be built and run with the make kselftest and
associated targets.

Most of the tests require escalated privileges. These return ERROR, and
run.sh continues.

Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
---
 tools/testing/selftests/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 9af1df2..6eef08a 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -4,6 +4,7 @@ TARGETS += efivarfs
 TARGETS += exec
 TARGETS += firmware
 TARGETS += ftrace
+TARGETS += futex
 TARGETS += kcmp
 TARGETS += memfd
 TARGETS += memory-hotplug
-- 
2.1.4
