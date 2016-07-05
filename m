From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v23 03/22] vfs: Add MAY_DELETE_SELF and MAY_DELETE_CHILD
 permission flags
Date: Tue, 05 Jul 2016 07:07:47 -0400
Message-ID: <1467716867.3800.4.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-4-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467294433-3222-4-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:46 +0200, Andreas Gruenbacher wrote:
> Normally, deleting a file requires MAY_WRITE access to the parent
> directory.=C2=A0=C2=A0With richacls, a file may be deleted with MAY_D=
ELETE_CHILD access
> to the parent directory or with MAY_DELETE_SELF access to the file.
>=20
> To support that, pass the MAY_DELETE_CHILD mask flag to inode_permiss=
ion()
> when checking for delete access inside a directory, and MAY_DELETE_SE=
LF
> when checking for delete access to a file itelf.
>=20

Minor misspelling in changelog above. It should be "itself".

> The MAY_DELETE_SELF permission overrides the sticky directory check.
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
> ---
> =C2=A0fs/namei.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
| 20 ++++++++++++--------
> =C2=A0include/linux/fs.h |=C2=A0=C2=A02 ++
> =C2=A02 files changed, 14 insertions(+), 8 deletions(-)
>=20
> diff --git a/fs/namei.c b/fs/namei.c
> index dc91858..663933e 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -454,9 +454,9 @@ static int sb_permission(struct super_block *sb, =
struct inode *inode, int mask)
> =C2=A0 * this, letting us set arbitrary permissions for filesystem ac=
cess without
> =C2=A0 * changing the "normal" UIDs which are used for other things.
> =C2=A0 *
> - * MAY_WRITE must be set in @mask whenever MAY_APPEND, MAY_CREATE_FI=
LE, or
> - * MAY_CREATE_DIR are set.=C2=A0=C2=A0That way, file systems that do=
n't support these
> - * permissions will check for MAY_WRITE instead.
> + * MAY_WRITE must be set in @mask whenever MAY_APPEND, MAY_CREATE_FI=
LE,
> + * MAY_CREATE_DIR, or MAY_DELETE_CHILD are set.=C2=A0=C2=A0That way,=
 file systems that
> + * don't support these permissions will check for MAY_WRITE instead.
> =C2=A0 */
> =C2=A0int inode_permission(struct inode *inode, int mask)
> =C2=A0{
> @@ -2778,14 +2778,18 @@ static int may_delete_or_replace(struct inode=
 *dir, struct dentry *victim,
> =C2=A0	BUG_ON(victim->d_parent->d_inode !=3D dir);
> =C2=A0	audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
> =C2=A0
> -	error =3D inode_permission(dir, mask);
> +	error =3D inode_permission(dir, mask | MAY_WRITE | MAY_DELETE_CHILD=
);
> +	if (!error && check_sticky(dir, inode))
> +		error =3D -EPERM;
> +	if (error && IS_RICHACL(inode) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0inode_permission(inode, MAY_DELETE_SELF) =3D=
=3D 0 &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0inode_permission(dir, mask) =3D=3D 0)
> +		error =3D 0;
> =C2=A0	if (error)
> =C2=A0		return error;
> =C2=A0	if (IS_APPEND(dir))
> =C2=A0		return -EPERM;
> -
> -	if (check_sticky(dir, inode) || IS_APPEND(inode) ||
> -	=C2=A0=C2=A0=C2=A0=C2=A0IS_IMMUTABLE(inode) || IS_SWAPFILE(inode))
> +	if (IS_APPEND(inode) || IS_IMMUTABLE(inode) || IS_SWAPFILE(inode))
> =C2=A0		return -EPERM;
> =C2=A0	if (isdir) {
> =C2=A0		if (!d_is_dir(victim))
> @@ -2803,7 +2807,7 @@ static int may_delete_or_replace(struct inode *=
dir, struct dentry *victim,
> =C2=A0
> =C2=A0static int may_delete(struct inode *dir, struct dentry *victim,=
 bool isdir)
> =C2=A0{
> -	return may_delete_or_replace(dir, victim, isdir, MAY_WRITE | MAY_EX=
EC);
> +	return may_delete_or_replace(dir, victim, isdir, MAY_EXEC);
> =C2=A0}
> =C2=A0
> =C2=A0static int may_replace(struct inode *dir, struct dentry *victim=
, bool isdir)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index dd614ad..86bfa10 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -86,6 +86,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff=
_t offset,
> =C2=A0#define MAY_NOT_BLOCK		0x00000080
> =C2=A0#define MAY_CREATE_FILE		0x00000100
> =C2=A0#define MAY_CREATE_DIR		0x00000200
> +#define MAY_DELETE_CHILD	0x00000400
> +#define MAY_DELETE_SELF		0x00000800
> =C2=A0
> =C2=A0/*
> =C2=A0 * flags in file.f_mode.=C2=A0=C2=A0Note that FMODE_READ and FM=
ODE_WRITE must correspond

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
