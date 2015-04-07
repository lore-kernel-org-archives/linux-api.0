From: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] selftests/timers: Make git ignore all binaries in timers
 test suite
Date: Tue, 7 Apr 2015 15:58:41 +0800
Message-ID: <55238E31.7000607@huawei.com>
References: <1428053591-67246-1-git-send-email-zhenzhang.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428053591-67246-1-git-send-email-zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch includes the timers test binaries into the .gitignore
file listing in their respective directories. This will make sure
that git ignores all of these test binaries when displaying status.

Signed-off-by: Zhang Zhen <zhenzhang.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 tools/testing/selftests/timers/.gitignore | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 tools/testing/selftests/timers/.gitignore

diff --git a/tools/testing/selftests/timers/.gitignore b/tools/testing/selftests/timers/.gitignore
new file mode 100644
index 0000000..ced9981
--- /dev/null
+++ b/tools/testing/selftests/timers/.gitignore
@@ -0,0 +1,18 @@
+alarmtimer-suspend
+change_skew
+clocksource-switch
+inconsistency-check
+leap-a-day
+leapcrash
+mqueue-lat
+nanosleep
+nsleep-lat
+posix_timers
+raw_skew
+rtctest
+set-2038
+set-tai
+set-timer-lat
+skew_consistency
+threadtest
+valid-adjtimex
-- 
1.8.5.5


.
