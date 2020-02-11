From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 05/24] proc: task_state(): use from_kfs{g,u}id_munged
Date: Tue, 11 Feb 2020 17:57:34 +0100
Message-ID: <20200211165753.356508-6-christian.brauner@ubuntu.com>
References: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200211165753.356508-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>
Cc: smbarber@chromium.org, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Serge Hallyn <serge@hallyn.com>, James Morris <jmorris@namei.org>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, containers@lists.linux-foundation.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

If fsid mappings have been written, this will cause proc to look at fsid
mappings for the user namespace. If no fsid mappings have been written the
behavior is as before.

Here is part of the output from /proc/<pid>/status from the initial user
namespace for systemd running in an unprivileged container as user namespace
root with id mapping 0 100000 100000 and fsid mapping 0 300000 100000:

Name:	systemd
Umask:	0000
State:	S (sleeping)
Tgid:	13023
Ngid:	0
Pid:	13023
PPid:	13008
TracerPid:	0
Uid:	100000	100000	100000	300000
Gid:	100000	100000	100000	300000
FDSize:	64
Groups:

Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/proc/array.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 5efaf3708ec6..d4a04f85a67e 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -91,6 +91,7 @@
 #include <linux/string_helpers.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_struct.h>
+#include <linux/fsuidgid.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -193,11 +194,11 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	seq_put_decimal_ull(m, "\nUid:\t", from_kuid_munged(user_ns, cred->uid));
 	seq_put_decimal_ull(m, "\t", from_kuid_munged(user_ns, cred->euid));
 	seq_put_decimal_ull(m, "\t", from_kuid_munged(user_ns, cred->suid));
-	seq_put_decimal_ull(m, "\t", from_kuid_munged(user_ns, cred->fsuid));
+	seq_put_decimal_ull(m, "\t", from_kfsuid_munged(user_ns, cred->fsuid));
 	seq_put_decimal_ull(m, "\nGid:\t", from_kgid_munged(user_ns, cred->gid));
 	seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns, cred->egid));
 	seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns, cred->sgid));
-	seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns, cred->fsgid));
+	seq_put_decimal_ull(m, "\t", from_kfsgid_munged(user_ns, cred->fsgid));
 	seq_put_decimal_ull(m, "\nFDSize:\t", max_fds);
 
 	seq_puts(m, "\nGroups:\t");
-- 
2.25.0
