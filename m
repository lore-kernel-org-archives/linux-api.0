From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 04/13] vfs: don't parse "posixacl" option
Date: Wed, 19 Jun 2019 14:30:10 +0200
Message-ID: <20190619123019.30032-4-mszeredi@redhat.com>
References: <20190619123019.30032-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190619123019.30032-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Unlike the others, this is _not_ a standard option accepted by mount(8).

In fact SB_POSIXACL is an internal flag, and accepting MS_POSIXACL on the
mount(2) interface is possibly a bug.

The only filesystem that apparently wants to handle the "posixacl" option
is 9p, but it has special handling of that option besides setting
SB_POSIXACL.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fs_context.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/fs_context.c b/fs/fs_context.c
index cbf89117a507..49636e541293 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -42,7 +42,6 @@ static const struct constant_table common_set_sb_flag[] = {
 	{ "dirsync",	SB_DIRSYNC },
 	{ "lazytime",	SB_LAZYTIME },
 	{ "mand",	SB_MANDLOCK },
-	{ "posixacl",	SB_POSIXACL },
 	{ "ro",		SB_RDONLY },
 	{ "sync",	SB_SYNCHRONOUS },
 };
-- 
2.21.0
