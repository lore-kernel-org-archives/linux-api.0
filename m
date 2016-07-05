From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v23 02/22] vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR
 permission flags
Date: Tue, 05 Jul 2016 07:02:52 -0400
Message-ID: <1467716572.3800.2.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-3-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467294433-3222-3-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:46 +0200, Andreas Gruenbacher wrote:
> Richacls distinguish between creating non-directories and directories=
=2E To
> support that, add an isdir parameter to may_create(). When checking
> inode_permission() for create permission, pass in an additional
> MAY_CREATE_FILE or MAY_CREATE_DIR mask flag.
>=20
> Add may_replace() to allow checking for delete and create access when
> replacing an existing file in vfs_rename().
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
> Reviewed-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
> ---
> =C2=A0fs/namei.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
| 49 +++++++++++++++++++++++++++++++++----------------
> =C2=A0include/linux/fs.h |=C2=A0=C2=A02 ++
> =C2=A02 files changed, 35 insertions(+), 16 deletions(-)
>=20
> diff --git a/fs/namei.c b/fs/namei.c
> index 7cc5487..dc91858 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -454,7 +454,9 @@ static int sb_permission(struct super_block *sb, =
struct inode *inode, int mask)
> =C2=A0 * this, letting us set arbitrary permissions for filesystem ac=
cess without
> =C2=A0 * changing the "normal" UIDs which are used for other things.
> =C2=A0 *
> - * When checking for MAY_APPEND, MAY_WRITE must also be set in @mask=
=2E
> + * MAY_WRITE must be set in @mask whenever MAY_APPEND, MAY_CREATE_FI=
LE, or
> + * MAY_CREATE_DIR are set.=C2=A0=C2=A0That way, file systems that do=
n't support these
> + * permissions will check for MAY_WRITE instead.
> =C2=A0 */
> =C2=A0int inode_permission(struct inode *inode, int mask)
> =C2=A0{
> @@ -2763,7 +2765,8 @@ EXPORT_SYMBOL(__check_sticky);
> =C2=A0 * 10. We don't allow removal of NFS sillyrenamed files; it's h=
andled by
> =C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0nfs_async_unlink().
> =C2=A0 */
> -static int may_delete(struct inode *dir, struct dentry *victim, bool=
 isdir)
> +static int may_delete_or_replace(struct inode *dir, struct dentry *v=
ictim,
> +				=C2=A0bool isdir, int mask)
> =C2=A0{
> =C2=A0	struct inode *inode =3D d_backing_inode(victim);
> =C2=A0	int error;
> @@ -2775,7 +2778,7 @@ static int may_delete(struct inode *dir, struct=
 dentry *victim, bool isdir)
> =C2=A0	BUG_ON(victim->d_parent->d_inode !=3D dir);
> =C2=A0	audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
> =C2=A0
> -	error =3D inode_permission(dir, MAY_WRITE | MAY_EXEC);
> +	error =3D inode_permission(dir, mask);
> =C2=A0	if (error)
> =C2=A0		return error;
> =C2=A0	if (IS_APPEND(dir))
> @@ -2798,6 +2801,18 @@ static int may_delete(struct inode *dir, struc=
t dentry *victim, bool isdir)
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
> +static int may_delete(struct inode *dir, struct dentry *victim, bool=
 isdir)
> +{
> +	return may_delete_or_replace(dir, victim, isdir, MAY_WRITE | MAY_EX=
EC);
> +}
> +
> +static int may_replace(struct inode *dir, struct dentry *victim, boo=
l isdir)
> +{
> +	int mask =3D isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE;
> +
> +	return may_delete_or_replace(dir, victim, isdir, mask | MAY_WRITE |=
 MAY_EXEC);
> +}
> +
> =C2=A0/*	Check whether we can create an object with dentry child in d=
irectory
> =C2=A0 *=C2=A0=C2=A0dir.
> =C2=A0 *=C2=A0=C2=A01. We can't do it if child already exists (open h=
as special treatment for
> @@ -2806,14 +2821,16 @@ static int may_delete(struct inode *dir, stru=
ct dentry *victim, bool isdir)
> =C2=A0 *=C2=A0=C2=A03. We should have write and exec permissions on d=
ir
> =C2=A0 *=C2=A0=C2=A04. We can't do it if dir is immutable (done in pe=
rmission())
> =C2=A0 */
> -static inline int may_create(struct inode *dir, struct dentry *child=
)
> +static inline int may_create(struct inode *dir, struct dentry *child=
, bool isdir)
> =C2=A0{
> +	int mask =3D isdir ? MAY_CREATE_DIR : MAY_CREATE_FILE;
> +
> =C2=A0	audit_inode_child(dir, child, AUDIT_TYPE_CHILD_CREATE);
> =C2=A0	if (child->d_inode)
> =C2=A0		return -EEXIST;
> =C2=A0	if (IS_DEADDIR(dir))
> =C2=A0		return -ENOENT;
> -	return inode_permission(dir, MAY_WRITE | MAY_EXEC);
> +	return inode_permission(dir, MAY_WRITE | MAY_EXEC | mask);
> =C2=A0}
> =C2=A0
> =C2=A0/*
> @@ -2863,7 +2880,7 @@ EXPORT_SYMBOL(unlock_rename);
> =C2=A0int vfs_create(struct inode *dir, struct dentry *dentry, umode_=
t mode,
> =C2=A0		bool want_excl)
> =C2=A0{
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, false);
> =C2=A0	if (error)
> =C2=A0		return error;
> =C2=A0
> @@ -3650,7 +3667,7 @@ EXPORT_SYMBOL(user_path_create);
> =C2=A0
> =C2=A0int vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t=
 mode, dev_t dev)
> =C2=A0{
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, false);
> =C2=A0
> =C2=A0	if (error)
> =C2=A0		return error;
> @@ -3744,7 +3761,7 @@ SYSCALL_DEFINE3(mknod, const char __user *, fil=
ename, umode_t, mode, unsigned, d
> =C2=A0
> =C2=A0int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t=
 mode)
> =C2=A0{
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, true);
> =C2=A0	unsigned max_links =3D dir->i_sb->s_max_links;
> =C2=A0
> =C2=A0	if (error)
> @@ -3800,7 +3817,7 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pat=
hname, umode_t, mode)
> =C2=A0
> =C2=A0int vfs_rmdir(struct inode *dir, struct dentry *dentry)
> =C2=A0{
> -	int error =3D may_delete(dir, dentry, 1);
> +	int error =3D may_delete(dir, dentry, true);
> =C2=A0
> =C2=A0	if (error)
> =C2=A0		return error;
> @@ -3922,7 +3939,7 @@ SYSCALL_DEFINE1(rmdir, const char __user *, pat=
hname)
> =C2=A0int vfs_unlink(struct inode *dir, struct dentry *dentry, struct=
 inode **delegated_inode)
> =C2=A0{
> =C2=A0	struct inode *target =3D dentry->d_inode;
> -	int error =3D may_delete(dir, dentry, 0);
> +	int error =3D may_delete(dir, dentry, false);
> =C2=A0
> =C2=A0	if (error)
> =C2=A0		return error;
> @@ -4056,7 +4073,7 @@ SYSCALL_DEFINE1(unlink, const char __user *, pa=
thname)
> =C2=A0
> =C2=A0int vfs_symlink(struct inode *dir, struct dentry *dentry, const=
 char *oldname)
> =C2=A0{
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, false);
> =C2=A0
> =C2=A0	if (error)
> =C2=A0		return error;
> @@ -4139,7 +4156,7 @@ int vfs_link(struct dentry *old_dentry, struct =
inode *dir, struct dentry *new_de
> =C2=A0	if (!inode)
> =C2=A0		return -ENOENT;
> =C2=A0
> -	error =3D may_create(dir, new_dentry);
> +	error =3D may_create(dir, new_dentry, false);
> =C2=A0	if (error)
> =C2=A0		return error;
> =C2=A0
> @@ -4336,14 +4353,14 @@ int vfs_rename(struct inode *old_dir, struct =
dentry *old_dentry,
> =C2=A0		return error;
> =C2=A0
> =C2=A0	if (!target) {
> -		error =3D may_create(new_dir, new_dentry);
> +		error =3D may_create(new_dir, new_dentry, is_dir);
> =C2=A0	} else {
> =C2=A0		new_is_dir =3D d_is_dir(new_dentry);
> =C2=A0
> =C2=A0		if (!(flags & RENAME_EXCHANGE))
> -			error =3D may_delete(new_dir, new_dentry, is_dir);
> +			error =3D may_replace(new_dir, new_dentry, is_dir);
> =C2=A0		else
> -			error =3D may_delete(new_dir, new_dentry, new_is_dir);
> +			error =3D may_replace(new_dir, new_dentry, new_is_dir);
> =C2=A0	}
> =C2=A0	if (error)
> =C2=A0		return error;
> @@ -4606,7 +4623,7 @@ SYSCALL_DEFINE2(rename, const char __user *, ol=
dname, const char __user *, newna
> =C2=A0
> =C2=A0int vfs_whiteout(struct inode *dir, struct dentry *dentry)
> =C2=A0{
> -	int error =3D may_create(dir, dentry);
> +	int error =3D may_create(dir, dentry, false);
> =C2=A0	if (error)
> =C2=A0		return error;
> =C2=A0
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 4ad130c..dd614ad 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -84,6 +84,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff=
_t offset,
> =C2=A0#define MAY_CHDIR		0x00000040
> =C2=A0/* called from RCU mode, don't block */
> =C2=A0#define MAY_NOT_BLOCK		0x00000080
> +#define MAY_CREATE_FILE		0x00000100
> +#define MAY_CREATE_DIR		0x00000200
> =C2=A0
> =C2=A0/*
> =C2=A0 * flags in file.f_mode.=C2=A0=C2=A0Note that FMODE_READ and FM=
ODE_WRITE must correspond

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
