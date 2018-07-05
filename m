From: Florian Weimer <fweimer@redhat.com>
Subject: Review request for glibc system call wrapper for statx
Date: Thu, 5 Jul 2018 19:13:32 +0200
Message-ID: <4aef7bc6-5deb-f232-4747-11e9232fae3c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-94022-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
Cc: GNU C Library <libc-alpha@sourceware.org>, David Howells <dhowells@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

I've proposed a statx system call wrapper for glibc:

   https://sourceware.org/ml/libc-alpha/2018-06/msg01038.html

The somewhat questionable part is the userspace emulation if the kernel 
does not support statx.  It looks like this:

+/* Approximate emulation of statx.  This will always fill in
+   POSIX-mandated attributes even if the underlying file system does
+   not actually support it (for example, GID and UID on file systems
+   without UNIX-style permissions).  */
+static __attribute__ ((unused)) int
+statx_generic (int fd, const char *path, int flags,
+               unsigned int mask, struct statx *buf)
+{
+  /* Flags which need to be cleared before passing them to
+     fstatat64.  */
+  static const int clear_flags = AT_STATX_SYNC_AS_STAT;
+
+    /* Flags supported by our emulation.  */
+  static const int supported_flags
+    = AT_EMPTY_PATH | AT_NO_AUTOMOUNT | AT_SYMLINK_NOFOLLOW
+      | clear_flags;
+
+  if (__glibc_unlikely ((flags & ~supported_flags) != 0))
+    {
+      __set_errno (EINVAL);
+      return -1;
+    }
+
+  struct stat64 st;
+  int ret = __fstatat64 (fd, path, &st, flags & ~clear_flags);
+  if (ret != 0)
+    return ret;
+
+  *buf = (struct statx)
+    {
+      /* We copy everything from fstat64, which corresponds the basic
+         fstat64.  */
+      .stx_mask = STATX_BASIC_STATS,
+      .stx_blksize = st.st_blksize,
+      .stx_nlink = st.st_nlink,
+      .stx_uid = st.st_uid,
+      .stx_gid = st.st_gid,
+      .stx_mode = st.st_mode,
+      .stx_ino = st.st_ino,
+      .stx_size = st.st_size,
+      .stx_blocks = st.st_blocks,
+      .stx_atime = statx_convert_timestamp (st.st_atim),
+      .stx_ctime = statx_convert_timestamp (st.st_ctim),
+      .stx_mtime = statx_convert_timestamp (st.st_mtim),
+      .stx_rdev_major = __gnu_dev_major (st.st_rdev),
+      .stx_rdev_minor = __gnu_dev_minor (st.st_rdev),
+      .stx_dev_major = __gnu_dev_minor (st.st_dev),
+      .stx_dev_minor = __gnu_dev_minor (st.st_dev),
+    };
+
+  return 0;
+}

Do you think this emulation is a good idea?  Or should we drop it and 
just return ENOSYS?

Thanks,
Florian
