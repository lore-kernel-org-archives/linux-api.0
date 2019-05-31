From: Palmer Dabbelt <palmer@sifive.com>
Subject: [PATCH 2/5] Add fchmodat4(), a new syscall
Date: Fri, 31 May 2019 12:12:01 -0700
Message-ID: <20190531191204.4044-3-palmer@sifive.com>
References: <20190531191204.4044-1-palmer@sifive.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190531191204.4044-1-palmer@sifive.com>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org, x86@kernel.org, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, Arnd Bergmann <arnd@arndb.de>, Palmer Dabbelt <palmer@sifive.com>
List-Id: linux-api@vger.kernel.org

man 3p says that fchmodat() takes a flags argument, but the Linux
syscall does not.  There doesn't appear to be a good userspace
workaround for this issue but the implementation in the kernel is pretty
straight-forward.  The specific use case where the missing flags came up
was WRT a fuse filesystem implemenation, but the functionality is pretty
generic so I'm assuming there would be other use cases.

Signed-off-by: Palmer Dabbelt <palmer@sifive.com>
---
 fs/open.c                | 21 +++++++++++++++++++--
 include/linux/syscalls.h |  5 +++++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index a00350018a47..cfad7684e8d3 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -568,11 +568,17 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
 	return ksys_fchmod(fd, mode);
 }
 
-int do_fchmodat(int dfd, const char __user *filename, umode_t mode)
+int do_fchmodat4(int dfd, const char __user *filename, umode_t mode, int flags)
 {
 	struct path path;
 	int error;
-	unsigned int lookup_flags = LOOKUP_FOLLOW;
+	unsigned int lookup_flags;
+
+	if (unlikely(flags & ~AT_SYMLINK_NOFOLLOW))
+		return -EINVAL;
+
+	lookup_flags = flags & AT_SYMLINK_NOFOLLOW ? 0 : LOOKUP_FOLLOW;
+
 retry:
 	error = user_path_at(dfd, filename, lookup_flags, &path);
 	if (!error) {
@@ -586,6 +592,17 @@ int do_fchmodat(int dfd, const char __user *filename, umode_t mode)
 	return error;
 }
 
+SYSCALL_DEFINE4(fchmodat4, int, dfd, const char __user *, filename,
+		umode_t, mode, int, flags)
+{
+	return do_fchmodat4(dfd, filename, mode, flags);
+}
+
+int do_fchmodat(int dfd, const char __user *filename, umode_t mode)
+{
+	return do_fchmodat4(dfd, filename, mode, 0);
+}
+
 SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename,
 		umode_t, mode)
 {
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 396871b218f4..cb040a412a4c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -435,6 +435,8 @@ asmlinkage long sys_chroot(const char __user *filename);
 asmlinkage long sys_fchmod(unsigned int fd, umode_t mode);
 asmlinkage long sys_fchmodat(int dfd, const char __user *filename,
 			     umode_t mode);
+asmlinkage long sys_fchmodat4(int dfd, const char __user *filename,
+			     umode_t mode, int flags);
 asmlinkage long sys_fchownat(int dfd, const char __user *filename, uid_t user,
 			     gid_t group, int flag);
 asmlinkage long sys_fchown(unsigned int fd, uid_t user, gid_t group);
@@ -1315,6 +1317,9 @@ static inline long ksys_link(const char __user *oldname,
 
 extern int do_fchmodat(int dfd, const char __user *filename, umode_t mode);
 
+extern int do_fchmodat4(int dfd, const char __user *filename, umode_t mode,
+			int flags);
+
 static inline int ksys_chmod(const char __user *filename, umode_t mode)
 {
 	return do_fchmodat(AT_FDCWD, filename, mode);
-- 
2.21.0
