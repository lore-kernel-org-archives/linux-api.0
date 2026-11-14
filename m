Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.136.161.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794682137;
	b=Y0Tw6ILbPvniKxABzJYm66IjfOWN32lDNwsHkm1yB8LyMY3bsEAxgbGR+nhfpp3nSz7d
	 ZIr6efRMLwopjPZWOwbwu2hu3eEOlHwRzzKKQTRMXvDFUSOJ1CN9smmCDf4RkpwJ17/Jf
	 AtjwGDYGn8z4n9Pn0gji2Br5s4h1eZLC4OrcVCtVFHOvv7ftOFFytFQo2D1KhFjxTdZGa
	 8WCcoPjm9JJStzrN1P6nhLOF9bKBfPjkrvw2Jgx+lE1Hre9igIo60gx3s8qPWeEYQsPrh
	 CCLVVZpqvD0XKxKyrClNUUTgJ8PEMBWcDdZZeyQ/lAWo70L62QmqdDsiPw6NQsG0Rcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794682137;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=aI54Ie8c1VqNhS28OYQ9yZt9UkfzW78gXsRade0CSKc=;
	b=cf29lZYwFuZ6SqHHVsM1svHm6Bp5hbFicLwmJcnbdc1XgIzA/OaZHiqCFqVpf06cqd5e
	 P8K4xGeZ4zd94/ECJfye9SU+Gl1dqmvnqjdaaLWC4g45l/8IkltrWx0sSEsKOzmidpjT2
	 pJkt8hgikQrtpl7TzzE32R0ckcu6JngSZHVGw0d6jltPOLVChZApi0i47Y96uw9DA0DC9
	 qai8uIU5BCzvBzB1o3ijo/5FD8IDHh2nP7iecEV3qYOj3aJXby426/tnG4Ua07GJKlXOW
	 09y3g+xk50ImsoxygCfX8AOlhvXgDm9iG3ehlW/D5/nsscN6r4aKziq8y9ds0BuYvsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unibo.it;
	spf=pass smtp.mailfrom=cs.unibo.it;
	dkim=pass header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=rcqr2P8B;
	arc=none smtp.remote-ip=130.136.161.50
Received: from mail.virtlab.unibo.it (mail.virtlab.unibo.it [130.136.161.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9202C606A32E;
	Sat, 14 Nov 2026 18:48:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9202C606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=rcqr2P8B
Received: from eipi10.cs.unibo.it (host0.studiodavoli.it [109.234.61.1])
	by mail.virtlab.unibo.it (Postfix) with ESMTPA id 56CD91C0253;
	Sat, 14 Nov 2026 19:48:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.unibo.it;
	s=virtlab; t=1794682135;
	bh=f69x1E8IZpvvBpnq5/O8dIRrinU08wbGm2L3oDSNc0o=;
	h=From:To:Cc:Subject:Date:From;
	b=rcqr2P8BHMO3RVUDoqhIA3y55kNeeNWkn6CKD7E8Sl3tNPJOAxP1KKNTUIFEAdZsZ
	 LhxZm3NXGN/aSOcqwc5TBvLKvlgIDl3Pq0BDhlSM8EhDfwHd88AlKBhEgwYESstYFr
	 D/7gmrzK5wFNHhAVRnXuhfAJ27Qa9psOnlcKgQmQ=
From: Renzo Davoli <renzo@cs.unibo.it>
To: linux-kernel@vger.kernel.org
Cc: Renzo Davoli <renzo@cs.unibo.it>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Dmitry V . Levin" <ldv@strace.io>,
	Alexey Gladkov <legion@kernel.org>,
	Eugene Syromyatnikov <evgsyr@gmail.com>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	strace-devel@lists.strace.io,
	linux-api@vger.kernel.org
Subject: [PATCH] ptrace: reject out of range error values in PTRACE_SET_SYSCALL_INFO
Date: Sat, 14 Nov 2026 19:48:40 +0100
Message-ID: <20261114184842.373304-1-renzo@cs.unibo.it>
X-Mailer: git-send-email 2.55.0
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

When PTRACE_SET_SYSCALL_INFO is used with op == PTRACE_SYSCALL_INFO_EXIT
and is_error set, info.exit.rval is passed to syscall_set_return_value()
as its "int error" argument.  The only check is that rval fits in a
"long", which is a no-op on 64-bit architectures, so:

 - values outside the "int" range are silently truncated;
 - a value whose low 32 bits are zero, e.g. 0 or 0x100000000, becomes
   error == 0, and the system call returns 0 as a success although the
   tracer asked for an error;
 - a positive value is stored as is by some architectures (e.g. x86)
   and is not seen as an error by the tracee.

PTRACE_GET_SYSCALL_INFO reports errors as negative errno values, so
reject with -ERANGE any error value outside [-MAX_ERRNO, -1].

Fixes: 26bb32768fe6 ("ptrace: introduce PTRACE_SET_SYSCALL_INFO request")
Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
Assisted-by: claude-opus-5-5
---
This patch is independent of the PTRACE_SET_SYSCALL_INFO syscall skipping
series and applies cleanly either before or after it.

Tested on x86_64 (QEMU/KVM) with a test program that, at the exit stop of
getpid(), calls PTRACE_SET_SYSCALL_INFO with op == PTRACE_SYSCALL_INFO_EXIT,
is_error = 1 and the following rval values:

  rval                   without this patch            with this patch
                         (getpid() in the tracee)
  0                      returns 0, success            -ERANGE
  1                      returns 1, success            -ERANGE
  ESRCH (3)              returns 3, success            -ERANGE
  -MAX_ERRNO - 1         returns -4096, success        -ERANGE
  INT_MIN                returns INT_MIN, success      -ERANGE
  0x100000000            returns 0, success            -ERANGE
  -0x100000000 - ESRCH   fails with ESRCH, but         -ERANGE
                         PTRACE_GET_SYSCALL_INFO
                         reports rval -3
  -ESRCH                 fails with ESRCH              fails with ESRCH
  -MAX_ERRNO             fails with errno 4095         fails with errno 4095

Without this patch PTRACE_SET_SYSCALL_INFO succeeds in every case, and
on x86_64 syscall_set_return_value() stores the error, truncated to
"int", as is: values outside [-MAX_ERRNO, -1] become successful return
values, so the tracer asks for an error and the tracee sees a success,
or a different error than the one requested.  With this patch these
values are rejected and the tracee registers are left untouched; valid
errno values behave as before.

 kernel/ptrace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 3f2fe68ccb14..2fbd0d55b42e 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1111,6 +1111,14 @@ ptrace_set_syscall_info_exit(struct task_struct *child, struct pt_regs *regs,
 	if (rval != info->exit.rval)
 		return -ERANGE;
 
+	/*
+	 * An error is passed to syscall_set_return_value() as an "int"
+	 * and must be a negative errno value: anything else would be
+	 * truncated or would make the system call succeed.
+	 */
+	if (info->exit.is_error && (rval < -MAX_ERRNO || rval >= 0))
+		return -ERANGE;
+
 	if (info->exit.is_error)
 		syscall_set_return_value(child, regs, rval, 0);
 	else
-- 
2.47.3

