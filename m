From: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] statx: reject unknown flags when using NULL path
Date: Fri, 10 Mar 2017 22:58:23 -0800
Message-ID: <20170311065823.4415-1-ebiggers3@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J . Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The statx() system call currently accepts unknown flags when called with
a NULL path to operate on a file descriptor.  Left unchanged, this could
make it hard to introduce new query flags in the future, since
applications may not be able to tell whether a given flag is supported.

Fix this by failing the system call with EINVAL if any flags other than
KSTAT_QUERY_FLAGS are specified in combination with a NULL path.

Arguably, we could still permit known lookup-related flags such as
AT_SYMLINK_NOFOLLOW.  However, that would be inconsistent with how
sys_utimensat() behaves when passed a NULL path, which seems to be the
closest precedent.  And given that the NULL path case is (I believe)
mainly intended to be used to implement a wrapper function like fstatx()
that doesn't have a path argument, I think rejecting lookup-related
flags too is probably the best choice.

Signed-off-by: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 fs/stat.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/stat.c b/fs/stat.c
index fa0be59340cc..df484a60846d 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -130,9 +130,13 @@ EXPORT_SYMBOL(vfs_getattr);
 int vfs_statx_fd(unsigned int fd, struct kstat *stat,
 		 u32 request_mask, unsigned int query_flags)
 {
-	struct fd f = fdget_raw(fd);
+	struct fd f;
 	int error = -EBADF;
 
+	if (query_flags & ~KSTAT_QUERY_FLAGS)
+		return -EINVAL;
+
+	f = fdget_raw(fd);
 	if (f.file) {
 		error = vfs_getattr(&f.file->f_path, stat,
 				    request_mask, query_flags);
-- 
2.12.0
