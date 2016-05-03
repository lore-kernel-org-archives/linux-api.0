From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 2/4] selftests/sigaltstack: Fix the sas test on old kernels
Date: Tue,  3 May 2016 10:31:50 -0700
Message-ID: <f3e739bf435beeaecbd5f038f1359d2eac6d1e63.1462296606.git.luto@kernel.org>
References: <cover.1462296606.git.luto@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1462296606.git.luto@kernel.org>
In-Reply-To: <cover.1462296606.git.luto@kernel.org>
References: <cover.1462296606.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Stas Sergeev <stsp@list.ru>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Brian Gerst <brgerst@gmail.com>, Denys Vlasenko <dvlasenk@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, Peter Zijlstra <peterz@infradead.org>, Shuah Khan <shuahkh@osg.samsung.com>, Thomas Gleixner <tglx@linutronix.de>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The handling for old kernels was wrong.  Fix it.

Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: Stas Sergeev <stsp@list.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 tools/testing/selftests/sigaltstack/sas.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/sigaltstack/sas.c b/tools/testing/selftests/sigaltstack/sas.c
index 57da8bfde60b..a98c3ef8141f 100644
--- a/tools/testing/selftests/sigaltstack/sas.c
+++ b/tools/testing/selftests/sigaltstack/sas.c
@@ -15,6 +15,7 @@
 #include <alloca.h>
 #include <string.h>
 #include <assert.h>
+#include <errno.h>
 
 #ifndef SS_AUTODISARM
 #define SS_AUTODISARM  (1 << 4)
@@ -117,13 +118,19 @@ int main(void)
 	stk.ss_flags = SS_ONSTACK | SS_AUTODISARM;
 	err = sigaltstack(&stk, NULL);
 	if (err) {
-		perror("[FAIL]\tsigaltstack(SS_ONSTACK | SS_AUTODISARM)");
-		stk.ss_flags = SS_ONSTACK;
-	}
-	err = sigaltstack(&stk, NULL);
-	if (err) {
-		perror("[FAIL]\tsigaltstack(SS_ONSTACK)");
-		return EXIT_FAILURE;
+		if (errno == EINVAL) {
+			printf("[NOTE]\tThe running kernel doesn't support SS_AUTODISARM\n");
+			/*
+			 * If test cases for the !SS_AUTODISARM variant were
+			 * added, we could still run them.  We don't have any
+			 * test cases like that yet, so just exit and report
+			 * success.
+			 */
+			return 0;
+		} else {
+			perror("[FAIL]\tsigaltstack(SS_ONSTACK | SS_AUTODISARM)");
+			return EXIT_FAILURE;
+		}
 	}
 
 	ustack = mmap(NULL, SIGSTKSZ, PROT_READ | PROT_WRITE,
-- 
2.5.5
