Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.136.161.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794836470;
	b=VOSuRA14B75X1MB88ta2oiwN8OGYdShyqj4tDBtqYTyXZZyZndlODqU7+BYTVqCWFB/r
	 Gq6E/2EveAbgFs6iUX0AGPxnu3yAFIxxR32O9gBDvoqkY6NyOLQFtCFeluxVTx/FNXBuT
	 uFO8pwmY/3UaCr3QUzi5qy4+CZhkklEF8ONi9dxKbRaoj9tXS6EZEPnFsPbBbKbgamZXK
	 XuEn6yXiF9YynMMPWnF9Udu0ejyRVg8RpQ9MWa6jv9BSpZD9F12BQ00tlwAei/L4U8FHt
	 RU6fWJ8fGECDVzdORC1J+69OIAxlXDBj/5o8kevHs0ftOYGnKTatWp71WiDvPfSsElA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794836470;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CpapQu0w6LOFQW0WFLF2s/fjzPRepgaOvKVV4hoWYc4=;
	b=eoeYUMSnimCYi9sPG++fkZ3ekgcqviNQj5kvOZiLmlWmevBFtpFHLEwqF0UjXL6VgXSG
	 wFHtamReGn2IVnv3LjgqELbvAY5e6agWQHaoyNZTN24WHIW49idvMREnoVVTQUUgjfolt
	 I6J4UECwkvEEYDornSMcy/fZ03E4CcQb0JoSyBZ6m5+Z+7iTBr7aZtbzSL0Qk8A3th/na
	 ZHvzXRSqSgDXnze8yOH7U2ZEAW2Qe6bduNNMJwIL5vjBbPZmrx1ZshapJEx68z56T4Coe
	 pnGu3+07Tm3fI1li3ao3AxaiKN8Mqnr2kpXKM9Wg/pXQDVytesl1Ep3fA/tBj31kv2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unibo.it;
	spf=pass smtp.mailfrom=cs.unibo.it;
	dkim=pass header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=WOw94JrS;
	arc=none smtp.remote-ip=130.136.161.50
Received: from mail.virtlab.unibo.it (mail.virtlab.unibo.it [130.136.161.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D79C5606A323;
	Mon, 16 Nov 2026 13:41:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D79C5606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=WOw94JrS
Received: from eipi10.cs.unibo.it (renzopb-wl.cs.unibo.it [130.136.2.252])
	by mail.virtlab.unibo.it (Postfix) with ESMTPA id 628DD1C025B;
	Mon, 16 Nov 2026 14:41:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.unibo.it;
	s=virtlab; t=1794836463;
	bh=9//oVE/LxVOx4EUXtWOmCIoiuW4udIJ+Pl0Zu697YCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOw94JrSLzcIqUIohv5l1kB3kJudL14DxhHL52i/tkVImtnyTffLD3e0oKsPC824a
	 yVya/xLWKqIXE+m/fOnQhJE5/rTuR7cW4f578mx+lf2jZOxXQbfS4kmp7n+n3csCsa
	 jnO2EMbURikH7/Cm4CVnjNyykdDxdvm76cTdQopM=
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
Subject: [PATCH v4 2/2] selftests/ptrace: check that PTRACE_SET_SYSCALL_INFO rejects invalid error values
Date: Mon, 16 Nov 2026 14:40:46 +0100
Message-ID: <20261116134050.505355-3-renzo@cs.unibo.it>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116134050.505355-1-renzo@cs.unibo.it>
References: <20261116134050.505355-1-renzo@cs.unibo.it>
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

Reviewed-by: Bradley Morgan <bradley.morgan@linux.dev>
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

