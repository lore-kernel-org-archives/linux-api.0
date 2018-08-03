From: =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
Subject: [PATCH v3 2/2] prctl: add PR_[GS]ET_KILLABLE
Date: Fri,  3 Aug 2018 16:40:21 +0200
Message-ID: <20180803144021.56920-2-j@bitron.ch>
References: <20180730075241.24002-1-j@bitron.ch>
 <20180803144021.56920-1-j@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180803144021.56920-1-j@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Eric Biederman <ebiederm@xmission.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
List-Id: linux-api@vger.kernel.org

PR_SET_KILLABLE clears the SIGNAL_UNKILLABLE flag. This allows
CLONE_NEWPID tasks to restore normal signal behavior, opting out of the
special signal protection for init processes. This prctl does not allow
setting the SIGNAL_UNKILLABLE flag, only clearing.

The SIGNAL_UNKILLABLE flag, which is implicitly set for tasks cloned
with CLONE_NEWPID, has the effect of ignoring all signals (from
userspace) if the corresponding handler is set to SIG_DFL. The only
exceptions are SIGKILL and SIGSTOP and they are only accepted if raised
from an ancestor namespace.

SIGINT, SIGQUIT and SIGTSTP are used in job control for ^C, ^\, ^Z.
While a task with the SIGNAL_UNKILLABLE flag could install handlers for
these signals, this is not sufficient to implement a shell that uses
CLONE_NEWPID for child processes:

 * As SIGSTOP is ignored when raised from the SIGNAL_UNKILLABLE process
   itself, it's not possible to implement the stop action in a custom
   SIGTSTP handler.
 * Many applications do not install handlers for these signals and
   thus, job control won't work properly with unmodified applications.

There are other scenarios besides job control in a shell where
applications rely on the default actions as described in signal(7) and
PID isolation may be useful. This new prctl makes the signal protection
for "init" processes optional, without breaking backward compatibility.

Signed-off-by: Jürg Billeter <j@bitron.ch>
---
 include/uapi/linux/prctl.h |  4 ++++
 kernel/sys.c               | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index c0d7ea0bf5b6..92afb63da727 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -219,4 +219,8 @@ struct prctl_mm_map {
 # define PR_SPEC_DISABLE		(1UL << 2)
 # define PR_SPEC_FORCE_DISABLE		(1UL << 3)
 
+/* Control SIGNAL_UNKILLABLE */
+#define PR_GET_KILLABLE			54
+#define PR_SET_KILLABLE			55
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 38509dc1f77b..92c9322cfb98 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2484,6 +2484,19 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			return -EINVAL;
 		error = arch_prctl_spec_ctrl_set(me, arg2, arg3);
 		break;
+	case PR_GET_KILLABLE:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = put_user(!(me->signal->flags & SIGNAL_UNKILLABLE),
+				 (int __user *)arg2);
+		break;
+	case PR_SET_KILLABLE:
+		if (arg2 != 1 || arg3 || arg4 || arg5)
+			return -EINVAL;
+		spin_lock_irq(&me->sighand->siglock);
+		me->signal->flags &= ~SIGNAL_UNKILLABLE;
+		spin_unlock_irq(&me->sighand->siglock);
+		break;
 	default:
 		error = -EINVAL;
 		break;
-- 
2.18.0
