From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 31/34] vfs: syscall: Add fspick() to select a superblock for reconfiguration [ver #12]
Date: Wed, 17 Oct 2018 14:20:12 +0100
Message-ID: <28710.1539782412@warthog.procyon.org.uk>
References: <19866.1539782101@warthog.procyon.org.uk> <68a2107f-bf70-055b-86cf-1ba2ba9422bf@gmail.com> <153754740781.17872.7869536526927736855.stgit@warthog.procyon.org.uk> <153754766004.17872.9829232103614083565.stgit@warthog.procyon.org.uk> <9b8bf436-65de-13b9-0002-0479d11c18ca@gmail.com> <20181013061141.GR32577@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <19866.1539782101@warthog.procyon.org.uk>
Content-ID: <28709.1539782412.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
Cc: dhowells@redhat.com, Alan Jenkins <alan.christopher.jenkins@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-api@vger.kernel.org, torvalds@linux-foundation.org, ebiederm@xmission.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> I should probably check that the picked point is actually a mountpoint.

The root of the mount object at the path specified, that is, perhaps with
something like the attached.

David
---
diff --git a/fs/fsopen.c b/fs/fsopen.c
index f673e93ac456..aaaaa17a233c 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -186,6 +186,10 @@ SYSCALL_DEFINE3(fspick, int, dfd, const char __user *, path, unsigned int, flags
 	if (ret < 0)
 		goto err;
 
+	ret = -EINVAL;
+	if (target.mnt->mnt_root != target.dentry)
+		goto err_path;
+
 	fc = vfs_new_fs_context(target.dentry->d_sb->s_type, target.dentry,
 				0, 0, FS_CONTEXT_FOR_RECONFIGURE);
 	if (IS_ERR(fc)) {
