From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v23 01/22] vfs: Add IS_ACL() and IS_RICHACL() tests
Date: Tue, 05 Jul 2016 07:00:13 -0400
Message-ID: <1467716413.3800.1.camel@redhat.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
	 <1467294433-3222-2-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1467294433-3222-2-git-send-email-agruenba@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 2016-06-30 at 15:46 +0200, Andreas Gruenbacher wrote:
> The vfs does not apply the umask for file systems that support acls.
> The test used for this used to be called IS_POSIXACL().=C2=A0=C2=A0Sw=
itch to a new
> IS_ACL() test to check for either posix acls or richacls instead.=C2=A0=
=C2=A0Add a
> new MS_RICHACL flag and IS_RICHACL() test for richacls alone.=C2=A0=C2=
=A0The
> IS_POSIXACL() test is still needed in some places like nfsd.
>=20
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> Reviewed-by: J. Bruce Fields <bfields@redhat.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Reviewed-by: Steve French <steve.french@primarydata.com>
> ---
> =C2=A0fs/Kconfig=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A03 +++
> =C2=A0fs/namei.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A06 +++---
> =C2=A0include/linux/fs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 12 ++++=
++++++++
> =C2=A0include/uapi/linux/fs.h |=C2=A0=C2=A03 ++-
> =C2=A04 files changed, 20 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/Kconfig b/fs/Kconfig
> index b8fcb41..de6de55 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -64,6 +64,9 @@ endif # BLOCK
> =C2=A0config FS_POSIX_ACL
> =C2=A0	def_bool n
> =C2=A0
> +config FS_RICHACL
> +	def_bool n
> +
> =C2=A0config EXPORTFS
> =C2=A0	tristate
> =C2=A0
> diff --git a/fs/namei.c b/fs/namei.c
> index 70580ab..7cc5487 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3115,7 +3115,7 @@ static int lookup_open(struct nameidata *nd, st=
ruct path *path,
> =C2=A0	=C2=A0* O_EXCL open we want to return EEXIST not EROFS).
> =C2=A0	=C2=A0*/
> =C2=A0	if (open_flag & O_CREAT) {
> -		if (!IS_POSIXACL(dir->d_inode))
> +		if (!IS_ACL(dir->d_inode))
> =C2=A0			mode &=3D ~current_umask();
> =C2=A0		if (unlikely(!got_write)) {
> =C2=A0			create_error =3D -EROFS;
> @@ -3709,7 +3709,7 @@ retry:
> =C2=A0	if (IS_ERR(dentry))
> =C2=A0		return PTR_ERR(dentry);
> =C2=A0
> -	if (!IS_POSIXACL(path.dentry->d_inode))
> +	if (!IS_ACL(path.dentry->d_inode))
> =C2=A0		mode &=3D ~current_umask();
> =C2=A0	error =3D security_path_mknod(&path, dentry, mode, dev);
> =C2=A0	if (error)
> @@ -3780,7 +3780,7 @@ retry:
> =C2=A0	if (IS_ERR(dentry))
> =C2=A0		return PTR_ERR(dentry);
> =C2=A0
> -	if (!IS_POSIXACL(path.dentry->d_inode))
> +	if (!IS_ACL(path.dentry->d_inode))
> =C2=A0		mode &=3D ~current_umask();
> =C2=A0	error =3D security_path_mkdir(&path, dentry, mode);
> =C2=A0	if (!error)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index dd28814..4ad130c 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1850,6 +1850,12 @@ struct super_operations {
> =C2=A0#define IS_IMMUTABLE(inode)	((inode)->i_flags & S_IMMUTABLE)
> =C2=A0#define IS_POSIXACL(inode)	__IS_FLG(inode, MS_POSIXACL)
> =C2=A0
> +#ifdef CONFIG_FS_RICHACL
> +#define IS_RICHACL(inode)	__IS_FLG(inode, MS_RICHACL)
> +#else
> +#define IS_RICHACL(inode)	0
> +#endif
> +
> =C2=A0#define IS_DEADDIR(inode)	((inode)->i_flags & S_DEAD)
> =C2=A0#define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
> =C2=A0#define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
> @@ -1863,6 +1869,12 @@ struct super_operations {
> =C2=A0				=C2=A0(inode)->i_rdev =3D=3D WHITEOUT_DEV)
> =C2=A0
> =C2=A0/*
> + * IS_ACL() tells the VFS to not apply the umask
> + * and use check_acl for acl permission checks when defined.
> + */
> +#define IS_ACL(inode)		__IS_FLG(inode, MS_POSIXACL | MS_RICHACL)
> +
> +/*
> =C2=A0 * Inode state bits.=C2=A0=C2=A0Protected by inode->i_lock
> =C2=A0 *
> =C2=A0 * Three bits determine the dirty state of the inode, I_DIRTY_S=
YNC,
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 3b00f7c..f9c41ef 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -120,7 +120,7 @@ struct inodes_stat_t {
> =C2=A0#define MS_VERBOSE	32768	/* War is peace. Verbosity is silence.
> =C2=A0				=C2=A0=C2=A0=C2=A0MS_VERBOSE is deprecated. */
> =C2=A0#define MS_SILENT	32768
> -#define MS_POSIXACL	(1<<16)	/* VFS does not apply the umask */
> +#define MS_POSIXACL	(1<<16)	/* Supports POSIX ACLs */
> =C2=A0#define MS_UNBINDABLE	(1<<17)	/* change to unbindable */
> =C2=A0#define MS_PRIVATE	(1<<18)	/* change to private */
> =C2=A0#define MS_SLAVE	(1<<19)	/* change to slave */
> @@ -130,6 +130,7 @@ struct inodes_stat_t {
> =C2=A0#define MS_I_VERSION	(1<<23) /* Update inode I_version field */
> =C2=A0#define MS_STRICTATIME	(1<<24) /* Always perform atime updates =
*/
> =C2=A0#define MS_LAZYTIME	(1<<25) /* Update the on-disk [acm]times la=
zily */
> +#define MS_RICHACL	(1<<26) /* Supports richacls */
> =C2=A0
> =C2=A0/* These sb flags are internal to the kernel */
> =C2=A0#define MS_NOSEC	(1<<28)

Reviewed-by: Jeff Layton <jlayton@redhat.com>
