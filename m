From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on sys_open()
Date: Fri,  6 Sep 2019 17:24:51 +0200
Message-ID: <20190906152455.22757-2-mic@digikod.net>
References: <20190906152455.22757-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190906152455.22757-1-mic@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, =?UTF-8?q?Philippe=20Tr=C3=A9
List-Id: linux-api@vger.kernel.org

When the O_MAYEXEC flag is passed, sys_open() may be subject to
additional restrictions depending on a security policy implemented by an
LSM through the inode_permission hook.

The underlying idea is to be able to restrict scripts interpretation
according to a policy defined by the system administrator.  For this to
be possible, script interpreters must use the O_MAYEXEC flag
appropriately.  To be fully effective, these interpreters also need to
handle the other ways to execute code (for which the kernel can't help):
command line parameters (e.g., option -e for Perl), module loading
(e.g., option -m for Python), stdin, file sourcing, environment
variables, configuration files...  According to the threat model, it may
be acceptable to allow some script interpreters (e.g. Bash) to interpret
commands from stdin, may it be a TTY or a pipe, because it may not be
enough to (directly) perform syscalls.

A simple security policy implementation is available in a following
patch for Yama.

This is an updated subset of the patch initially written by Vincent
Strubel for CLIP OS:
https://github.com/clipos-archive/src_platform_clip-patches/blob/f5cb330d6b684752e403b4e41b39f7004d88e561/1901_open_mayexec.patch
This patch has been used for more than 10 years with customized script
interpreters.  Some examples can be found here:
https://github.com/clipos-archive/clipos4_portage-overlay/search?q=O_MAYEXEC

Changes since v1:
* set __FMODE_EXEC when using O_MAYEXEC to make this information
  available through the new fanotify/FAN_OPEN_EXEC event (suggested by
  Jan Kara and Matthew Bobrowski)

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Signed-off-by: Vincent Strubel <vincent.strubel@ssi.gouv.fr>
Reviewed-by: Philippe Trébuchet <philippe.trebuchet@ssi.gouv.fr>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mickaël Salaün <mickael.salaun@ssi.gouv.fr>
---
 fs/fcntl.c                       | 2 +-
 fs/open.c                        | 6 ++++++
 include/linux/fcntl.h            | 2 +-
 include/linux/fs.h               | 2 ++
 include/uapi/asm-generic/fcntl.h | 3 +++
 5 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 3d40771e8e7c..4cf05a2fd162 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -1031,7 +1031,7 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ !=
+	BUILD_BUG_ON(22 - 1 /* for O_RDONLY being 0 */ !=
 		HWEIGHT32(
 			(VALID_OPEN_FLAGS & ~(O_NONBLOCK | O_NDELAY)) |
 			__FMODE_EXEC | __FMODE_NONOTIFY));
diff --git a/fs/open.c b/fs/open.c
index a59abe3c669a..1b9b6fedf7cd 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -989,6 +989,12 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		acc_mode = 0;
 	}
 
+	/* Check execution permissions on open. */
+	if (flags & O_MAYEXEC) {
+		acc_mode |= MAY_OPENEXEC;
+		flags |= __FMODE_EXEC;
+	}
+
 	op->open_flag = flags;
 
 	/* O_TRUNC implies we need access checks for write permissions */
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index d019df946cb2..af88fb6c8313 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -9,7 +9,7 @@
 	(O_RDONLY | O_WRONLY | O_RDWR | O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC | \
 	 O_APPEND | O_NDELAY | O_NONBLOCK | O_NDELAY | __O_SYNC | O_DSYNC | \
 	 FASYNC	| O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW | \
-	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE)
+	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE | O_MAYEXEC)
 
 #ifndef force_o_largefile
 #define force_o_largefile() (!IS_ENABLED(CONFIG_ARCH_32BIT_OFF_T))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 997a530ff4e9..848f5711bdf0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -99,6 +99,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 #define MAY_CHDIR		0x00000040
 /* called from RCU mode, don't block */
 #define MAY_NOT_BLOCK		0x00000080
+/* the inode is opened with O_MAYEXEC */
+#define MAY_OPENEXEC		0x00000100
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 9dc0bf0c5a6e..cbb9425d6e7c 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -97,6 +97,9 @@
 #define O_NDELAY	O_NONBLOCK
 #endif
 
+/* command execution from file is intended, check exec permissions */
+#define O_MAYEXEC	040000000
+
 #define F_DUPFD		0	/* dup */
 #define F_GETFD		1	/* get close_on_exec */
 #define F_SETFD		2	/* set/clear close_on_exec */
-- 
2.23.0
