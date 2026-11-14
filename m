Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.136.161.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794682055;
	b=mR6IHNyiZULQiqC7cTlg5qaCvSoyKDVYhnCiM2E1KANKQ4V9/7YMUsII5m052rzAglrK
	 5EiVRZ4/TrKcaeKLAP+S+Pgsw6mPEvmoBy3rZRDyIhQqlmNR8Gz0OVp6Gw3s/7zxKNgI1
	 ti7ieclsBQay2joju/o75GqPZWljLJj9ITsPMKRkzvQxApZMVQgw+xHUUFW/vFsKnQON1
	 NHaD0oiuoRMAKFMujXF5WShe2/EccJo9gW6p61FhwwZ1HNYaZJxko2LZnursViDLx4XfK
	 56mgLBzYL8s9L8ftDiNJAs8TtYlW7glmMwLC81o1q1UF03qpblJzwc0ddHwMcYA6dSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794682055;
	h=DMARC-Filter:Received:DKIM-Signature:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hxjj+LpErSjCWfQNuEXEdV2ZmjGWHa8cP7ZhwrcMOSw=;
	b=dptP64/Heh6EQc7Pw4x9YWAYATq+Kxiyprbbfp5gEAn4WFujedFROi3q+hDlJQwVDWnl
	 LHhocabMj+9QpO7X33z9jRXmYCkTf0Epsh2siBAc7Toex60lmwH0H/XPRB2HMqP8r+3ZJ
	 My0OY9L/4HA6k0cPSqj06K8czTpC2T1eoJ+p8TySmKsmZ3FFC4TEXjQljopWoCktgu2HN
	 QAECaAuNcn3wrKMfhAM0FnkJL9nAGlvrUQuJuSWQta0wLhUOrDN2fMcvlxqeIBvmU6zVe
	 I/QhzcOvD8ZZP7ory7jbUgwB1j7/rAAS8cM21EHhqBPvjvPIyVbPzBsY83TlSF0XMuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unibo.it;
	spf=pass smtp.mailfrom=cs.unibo.it;
	dkim=pass header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b="K/ii5XlN";
	arc=none smtp.remote-ip=130.136.161.50
