Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.136.161.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794756438;
	b=U4mf0/bFrd2AmIn5J45Y5OXjheRMUwTjWkaZsTrRna3SQ86Alf1AjlPSHQK6S5uqroYN
	 LXaf+DhvYeyioHpat+4CY2iGNz7GP2UEjqIaEKPDjVCXJvsi3lQz7H9CWxXTCr6TxcCXg
	 9e1+NDT16lYIfLLzb7ECP/GJhU24UCeX/Gl4l7AXKTk3itRJui6Ssp8vH72gDqHaVmVJj
	 8GkDav3lmQlZbULvsAAQdeiSQfwDJh3/R/WoXPkha0lIJPm3RTMcQ4ERuRUyEgo41eJci
	 0LIHOw73sbXahO3ciKrJCO1VrQ2r8UsgnrY1qYLTD8Ab49hBf9v/H9xpohLyzFBvCfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794756438;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rsB3JLoCPVV0K4C/Spsno0mPXtm72WZwA26MPlIaX0k=;
	b=wngvcDMxL0AShfAJsLXjRtLy8Uc+E9tLXxVKJXPTAJNT2RMYAGkEvq4TjAZCJ9ciN0w5
	 oxFELEvdjcBC7LYv/5foM6hVFRflA5AB1OZxQGtBM275CiL37hfxSeDdSu/M2ICoWIDCh
	 ETYkMxKEx4RzU+NcGSkN/uIbluz5cuehoGQTdXM/kUk+c7OdKinzwfs0VVs6YEzmPIOis
	 5sCF8vY2f3MIbW7Ktf05pBI6Nqmc2ovvKYOzkfD0ys+XPlbr4CcTP53FBKrqW5c9fk7LV
	 3Q+9nKu6WN6fKtuijrHrKphx39TDT7DWYMxFP+EHX4MQtStMvPKPqsPVLxjGB76YFBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unibo.it;
	spf=pass smtp.mailfrom=cs.unibo.it;
	dkim=pass header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=bprRZ0rA;
	arc=none smtp.remote-ip=130.136.161.50
Received: from mail.virtlab.unibo.it (mail.virtlab.unibo.it [130.136.161.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E4B9606A32E;
	Sun, 15 Nov 2026 15:27:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E4B9606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=bprRZ0rA
Received: from eipi10.cs.unibo.it (unknown [94.32.99.206])
	by mail.virtlab.unibo.it (Postfix) with ESMTPA id 243321C025E;
	Sun, 15 Nov 2026 16:27:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.unibo.it;
	s=virtlab; t=1794756437;
	bh=Xaq7tdArymqQ9EW3aTadVEYTr9nONTfiZp+7FcATQEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bprRZ0rArOUpY6GCjzbDO1Z8bgfko3+Znq+35eqQ3OKHyYsPgxt59/ayB5tOdmbEU
	 L131BwEL/03UV+uIAJDIu2UCQ+aThRBuJZmwg1ry+APMn6fyEmktV5RRtygzZvdpyb
	 QaioTydhiAmxlgq0bae+B2vYqnkgR/RpSqUQ4BEk=
From: Renzo Davoli <renzo@cs.unibo.it>
To: linux-kernel@vger.kernel.org
Cc: Renzo Davoli <renzo@cs.unibo.it>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Dmitry V . Levin" <ldv@strace.io>,
	Alexey Gladkov <legion@kernel.org>,
	Eugene Syromyatnikov <evgsyr@gmail.com>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Bradley Morgan <bradley.morgan@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	strace-devel@lists.strace.io,
	linux-api@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v3 2/2] selftests/ptrace: check that PTRACE_SET_SYSCALL_INFO rejects invalid error values
Date: Sun, 15 Nov 2026 16:27:00 +0100
Message-ID: <20261115152703.416254-3-renzo@cs.unibo.it>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261115152703.416254-1-renzo@cs.unibo.it>
References: <20261115152703.416254-1-renzo@cs.unibo.it>
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

At every exit stop of the set_syscall_info test, try to set with
is_error set a few values outside [-MAX_ERRNO, -1], check that
PTRACE_SET_SYSCALL_INFO fails with ERANGE and that the return value
of the system call is left untouched.

Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
---
 .../selftests/ptrace/set_syscall_info.c       | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/tools/testing/selftests/ptrace/set_syscall_info.c b/tools/testing/selftests/ptrace/set_syscall_info.c
index 1cc411a41cd6..366ef0ec228f 100644
--- a/tools/testing/selftests/ptrace/set_syscall_info.c
+++ b/tools/testing/selftests/ptrace/set_syscall_info.c
@@ -126,6 +126,54 @@ check_psi_exit(struct __test_metadata *_metadata,
 	}
 }
 
+/* Error values that PTRACE_SET_SYSCALL_INFO must reject with ERANGE. */
+static const long long bad_error_rval[] = {
+	0,
+	1,
+	ESRCH,
+	-4095 - 1,	/* -MAX_ERRNO - 1 */
+	-2147483647LL - 1,
+#if __SIZEOF_LONG__ > 4
+	0x100000000LL,
+	-0x100000000LL - ESRCH,
+#endif
+};
+
+static void
+check_psi_exit_bad_rval(struct __test_metadata *_metadata,
+			const struct ptrace_syscall_info *orig,
+			const struct si_exit *exp_exit)
+{
+	struct ptrace_syscall_info info;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(bad_error_rval); ++i) {
+		info = *orig;
+		info.exit.is_error = 1;
+		info.exit.rval = bad_error_rval[i];
+		ASSERT_EQ(-1, sys_ptrace(PTRACE_SET_SYSCALL_INFO,
+					 tracee_pid, sizeof(info),
+					 (uintptr_t) &info)) {
+			LOG_KILL_TRACEE("PTRACE_SET_SYSCALL_INFO: error rval %lld accepted",
+					bad_error_rval[i]);
+		}
+		ASSERT_EQ(ERANGE, errno) {
+			LOG_KILL_TRACEE("PTRACE_SET_SYSCALL_INFO: error rval %lld: %m",
+					bad_error_rval[i]);
+		}
+
+		/* the return value must be left untouched */
+		memset(&info, 0, sizeof(info));
+		info.op = 0xff;
+		ASSERT_LT(0, sys_ptrace(PTRACE_GET_SYSCALL_INFO, tracee_pid,
+					sizeof(info), (uintptr_t) &info)) {
+			LOG_KILL_TRACEE("PTRACE_GET_SYSCALL_INFO: %m");
+		}
+		check_psi_exit(_metadata, &info, exp_exit,
+			       "PTRACE_SET_SYSCALL_INFO with bad error rval");
+	}
+}
+
 TEST(set_syscall_info)
 {
 	const pid_t tracer_pid = getpid();
@@ -476,6 +524,9 @@ TEST(set_syscall_info)
 				check_psi_exit(_metadata, &info, exp_exit,
 						"PTRACE_GET_SYSCALL_INFO #1");
 
+				/* invalid error values must be rejected */
+				check_psi_exit_bad_rval(_metadata, &info, exp_exit);
+
 				/* apply the changes */
 				info.exit.is_error = set_exit->is_error;
 				info.exit.rval = set_exit->rval;
-- 
2.47.3

