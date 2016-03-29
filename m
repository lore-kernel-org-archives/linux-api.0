From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 1/2] selftest/seccomp: Fix the flag name SECCOMP_FILTER_FLAG_TSYNC
Date: Tue, 29 Mar 2016 20:46:07 +0200
Message-ID: <1459277167-9973-1-git-send-email-mic@digikod.net>
References: <56FAA0CC.2050201@osg.samsung.com>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-2860-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <56FAA0CC.2050201@osg.samsung.com>
To: linux-security-module@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuahkh@osg.samsung.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

Rename SECCOMP_FLAG_FILTER_TSYNC to SECCOMP_FILTER_FLAG_TSYNC to match
the UAPI.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Will Drewry <wad@chromium.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index b9453b838162..9c1460f277c2 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -1497,8 +1497,8 @@ TEST_F(TRACE_syscall, syscall_dropped)
 #define SECCOMP_SET_MODE_FILTER 1
 #endif
 
-#ifndef SECCOMP_FLAG_FILTER_TSYNC
-#define SECCOMP_FLAG_FILTER_TSYNC 1
+#ifndef SECCOMP_FILTER_FLAG_TSYNC
+#define SECCOMP_FILTER_FLAG_TSYNC 1
 #endif
 
 #ifndef seccomp
@@ -1613,7 +1613,7 @@ TEST(TSYNC_first)
 		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
 	}
 
-	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYNC,
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_TSYNC,
 		      &prog);
 	ASSERT_NE(ENOSYS, errno) {
 		TH_LOG("Kernel does not support seccomp syscall!");
@@ -1831,7 +1831,7 @@ TEST_F(TSYNC, two_siblings_with_ancestor)
 		self->sibling_count++;
 	}
 
-	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYNC,
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_TSYNC,
 		      &self->apply_prog);
 	ASSERT_EQ(0, ret) {
 		TH_LOG("Could install filter on all threads!");
@@ -1892,7 +1892,7 @@ TEST_F(TSYNC, two_siblings_with_no_filter)
 		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
 	}
 
-	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYNC,
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_TSYNC,
 		      &self->apply_prog);
 	ASSERT_NE(ENOSYS, errno) {
 		TH_LOG("Kernel does not support seccomp syscall!");
@@ -1940,7 +1940,7 @@ TEST_F(TSYNC, two_siblings_with_one_divergence)
 		self->sibling_count++;
 	}
 
-	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYNC,
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_TSYNC,
 		      &self->apply_prog);
 	ASSERT_EQ(self->sibling[0].system_tid, ret) {
 		TH_LOG("Did not fail on diverged sibling.");
@@ -1992,7 +1992,7 @@ TEST_F(TSYNC, two_siblings_not_under_filter)
 		TH_LOG("Kernel does not support SECCOMP_SET_MODE_FILTER!");
 	}
 
-	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYNC,
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_TSYNC,
 		      &self->apply_prog);
 	ASSERT_EQ(ret, self->sibling[0].system_tid) {
 		TH_LOG("Did not fail on diverged sibling.");
@@ -2021,7 +2021,7 @@ TEST_F(TSYNC, two_siblings_not_under_filter)
 	/* Switch to the remaining sibling */
 	sib = !sib;
 
-	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYNC,
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_TSYNC,
 		      &self->apply_prog);
 	ASSERT_EQ(0, ret) {
 		TH_LOG("Expected the remaining sibling to sync");
@@ -2044,7 +2044,7 @@ TEST_F(TSYNC, two_siblings_not_under_filter)
 	while (!kill(self->sibling[sib].system_tid, 0))
 		sleep(0.1);
 
-	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FLAG_FILTER_TSYNC,
+	ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_TSYNC,
 		      &self->apply_prog);
 	ASSERT_EQ(0, ret);  /* just us chickens */
 }
-- 
2.8.0.rc3