Received: from mail.virtlab.unibo.it (mail.virtlab.unibo.it [130.136.161.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98DD3606A330;
	Sat, 14 Nov 2026 18:47:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98DD3606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=K/ii5XlN
Received: from eipi10.cs.unibo.it (host0.studiodavoli.it [109.234.61.1])
	by mail.virtlab.unibo.it (Postfix) with ESMTPA id 922621C0264;
	Sat, 14 Nov 2026 19:47:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.unibo.it;
	s=virtlab; t=1794682053;
	bh=HV09B8jmjXj9lm5J4bq0lCVGwIg+jU6Ncblm2AkaWL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/ii5XlNbeYG+KyzqNm8OMVUzghQrLusbyp1dzcBejhV0W755Id3KwVjsj+xD60M/
	 UuB2DoEu+2pV8ZGPTxWr6qcZaRx3Z0q/UYSJ9/Gmf/a65uaRgT65tVwkxCC3jkpjOj
	 ljhs4j4a+dgEhCtYaUtQs0GPBZePWuoX7oSjA8xQ=
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
Subject: [PATCH v4 3/3] selftests/ptrace: add a test case for PTRACE_SYSCALL_INFO_FLAG_SET_IP
Date: Sat, 14 Nov 2026 19:47:18 +0100
Message-ID: <20261114184720.373178-4-renzo@cs.unibo.it>
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

Check whether PTRACE_SYSCALL_INFO_FLAG_SET_IP semantics implemented in the
kernel matches userspace expectations.

Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
---
 .../selftests/ptrace/set_syscall_info.c       | 173 ++++++++++++++++++
 1 file changed, 173 insertions(+)

diff --git a/tools/testing/selftests/ptrace/set_syscall_info.c b/tools/testing/selftests/ptrace/set_syscall_info.c
index 0e2fc2cdf1dc..b8a13156d915 100644
--- a/tools/testing/selftests/ptrace/set_syscall_info.c
+++ b/tools/testing/selftests/ptrace/set_syscall_info.c
@@ -90,6 +90,10 @@ static struct sock_fprog seccomp_prog = {
 	.len = ARRAY_SIZE(seccomp_filter)
 };
 
+static char w1[] = {'A', '\n'};
+static char w2[] = {'B', '\n'};
+static char w3[] = {'C', '\n'};
+
 static void
 check_psi_entry(struct __test_metadata *_metadata,
 		const struct ptrace_syscall_info *info,
@@ -763,4 +767,173 @@ TEST(set_syscall_info_seccomp)
 	}
 }
 
+TEST(set_syscall_info_setip)
+{
+	tracer_pid = getpid();
+	tracee_pid = fork();
+
+	ASSERT_LE(0, tracee_pid) {
+		TH_LOG("fork: %m");
+	}
+
+	/* tracee */
+	if (tracee_pid == 0) {
+		int rv;
+
+		tracee_pid = getpid();
+		ASSERT_EQ(0, sys_ptrace(PTRACE_TRACEME, 0, 0, 0)) {
+			TH_LOG("PTRACE_TRACEME: %m");
+		}
+		ASSERT_EQ(0, kill(tracee_pid, SIGSTOP)) {
+			/* cannot happen */
+			TH_LOG("kill SIGSTOP: %m");
+		}
+
+		ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
+			TH_LOG("prctl: %m");
+			_exit(1);
+		}
+		ASSERT_EQ(0, sys_seccomp(SECCOMP_SET_MODE_FILTER, 0,
+					 (void *) &seccomp_prog)) {
+			TH_LOG("seccomp: %m");
+			_exit(1);
+		}
+
+presyscall:
+		/*
+		 * This system call runs twice: the tracer moves the
+		 * instruction pointer back to presyscall.
+		 */
+		rv = write(1, w1, sizeof(w1));
+		if (rv != 2)
+			_exit(1);
+
+		/* run write unmodified */
+		rv = write(1, w3, sizeof(w3));
+		if (rv != 2)
+			_exit(1);
+		_exit(0);
+	}
+
+	int status;
+	void *doitagain = &&presyscall;
+
+	/* tracer */
+	ASSERT_LE(0, waitpid(-1, &status, 0)) {
+		LOG_KILL_TRACEE("waitpid: %m");
+	}
+
+	ASSERT_EQ(0, sys_ptrace(PTRACE_SETOPTIONS, tracee_pid, 0,
+				PTRACE_O_TRACESECCOMP | PTRACE_O_TRACESYSGOOD)) {
+		LOG_KILL_TRACEE("PTRACE_SETOPTIONS: %m");
+	}
+
+	ASSERT_EQ(0, sys_ptrace(PTRACE_CONT, tracee_pid, 0, 0)) {
+		LOG_KILL_TRACEE("PTRACE_CONT: %m");
+	}
+
+	static const char * const testname[] = {
+		"unknown error",
+		"write unexpected return value",
+		"write unexpected set ip return value",
+		"final write unexpected set ip return value"
+	};
+
+	for (ptrace_stop = 0; ; ++ptrace_stop) {
+		ASSERT_EQ(tracee_pid, wait(&status)) {
+			/* cannot happen */
+			LOG_KILL_TRACEE("wait: %m");
+		}
+		if (WIFEXITED(status)) {
+			tracee_pid = 0; /* the tracee is no more */
+			ASSERT_EQ(0, WEXITSTATUS(status)) {
+				LOG_KILL_TRACEE("unexpected exit status %u",
+						WEXITSTATUS(status));
+			}
+			break;
+		}
+		ASSERT_FALSE(WIFSIGNALED(status)) {
+			tracee_pid = 0; /* the tracee is no more */
+			LOG_KILL_TRACEE("unexpected signal %u",
+					WTERMSIG(status));
+		}
+		ASSERT_TRUE(WIFSTOPPED(status)) {
+			LOG_KILL_TRACEE("unexpected wait status %#x", status);
+		}
+
+		ASSERT_LT(ptrace_stop, ARRAY_SIZE(testname)) {
+			LOG_KILL_TRACEE("ptrace stop overflow");
+		}
+
+		ASSERT_EQ(status >> 8, SIGTRAP | (PTRACE_EVENT_SECCOMP << 8)) {
+			LOG_KILL_TRACEE("unexpected stop, wait status %#x",
+					status);
+		}
+
+		struct ptrace_syscall_info info;
+		size_t info_size = sizeof(info);
+
+		ASSERT_LT(0, sys_ptrace(PTRACE_GET_SYSCALL_INFO, tracee_pid,
+					info_size, (uintptr_t) &info)) {
+			LOG_KILL_TRACEE("PTRACE_GET_SYSCALL_INFO: %m");
+		}
+		ASSERT_EQ(PTRACE_SYSCALL_INFO_SECCOMP, info.op) {
+			LOG_KILL_TRACEE("entry op mismatch: %m");
+		}
+		ASSERT_TRUE(info.arch) {
+			LOG_KILL_TRACEE("entry arch mismatch: %m");
+		}
+		ASSERT_TRUE(info.instruction_pointer) {
+			LOG_KILL_TRACEE("entry instruction_pointer mismatch: %m");
+		}
+		ASSERT_TRUE(info.stack_pointer) {
+			LOG_KILL_TRACEE("entry stack_pointer mismatch: %m");
+		}
+
+		ASSERT_FALSE(info.seccomp.nr == __NR_exit_group &&
+			     info.seccomp.args[0] == 1) {
+			LOG_KILL_TRACEE("tracee error: %s",
+					testname[ptrace_stop]);
+		}
+
+		switch (ptrace_stop) {
+		case 0:
+			ASSERT_EQ(__NR_write, info.seccomp.nr) {
+				LOG_KILL_TRACEE("step %d nr __NR_write mismatch",
+						ptrace_stop);
+			}
+			info.instruction_pointer = (uintptr_t) doitagain;
+			info.flags = PTRACE_SYSCALL_INFO_FLAG_SET_IP;
+			break;
+		case 1:
+			info.seccomp.nr = __NR_write;
+			info.seccomp.args[0] = 1;
+			info.seccomp.args[1] = (uintptr_t) w2;
+			info.seccomp.args[2] = sizeof(w2);
+			break;
+		case 2:
+			ASSERT_EQ(__NR_write, info.seccomp.nr) {
+				LOG_KILL_TRACEE("step %d nr __NR_write mismatch",
+						ptrace_stop);
+			}
+			break;
+		case 3:
+			ASSERT_EQ(__NR_exit_group, info.seccomp.nr) {
+				LOG_KILL_TRACEE("step %d nr __NR_exit_group mismatch",
+						ptrace_stop);
+			}
+			break;
+		}
+
+		ASSERT_EQ(0, sys_ptrace(PTRACE_SET_SYSCALL_INFO, tracee_pid,
+					info_size, (uintptr_t) &info)) {
+			LOG_KILL_TRACEE("PTRACE_SET_SYSCALL_INFO: %m");
+		}
+
+		ASSERT_EQ(0, sys_ptrace(PTRACE_CONT, tracee_pid, 0, 0)) {
+			LOG_KILL_TRACEE("PTRACE_CONT: %m");
+		}
+	}
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3

