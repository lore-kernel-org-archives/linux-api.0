From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH v2 6/5] statx: add STATX_RESULT_MASK flag
Date: Fri, 19 Oct 2018 16:39:32 +0200
Message-ID: <20181019143932.6697-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, Amir Goldstein <amir73il@gmail.com>
List-Id: linux-api@vger.kernel.org

This request_mask flag indicates that the caller is interested in the
result_mask.  At the moment all ->getattr() callers discard the result mask
except sys_statx().

FUSE needs this, because it uses legacy inode initialization, that doesn't
return a result_mask, so needs a refresh when caller asks for it with
statx().

It might make sense later to promote this to a proper statx mask flag and
return it in stx_mask to userspace.  This needs some more work to make sure
only filesystems set this flag where the result_mask is valid (e.g. NFS
wouldn't be able to set it, since it doesn't query the server about
supported fields).

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/stat.c            | 1 +
 include/linux/stat.h | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/fs/stat.c b/fs/stat.c
index b46583df70d4..0b71e5bdbc6b 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -576,6 +576,7 @@ SYSCALL_DEFINE5(statx,
 	if ((flags & AT_STATX_SYNC_TYPE) == AT_STATX_SYNC_TYPE)
 		return -EINVAL;
 
+	mask |= STATX_RESULT_MASK;
 	error = vfs_statx(dfd, filename, flags, &stat, mask);
 	if (error)
 		return error;
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 765573dc17d6..65448b1163d3 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -21,6 +21,12 @@
 
 #define KSTAT_QUERY_FLAGS (AT_STATX_SYNC_TYPE)
 
+/*
+ * This is an internal mask value, meaning: caller is interested in
+ * .result_mask, i.e. it's sys_statx().
+ */
+#define STATX_RESULT_MASK STATX__RESERVED
+
 struct kstat {
 	u32		result_mask;	/* What fields the user got */
 	umode_t		mode;
-- 
2.14.3
