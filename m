From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/6] xstat: CIFS: Return extended attributes
Date: Thu, 19 Apr 2012 10:19:56 -0500
Message-ID: <CAH2r5msKb6sSs_RLk=smCEZEb6ytZ5KMHXCXwe6rUeC7wbtLKQ@mail.gmail.com>
References: <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
	<20120419140706.17272.72290.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120419140706.17272.72290.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org, kfm-devel-RoXCvvDuEio@public.gmane.org, nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46or some of our users this would help A LOT.

Interesting ... just had discussions yesterday with some guys trying
to migrate to Linux and another set trying to backup Windows/NetApp
from Linux.

Some things they brought up that they needed (beyond what we already
have wth the cifs acl and SID and "dos attributes" xattrs, which is
even more useful now with the backup intent cifs mount flag) included:
- how do they tell if the inode number for a file was manufactured on
the client, or whether we were able to use the server file's inode
number ("UniqueId")
- how to get birth time (creation time)
- how to tell if file is "offline" (HSM)
- And is there a way to return the other less common cifs attributes
(e.g. "reparse")

Dave's patch seems to address all of that.  Samba server stuffs most
of this in an ndr encoded xattr blob which isn't much good for kernel
code to use, and I really prefer Dave's approach.   Without this, I
would need to add another cifs specific ioctl, but since there is
significant overlap between some of these and ntfs, vfat, nfs etc. I
like the xstat idea better.



On Thu, Apr 19, 2012 at 9:07 AM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> Return extended attributes from the CIFS filesystem. =A0This includes=
 the
> following:
>
> =A0(1) Return the file creation time as btime. =A0We assume that the =
creation time
> =A0 =A0 won't change over the life of the inode.
>
> =A0(2) Set XSTAT_INFO_AUTOMOUNT on referral/submount directories.
>
> =A0(3) Unset XSTAT_INO if we made up the inode number and didn't get =
it from the
> =A0 =A0 server.
>
> =A0(4) Unset XSTAT_[UG]ID if we are either returning values passed to=
 mount
> =A0 =A0 and/or the server doesn't return them.
>
> =A0(5) Map various Windows file attributes to FS_xxx_FL flags in st_i=
oc_flags
> =A0 =A0 and XSTAT_INFO_xxx flags in st_information, fetching them fro=
m the server
> =A0 =A0 if we don't have them yet or don't have a current copy.
>
> =A0 =A0 Possibly things like Hidden, System and Archive should be FS_=
xxx_FL flags
> =A0 =A0 rather than XSTAT_INFO_xxx flags and st_ioc_flags should be e=
xpanded to
> =A0 =A0 64 bits.
>
> =A0(6) Set XSTAT_INFO_REMOTE on all files fetched by CIFS.
>
> =A0(7) Set XSTAT_INFO_NONSYSTEM_OWNERSHIP on all files as they all ha=
ve Windows
> =A0 =A0 ownership details too.
>
> =A0(8) Set XSTAT_INFO_HAS_ACL if CONFIG_CIFS_ACL=3Dy as Windows ACLs =
are available
> =A0 =A0 on the object.
>
> Furthermore, what cifs_getattr() does can be controlled as follows:
>
> =A0(1) If AT_FORCE_ATTR_SYNC is indicated, or if the inode flags or c=
reation time
> =A0 =A0 are requested but not yet collected, then the attributes will=
 be reread
> =A0 =A0 unconditionally.
>
> =A0(2) If the basic stats are requested or if the inode flags are req=
uested and
> =A0 =A0 have been collected previously, then the attributes will be r=
eread if out
> =A0 =A0 of date.
>
> =A0(3) Otherwise the cached attributes will be used - even if expired=
 - without
> =A0 =A0 reference to the server.
>
> Note that cifs_revalidate_dentry() will issue an extra operation to g=
et the
> FILE_ALL_INFO in addition to the FILE_UNIX_BASIC_INFO if it needs to =
collect
> creation time and attributes on behalf of cifs_getattr().
>
> [NOTE: THIS PATCH IS UNTESTED!]
>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>
> =A0fs/cifs/cifsfs.h =A0 | =A0 =A04 +-
> =A0fs/cifs/cifsglob.h | =A0 16 +++++--
> =A0fs/cifs/dir.c =A0 =A0 =A0| =A0 =A02 -
> =A0fs/cifs/inode.c =A0 =A0| =A0120 ++++++++++++++++++++++++++++++++++=
+++++++++++-------
> =A04 files changed, 118 insertions(+), 24 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index d1389bb..021e327 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -56,9 +56,9 @@ extern int cifs_rmdir(struct inode *, struct dentry=
 *);
