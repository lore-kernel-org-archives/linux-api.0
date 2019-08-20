From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V40 24/29] lockdown: Lock down perf when in confidentiality mode
Date: Mon, 19 Aug 2019 17:18:00 -0700
Message-ID: <20190820001805.241928-25-matthewgarrett@google.com>
References: <20190820001805.241928-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190820001805.241928-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Matthew Garrett <mjg59@google.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>
List-Id: linux-api@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Disallow the use of certain perf facilities that might allow userspace to
access kernel data.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Garrett <mjg59@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: James Morris <jmorris@namei.org>
---
 include/linux/security.h     | 1 +
 kernel/events/core.c         | 7 +++++++
 security/lockdown/lockdown.c | 1 +
 3 files changed, 9 insertions(+)

diff --git a/include/linux/security.h b/include/linux/security.h
index e604f4c67f03..b94f1e697537 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -119,6 +119,7 @@ enum lockdown_reason {
 	LOCKDOWN_KCORE,
 	LOCKDOWN_KPROBES,
 	LOCKDOWN_BPF_READ,
+	LOCKDOWN_PERF,
 	LOCKDOWN_CONFIDENTIALITY_MAX,
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f85929ce13be..8732f980a4fc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10798,6 +10798,13 @@ SYSCALL_DEFINE5(perf_event_open,
 	    perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
+	err = security_locked_down(LOCKDOWN_PERF);
+	if (err && (attr.sample_type & PERF_SAMPLE_REGS_INTR))
+		/* REGS_INTR can leak data, lockdown must prevent this */
+		return err;
+
+	err = 0;
+
 	/*
 	 * In cgroup mode, the pid argument is used to pass the fd
 	 * opened to the cgroup directory in cgroupfs. The cpu argument
diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
index 2397772c56bd..3d7b1039457b 100644
--- a/security/lockdown/lockdown.c
+++ b/security/lockdown/lockdown.c
@@ -34,6 +34,7 @@ static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
 	[LOCKDOWN_KCORE] = "/proc/kcore access",
 	[LOCKDOWN_KPROBES] = "use of kprobes",
 	[LOCKDOWN_BPF_READ] = "use of bpf to read kernel RAM",
+	[LOCKDOWN_PERF] = "unsafe use of perf",
 	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
 };
 
-- 
2.23.0.rc1.153.gdeed80330f-goog
