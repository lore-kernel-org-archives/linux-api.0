Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794759437;
	b=gJu3z98X40rSWzfjUc7a3YXj9nBCgV95rbkz4jjztFJ4/iImsMbmFrp4ifsMoQsOyp3t
	 KK5GGybJdGi3gabezn09h0cAqHn0vGF4gTfyfntVBDb069tt6Qs67GB1u+oYrzeMi9nZ8
	 NM0LcoBSNLpGFtQ/ODBqnMquT+iFvzSw2wPYU011qe/u0/NuGvxqgFVM4B8bQGem/746e
	 KpPJIjlJ6lkGPvw0ZOCvdWzNgi5L1IHxbIAWEhjEXwQhnmRDoIs6JhDyyyYtgpv5NGgU3
	 V9hvOqtPrN5D4p9+56D/GIHWJUMKrLCAYfihF9HJDa9GgKdtsNgvGrY2HDYP1jPrVcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794759437;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:CC:Subject:In-Reply-To:
	 References:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=NCICt+g4ba+h6Y1JYbGSqPwtwINdBha1BMylpnmqlkw=;
	b=c5v/SGSp//9s4ZmA2uCWZ5B0f7D8rdS5dVmORplRbFnUmxf6jEBSVSaNxNVUNSK7a2vx
	 2+BhXoPLwjGUVzUvynIrjx9g2t/HIGn5k+YzQzgNdkdI0KzQvNwm5dp2/N4qIvjVz+Fvy
	 we3L3q27uyl6mFM55xG04i9KvTMdHgcNUb5BTS+VtnJpd6Iu6igVuLAItn2bu1oa+X8od
	 TN0/6vlk6de+T6w359OSHjjZRWXg1eYtOUYTl/GJWQ9EJqSrZBXxl2XU2bQqeCB/20hrB
	 mx30N8vVuZ9oQI3jE4HRGetqUutPUBSbB1LvEBmf/C7+S7byE/34w7Wl9i4157jnCXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jTGU0qPZ;
	arc=none smtp.remote-ip=91.218.175.138
