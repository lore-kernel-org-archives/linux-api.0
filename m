From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 2/3] uapi: get rid of STATX_ALL
Date: Thu, 18 Oct 2018 15:11:24 +0200
Message-ID: <20181018131125.6303-2-mszeredi@redhat.com>
References: <20181018131125.6303-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181018131125.6303-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

Constants of the *_ALL type can be actively harmful due to the fact that
developers will usually fail to consider the possible effects of future
changes to the definition.

Remove STATX_ALL from the uapi, while no damage has been done yet.

We could keep something like this around in the kernel, but there's
actually no point, since all filesystems should be explicitly checking
flags that they support and not rely on the VFS masking unknown ones out: a
flag could be known to the VFS, yet not known to the filesystem (see
orangefs bug fixed in the previous patch).

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
---
 fs/stat.c                       | 1 -
 include/uapi/linux/stat.h       | 2 +-
 samples/statx/test-statx.c      | 2 +-
 tools/include/uapi/linux/stat.h | 2 +-
 4 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index f8e6fb2c3657..8d297a279991 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -73,7 +73,6 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
 
 	memset(stat, 0, sizeof(*stat));
 	stat->result_mask |= STATX_BASIC_STATS;
-	request_mask &= STATX_ALL;
 	query_flags &= KSTAT_QUERY_FLAGS;
 	if (inode->i_op->getattr)
 		return inode->i_op->getattr(path, stat, request_mask,
diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
index 7b35e98d3c58..370f09d92fa6 100644
--- a/include/uapi/linux/stat.h
+++ b/include/uapi/linux/stat.h
@@ -148,7 +148,7 @@ struct statx {
 #define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks */
 #define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
 #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
-#define STATX_ALL		0x00000fffU	/* All currently supported flags */
+
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 
 /*
diff --git a/samples/statx/test-statx.c b/samples/statx/test-statx.c
index d4d77b09412c..e354048dea3c 100644
--- a/samples/statx/test-statx.c
+++ b/samples/statx/test-statx.c
@@ -211,7 +211,7 @@ int main(int argc, char **argv)
 	struct statx stx;
 	int ret, raw = 0, atflag = AT_SYMLINK_NOFOLLOW;
 
-	unsigned int mask = STATX_ALL;
+	unsigned int mask = STATX_BASIC_STATS | STATX_BTIME;
 
 	for (argv++; *argv; argv++) {
 		if (strcmp(*argv, "-F") == 0) {
diff --git a/tools/include/uapi/linux/stat.h b/tools/include/uapi/linux/stat.h
index 7b35e98d3c58..370f09d92fa6 100644
--- a/tools/include/uapi/linux/stat.h
+++ b/tools/include/uapi/linux/stat.h
@@ -148,7 +148,7 @@ struct statx {
 #define STATX_BLOCKS		0x00000400U	/* Want/got stx_blocks */
 #define STATX_BASIC_STATS	0x000007ffU	/* The stuff in the normal stat struct */
 #define STATX_BTIME		0x00000800U	/* Want/got stx_btime */
-#define STATX_ALL		0x00000fffU	/* All currently supported flags */
+
 #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
 
 /*
-- 
2.14.3
