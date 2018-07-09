From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH for 4.18 1/6] rseq: use __u64 for rseq_cs fields, validate user inputs
Date: Mon,  9 Jul 2018 15:51:50 -0400
Message-ID: <20180709195155.7654-2-mathieu.desnoyers@efficios.com>
References: <20180709195155.7654-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180709195155.7654-1-mathieu.desnoyers@efficios.com>
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

Validating the value of the start_ip and post_commit_offset fields
prevents overflow on arithmetic performed on those values, used to
check whether abort_ip is within the rseq critical section.

If validation fails, the process is killed with a segmentation fault.

When the signature encountered before abort_ip does not match the expected
signature, return -EINVAL rather than -EPERM to be consistent with other
input validation return codes from rseq_get_rseq_cs().

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
 include/uapi/linux/rseq.h |  6 +++---
 kernel/rseq.c             | 14 ++++++++++----
 2 files changed, 13 insertions(+), 7 deletions(-)

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
index 22b6acf1ad63..16b38c5342f9 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -130,14 +130,20 @@ static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
 	urseq_cs = (struct rseq_cs __user *)ptr;
 	if (copy_from_user(rseq_cs, urseq_cs, sizeof(*rseq_cs)))
 		return -EFAULT;
-	if (rseq_cs->version > 0)
-		return -EINVAL;
 
+	if (rseq_cs->start_ip >= TASK_SIZE ||
+	    rseq_cs->start_ip + rseq_cs->post_commit_offset >= TASK_SIZE ||
+	    rseq_cs->abort_ip >= TASK_SIZE ||
+	    rseq_cs->version > 0)
+		return -EINVAL;
+	/* Check for overflow. */
+	if (rseq_cs->start_ip + rseq_cs->post_commit_offset < rseq_cs->start_ip)
+		return -EINVAL;
 	/* Ensure that abort_ip is not in the critical section. */
 	if (rseq_cs->abort_ip - rseq_cs->start_ip < rseq_cs->post_commit_offset)
 		return -EINVAL;
 
-	usig = (u32 __user *)(rseq_cs->abort_ip - sizeof(u32));
+	usig = (u32 __user *)(unsigned long)(rseq_cs->abort_ip - sizeof(u32));
 	ret = get_user(sig, usig);
 	if (ret)
 		return ret;
@@ -146,7 +152,7 @@ static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
 		printk_ratelimited(KERN_WARNING
 			"Possible attack attempt. Unexpected rseq signature 0x%x, expecting 0x%x (pid=%d, addr=%p).\n",
 			sig, current->rseq_sig, current->pid, usig);
-		return -EPERM;
+		return -EINVAL;
 	}
 	return 0;
 }
-- 
2.11.0
