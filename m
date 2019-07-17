From: Palmer Dabbelt <palmer@sifive.com>
Subject: [PATCH v2 2/4] Add fchmodat4(), a new syscall
Date: Tue, 16 Jul 2019 18:27:17 -0700
Message-ID: <20190717012719.5524-3-palmer@sifive.com>
References: <20190717012719.5524-1-palmer@sifive.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190717012719.5524-1-palmer@sifive.com>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org, James.Bottomley@HansenPartnership.com, deller@gmx.de, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, heiko.carstens@de.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com, ysato@users.sourceforge.jp, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, peterz@infradead.org, acme@kernel.org, alexander.shishkin@linux.intel.com, jolsa@redhat.com, namhyung@kernel.org, Palmer Dabbelt <palm>
List-Id: linux-api@vger.kernel.org

man 3p says that fchmodat() takes a flags argument, but the Linux
syscall does not.  There doesn't appear to be a good userspace
workaround for this issue but the implementation in the kernel is pretty
straight-forward.  The specific use case where the missing flags came up
was WRT a fuse filesystem implemenation, but the functionality is pretty
generic so I'm assuming there would be other use cases.

Signed-off-by: Palmer Dabbelt <palmer@sifive.com>
---
 fs/open.c                | 20 ++++++++++++++++----
 include/linux/syscalls.h |  7 +++++--
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index b5b80469b93d..2f72b4d6a2c1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -569,11 +569,17 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd, umode_t, mode)
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
@@ -587,15 +593,21 @@ int do_fchmodat(int dfd, const char __user *filename, umode_t mode)
 	return error;
 }
 
+SYSCALL_DEFINE4(fchmodat4, int, dfd, const char __user *, filename,
+		umode_t, mode, int, flags)
+{
+	return do_fchmodat4(dfd, filename, mode, flags);
+}
+
 SYSCALL_DEFINE3(fchmodat, int, dfd, const char __user *, filename,
 		umode_t, mode)
 {
-	return do_fchmodat(dfd, filename, mode);
+	return do_fchmodat4(dfd, filename, mode, 0);
 }
 
 SYSCALL_DEFINE2(chmod, const char __user *, filename, umode_t, mode)
 {
-	return do_fchmodat(AT_FDCWD, filename, mode);
+	return do_fchmodat4(AT_FDCWD, filename, mode, 0);
 }
 
 static int chown_common(const struct path *path, uid_t user, gid_t group)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e1c20f1d0525..a4bde25ad264 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -433,6 +433,8 @@ asmlinkage long sys_chroot(const char __user *filename);
 asmlinkage long sys_fchmod(unsigned int fd, umode_t mode);
 asmlinkage long sys_fchmodat(int dfd, const char __user *filename,
 			     umode_t mode);
+asmlinkage long sys_fchmodat4(int dfd, const char __user *filename,
+			     umode_t mode, int flags);
 asmlinkage long sys_fchownat(int dfd, const char __user *filename, uid_t user,
 			     gid_t group, int flag);
 asmlinkage long sys_fchown(unsigned int fd, uid_t user, gid_t group);
@@ -1320,11 +1322,12 @@ static inline long ksys_link(const char __user *oldname,
 	return do_linkat(AT_FDCWD, oldname, AT_FDCWD, newname, 0);
 }
 
-extern int do_fchmodat(int dfd, const char __user *filename, umode_t mode);
+extern int do_fchmodat4(int dfd, const char __user *filename, umode_t mode,
+			int flags);
 
 static inline int ksys_chmod(const char __user *filename, umode_t mode)
 {
-	return do_fchmodat(AT_FDCWD, filename, mode);
+	return do_fchmodat4(AT_FDCWD, filename, mode, 0);
 }
 
 extern long do_faccessat(int dfd, const char __user *filename, int mode);
-- 
2.21.0
