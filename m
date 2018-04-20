From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 15/17] signal: Add TRAP_UNK si_code for undiagnosted trap exceptions
Date: Thu, 19 Apr 2018 20:04:06 -0500
Message-ID: <20180420010408.24438-15-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, linux-alpha@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

Both powerpc and alpha have cases where they wronly set si_code to 0
in combination with SIGTRAP and don't mean SI_USER.

About half the time this is because the architecture can not report
accurately what kind of trap exception triggered the trap exception.
The other half the time it looks like no one has bothered to
figure out an appropriate si_code.

For the cases where the architecture does not have enough information
or is too lazy to figure out exactly what kind of trap exception
it is define TRAP_UNK.

Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-alpha@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/x86/kernel/signal_compat.c    | 2 +-
 include/uapi/asm-generic/siginfo.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/signal_compat.c b/arch/x86/kernel/signal_compat.c
index 14c057f29979..9ccbf0576cd0 100644
--- a/arch/x86/kernel/signal_compat.c
+++ b/arch/x86/kernel/signal_compat.c
@@ -29,7 +29,7 @@ static inline void signal_compat_build_tests(void)
 	BUILD_BUG_ON(NSIGFPE  != 15);
 	BUILD_BUG_ON(NSIGSEGV != 7);
 	BUILD_BUG_ON(NSIGBUS  != 5);
-	BUILD_BUG_ON(NSIGTRAP != 4);
+	BUILD_BUG_ON(NSIGTRAP != 5);
 	BUILD_BUG_ON(NSIGCHLD != 6);
 	BUILD_BUG_ON(NSIGSYS  != 1);
 
diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
index 558b902f18d4..80e2a7227205 100644
--- a/include/uapi/asm-generic/siginfo.h
+++ b/include/uapi/asm-generic/siginfo.h
@@ -249,7 +249,8 @@ typedef struct siginfo {
 #define TRAP_TRACE	2	/* process trace trap */
 #define TRAP_BRANCH     3	/* process taken branch trap */
 #define TRAP_HWBKPT     4	/* hardware breakpoint/watchpoint */
-#define NSIGTRAP	4
+#define TRAP_UNK	5	/* undiagnosed trap */
+#define NSIGTRAP	5
 
 /*
  * There is an additional set of SIGTRAP si_codes used by ptrace
-- 
2.14.1
