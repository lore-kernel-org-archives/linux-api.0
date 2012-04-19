From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/6] xstat: Ext4: Return extended attributes
Date: Thu, 19 Apr 2012 11:03:54 -0500
Message-ID: <CAH2r5mtHj6LnOcRDv37_S-tZmc42sTLwE8Z02+27XZbjEVzZfg@mail.gmail.com>
References: <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
	<20120419140625.17272.23303.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120419140625.17272.23303.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org, kfm-devel-RoXCvvDuEio@public.gmane.org, nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch reminds me of a question on time stamps - how can an
application query the time granularity ie sb_s_time_gran for a mount
(e.g. 1 second for some file systems, 100 nanoseconds for cifs/smb2, 1
nanosecond for others etc.)

On Thu, Apr 19, 2012 at 9:06 AM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> Return extended attributes from the Ext4 filesystem. =A0This includes=
 the
> following:
>
> =A0(1) The inode creation time (i_crtime) as i_btime.
>
> =A0(2) The inode i_generation as i_gen if not the root directory.
>
> =A0(3) The inode i_version as st_data_version if a file with I_VERSIO=
N set or a
> =A0 =A0 directory.
>
> =A0(4) FS_xxx_FL flags are returned as for ioctl(FS_IOC_GETFLAGS).
>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>
> =A0fs/ext4/ext4.h =A0 =A0| =A0 =A02 ++
> =A0fs/ext4/file.c =A0 =A0| =A0 =A02 +-
> =A0fs/ext4/inode.c =A0 | =A0 32 +++++++++++++++++++++++++++++---
> =A0fs/ext4/namei.c =A0 | =A0 =A02 ++
> =A0fs/ext4/super.c =A0 | =A0 =A01 +
> =A0fs/ext4/symlink.c | =A0 =A02 ++
> =A06 files changed, 37 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index ab2594a..81806da 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1899,6 +1899,8 @@ extern int =A0ext4_getattr(struct vfsmount *mnt=
, struct dentry *dentry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct=
 kstat *stat);
