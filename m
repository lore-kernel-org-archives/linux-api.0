From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v23 12/22] vfs: Add get_richacl and set_richacl inode
 operations
Date: Wed, 06 Jul 2016 14:31:13 -0400
Message-ID: <1467829873.2908.1.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-13-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467294433-3222-13-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:47 +0200, Andreas Gruenbacher wrote:
> These operations are similar to the get_acl and set_acl operations fo=
r
> POSIX ACLs.=C2=A0=C2=A0The distinction between access and default ACL=
s doesn't exist
> for richacls.
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
> ---
> =C2=A0include/linux/fs.h | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 06a30b0..ac96bda 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1726,6 +1726,7 @@ struct inode_operations {
> =C2=A0	const char * (*get_link) (struct dentry *, struct inode *, str=
uct delayed_call *);
> =C2=A0	int (*permission) (struct inode *, int);
> =C2=A0	struct posix_acl * (*get_acl)(struct inode *, int);
> +	struct richacl * (*get_richacl)(struct inode *);
> =C2=A0
> =C2=A0	int (*readlink) (struct dentry *, char __user *,int);
> =C2=A0
> @@ -1756,6 +1757,7 @@ struct inode_operations {
> =C2=A0			=C2=A0=C2=A0=C2=A0umode_t create_mode, int *opened);
> =C2=A0	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
> =C2=A0	int (*set_acl)(struct inode *, struct posix_acl *, int);
> +	int (*set_richacl)(struct inode *, struct richacl *);
> =C2=A0} ____cacheline_aligned;
> =C2=A0
> =C2=A0ssize_t rw_copy_check_uvector(int type, const struct iovec __us=
er * uvector,

Looks OK, though it's hard to review something like this without some
context. Maybe this patch should be folded in with the patch that
actually adds the calls for these operations?

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
