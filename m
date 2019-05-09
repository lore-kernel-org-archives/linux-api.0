From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 1/3] fs: add ksys_lsetxattr() wrapper
Date: Thu, 9 May 2019 13:24:18 +0200
Message-ID: <20190509112420.15671-2-roberto.sassu@huawei.com>
References: <20190509112420.15671-1-roberto.sassu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190509112420.15671-1-roberto.sassu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, initramfs@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com, silviu.vlasceanu@huawei.com, dmitry.kasatkin@huawei.com, takondra@cisco.com, kamensky@cisco.com, hpa@zytor.com, arnd@arndb.de, rob@landley.net, james.w.mcmechan@gmail.com, Roberto Sassu <roberto.sassu@huawei.com>
List-Id: linux-api@vger.kernel.org

Similarly to commit 03450e271a16 ("fs: add ksys_fchmod() and do_fchmodat()
helpers and ksys_chmod() wrapper; remove in-kernel calls to syscall"), this
patch introduces the ksys_lsetxattr() helper to avoid in-kernel calls to
the sys_lsetxattr() syscall.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 fs/xattr.c               | 9 ++++++++-
 include/linux/syscalls.h | 3 +++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 0d6a6a4af861..422b3d481edb 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -484,11 +484,18 @@ SYSCALL_DEFINE5(setxattr, const char __user *, pathname,
 	return path_setxattr(pathname, name, value, size, flags, LOOKUP_FOLLOW);
 }
 
+int ksys_lsetxattr(const char __user *pathname,
+		   const char __user *name, const void __user *value,
+		   size_t size, int flags)
+{
+	return path_setxattr(pathname, name, value, size, flags, 0);
+}
+
 SYSCALL_DEFINE5(lsetxattr, const char __user *, pathname,
 		const char __user *, name, const void __user *, value,
 		size_t, size, int, flags)
 {
-	return path_setxattr(pathname, name, value, size, flags, 0);
+	return ksys_lsetxattr(pathname, name, value, size, flags);
 }
 
 SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e446806a561f..b639f13cd1f8 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -1260,6 +1260,9 @@ int ksys_ipc(unsigned int call, int first, unsigned long second,
 	unsigned long third, void __user * ptr, long fifth);
 int compat_ksys_ipc(u32 call, int first, int second,
 	u32 third, u32 ptr, u32 fifth);
+int ksys_lsetxattr(const char __user *pathname,
+		   const char __user *name, const void __user *value,
+		   size_t size, int flags);
 
 /*
  * The following kernel syscall equivalents are just wrappers to fs-internal
-- 
2.17.1