> =A0extern void ext4_evict_inode(struct inode *);
> =A0extern void ext4_clear_inode(struct inode *);
> +extern int =A0ext4_file_getattr(struct vfsmount *mnt, struct dentry =
*dentry,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ksta=
t *stat);
> =A0extern int =A0ext4_sync_inode(handle_t *, struct inode *);
> =A0extern void ext4_dirty_inode(struct inode *, int);
> =A0extern int ext4_change_inode_journal_flag(struct inode *, int);
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index cb70f18..ae8654c 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -249,7 +249,7 @@ const struct file_operations ext4_file_operations=
 =3D {
>
> =A0const struct inode_operations ext4_file_inode_operations =3D {
> =A0 =A0 =A0 =A0.setattr =A0 =A0 =A0 =A0=3D ext4_setattr,
> - =A0 =A0 =A0 .getattr =A0 =A0 =A0 =A0=3D ext4_getattr,
> + =A0 =A0 =A0 .getattr =A0 =A0 =A0 =A0=3D ext4_file_getattr,
> =A0#ifdef CONFIG_EXT4_FS_XATTR
> =A0 =A0 =A0 =A0.setxattr =A0 =A0 =A0 =3D generic_setxattr,
> =A0 =A0 =A0 =A0.getxattr =A0 =A0 =A0 =3D generic_getxattr,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index c77b0bd..eafc188 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4191,11 +4191,37 @@ err_out:
> =A0int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kstat *stat)
> =A0{
> - =A0 =A0 =A0 struct inode *inode;
> - =A0 =A0 =A0 unsigned long delalloc_blocks;
> + =A0 =A0 =A0 struct inode *inode =3D dentry->d_inode;
> + =A0 =A0 =A0 struct ext4_inode_info *ei =3D EXT4_I(inode);
> +
> + =A0 =A0 =A0 stat->result_mask |=3D XSTAT_BTIME;
> + =A0 =A0 =A0 stat->btime.tv_sec =3D ei->i_crtime.tv_sec;
> + =A0 =A0 =A0 stat->btime.tv_nsec =3D ei->i_crtime.tv_nsec;
> +
> + =A0 =A0 =A0 if (inode->i_ino !=3D EXT4_ROOT_INO) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->result_mask |=3D XSTAT_GEN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->gen =3D inode->i_generation;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (S_ISDIR(inode->i_mode) || IS_I_VERSION(inode)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->result_mask |=3D XSTAT_VERSION;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->version =3D inode->i_version;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ext4_get_inode_flags(ei);
> + =A0 =A0 =A0 stat->ioc_flags |=3D ei->i_flags & EXT4_FL_USER_VISIBLE=
;
> + =A0 =A0 =A0 stat->result_mask |=3D XSTAT_IOC_FLAGS;
>
> - =A0 =A0 =A0 inode =3D dentry->d_inode;
> =A0 =A0 =A0 =A0generic_fillattr(inode, stat);
> + =A0 =A0 =A0 return 0;
> +}
> +
> +int ext4_file_getattr(struct vfsmount *mnt, struct dentry *dentry,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kstat *stat)
> +{
> + =A0 =A0 =A0 struct inode *inode =3D dentry->d_inode;
> + =A0 =A0 =A0 u64 delalloc_blocks;
> +
> + =A0 =A0 =A0 ext4_getattr(mnt, dentry, stat);
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * We can't update i_blocks if the block allocation is=
 delayed
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 349d7b3..6162387 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2579,6 +2579,7 @@ const struct inode_operations ext4_dir_inode_op=
erations =3D {
> =A0 =A0 =A0 =A0.mknod =A0 =A0 =A0 =A0 =A0=3D ext4_mknod,
> =A0 =A0 =A0 =A0.rename =A0 =A0 =A0 =A0 =3D ext4_rename,
> =A0 =A0 =A0 =A0.setattr =A0 =A0 =A0 =A0=3D ext4_setattr,
> + =A0 =A0 =A0 .getattr =A0 =A0 =A0 =A0=3D ext4_getattr,
> =A0#ifdef CONFIG_EXT4_FS_XATTR
> =A0 =A0 =A0 =A0.setxattr =A0 =A0 =A0 =3D generic_setxattr,
> =A0 =A0 =A0 =A0.getxattr =A0 =A0 =A0 =3D generic_getxattr,
> @@ -2591,6 +2592,7 @@ const struct inode_operations ext4_dir_inode_op=
erations =3D {
>
> =A0const struct inode_operations ext4_special_inode_operations =3D {
> =A0 =A0 =A0 =A0.setattr =A0 =A0 =A0 =A0=3D ext4_setattr,
> + =A0 =A0 =A0 .getattr =A0 =A0 =A0 =A0=3D ext4_getattr,
> =A0#ifdef CONFIG_EXT4_FS_XATTR
> =A0 =A0 =A0 =A0.setxattr =A0 =A0 =A0 =3D generic_setxattr,
> =A0 =A0 =A0 =A0.getxattr =A0 =A0 =A0 =3D generic_getxattr,
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ceebaf8..2d395bf 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3040,6 +3040,7 @@ static int ext4_fill_super(struct super_block *=
sb, void *data, int silent)
> =A0 =A0 =A0 =A0if (sb->s_magic !=3D EXT4_SUPER_MAGIC)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cantfind_ext4;
> =A0 =A0 =A0 =A0sbi->s_kbytes_written =3D le64_to_cpu(es->s_kbytes_wri=
tten);
> + =A0 =A0 =A0 memcpy(sb->s_volume_id, es->s_uuid, sizeof(sb->s_volume=
_id));
>
> =A0 =A0 =A0 =A0/* Set defaults before we parse the mount options */
> =A0 =A0 =A0 =A0def_mount_opts =3D le32_to_cpu(es->s_default_mount_opt=
s);
> diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
> index ed9354a..d8fe7fb 100644
> --- a/fs/ext4/symlink.c
> +++ b/fs/ext4/symlink.c
> @@ -35,6 +35,7 @@ const struct inode_operations ext4_symlink_inode_op=
erations =3D {
> =A0 =A0 =A0 =A0.follow_link =A0 =A0=3D page_follow_link_light,
> =A0 =A0 =A0 =A0.put_link =A0 =A0 =A0 =3D page_put_link,
> =A0 =A0 =A0 =A0.setattr =A0 =A0 =A0 =A0=3D ext4_setattr,
> + =A0 =A0 =A0 .getattr =A0 =A0 =A0 =A0=3D ext4_getattr,
> =A0#ifdef CONFIG_EXT4_FS_XATTR
> =A0 =A0 =A0 =A0.setxattr =A0 =A0 =A0 =3D generic_setxattr,
> =A0 =A0 =A0 =A0.getxattr =A0 =A0 =A0 =3D generic_getxattr,
> @@ -47,6 +48,7 @@ const struct inode_operations ext4_fast_symlink_ino=
de_operations =3D {
> =A0 =A0 =A0 =A0.readlink =A0 =A0 =A0 =3D generic_readlink,
> =A0 =A0 =A0 =A0.follow_link =A0 =A0=3D ext4_follow_link,
> =A0 =A0 =A0 =A0.setattr =A0 =A0 =A0 =A0=3D ext4_setattr,
> + =A0 =A0 =A0 .getattr =A0 =A0 =A0 =A0=3D ext4_getattr,
> =A0#ifdef CONFIG_EXT4_FS_XATTR
> =A0 =A0 =A0 =A0.setxattr =A0 =A0 =A0 =3D generic_setxattr,
> =A0 =A0 =A0 =A0.getxattr =A0 =A0 =A0 =3D generic_getxattr,
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
