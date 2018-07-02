From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH for 4.18 1/2] rseq: use __u64 for rseq_cs fields, validate abort_ip < TASK_SIZE
Date: Mon,  2 Jul 2018 16:40:57 -0400
Message-ID: <20180702204058.819-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@g>
List-Id: linux-api@vger.kernel.org

Change the rseq ABI so rseq_cs start_ip, post_commit_offset and abort_ip
fields are seen as 64-bit fields by both 32-bit and 64-bit kernels rather
that ignoring the 32 upper bits on 32-bit kernels. This ensures we have a
consistent behavior for a 32-bit binary executed on 32-bit kernels and in
compat mode on 64-bit kernels.

Validating the value of abort_ip field to be below TASK_SIZE ensures the
kernel don't return to an invalid address when returning to userspace
after an abort. I don't fully trust each architecture code to consistently
deal with invalid return addresses.

If validation fails, the process is killed with a segmentation fault.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Paul Turner <pjt@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>
CC: Dave Watson <davejwatson@fb.com>
CC: Chris Lameter <cl@linux.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Ben Maurer <bmaurer@fb.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Josh Triplett <josh@joshtriplett.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Russell King <linux@arm.linux.org.uk>
CC: Catalin Marinas <catalin.marinas@arm.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: linux-api@vger.kernel.org
---
 include/uapi/linux/rseq.h | 6 +++---
 kernel/rseq.c             | 5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
index d620fa43756c..519ad6e176d1 100644
--- a/include/uapi/linux/rseq.h
+++ b/include/uapi/linux/rseq.h
@@ -52,10 +52,10 @@ struct rseq_cs {
 	__u32 version;
 	/* enum rseq_cs_flags */
 	__u32 flags;
-	LINUX_FIELD_u32_u64(start_ip);
+	__u64 start_ip;
 	/* Offset from start_ip. */
-	LINUX_FIELD_u32_u64(post_commit_offset);
-	LINUX_FIELD_u32_u64(abort_ip);
+	__u64 post_commit_offset;
+	__u64 abort_ip;
 } __attribute__((aligned(4 * sizeof(__u64))));
 
 /*
diff --git a/kernel/rseq.c b/kernel/rseq.c
index 22b6acf1ad63..2e5d88f09baf 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -128,7 +128,8 @@ static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
 		return 0;
 	}
 	urseq_cs = (struct rseq_cs __user *)ptr;
-	if (copy_from_user(rseq_cs, urseq_cs, sizeof(*rseq_cs)))
+	if (copy_from_user(rseq_cs, urseq_cs, sizeof(*rseq_cs)) ||
+	    rseq_cs->abort_ip >= TASK_SIZE)
 		return -EFAULT;
 	if (rseq_cs->version > 0)
 		return -EINVAL;
@@ -137,7 +138,7 @@ static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
 	if (rseq_cs->abort_ip - rseq_cs->start_ip < rseq_cs->post_commit_offset)
 		return -EINVAL;
 
-	usig = (u32 __user *)(rseq_cs->abort_ip - sizeof(u32));
+	usig = (u32 __user *)(unsigned long)(rseq_cs->abort_ip - sizeof(u32));
 	ret = get_user(sig, usig);
 	if (ret)
 		return ret;
-- 
2.11.0
