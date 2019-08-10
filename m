From: Alistair Francis <alistair.francis@wdc.com>
Subject: [PATCH] syscalls: Update the syscall #defines to match uapi
Date: Fri,  9 Aug 2019 18:07:58 -0700
Message-ID: <20190810010758.16407-1-alistair.francis@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, arnd@arndb.de
Cc: deepa.kernel@gmail.com, alistair23@gmail.com, Alistair Francis <alistair.francis@wdc.com>
List-Id: linux-api@vger.kernel.org

Update the #defines around sys_fstat64() and sys_fstatat64() to match
the #defines around the __NR3264_fstatat and __NR3264_fstat definitions
in include/uapi/asm-generic/unistd.h. This avoids compiler failures if
one is defined.

Signed-off-by: Alistair Francis <alistair.francis@wdc.com>
---
 include/linux/syscalls.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 2bcef4c70183..e4bf5e480d60 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -512,7 +512,7 @@ asmlinkage long sys_readlinkat(int dfd, const char __user *path, char __user *bu
 asmlinkage long sys_newfstatat(int dfd, const char __user *filename,
 			       struct stat __user *statbuf, int flag);
 asmlinkage long sys_newfstat(unsigned int fd, struct stat __user *statbuf);
-#if defined(__ARCH_WANT_STAT64) || defined(__ARCH_WANT_COMPAT_STAT64)
+#if defined(__ARCH_WANT_NEW_STAT) || defined(__ARCH_WANT_STAT64)
 asmlinkage long sys_fstat64(unsigned long fd, struct stat64 __user *statbuf);
 asmlinkage long sys_fstatat64(int dfd, const char __user *filename,
 			       struct stat64 __user *statbuf, int flag);
-- 
2.22.0
