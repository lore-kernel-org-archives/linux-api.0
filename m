From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [RFC v1 08/17] selftest/seccomp: Remove unknown_ret_is_kill_above_allow test
Date: Thu, 24 Mar 2016 02:46:39 +0100
Message-ID: <1458784008-16277-9-git-send-email-mic@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-2838-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1458784008-16277-1-git-send-email-mic@digikod.net>
To: linux-security-module@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

This is not relevant anymore because of SECCOMP_RET_INTER.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 150829dd7998..023717bf3185 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -363,28 +363,6 @@ TEST_SIGNAL(unknown_ret_is_kill_inside, SIGSYS)
 	}
 }
 
-/* return code >= 0x80000000 is unused. */
-TEST_SIGNAL(unknown_ret_is_kill_above_allow, SIGSYS)
-{
-	struct sock_filter filter[] = {
-		BPF_STMT(BPF_RET|BPF_K, 0x90000000U),
-	};
-	struct sock_fprog prog = {
-		.len = (unsigned short)ARRAY_SIZE(filter),
-		.filter = filter,
-	};
-	long ret;
-
-	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
-	ASSERT_EQ(0, ret);
-
-	ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
-	ASSERT_EQ(0, ret);
-	EXPECT_EQ(0, syscall(__NR_getpid)) {
-		TH_LOG("getpid() shouldn't ever return");
-	}
-}
-
 TEST_SIGNAL(KILL_all, SIGSYS)
 {
 	struct sock_filter filter[] = {
-- 
2.8.0.rc3
