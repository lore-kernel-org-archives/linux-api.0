From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: [PATCH, v9 2/3] hrtimer: implement PR_GET_EFFECTIVE_TIMERSLACK
Date: Mon, 14 Mar 2011 16:05:23 +0200
Message-ID: <1300111524-5666-3-git-send-email-kirill@shutemov.name>
References: <1300111524-5666-1-git-send-email-kirill@shutemov.name>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1300111524-5666-1-git-send-email-kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Menage <menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

PR_GET_EFFECTIVE_TIMERSLACK allows process to know its effective timer
slack value.

Signed-off-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
---
 include/linux/prctl.h |    6 ++++++
 kernel/sys.c          |    3 +++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/prctl.h b/include/linux/prctl.h
index a3baeb2..3199458 100644
--- a/include/linux/prctl.h
+++ b/include/linux/prctl.h
@@ -102,4 +102,10 @@
 
 #define PR_MCE_KILL_GET 34
 
+/*
+ * Get effective timerslack value for the process.
+ * It can be higher than PR_GET_TIMERSLACK.
+ */
+#define PR_GET_EFFECTIVE_TIMERSLACK 35
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 18da702..b2ec8bf 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1693,6 +1693,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		case PR_GET_TIMERSLACK:
 			error = current->timer_slack_ns;
 			break;
+		case PR_GET_EFFECTIVE_TIMERSLACK:
+			error = task_get_effective_timer_slack(current);
+			break;
 		case PR_SET_TIMERSLACK:
 			if (arg2 <= 0)
 				current->timer_slack_ns =
-- 
1.7.4.1
