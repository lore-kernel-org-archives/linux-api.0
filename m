From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 3/4] signals/sigaltstack: Report current flag bits in sigaltstack()
Date: Tue,  3 May 2016 10:31:51 -0700
Message-ID: <94b291ec9fd47741a9264851e316e158ded0b00d.1462296606.git.luto@kernel.org>
References: <cover.1462296606.git.luto@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1462296606.git.luto@kernel.org>
In-Reply-To: <cover.1462296606.git.luto@kernel.org>
References: <cover.1462296606.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Stas Sergeev <stsp@list.ru>, Al Viro <viro@zeniv.linux.org.uk>, Amanieu d'Antras <amanieu@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Brian Gerst <brgerst@gmail.com>, Denys Vlasenko <dvlasenk@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Richard Weinberger <richard@nod.at>, Sasha Levin <sasha.levin@oracle.com>, Shuah Khan <shuahkh@osg.samsung.com>, Thomas Gleixner <tglx@linutronix.de>, Vladimir Davydov <vdavydov@parallels.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

sigaltstack()'s reported previous state uses a somewhat odd
convention, but the concept of flag bits is new, and we can do the
flag bits sensibly.  Specifically, let's just report them directly.

This will allow saving and restoring the sigaltstack state using
sigaltstack() to work correctly.

Signed-off-by: Stas Sergeev <stsp@list.ru>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amanieu d'Antras <amanieu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: linux-api@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 kernel/signal.c                           |  3 ++-
 tools/testing/selftests/sigaltstack/sas.c | 19 ++++++++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index bf97ea5775ae..ab122a2cee41 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3099,7 +3099,8 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 
 	oss.ss_sp = (void __user *) current->sas_ss_sp;
 	oss.ss_size = current->sas_ss_size;
-	oss.ss_flags = sas_ss_flags(sp);
+	oss.ss_flags = sas_ss_flags(sp) |
+		(current->sas_ss_flags & SS_FLAG_BITS);
 
 	if (uss) {
 		void __user *ss_sp;
diff --git a/tools/testing/selftests/sigaltstack/sas.c b/tools/testing/selftests/sigaltstack/sas.c
index a98c3ef8141f..4280d0699792 100644
--- a/tools/testing/selftests/sigaltstack/sas.c
+++ b/tools/testing/selftests/sigaltstack/sas.c
@@ -113,6 +113,19 @@ int main(void)
 		perror("mmap()");
 		return EXIT_FAILURE;
 	}
+
+	err = sigaltstack(NULL, &stk);
+	if (err) {
+		perror("[FAIL]\tsigaltstack()");
+		exit(EXIT_FAILURE);
+	}
+	if (stk.ss_flags == SS_DISABLE) {
+		printf("[OK]\tInitial sigaltstack state was SS_DISABLE\n");
+	} else {
+		printf("[FAIL]\tInitial sigaltstack state was %i; should have been SS_DISABLE\n", stk.ss_flags);
+		return EXIT_FAILURE;
+	}
+
 	stk.ss_sp = sstack;
 	stk.ss_size = SIGSTKSZ;
 	stk.ss_flags = SS_ONSTACK | SS_AUTODISARM;
@@ -151,12 +164,12 @@ int main(void)
 		perror("[FAIL]\tsigaltstack()");
 		exit(EXIT_FAILURE);
 	}
-	if (stk.ss_flags != 0) {
-		printf("[FAIL]\tss_flags=%i, should be 0\n",
+	if (stk.ss_flags != SS_AUTODISARM) {
+		printf("[FAIL]\tss_flags=%i, should be SS_AUTODISARM\n",
 				stk.ss_flags);
 		exit(EXIT_FAILURE);
 	}
-	printf("[OK]\tsigaltstack is enabled after signal\n");
+	printf("[OK]\tsigaltstack is still SS_AUTODISARM after signal\n");
 
 	printf("[OK]\tTest passed\n");
 	return 0;
-- 
2.5.5
