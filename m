From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: [PATCH] statx: correct error handling of NULL pathname
Date: Thu, 27 Apr 2017 13:54:11 +0200
Message-ID: <d10d318c-7461-96fb-952b-c246811a8228@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mtk.manpages@gmail.com, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>Michael Kerrisk <mtk.manpages@gmail.com>, hch@infradead.org
List-Id: linux-api@vger.kernel.org


The change in 1e2f82d1e9d1 to error on a NULL pathname to statx()
is inconsistent.  It results in the error EINVAL for a NULL pathname.
Consistent with similar APIs (fchownat(), fstatat(), linkat()),
the error should be EFAULT.

The solution is simply to remove the EINVAL check. As I already
pointed out in https://lkml.org/lkml/2017/4/26/561, user_path_at*()
and filename_lookup() will handle the NULL pathname as per
the other APIs, to correctly produce the error EFAULT.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
---
 fs/stat.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index 3d85747..a257b87 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -567,8 +567,6 @@ SYSCALL_DEFINE5(statx,
 		return -EINVAL;
 	if ((flags & AT_STATX_SYNC_TYPE) == AT_STATX_SYNC_TYPE)
 		return -EINVAL;
-	if (!filename)
-		return -EINVAL;
 
 	error = vfs_statx(dfd, filename, flags, &stat, mask);
 	if (error)
-- 
2.5.5

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
