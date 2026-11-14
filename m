Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.136.161.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794682054;
	b=tCfJ6isE09eSTyry3E91fCGlEE5Z0zVMIdmp570RlCScLSpkz0LLH9mDC/JRbYuEfA37
	 dfstPBsTRkNc/Lv733ZFwp0ZFUQSGKqUj6pFtKbIG3BOfp7scLb8fAFhCeD/mOOAwmec1
	 rVEK/lFTOBRnV6JJlCibxSFMwPB+UAWWnr8Tqmvzsjdo3zVkzz9lvrmgpqnbhKq29q7mT
	 7f29jzRchj6M7w4LLPpvoEXAWTGfS5t6NpckkdNZOUa57O+MBIPP2tMyLb6EbRAvSfp6B
	 FWqr9F/ejd87oBXYQpsiKoUaAL0M9hzdiXusR/Hn+88kaL9ReuifT+9LHcs5F0wXxiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794682054;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=00dly/4uJsAvZjuQ0ZIcQDBkN5Fye630g3uWkbaeUMo=;
	b=Jg8UKLksWHBeFtzlCEkfQABShiosup5sz2zNz3EO7tDrkH3xUOe29xd/2MAa67cnCvCe
	 S8NiC/unFk4sDspY4P/1HuX5TSCR3waiDrKeOkgE8BQPUaMRCJPGh4tCQxu8fcG4sty5X
	 8DojHESUCNuguIWjHoQVQGssG9soEAHvKBreaYYF0rb3qd+51bkaPSfYtbHI/BYgKeLur
	 phM0QtDdgOgIFOIngwyLMlohHSD6qRrFYacaaq42ZwLJ17DEQ94UgKynZuauHReAxLq1S
	 Fg9HmWK9x6x/QUHg341VbSJ2DwjQG1AmGk4MpHik+EWDTIeAX87zTLfJlgIr93IaBZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unibo.it;
	spf=pass smtp.mailfrom=cs.unibo.it;
	dkim=pass header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=EHwvfCki;
	arc=none smtp.remote-ip=130.136.161.50
