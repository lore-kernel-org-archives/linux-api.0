From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: [PATCH 5/6] fs: Make alloc_fd non-private
Date: Thu, 12 Mar 2015 18:40:54 -0700
Message-ID: <5083dceeba618b421c25042c6343080f09f919f8.1426180120.git.josh@joshtriplett.org>
References: <cover.1426180120.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1426180120.git.josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

This allows callers to allocate a file descriptor with a defined minimum
value, without directly calling the lower-level __alloc_fd.

Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Signed-off-by: Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 fs/file.c            | 2 +-
 include/linux/file.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index ee738ea..583ba46 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -500,7 +500,7 @@ out:
 	return error;
 }
 
-static int alloc_fd(unsigned start, unsigned flags)
+int alloc_fd(unsigned start, unsigned flags)
 {
 	return __alloc_fd(current->files, start, rlimit(RLIMIT_NOFILE), flags);
 }
diff --git a/include/linux/file.h b/include/linux/file.h
index f87d308..d49f3bd 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -65,6 +65,7 @@ extern int replace_fd(unsigned fd, struct file *file, unsigned flags);
 extern void set_close_on_exec(unsigned int fd, int flag);
 extern bool get_close_on_exec(unsigned int fd);
 extern void put_filp(struct file *);
+extern int alloc_fd(unsigned start, unsigned flags);
 extern int get_unused_fd_flags(unsigned flags);
 extern void put_unused_fd(unsigned int fd);
 
-- 
2.1.4
