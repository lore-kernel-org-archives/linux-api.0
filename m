From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 08/13] sysfs: don't ignore options
Date: Wed, 19 Jun 2019 14:30:14 +0200
Message-ID: <20190619123019.30032-8-mszeredi@redhat.com>
References: <20190619123019.30032-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190619123019.30032-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The options "sync", "async", "dirsync", "lazytime", "nolazytime", "mand"
and "nomand" make no sense for the sysfs filesystem.  If these options are
supplied to fsconfig(FSCONFIG_SET_FLAG), then return -EINVAL instead of
silently ignoring the option.

Any implementation, such as mount(8) that needs to parse this option
without failing should simply ignore the return value from fsconfig().

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/sysfs/mount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index ba576a976e8c..4797b7952fc5 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -49,7 +49,7 @@ static void sysfs_fs_context_free(struct fs_context *fc)
 
 static const struct fs_context_operations sysfs_fs_context_ops = {
 	.free		= sysfs_fs_context_free,
-	.parse_param	= vfs_parse_sb_flag,
+	.parse_param	= vfs_parse_ro_rw,
 	.get_tree	= sysfs_get_tree,
 };
 
-- 
2.21.0
