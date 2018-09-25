From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 1/6] signal/sparc: Move EMT_TAGOVF into the generic siginfo.h
Date: Tue, 25 Sep 2018 19:19:01 +0200
Message-ID: <20180925171906.19683-1-ebiederm@xmission.com>
References: <87h8idv6nw.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87h8idv6nw.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-arch@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

When moving all of the architectures specific si_codes into
siginfo.h, I apparently overlooked EMT_TAGOVF.  Move it now.

Remove the now redundant test in siginfo_layout for SIGEMT
as now NSIGEMT is always defined.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/sparc/include/uapi/asm/siginfo.h | 6 ------
 include/uapi/asm-generic/siginfo.h    | 6 ++++++
 kernel/signal.c                       | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/sparc/include/uapi/asm/siginfo.h b/arch/sparc/include/uapi/asm/siginfo.h
index e7049550ac82..6c820ea0813b 100644
--- a/arch/sparc/include/uapi/asm/siginfo.h
+++ b/arch/sparc/include/uapi/asm/siginfo.h
@@ -17,10 +17,4 @@
 
 #define SI_NOINFO	32767		/* no information in siginfo_t */
 
-/*
- * SIGEMT si_codes
- */
-#define EMT_TAGOVF	1	/* tag overflow */
-#define NSIGEMT		1
-
 #endif /* _UAPI__SPARC_SIGINFO_H */
diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
index 80e2a7227205..1811b8101937 100644
--- a/include/uapi/asm-generic/siginfo.h
+++ b/include/uapi/asm-generic/siginfo.h
@@ -285,6 +285,12 @@ typedef struct siginfo {
 #define SYS_SECCOMP	1	/* seccomp triggered */
 #define NSIGSYS		1
 
+/*
+ * SIGEMT si_codes
+ */
+#define EMT_TAGOVF	1	/* tag overflow */
+#define NSIGEMT		1
+
 /*
  * sigevent definitions
  * 
diff --git a/kernel/signal.c b/kernel/signal.c
index e16278710b36..7b49c31d3fdb 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2856,7 +2856,7 @@ enum siginfo_layout siginfo_layout(int sig, int si_code)
 			[SIGSEGV] = { NSIGSEGV, SIL_FAULT },
 			[SIGBUS]  = { NSIGBUS,  SIL_FAULT },
 			[SIGTRAP] = { NSIGTRAP, SIL_FAULT },
-#if defined(SIGEMT) && defined(NSIGEMT)
+#if defined(SIGEMT)
 			[SIGEMT]  = { NSIGEMT,  SIL_FAULT },
 #endif
 			[SIGCHLD] = { NSIGCHLD, SIL_CHLD },
-- 
2.17.1
