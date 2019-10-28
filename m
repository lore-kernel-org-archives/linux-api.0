From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC] fs/fcntl: add fcntl F_GET_RSS
Date: Mon, 28 Oct 2019 13:28:09 +0300
Message-ID: <157225848971.557.16257813537984792761.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Roman Gushchin <guro@fb.com>
List-Id: linux-api@vger.kernel.org

This implements fcntl() for getting amount of resident memory in cache.
Kernel already maintains counter for each inode, this patch just exposes
it into userspace. Returned size is in kilobytes like values in procfs.

Alternatively this could be implemented via mapping file and collecting
map of cached pages with mincore(). Which is much slower and O(n*log n).

Syscall fincore() never was implemented in Linux.
This fcntl() covers one of its use-cases with minimal footprint.

Unlike to mincore() this fcntl counts all pages, including allocated but
not read yet (non-uptodate) and pages beyond end of file.

This employs same security model as mincore() and requires one of:
- file is opened for writing
- current user owns inode
- current user could open inode for writing

Usage:
resident_kb = fcntl(fd, F_GET_RSS);

Error codes:
-EINVAL		- not supported
-EPERM		- not writable / owner
-ENODATA	- special inode without cache

Notes:
Range of pages could be evicted from cache using POSIX_FADV_DONTNEED.
Populating with POSIX_FADV_WILLNEED is asynchronous and limited with
disk read_ahead_kb and max_sectors_kb. It seems most effective way to
read data into cache synchronously is a sendfile() into /dev/null.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 fs/fcntl.c                 |   30 ++++++++++++++++++++++++++++++
 include/uapi/linux/fcntl.h |    5 +++++
 2 files changed, 35 insertions(+)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 3d40771e8e7c..b241d3c925db 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -25,6 +25,8 @@
 #include <linux/user_namespace.h>
 #include <linux/memfd.h>
 #include <linux/compat.h>
+#include <linux/dax.h>
+#include <linux/hugetlb.h>
 
 #include <linux/poll.h>
 #include <asm/siginfo.h>
@@ -319,6 +321,31 @@ static long fcntl_rw_hint(struct file *file, unsigned int cmd,
 	}
 }
 
+static long fcntl_get_rss(struct file *filp)
+{
+	struct address_space *mapping = filp->f_mapping;
+	unsigned long pages;
+
+	if (!mapping)
+		return -ENODATA;
+
+	/* The same limitations as for sys_mincore() */
+	if (!(filp->f_mode & FMODE_WRITE) &&
+	    !inode_owner_or_capable(mapping->host) &&
+	    inode_permission(mapping->host, MAY_WRITE))
+		return -EPERM;
+
+	if (dax_mapping(mapping))
+		pages = READ_ONCE(mapping->nrexceptional);
+	else
+		pages = READ_ONCE(mapping->nrpages);
+
+	if (is_file_hugepages(filp))
+		pages <<= huge_page_order(hstate_file(filp));
+
+	return pages << (PAGE_SHIFT - 10);	/* page -> kb */
+}
+
 static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 		struct file *filp)
 {
@@ -426,6 +453,9 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
 	case F_SET_FILE_RW_HINT:
 		err = fcntl_rw_hint(filp, cmd, arg);
 		break;
+	case F_GET_RSS:
+		err = fcntl_get_rss(filp);
+		break;
 	default:
 		break;
 	}
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index 1d338357df8a..d467f1dbfc67 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -54,6 +54,11 @@
 #define F_GET_FILE_RW_HINT	(F_LINUX_SPECIFIC_BASE + 13)
 #define F_SET_FILE_RW_HINT	(F_LINUX_SPECIFIC_BASE + 14)
 
+/*
+ * Get amount of resident memory in file cache in kilobytes.
+ */
+#define F_GET_RSS		(F_LINUX_SPECIFIC_BASE + 15)
+
 /*
  * Valid hint values for F_{GET,SET}_RW_HINT. 0 is "not set", or can be
  * used to clear any hints previously set.