Received: from mail.virtlab.unibo.it (mail.virtlab.unibo.it [130.136.161.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78673606A33E;
	Sat, 14 Nov 2026 18:47:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78673606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=EHwvfCki
Received: from eipi10.cs.unibo.it (host0.studiodavoli.it [109.234.61.1])
	by mail.virtlab.unibo.it (Postfix) with ESMTPA id 73C031C025E;
	Sat, 14 Nov 2026 19:47:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.unibo.it;
	s=virtlab; t=1794682052;
	bh=hoWPkmv3P1ctIMiEu2Hj5HhfcHsRt29pRdzWjH7fRac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHwvfCkiZ7uDwQgvFmWkAyf4BF8KLc6f3B0gDkffOP7DDRJtsWCwMWaEZLNY6ymVY
	 m30beYOGkyLgrF0bVME5Ru4bnvxqr9GF8jhi5jEuKQtAjTr6rHU/SfhZzLCBOqzTI0
	 YD4kK854lO0tJVYnfSgCTP5ciqdwUL4eh/+hpYQs=
From: Renzo Davoli <renzo@cs.unibo.it>
To: linux-kernel@vger.kernel.org
Cc: Renzo Davoli <renzo@cs.unibo.it>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Alexey Gladkov <legion@kernel.org>,
	Eugene Syromyatnikov <evgsyr@gmail.com>,
	Davide Berardi <berardi.dav@gmail.com>,
	"Dmitry V . Levin" <ldv@strace.io>,
	=?UTF-8?q?Michal=20Such=C3=A1nek?= <msuchanek@suse.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	strace-devel@lists.strace.io,
	linux-api@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v4 2/3] ptrace: add PTRACE_SYSCALL_INFO_FLAG_SET_IP
Date: Sat, 14 Nov 2026 19:47:17 +0100
Message-ID: <20261114184720.373178-3-renzo@cs.unibo.it>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261114184720.373178-1-renzo@cs.unibo.it>
References: <20261114184720.373178-1-renzo@cs.unibo.it>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This flag adds support for modifying the tracee's instruction pointer.

To do this, the tracer stores the new instruction pointer value in the
instruction_pointer field of the ptrace_syscall_info structure and
sets the PTRACE_SYSCALL_INFO_FLAG_SET_IP flag in the flags field.

This flag is introduced to avoid breaking existing code that uses
PTRACE_SET_SYSCALL_INFO and currently ignores the
instruction_pointer field.

The proposal does not add any new ptrace capability. It merely provides a
portable interface for a capability that already exists and is already relied
upon by existing applications.

WHY

PTRACE_SYSCALL_INFO_FLAG_SET_IP completes the set of actions that a tracer can
request when intercepting a system call.

A tracer can currently instruct a tracee to:

* execute the original system call;
* execute a different system call (or the same system call with modified arguments);
* skip the system call and provide the desired return value and/or errno.

The proposed PTRACE_SYSCALL_INFO_FLAG_SET_IP adds a fourth possibility:
* execute an arbitrary sequence of two or more system calls in place of the original one.

The mechanism is straightforward. During a PTRACE_SYSCALL_INFO_EXIT stop, the
tracer rewinds the instruction pointer to the system call instruction (e.g. by
2 bytes on x86-64 for syscall, or by the appropriate amount on other
architectures). When the tracee resumes, it immediately generates a new
syscall-entry stop, allowing the tracer to provide a new system call number and
arguments. By repeating this process, a tracer can transparently replace a
single system call with any sequence of system calls.

This capability already exists on all architectures through
architecture-specific interfaces such as PTRACE_POKEUSER, PTRACE_SETREGS, or
PTRACE_SETREGSET. PTRACE_SYSCALL_INFO_FLAG_SET_IP does not introduce a new
capability; it merely exposes an existing one through the portable
PTRACE_GET_SYSCALL_INFO/PTRACE_SET_SYSCALL_INFO API.

WHO

The VUOS project uses this mechanism extensively.
VUOS provides namespace-like execution environments implemented entirely in
user space, without relying on kernel namespaces.
https://wiki.virtualsquare.org/#/tutorials/vuosbasics

For example, VUOS allows unprivileged processes to use user-space
implementations of filesystems (FUSE), networking stacks, virtual devices, and
other resources.

To improve scalability on multicore systems, VUOS implements what we call the
guardian angel model: each traced thread has its own dedicated tracer thread.
This avoids a single tracer becoming a bottleneck.

When a traced thread creates a child, ownership of the new tracee must be
transferred to a newly created guardian angel. This requires delaying execution
of the child's first system call until the new tracer has attached.

The current implementation proceeds as follows:
* save the original system call number and arguments;
* replace the system call with a blocking ppoll(NULL, 0, NULL, NULL) call;
* detach the original tracer;
* attach the new guardian angel using PTRACE_SEIZE;
* interrupt the blocking ppoll() with PTRACE_INTERRUPT;
* at the subsequent syscall-exit stop, rewind the instruction pointer to the system call instruction;
* at the following syscall-entry stop, restore the original system call number and arguments.

This mechanism is currently implemented using architecture-specific register
manipulation. PTRACE_SYSCALL_INFO_FLAG_SET_IP would allow the same
implementation to be written using the portable ptrace syscall information API.

Although VUOS is the primary motivation for this proposal, the feature is
generally useful for any project implementing ptrace-based system call
interposition, including PRoot, strace's syscall injection machinery, and
similar frameworks.

Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
---
 include/uapi/linux/ptrace.h |  4 ++++
 kernel/ptrace.c             | 38 +++++++++++++++++++++++++++----------
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index 5f8ef6156752..6f62cb812875 100644
--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -80,6 +80,10 @@ struct seccomp_metadata {
 #define PTRACE_SYSCALL_INFO_EXIT	2
 #define PTRACE_SYSCALL_INFO_SECCOMP	3
 
+#define PTRACE_SYSCALL_INFO_FLAG_SET_IP (1 << 0)
+#define PTRACE_SYSCALL_INFO_FLAG_ALL \
+	(PTRACE_SYSCALL_INFO_FLAG_SET_IP)
+
 struct ptrace_syscall_info {
 	__u8 op;	/* PTRACE_SYSCALL_INFO_* */
 	__u8 reserved;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index ab6f5dab0223..a6980855ce2d 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1156,7 +1156,9 @@ ptrace_set_syscall_info(struct task_struct *child, unsigned long user_size,
 {
 	struct pt_regs *regs = task_pt_regs(child);
 	struct ptrace_syscall_info info;
+	unsigned long ip = 0;
 	int op;
+	int ret;
 
 	if (user_size < sizeof(info))
 		return -EINVAL;
@@ -1169,10 +1171,16 @@ ptrace_set_syscall_info(struct task_struct *child, unsigned long user_size,
 	if (copy_from_user(&info, datavp, sizeof(info)))
 		return -EFAULT;
 
-	/* Reserved for future use. */
-	if (info.flags || info.reserved)
+	/* Unused flags and fields reserved for future use. */
+	if ((info.flags & ~PTRACE_SYSCALL_INFO_FLAG_ALL) || info.reserved)
 		return -EINVAL;
 
+	if (info.flags & PTRACE_SYSCALL_INFO_FLAG_SET_IP) {
+		ip = info.instruction_pointer;
+		if (ip != info.instruction_pointer)
+			return -ERANGE;
+	}
+
 	op = ptrace_get_syscall_info_op(child);
 
 	/*
@@ -1183,24 +1191,34 @@ ptrace_set_syscall_info(struct task_struct *child, unsigned long user_size,
 	 * PTRACE_SYSCALL_INFO_EXIT one, so only the return value can be
 	 * changed anymore during the same stop.
 	 */
-	if (op == PTRACE_SYSCALL_INFO_SECCOMP &&
-	    info.op == PTRACE_SYSCALL_INFO_EXIT)
-		return ptrace_set_syscall_info_seccomp_skip(child, regs, &info);
-
-	if (op != info.op)
+	if (op != info.op &&
+	    !(op == PTRACE_SYSCALL_INFO_SECCOMP &&
+	      info.op == PTRACE_SYSCALL_INFO_EXIT))
 		return -EINVAL;
 
 	switch (info.op) {
 	case PTRACE_SYSCALL_INFO_ENTRY:
-		return ptrace_set_syscall_info_entry(child, regs, &info);
+		ret = ptrace_set_syscall_info_entry(child, regs, &info);
+		break;
 	case PTRACE_SYSCALL_INFO_EXIT:
-		return ptrace_set_syscall_info_exit(child, regs, &info);
+		if (op == PTRACE_SYSCALL_INFO_SECCOMP)
+			ret = ptrace_set_syscall_info_seccomp_skip(child, regs,
+								   &info);
+		else
+			ret = ptrace_set_syscall_info_exit(child, regs, &info);
+		break;
 	case PTRACE_SYSCALL_INFO_SECCOMP:
-		return ptrace_set_syscall_info_seccomp(child, regs, &info);
+		ret = ptrace_set_syscall_info_seccomp(child, regs, &info);
+		break;
 	default:
 		/* Other types of system call stops are not supported yet. */
 		return -EINVAL;
 	}
+
+	if (!ret && (info.flags & PTRACE_SYSCALL_INFO_FLAG_SET_IP))
+		instruction_pointer_set(regs, ip);
+
+	return ret;
 }
 #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
 
-- 
2.47.3