Received: from mta0.migadu.com (out-138.mta0.migadu.com [91.218.175.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8462606A32E
	for <linux-api@vger.kernel.org>; Sun, 15 Nov 2026 16:17:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8462606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jTGU0qPZ
X-Envelope-To: linux-api@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=g57S+tnYE1I+WM8B/j2X3/lHuNfkcd/fJZIJlo5BpOI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794759434; v=1; x=1795364234;
 b=jTGU0qPZCdwrI1i/wZMz58bJOOopSnXcy2Ep+1AQXZPEmXUnbL1WX7MKLyJcDW9D67Sz3koD
 ockiAJ9/swiyVABwzraZ99v2DEt2JrQeE8Cuv0m/xBV9BjzJUqhdpe1tef+brwftpEBOouOuVfG
 KtxDx7idEGBPqti7itEL2fDs=
X-Envelope-To: linux-api@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 434b23527c560fa3;
	Sun, 15 Nov 2026 16:17:14 +0000
X-Mizu-Trace-ID: 434b23527c560fa3
X-Migadu-Flow: FLOW_OUT
Date: Sun, 15 Nov 2026 16:17:06 +0000
From: Bradley Morgan <bradley.morgan@linux.dev>
To: Renzo Davoli <renzo@cs.unibo.it>, linux-kernel@vger.kernel.org
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Dmitry V . Levin" <ldv@strace.io>, Alexey Gladkov <legion@kernel.org>,
 Eugene Syromyatnikov <evgsyr@gmail.com>,
 Charlie Jenkins <thecharlesjenkins@gmail.com>, Shuah Khan <shuah@kernel.org>,
 strace-devel@lists.strace.io, linux-api@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3_2/2=5D_selftests/ptrace=3A_check_that_PT?=
 =?US-ASCII?Q?RACE=5FSET=5FSYSCALL=5FINFO_rejects_invalid_error_values?=
In-Reply-To: <20261115152703.416254-3-renzo@cs.unibo.it>
References: <20261115152703.416254-1-renzo@cs.unibo.it> <20261115152703.416254-3-renzo@cs.unibo.it>
Message-ID: <DEC23DE6-5D6B-42FA-8A31-2914B730C777@linux.dev>
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

On 15 November 2026 15:27:00 GMT, Renzo Davoli <renzo@cs.unibo.it> wrote:
>At every exit stop of the set_syscall_info test, try to set with
>is_error set a few values outside [-MAX_ERRNO, -1], check that
>PTRACE_SET_SYSCALL_INFO fails with ERANGE and that the return value
>of the system call is left untouched.
>
>Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
>---
> .../selftests/ptrace/set_syscall_info.c       | 51 +++++++++++++++++++
> 1 file changed, 51 insertions(+)
>
>diff --git a/tools/testing/selftests/ptrace/set_syscall_info.c b/tools/testing/selftests/ptrace/set_syscall_info.c
>index 1cc411a41cd6..366ef0ec228f 100644
>--- a/tools/testing/selftests/ptrace/set_syscall_info.c
>+++ b/tools/testing/selftests/ptrace/set_syscall_info.c
>@@ -126,6 +126,54 @@ check_psi_exit(struct __test_metadata *_metadata,
> 	}
> }
> 
>+/* Error values that PTRACE_SET_SYSCALL_INFO must reject with ERANGE. */
>+static const long long bad_error_rval[] = {
>+	0,
>+	1,
>+	ESRCH,
>+	-4095 - 1,	/* -MAX_ERRNO - 1 */
>+	-2147483647LL - 1,
>+#if __SIZEOF_LONG__ > 4
>+	0x100000000LL,
>+	-0x100000000LL - ESRCH,
>+#endif
>+};

yeah sure. Bit of a odd way to show error codes but okie dokie.

>+
>+static void
>+check_psi_exit_bad_rval(struct __test_metadata *_metadata,
>+			const struct ptrace_syscall_info *orig,
>+			const struct si_exit *exp_exit)
>+{
>+	struct ptrace_syscall_info info;
>+	unsigned int i;
>+
>+	for (i = 0; i < ARRAY_SIZE(bad_error_rval); ++i) {
>+		info = *orig;
>+		info.exit.is_error = 1;
>+		info.exit.rval = bad_error_rval[i];
>+		ASSERT_EQ(-1, sys_ptrace(PTRACE_SET_SYSCALL_INFO,
>+					 tracee_pid, sizeof(info),
>+					 (uintptr_t) &info)) {
>+			LOG_KILL_TRACEE("PTRACE_SET_SYSCALL_INFO: error rval %lld accepted",
>+					bad_error_rval[i]);
>+		}
>+		ASSERT_EQ(ERANGE, errno) {
>+			LOG_KILL_TRACEE("PTRACE_SET_SYSCALL_INFO: error rval %lld: %m",
>+					bad_error_rval[i]);
>+		}
>+
>+		/* the return value must be left untouched */
>+		memset(&info, 0, sizeof(info));
>+		info.op = 0xff;
>+		ASSERT_LT(0, sys_ptrace(PTRACE_GET_SYSCALL_INFO, tracee_pid,
>+					sizeof(info), (uintptr_t) &info)) {
>+			LOG_KILL_TRACEE("PTRACE_GET_SYSCALL_INFO: %m");
>+		}
>+		check_psi_exit(_metadata, &info, exp_exit,
>+			       "PTRACE_SET_SYSCALL_INFO with bad error rval");
>+	}
>+}
>+
> TEST(set_syscall_info)
> {
> 	const pid_t tracer_pid = getpid();
>@@ -476,6 +524,9 @@ TEST(set_syscall_info)
> 				check_psi_exit(_metadata, &info, exp_exit,
> 						"PTRACE_GET_SYSCALL_INFO #1");
> 
>+				/* invalid error values must be rejected */
>+				check_psi_exit_bad_rval(_metadata, &info, exp_exit);
>+

Reviewed-by: Bradley Morgan <bradley.morgan@linux.dev>


A feature suggestion on the table here is that you can modify the
bad_error_rval[] parameter thru sysfs so you'd provide custom addresses or
custom whatever.

E.g:

Echoing 0 to the sysfs directory. Then checking dmesg to see if it passed
or if a hole happened.



> 				/* apply the changes */
> 				info.exit.is_error = set_exit->is_error;
> 				info.exit.rval = set_exit->rval;
>


--- Thanks!
