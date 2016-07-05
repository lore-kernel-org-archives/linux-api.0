From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v23 04/22] vfs: Make the inode passed to inode_change_ok
 non-const
Date: Tue, 05 Jul 2016 07:12:14 -0400
Message-ID: <1467717134.3800.7.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-5-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467294433-3222-5-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:46 +0200, Andreas Gruenbacher wrote:
> We will need to call iop->permission and iop->get_acl from
> inode_change_ok() for additional permission checks, and both take a
> non-const inode.
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
> Reviewed-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
> ---
> =C2=A0fs/attr.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0| 2 +-
> =C2=A0include/linux/fs.h | 2 +-
> =C2=A02 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/attr.c b/fs/attr.c
> index 25b24d0..7ca7fa0 100644
> --- a/fs/attr.c
> +++ b/fs/attr.c
> @@ -28,7 +28,7 @@
> =C2=A0 * Should be called as the first thing in ->setattr implementat=
ions,
> =C2=A0 * possibly after taking additional locks.
> =C2=A0 */
> -int inode_change_ok(const struct inode *inode, struct iattr *attr)
> +int inode_change_ok(struct inode *inode, struct iattr *attr)
> =C2=A0{
> =C2=A0	unsigned int ia_valid =3D attr->ia_valid;
> =C2=A0
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 86bfa10..208f73b 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2993,7 +2993,7 @@ extern int buffer_migrate_page(struct address_s=
pace *,
> =C2=A0#define buffer_migrate_page NULL
> =C2=A0#endif
> =C2=A0
> -extern int inode_change_ok(const struct inode *, struct iattr *);
> +extern int inode_change_ok(struct inode *, struct iattr *);
> =C2=A0extern int inode_newsize_ok(const struct inode *, loff_t offset=
);
> =C2=A0extern void setattr_copy(struct inode *inode, const struct iatt=
r *attr);
> =C2=A0

Yuck. Bummer to lose the "const" there, but it doesn't look like it's
possible to make those ops take a const arg.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