> =A0extern int cifs_rename(struct inode *, struct dentry *, struct ino=
de *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct dentry *);
> =A0extern int cifs_revalidate_file_attr(struct file *filp);
> -extern int cifs_revalidate_dentry_attr(struct dentry *);
> +extern int cifs_revalidate_dentry_attr(struct dentry *, bool, bool);
> =A0extern int cifs_revalidate_file(struct file *filp);
> -extern int cifs_revalidate_dentry(struct dentry *);
> +extern int cifs_revalidate_dentry(struct dentry *, bool, bool);
> =A0extern int cifs_invalidate_mapping(struct inode *inode);
> =A0extern int cifs_getattr(struct vfsmount *, struct dentry *, struct=
 kstat *);
> =A0extern int cifs_setattr(struct dentry *, struct iattr *);
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 4ff6313..d3567da 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -621,11 +621,15 @@ struct cifsInodeInfo {
> =A0 =A0 =A0 =A0/* BB add in lists for dirty pages i.e. write caching =
info for oplock */
> =A0 =A0 =A0 =A0struct list_head openFileList;
> =A0 =A0 =A0 =A0__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, comp=
ressed, system */
> - =A0 =A0 =A0 bool clientCanCacheRead; =A0 =A0 =A0 =A0/* read oplock =
*/
> - =A0 =A0 =A0 bool clientCanCacheAll; =A0 =A0 =A0 =A0 /* read and wri=
tebehind oplock */
> - =A0 =A0 =A0 bool delete_pending; =A0 =A0 =A0 =A0 =A0 =A0/* DELETE_O=
N_CLOSE is set */
> - =A0 =A0 =A0 bool invalid_mapping; =A0 =A0 =A0 =A0 =A0 /* pagecache =
is invalid */
> + =A0 =A0 =A0 bool clientCanCacheRead:1; =A0 =A0 =A0/* read oplock */
> + =A0 =A0 =A0 bool clientCanCacheAll:1; =A0 =A0 =A0 /* read and write=
behind oplock */
> + =A0 =A0 =A0 bool delete_pending:1; =A0 =A0 =A0 =A0 =A0/* DELETE_ON_=
CLOSE is set */
> + =A0 =A0 =A0 bool invalid_mapping:1; =A0 =A0 =A0 =A0 /* pagecache is=
 invalid */
> + =A0 =A0 =A0 bool btime_valid:1; =A0 =A0 =A0 =A0 =A0 =A0 /* stored c=
reation time is valid */
> + =A0 =A0 =A0 bool uid_faked:1; =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* true i=
f i_uid is faked */
> + =A0 =A0 =A0 bool gid_faked:1; =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* true i=
f i_gid is faked */
> =A0 =A0 =A0 =A0unsigned long time; =A0 =A0 =A0 =A0 =A0 =A0 /* jiffies=
 of last update of inode */
> + =A0 =A0 =A0 struct timespec btime; =A0 =A0 =A0 =A0 =A0/* creation t=
ime */
> =A0 =A0 =A0 =A0u64 =A0server_eof; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* c=
urrent file size on server -- protected by i_lock */
> =A0 =A0 =A0 =A0u64 =A0uniqueid; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*=
 server inode number */
> =A0 =A0 =A0 =A0u64 =A0createtime; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* c=
reation time on server */
> @@ -833,6 +837,9 @@ struct dfs_info3_param {
> =A0#define CIFS_FATTR_DELETE_PENDING =A0 =A0 =A00x2
> =A0#define CIFS_FATTR_NEED_REVAL =A0 =A0 =A0 =A0 =A00x4
> =A0#define CIFS_FATTR_INO_COLLISION =A0 =A0 =A0 0x8
> +#define CIFS_FATTR_WINATTRS_VALID =A0 =A0 =A00x10 =A0 =A0/* T if cf_=
btime and cf_cifsattrs valid */
> +#define CIFS_FATTR_UID_FAKED =A0 =A0 =A0 =A0 =A0 0x20 =A0 =A0/* T if=
 cf_uid is faked */
> +#define CIFS_FATTR_GID_FAKED =A0 =A0 =A0 =A0 =A0 0x40 =A0 =A0/* T if=
 cf_gid is faked */
>
> =A0struct cifs_fattr {
> =A0 =A0 =A0 =A0u32 =A0 =A0 =A0 =A0 =A0 =A0 cf_flags;
> @@ -850,6 +857,7 @@ struct cifs_fattr {
> =A0 =A0 =A0 =A0struct timespec cf_atime;
> =A0 =A0 =A0 =A0struct timespec cf_mtime;
> =A0 =A0 =A0 =A0struct timespec cf_ctime;
> + =A0 =A0 =A0 struct timespec cf_btime;
> =A0};
>
> =A0static inline void free_dfs_info_param(struct dfs_info3_param *par=
am)
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index d172c8e..d9e03ae 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -664,7 +664,7 @@ cifs_d_revalidate(struct dentry *direntry, struct=
 nameidata *nd)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ECHILD;
>
> =A0 =A0 =A0 =A0if (direntry->d_inode) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_revalidate_dentry(direntry))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_revalidate_dentry(direntry, fa=
lse, false))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 745da3d..662d5ce 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -135,13 +135,21 @@ cifs_fattr_to_inode(struct inode *inode, struct=
 cifs_fattr *fattr)
> =A0 =A0 =A0 =A0set_nlink(inode, fattr->cf_nlink);
> =A0 =A0 =A0 =A0inode->i_uid =3D fattr->cf_uid;
> =A0 =A0 =A0 =A0inode->i_gid =3D fattr->cf_gid;
> + =A0 =A0 =A0 if (fattr->cf_flags & CIFS_FATTR_UID_FAKED)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_i->uid_faked =3D true;
> + =A0 =A0 =A0 if (fattr->cf_flags & CIFS_FATTR_GID_FAKED)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_i->gid_faked =3D true;
>
> =A0 =A0 =A0 =A0/* if dynperm is set, don't clobber existing mode */
> =A0 =A0 =A0 =A0if (inode->i_state & I_NEW ||
> =A0 =A0 =A0 =A0 =A0 =A0!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM=
))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0inode->i_mode =3D fattr->cf_mode;
>
> - =A0 =A0 =A0 cifs_i->cifsAttrs =3D fattr->cf_cifsattrs;
> + =A0 =A0 =A0 if (fattr->cf_flags & CIFS_FATTR_WINATTRS_VALID) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_i->cifsAttrs =3D fattr->cf_cifsatt=
rs;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_i->btime =3D fattr->cf_btime;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_i->btime_valid =3D true;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_i->time =3D 0;
> @@ -248,15 +256,19 @@ cifs_unix_basic_to_fattr(struct cifs_fattr *fat=
tr, FILE_UNIX_BASIC_INFO *info,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fattr->cf_uid =3D cifs_sb->mnt_uid;
> - =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_flags |=3D CIFS_FATTR_UID_FAK=
ED;
> + =A0 =A0 =A0 } else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fattr->cf_uid =3D le64_to_cpu(info->Ui=
d);
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fattr->cf_gid =3D cifs_sb->mnt_gid;
> - =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_flags |=3D CIFS_FATTR_GID_FAK=
ED;
> + =A0 =A0 =A0 } else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fattr->cf_gid =3D le64_to_cpu(info->Gi=
d);
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0fattr->cf_nlink =3D le64_to_cpu(info->Nlinks);
> =A0}
> @@ -283,7 +295,8 @@ cifs_create_dfs_fattr(struct cifs_fattr *fattr, s=
truct super_block *sb)
> =A0 =A0 =A0 =A0fattr->cf_ctime =3D CURRENT_TIME;
> =A0 =A0 =A0 =A0fattr->cf_mtime =3D CURRENT_TIME;
> =A0 =A0 =A0 =A0fattr->cf_nlink =3D 2;
> - =A0 =A0 =A0 fattr->cf_flags |=3D CIFS_FATTR_DFS_REFERRAL;
> + =A0 =A0 =A0 fattr->cf_flags |=3D CIFS_FATTR_DFS_REFERRAL |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_FATTR_UID_FAKED | CIFS_FATTR_GID_F=
AKED;
> =A0}
>
> =A0int cifs_get_file_info_unix(struct file *filp)
> @@ -510,6 +523,7 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, =
=46ILE_ALL_INFO *info,
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb=
);
>
> =A0 =A0 =A0 =A0memset(fattr, 0, sizeof(*fattr));
> + =A0 =A0 =A0 fattr->cf_flags =3D CIFS_FATTR_WINATTRS_VALID;
> =A0 =A0 =A0 =A0fattr->cf_cifsattrs =3D le32_to_cpu(info->Attributes);
> =A0 =A0 =A0 =A0if (info->DeletePending)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fattr->cf_flags |=3D CIFS_FATTR_DELETE=
_PENDING;
> @@ -521,6 +535,7 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, =
=46ILE_ALL_INFO *info,
>
> =A0 =A0 =A0 =A0fattr->cf_ctime =3D cifs_NTtimeToUnix(info->ChangeTime=
);
> =A0 =A0 =A0 =A0fattr->cf_mtime =3D cifs_NTtimeToUnix(info->LastWriteT=
ime);
> + =A0 =A0 =A0 fattr->cf_btime =3D cifs_NTtimeToUnix(info->CreationTim=
e);
>
> =A0 =A0 =A0 =A0if (adjust_tz) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fattr->cf_ctime.tv_sec +=3D tcon->ses-=
>server->timeAdj;
> @@ -1724,7 +1739,8 @@ int cifs_revalidate_file_attr(struct file *filp=
)
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> -int cifs_revalidate_dentry_attr(struct dentry *dentry)
> +int cifs_revalidate_dentry_attr(struct dentry *dentry,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool wa=
nt_extra_bits, bool force)
> =A0{
> =A0 =A0 =A0 =A0int xid;
> =A0 =A0 =A0 =A0int rc =3D 0;
> @@ -1735,7 +1751,7 @@ int cifs_revalidate_dentry_attr(struct dentry *=
dentry)
> =A0 =A0 =A0 =A0if (inode =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOENT;
>
> - =A0 =A0 =A0 if (!cifs_inode_needs_reval(inode))
> + =A0 =A0 =A0 if (!force && !cifs_inode_needs_reval(inode))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
> @@ -1752,9 +1768,12 @@ int cifs_revalidate_dentry_attr(struct dentry =
*dentry)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "%ld jiffies %ld", full_path, inode, =
inode->i_count.counter,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dentry, dentry->d_time, jiffies);
>
> - =A0 =A0 =A0 if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
> + =A0 =A0 =A0 if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_get_inode_info_unix(&inode=
, full_path, sb, xid);
> - =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc !=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (!cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext || want=
_extra_bits)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D cifs_get_inode_info(&inode, ful=
l_path, NULL, sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 xid, NULL);
>
> @@ -1779,12 +1798,13 @@ int cifs_revalidate_file(struct file *filp)
> =A0}
>
> =A0/* revalidate a dentry's inode attributes */
> -int cifs_revalidate_dentry(struct dentry *dentry)
> +int cifs_revalidate_dentry(struct dentry *dentry,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool want_extra_=
bits, bool force)
> =A0{
> =A0 =A0 =A0 =A0int rc;
> =A0 =A0 =A0 =A0struct inode *inode =3D dentry->d_inode;
>
> - =A0 =A0 =A0 rc =3D cifs_revalidate_dentry_attr(dentry);
> + =A0 =A0 =A0 rc =3D cifs_revalidate_dentry_attr(dentry, want_extra_b=
its, force);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> @@ -1796,11 +1816,30 @@ int cifs_revalidate_dentry(struct dentry *den=
try)
> =A0int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kstat *stat)
> =A0{
> + =A0 =A0 =A0 struct cifsInodeInfo *cifs_i =3D CIFS_I(dentry->d_inode=
);
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry->d_sb)=
;
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb=
);
> =A0 =A0 =A0 =A0struct inode *inode =3D dentry->d_inode;
> + =A0 =A0 =A0 unsigned force =3D stat->query_flags & AT_FORCE_ATTR_SY=
NC;
> + =A0 =A0 =A0 bool want_extra_bits =3D false;
> + =A0 =A0 =A0 u32 info, ioc =3D 0;
> + =A0 =A0 =A0 u32 attrs;
> =A0 =A0 =A0 =A0int rc;
>
> + =A0 =A0 =A0 if (cifs_i->uid_faked)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->request_mask &=3D ~XSTAT_UID;
> + =A0 =A0 =A0 if (cifs_i->gid_faked)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->request_mask &=3D ~XSTAT_GID;
> +
> + =A0 =A0 =A0 if (stat->request_mask & XSTAT_BTIME && !cifs_i->btime_=
valid) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 want_extra_bits =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 force =3D true;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (stat->request_mask & XSTAT_IOC_FLAGS) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 want_extra_bits =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 force =3D true;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * We need to be sure that all dirty pages are written=
 and the server
