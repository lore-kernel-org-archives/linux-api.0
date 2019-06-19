From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 12/13] fusectl: don't ignore options
Date: Wed, 19 Jun 2019 14:30:18 +0200
Message-ID: <20190619123019.30032-12-mszeredi@redhat.com>
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
and "nomand" make no sense for the fusectl filesystem.  If these options
are supplied to fsconfig(FSCONFIG_SET_FLAG), then return -EINVAL instead of
silently ignoring the option.

Any implementation, such as mount(8) that needs to parse this option
without failing should simply ignore the return value from fsconfig().

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/control.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index c35013ed7f65..f3aab288929f 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -351,7 +351,7 @@ static int fuse_ctl_get_tree(struct fs_context *fc)
 
 static const struct fs_context_operations fuse_ctl_context_ops = {
 	.get_tree	= fuse_ctl_get_tree,
-	.parse_param	= vfs_parse_fs_param,
+	.parse_param	= vfs_parse_ro_rw,
 };
 
 static int fuse_ctl_init_fs_context(struct fs_context *fc)
-- 
2.21.0
