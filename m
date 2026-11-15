Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794703897;
	b=wDeXncC3y/FCVba21tEQ2KjqyX0ngzVxfp84eo7Yjtx0tgEJKOZzg7bG3EHREW7VSvMp
	 vkeTH4mfAC+X3AFjSspkeEEwMG00aDZSaaQeWi9P+DKJzbsV9EWZoBjNWS9ZZMSrs/Krr
	 LRSUjE0tcJHAzhu+mZ88vS5wOSs9caQMDv8FbwTFmBCjFuPXlW3ZTYzhoSX4fUXHPeAaL
	 CB8xy5095/vbdsIu8Bjz3rU06Yk8URyhsqYZN5Ms5h8/oQJxGfIy6zmMWBZ5fFCSEQKi3
	 Zj/3aXHDy6owy9Dx75qYbK2yrjoJsZXLblrPQgMMELlQ016+dqY/9TgheRnR3/zL9rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794703897;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:CC:Subject:In-Reply-To:
	 Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=cIQKJ+UG91RHKyYene2ntrB1MHw8caFD+qmGOAO6wSU=;
	b=QI5I0KKbx7VMjPHfis9RKBPo8n4p8KDdAbRuAo0Eeu0jMYXUAYA/LLjwRThD2oRS0mh4
	 rp0Pt0QNDTi31t9R/6jHDl/bvmXTcmHEJ+4V7d0/VxSShYQW9tPWZ4z9ePaV/SIq9R6e5
	 CD4mktvjwPr8h5N6grSBrd/nK98OVCklSpaaG9LIQ+I0sREiYytYkVQSGjear/FYYM86t
	 TnPy/plyrybWWerYKbf7Z+X9B9EMxfH7gpemRwFNK9PVnePcTVKgNXSDgwwiUomGDXRf4
	 XhqLZxtzNPOAry14hsKAhbNkYBTKsNWZBjt3ebu6yPf8G1aEt7hsjoj+w6ywZ9ldZ/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SWe59QkV;
	arc=none smtp.remote-ip=95.215.58.199
Received: from mta1.migadu.com (out-199.mta1.migadu.com [95.215.58.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA889606A323
	for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 00:51:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA889606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SWe59QkV
X-Envelope-To: linux-api@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xFnLsG59GvlRg1cGX6jqXi1P0i1OqXy1k2drts1zmg0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794703893; v=1; x=1795308693;
 b=SWe59QkVUKTpOuhVSRr4ltJFXxocdeMcga7R0GcwcO0EDL0etq+qIs5/TVyfHi6BVNDn7trL
 imz1lbQV0oqs9d4PGRQ2flu/5KeG5Ck2h36znDAAhUdCaKbTrlRYVhArXQYR0+6Traj224K3d4W
 MiSpnRv/orIv1JjypQ1hNdnM=
X-Envelope-To: linux-api@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d6aa2e4d69f7770f;
	Sun, 15 Nov 2026 00:51:33 +0000
X-Mizu-Trace-ID: d6aa2e4d69f7770f
X-Migadu-Flow: FLOW_OUT
Date: Sun, 15 Nov 2026 00:51:33 +0000
From: Bradley Morgan <bradley.morgan@linux.dev>
To: renzo@cs.unibo.it
CC: akpm@linux-foundation.org, evgsyr@gmail.com, ldv@strace.io, legion@kernel.org,
 linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, oleg@redhat.com,
 strace-devel@lists.strace.io, thecharlesjenkins@gmail.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_ptrace=3A_reject_out_of_range?=
 =?US-ASCII?Q?_error_values_in_PTRACE=5FSET=5FSYSCALL=5FINFO?=
In-Reply-To: <20261114184842.373304-1-renzo@cs.unibo.it>
Message-ID: <2D2A202C-35F8-4200-9110-B0E636216FCF@linux.dev>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 14 November 2026 18:48:40 GMT, Renzo Davoli <renzo@cs.unibo.it> wrote:
>When PTRACE_SET_SYSCALL_INFO is used with op == PTRACE_SYSCALL_INFO_EXIT
>and is_error set, info.exit.rval is passed to syscall_set_return_value()
>as its "int error" argument.  The only check is that rval fits in a
>"long", which is a no-op on 64-bit architectures, so:
>
> - values outside the "int" range are silently truncated;
> - a value whose low 32 bits are zero, e.g. 0 or 0x100000000, becomes
>   error == 0, and the system call returns 0 as a success although the
>   tracer asked for an error;
> - a positive value is stored as is by some architectures (e.g. x86)
>   and is not seen as an error by the tracee.
>
>PTRACE_GET_SYSCALL_INFO reports errors as negative errno values, so
>reject with -ERANGE any error value outside [-MAX_ERRNO, -1].
>
>Fixes: 26bb32768fe6 ("ptrace: introduce PTRACE_SET_SYSCALL_INFO request")
>Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
>Assisted-by: claude-opus-5-5

Drop. No longer needed. Annoyingly. Assisted bys aren't needed no more. :(

>---
>This patch is independent of the PTRACE_SET_SYSCALL_INFO syscall skipping
>series and applies cleanly either before or after it.
>
>Tested on x86_64 (QEMU/KVM) with a test program that, at the exit stop of
>getpid(), calls PTRACE_SET_SYSCALL_INFO with op ==
>PTRACE_SYSCALL_INFO_EXIT,
>is_error = 1 and the following rval values:
>
>  rval                   without this patch            with this patch
>                         (getpid() in the tracee)
>  0                      returns 0, success            -ERANGE
>  1                      returns 1, success            -ERANGE
>  ESRCH (3)              returns 3, success            -ERANGE
>  -MAX_ERRNO - 1         returns -4096, success        -ERANGE
>  INT_MIN                returns INT_MIN, success      -ERANGE
>  0x100000000            returns 0, success            -ERANGE
>  -0x100000000 - ESRCH   fails with ESRCH, but         -ERANGE
>                         PTRACE_GET_SYSCALL_INFO
>                         reports rval -3
>  -ESRCH                 fails with ESRCH              fails with ESRCH
>  -MAX_ERRNO             fails with errno 4095         fails with errno 4095
>
>Without this patch PTRACE_SET_SYSCALL_INFO succeeds in every case, and
>on x86_64 syscall_set_return_value() stores the error, truncated to
>"int", as is: values outside [-MAX_ERRNO, -1] become successful return
>values, so the tracer asks for an error and the tracee sees a success,
>or a different error than the one requested.  With this patch these
>values are rejected and the tracee registers are left untouched; valid
>errno values behave as before.

That's just word puke. I did NOT read all of that, make it TL;DR
preferably.

>
> kernel/ptrace.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>
>diff --git a/kernel/ptrace.c b/kernel/ptrace.c
>index 3f2fe68ccb14..2fbd0d55b42e 100644
>--- a/kernel/ptrace.c
>+++ b/kernel/ptrace.c
>@@ -1111,6 +1111,14 @@ ptrace_set_syscall_info_exit(struct task_struct *child, struct pt_regs *regs,
> 	if (rval != info->exit.rval)
> 		return -ERANGE;
> 
>+	/*
>+	 * An error is passed to syscall_set_return_value() as an "int"
>+	 * and must be a negative errno value: anything else would be
>+	 * truncated or would make the system call succeed.
>+	 */

This is very verbose. Like VERY verbose. Maybe a one or two liner comment
would be way way better

>+	if (info->exit.is_error && (rval < -MAX_ERRNO || rval >= 0))
>+		return -ERANGE;
>+
> 	if (info->exit.is_error)
> 		syscall_set_return_value(child, regs, rval, 0);
> 	else
>

--- Thanks!