> =A0 =A0 =A0 =A0 * has actual ctime, mtime and file length.
> @@ -1814,13 +1853,14 @@ int cifs_getattr(struct vfsmount *mnt, struct=
 dentry *dentry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 rc =3D cifs_revalidate_dentry_attr(dentry);
> - =A0 =A0 =A0 if (rc)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 if (force || stat->request_mask & XSTAT_BASIC_STATS) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_revalidate_dentry(dentry, w=
ant_extra_bits, force);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0generic_fillattr(inode, stat);
> =A0 =A0 =A0 =A0stat->blksize =3D CIFS_MAX_MSGSIZE;
> - =A0 =A0 =A0 stat->ino =3D CIFS_I(inode)->uniqueid;
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * If on a multiuser mount without unix extensions, an=
d the admin hasn't
> @@ -1834,7 +1874,53 @@ int cifs_getattr(struct vfsmount *mnt, struct =
dentry *dentry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!(cifs_sb->mnt_cifs_flags & CIFS_M=
OUNT_OVERR_GID))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stat->gid =3D current_=
fsgid();
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 return rc;
> +
> + =A0 =A0 =A0 info =3D XSTAT_INFO_REMOTE | XSTAT_INFO_NONSYSTEM_OWNER=
SHIP;
> +#ifdef CONFIG_CIFS_ACL
> + =A0 =A0 =A0 info |=3D XSTAT_INFO_HAS_ACL;
> +#endif
> +
> + =A0 =A0 =A0 if (cifs_i->btime_valid) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->btime =3D cifs_i->btime;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->result_mask |=3D XSTAT_BTIME;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* We don't promise an inode number if we made one up *=
/
> + =A0 =A0 =A0 stat->ino =3D cifs_i->uniqueid;
> + =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)=
)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->result_mask &=3D ~XSTAT_INO;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* If on a multiuser mount without unix extensions, a=
nd the admin
> + =A0 =A0 =A0 =A0* hasn't overridden them, set the ownership to the f=
suid/fsgid of the
> + =A0 =A0 =A0 =A0* current process.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER) &&
> + =A0 =A0 =A0 =A0 =A0 !tcon->unix_ext) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs_flags & CIFS_MO=
UNT_OVERR_UID))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->uid =3D current_f=
suid();
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs_flags & CIFS_MO=
UNT_OVERR_GID))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->gid =3D current_f=
sgid();
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (cifs_i->uid_faked)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->result_mask &=3D ~XSTAT_UID;
> + =A0 =A0 =A0 if (cifs_i->gid_faked)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 stat->result_mask &=3D ~XSTAT_GID;
> +
> + =A0 =A0 =A0 attrs =3D cifs_i->cifsAttrs;
> + =A0 =A0 =A0 if (attrs & ATTR_HIDDEN) =A0 =A0 =A0 =A0info |=3D XSTAT=
_INFO_HIDDEN;
> + =A0 =A0 =A0 if (attrs & ATTR_SYSTEM) =A0 =A0 =A0 =A0info |=3D XSTAT=
_INFO_SYSTEM;
> + =A0 =A0 =A0 if (attrs & ATTR_ARCHIVE) =A0 =A0 =A0 info |=3D XSTAT_I=
NFO_ARCHIVE;
> + =A0 =A0 =A0 if (attrs & ATTR_TEMPORARY) =A0 =A0 info |=3D XSTAT_INF=
O_TEMPORARY;
> + =A0 =A0 =A0 if (attrs & ATTR_REPARSE) =A0 =A0 =A0 info |=3D XSTAT_I=
NFO_REPARSE_POINT;
> + =A0 =A0 =A0 if (attrs & ATTR_OFFLINE) =A0 =A0 =A0 info |=3D XSTAT_I=
NFO_OFFLINE;
> + =A0 =A0 =A0 if (attrs & ATTR_ENCRYPTED) =A0 =A0 info |=3D XSTAT_INF=
O_ENCRYPTED;
> + =A0 =A0 =A0 stat->information |=3D info;
> +
> + =A0 =A0 =A0 if (attrs & ATTR_READONLY) =A0 =A0 =A0ioc |=3D FS_IMMUT=
ABLE_FL;
> + =A0 =A0 =A0 if (attrs & ATTR_COMPRESSED) =A0 =A0ioc |=3D FS_COMPR_F=
L;
> + =A0 =A0 =A0 stat->ioc_flags |=3D ioc;
> + =A0 =A0 =A0 return 0;
> =A0}
>
> =A0static int cifs_truncate_page(struct address_space *mapping, loff_=
t from)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
