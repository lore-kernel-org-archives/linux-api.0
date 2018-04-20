From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [REVIEW][PATCH 01/17] signal/alpha: Document a conflict with SI_USER for SIGFPE
Date: Thu, 19 Apr 2018 20:03:52 -0500
Message-ID: <20180420010408.24438-1-ebiederm@xmission.com>
References: <878t9ilmhv.fsf@xmission.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <878t9ilmhv.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Helge Deller <deller@gmx.de>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Setting si_code to 0 is the same as setting si_code to SI_USER.  This
is the same si_code as SI_USER.  Posix and common sense requires that
SI_USER not be a signal specific si_code.  As such this use of 0 for
the si_code is a pretty horribly broken ABI.

Cc: Helge Deller <deller@gmx.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: linux-alpha@vger.kernel.org
History Tree: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
Ref: 0a635c7a84cf ("Fill in siginfo_t.")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 arch/alpha/kernel/osf_sys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 89faa6f4de47..2e02aef5a334 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -872,7 +872,7 @@ SYSCALL_DEFINE5(osf_setsysinfo, unsigned long, op, void __user *, buffer,
 		fex = (exc >> IEEE_STATUS_TO_EXCSUM_SHIFT) & swcr;
  		if (fex) {
 			siginfo_t info;
-			int si_code = 0;
+			int si_code = FPE_FIXME;
 
 			if (fex & IEEE_TRAP_ENABLE_DNO) si_code = FPE_FLTUND;
 			if (fex & IEEE_TRAP_ENABLE_INE) si_code = FPE_FLTRES;
-- 
2.14.1
