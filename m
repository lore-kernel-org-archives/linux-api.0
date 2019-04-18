From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v2 3/5] signal: use fdget() since we don't allow O_PATH
Date: Thu, 18 Apr 2019 12:18:39 +0200
Message-ID: <20190418101841.4476-4-christian@brauner.io>
References: <20190418101841.4476-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190418101841.4476-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, oleg@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>, Jann Horn <jann@thejh.net>
List-Id: linux-api@vger.kernel.org

As stated in the original commit for pidfd_send_signal() we don't allow to
signal processes through O_PATH file descriptors since it is semantically
equivalent to a write on the pidfd. We already correctly error out right
now and return EBADF if an O_PATH fd is passed. This is because we use
file->f_op to detect whether a pidfd is passed and O_PATH fds have their
file->f_op set to empty_fops in do_dentry_open() and thus fail the test.
Thus, there is no regression. It's just semantically correct to use fdget()
and return an error right from there instead of taking a reference and
returning an error later.

Signed-off-by: Christian Brauner <christian@brauner.io>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jann Horn <jann@thejh.net>
Cc: David Howells <dhowells@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
/* changelog */
v1: patch not present
v2:
- Oleg Nesterov <oleg@redhat.com>:
  - split out from following patch since the s/fdget_raw()/fdget()/
    replacement is a fix unrelated to the theme of the following patch
---
 kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index f98448cf2def..227ba170298e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3581,7 +3581,7 @@ SYSCALL_DEFINE4(pidfd_send_signal, int, pidfd, int, sig,
 	if (flags)
 		return -EINVAL;
 
-	f = fdget_raw(pidfd);
+	f = fdget(pidfd);
 	if (!f.file)
 		return -EBADF;
 
-- 
2.21.0
