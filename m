From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 100/105] vfs: deny copy_file_range() for non regular files
Date: Tue, 10 Oct 2017 21:51:11 +0200
Message-ID: <20171010192549.233914610@linuxfoundation.org>
References: <20171010192533.717049376@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171010192533.717049376@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, linux-api@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>, Miklos Szeredi <mszeredi@redhat.com>, Theodore Tso <tytso@mit.edu>
List-Id: linux-api@vger.kernel.org

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 11cbfb10775aa2a01cee966d118049ede9d0bdf2 upstream.

There is no in-tree file system that implements copy_file_range()
for non regular files.

Deny an attempt to copy_file_range() a directory with EISDIR
and any other non regualr file with EINVAL to conform with
behavior of vfs_{clone,dedup}_file_range().

This change is needed prior to converting sb_start_write()
to  file_start_write() in the vfs helper.

Cc: linux-api@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/read_write.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1518,6 +1518,11 @@ ssize_t vfs_copy_file_range(struct file
 	if (flags != 0)
 		return -EINVAL;
 
+	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
+		return -EISDIR;
+	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
+		return -EINVAL;
+
 	ret = rw_verify_area(READ, file_in, &pos_in, len);
 	if (unlikely(ret))
 		return ret;
