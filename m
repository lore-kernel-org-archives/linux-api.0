From: =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@endocode.com>
Subject: [PATCH v3] fs, proc: introduce CONFIG_PROC_CHILDREN
Date: Tue, 26 May 2015 17:12:42 +0200
Message-ID: <1432653162-20973-1-git-send-email-iago@endocode.com>
References: <20150522153705.GI16716@uranus>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150522153705.GI16716@uranus>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@endocode.com>, Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>, Pavel Emelyanov <xemul@parallels.com>, Serge Hallyn <serge.hallyn@canonical.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Djalal Harouni <djalal@endocode.com>, Alban Crequy <alban@endocode.com>
List-Id: linux-api@vger.kernel.org

commit 818411616baf ("fs, proc: introduce
/proc/<pid>/task/<tid>/children entry") introduced the children entry
for checkpoint restore and the file is only available on kernels
configured with CONFIG_EXPERT and CONFIG_CHECKPOINT_RESTORE.

This is available in most distributions (Fedora, Debian, Ubuntu, CoreOS=
)
because they usually enable CONFIG_EXPERT and CONFIG_CHECKPOINT_RESTORE=
=2E
But Arch does not enable CONFIG_EXPERT or CONFIG_CHECKPOINT_RESTORE.

However, the children proc file is useful outside of checkpoint restore=
=2E
I would like to use it in rkt. The rkt process exec() another program i=
t
does not control, and that other program will fork()+exec() a child
process. I would like to find the pid of the child process from an
external tool without iterating in /proc over all processes to find
which one has a parent pid equal to rkt.

This commit introduces CONFIG_PROC_CHILDREN and makes
CONFIG_CHECKPOINT_RESTORE select it. This allows enabling
/proc/<pid>/task/<tid>/children without needing to enable
CONFIG_CHECKPOINT_RESTORE and CONFIG_EXPERT.

Alban tested that /proc/<pid>/task/<tid>/children is present when the
kernel is configured with CONFIG_PROC_CHILDREN=3Dy but without
CONFIG_CHECKPOINT_RESTORE

v3: change depend -> select
v2: introduce CONFIG_PROC_CHILDREN http://marc.info/?l=3Dlinux-fsdevel&=
m=3D143229890217280&w=3D2
v1: http://marc.info/?l=3Dlinux-api&m=3D143220431121869&w=3D2

Signed-off-by: Iago L=C3=B3pez Galeiras <iago@endocode.com>
Cc: Alban Crequy <alban@endocode.com>
Tested-by: Alban Crequy <alban@endocode.com>
---
 fs/proc/Kconfig | 4 ++++
 fs/proc/array.c | 4 ++--
 fs/proc/base.c  | 2 +-
 init/Kconfig    | 1 +
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index 2183fcf..d751fcb 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -71,3 +71,7 @@ config PROC_PAGE_MONITOR
 	  /proc/pid/smaps, /proc/pid/clear_refs, /proc/pid/pagemap,
 	  /proc/kpagecount, and /proc/kpageflags. Disabling these
           interfaces will reduce the size of the kernel by approximate=
ly 4kb.
+
+config PROC_CHILDREN
+	bool "Include /proc/<pid>/task/<tid>/children file"
+	default n
diff --git a/fs/proc/array.c b/fs/proc/array.c
index fd02a9e..ddc4b2c 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -569,7 +569,7 @@ int proc_pid_statm(struct seq_file *m, struct pid_n=
amespace *ns,
 	return 0;
 }
=20
-#ifdef CONFIG_CHECKPOINT_RESTORE
+#ifdef CONFIG_PROC_CHILDREN
 static struct pid *
 get_children_pid(struct inode *inode, struct pid *pid_prev, loff_t pos=
)
 {
@@ -692,4 +692,4 @@ const struct file_operations proc_tid_children_oper=
ations =3D {
 	.llseek  =3D seq_lseek,
 	.release =3D children_seq_release,
 };
-#endif /* CONFIG_CHECKPOINT_RESTORE */
+#endif /* CONFIG_PROC_CHILDREN */
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 093ca14..5477a4a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2922,7 +2922,7 @@ static const struct pid_entry tid_base_stuff[] =3D=
 {
 	ONE("stat",      S_IRUGO, proc_tid_stat),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_tid_maps_operations),
-#ifdef CONFIG_CHECKPOINT_RESTORE
+#ifdef CONFIG_PROC_CHILDREN
 	REG("children",  S_IRUGO, proc_tid_children_operations),
 #endif
 #ifdef CONFIG_NUMA
diff --git a/init/Kconfig b/init/Kconfig
index dc24dec..fa09e5e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1145,6 +1145,7 @@ endif # CGROUPS
=20
 config CHECKPOINT_RESTORE
 	bool "Checkpoint/restore support" if EXPERT
+	select PROC_CHILDREN
 	default n
 	help
 	  Enables additional kernel features in a sake of checkpoint/restore.
--=20
2.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
