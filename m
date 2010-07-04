From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 3/3] xstat: Implement a requestable extra result to
	procure some inode flags [ver #4]
Date: Sun, 4 Jul 2010 06:27:30 +0200
Message-ID: <AANLkTilJVYGllPB5I2lG_MPWgxYSJmHh4dproHx563kT@mail.gmail.com>
References: <20100701235727.19035.84584.stgit@warthog.procyon.org.uk>
	<20100701235738.19035.21536.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20100701235738.19035.21536.stgit@warthog.procyon.org.uk>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
To: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-Id: linux-api@vger.kernel.org

[CC+=3Dlinux-api]

On Fri, Jul 2, 2010 at 1:57 AM, David Howells <dhowells@redhat.com> wrote:
> [This is, for the moment, to be considered an example. =A0Do we actually =
want to
> =A0export these flags? =A0Should they be a full member of struct xstat?]


Since I suggested the idea, obviously I'm inclined to think they should ;-)=
.

Cheers,

Michael


> Allow an extra result to be requested that makes available some inode fla=
gs,
> along the lines of BSD's st_flags and Ext2/3/4's inode flags. =A0This is
> requested by setting XSTAT_REQUEST_INODE_FLAGS in the request_mask. =A0If=
 the
> filesystem supports it for that file, then this will be set in result_mas=
k and
> 16 bytes of information will be appended to the xstat buffer, if sufficie=
nt
> buffer space is available.
>
> The extra result is laid out according to the following structure:
>
> =A0 =A0 =A0 =A0struct xstat_inode_flags {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_flags;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_supported=
_flags;
> =A0 =A0 =A0 =A0};
>
> where the filesystem indicates the flags it supports for that file and th=
e
> flags that are set on that file. =A0The structure is of length:
>
> =A0 =A0 =A0 =A0XSTAT_LENGTH_INODE_FLAGS
>
> The flags come in three sets:
>
> =A0(1) User settable flags (to be consistent with the BSD st_flags field)=
:
>
> =A0 =A0 =A0 =A0UF_NODUMP =A0 =A0 =A0 Do not dump this file.
> =A0 =A0 =A0 =A0UF_IMMUTABLE =A0 =A0This file is immutable.
> =A0 =A0 =A0 =A0UF_APPEND =A0 =A0 =A0 This file is append-only.
> =A0 =A0 =A0 =A0UF_OPAQUE =A0 =A0 =A0 This directory is opaque (unionfs).
> =A0 =A0 =A0 =A0UF_NOUNLINK =A0 =A0 This file can't be removed or renamed.
> =A0 =A0 =A0 =A0UF_COMPRESSED =A0 This file is compressed.
> =A0 =A0 =A0 =A0UF_HIDDEN =A0 =A0 =A0 This file shouldn't be displayed in =
a GUI.
>
> =A0 =A0 The UF_SETTABLE constant is the union of the above flags.
>
> =A0(2) Superuser settable flags (to be consistent with the BSD st_flags f=
ield):
>
> =A0 =A0 =A0 =A0SF_ARCHIVED =A0 =A0 This file has been archived.
> =A0 =A0 =A0 =A0SF_IMMUTABLE =A0 =A0This file is immutable.
> =A0 =A0 =A0 =A0SF_APPEND =A0 =A0 =A0 This file is append-only.
> =A0 =A0 =A0 =A0SF_NOUNLINK =A0 =A0 This file can't be removed or renamed.
> =A0 =A0 =A0 =A0SF_HIDDEN =A0 =A0 =A0 This file is a snapshot inode.
>
> =A0 =A0 The SF_SETTABLE constant is the union of the above flags.
>
> =A0(3) Linux-specific flags:
>
> =A0 =A0 =A0 =A0XSTAT_LF_MAGIC_FILE =A0 =A0 Magic file, such as found in p=
rocfs and sysfs.
> =A0 =A0 =A0 =A0XSTAT_LF_SYNC =A0 =A0 =A0 =A0 =A0 File is written synchron=
ously.
> =A0 =A0 =A0 =A0XSTAT_LF_NOATIME =A0 =A0 =A0 =A0Atime is not updated on th=
is file.
> =A0 =A0 =A0 =A0XSTAT_LF_JOURNALLED_DATA Data modifications to this file a=
re journalled.
> =A0 =A0 =A0 =A0XSTAT_LF_ENCRYPTED =A0 =A0 =A0This file is encrypted.
> =A0 =A0 =A0 =A0XSTAT_LF_SYSTEM =A0 =A0 =A0 =A0 This file is a system file=
 (FAT/NTFS/CIFS).
> =A0 =A0 =A0 =A0XSTAT_LF_TEMPORARY =A0 =A0 =A0This file is a temporary fil=
e (NTFS/CIFS).
> =A0 =A0 =A0 =A0XSTAT_LF_OFFLINE =A0 =A0 =A0 =A0file is currently unavaila=
ble (CIFS).
>
>
> The Ext4 filesystem has been modified to map certain Ext4 inode flags to =
the
> above:
>
> =A0 =A0 =A0 =A0EXT4 FLAG =A0 =A0 =A0 =A0 =A0 =A0 =A0 MAPPED TO
> =A0 =A0 =A0 =A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =A0 =A0 =A0 =A0EXT4_COMPR_FL =A0 =A0 =A0 =A0 =A0 UF_COMPRESSED
> =A0 =A0 =A0 =A0EXT4_SYNC_FL =A0 =A0 =A0 =A0 =A0 =A0XSTAT_LF_SYNC
> =A0 =A0 =A0 =A0EXT4_IMMUTABLE_FL =A0 =A0 =A0 UF_IMMUTABLE and SF_IMMUTABL=
E
> =A0 =A0 =A0 =A0EXT4_APPEND_FL =A0 =A0 =A0 =A0 =A0UF_APPEND and SF_APPEND
> =A0 =A0 =A0 =A0EXT4_NODUMP_FL =A0 =A0 =A0 =A0 =A0UF_NODUMP
> =A0 =A0 =A0 =A0EXT4_NOATIME_FL =A0 =A0 =A0 =A0 XSTAT_LF_NOATIME
> =A0 =A0 =A0 =A0EXT4_JOURNAL_DATA_FL =A0 =A0XSTAT_LF_JOURNALLED_DATA
> =A0 =A0 =A0 =A0EXT4_DIRSYNC_FL =A0 =A0 =A0 =A0 XSTAT_LF_SYNC (directories=
 only)
>
> With this patch applied, the test program given in the patch that introdu=
ced
> the xstat() syscalls now does this:
>
> =A0 =A0 =A0 =A0[root@andromeda ~]# chattr +ia /var/cache/fscache/cull_ati=
mes
> =A0 =A0 =A0 =A0[root@andromeda ~]# lsattr /var/cache/fscache/cull_atimes
> =A0 =A0 =A0 =A0----ia-------e- /var/cache/fscache/cull_atimes
> =A0 =A0 =A0 =A0[root@andromeda ~]# /tmp/xstat /var/cache/fscache/cull_ati=
mes
> =A0 =A0 =A0 =A0xstat(/var/cache/fscache/cull_atimes) =3D 168
> =A0 =A0 =A0 =A0results=3D5fef
> =A0 =A0 =A0 =A0 =A0Size: 78088 =A0 =A0 =A0 =A0 =A0 Blocks: 168 =A0 =A0 =
=A0 =A0IO Block: 4096 =A0 =A0regular file
> =A0 =A0 =A0 =A0Device: 08:06 =A0 =A0 =A0 =A0 =A0 Inode: 13 =A0 =A0 =A0 =
=A0 =A0Links: 1
> =A0 =A0 =A0 =A0Access: (0600/-rw-------) =A0Uid: 0
> =A0 =A0 =A0 =A0Gid: 0
> =A0 =A0 =A0 =A0Access: 2010-06-29 18:17:41.092290108+0100
> =A0 =A0 =A0 =A0Modify: 2010-06-25 17:25:53.320261493+0100
> =A0 =A0 =A0 =A0Change: 2010-07-02 00:46:51.278803967+0100
> =A0 =A0 =A0 =A0Create: 2010-06-25 15:17:39.711172889+0100
> =A0 =A0 =A0 =A0Inode version: f585ab73h
> =A0 =A0 =A0 =A00098: 0000000000060006 0000000e00060027
>
> The extra results are hex dumped at the end in 64-bit chunks. =A0As can b=
e seen
> above, st_flags=3D0x0000000000060006 and st_supported_flags=3D0000000e000=
60027.
> That's showing that the file now has [SU]F_IMMUTABLE and [SU]F_APPEND ena=
bled.
>
> Note also that XSTAT_REQUEST_INODE_FLAGS (0x4000) is present in the resul=
t_mask
> value (0x5fef) returned to userspace, and the amount of data returned by
> xstat() has increased from 152 to 168 as appropriate for 16 bytes of extr=
a
> data.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
> =A0fs/ext4/ext4.h =A0 =A0 =A0 | =A0 =A02 ++
> =A0fs/ext4/file.c =A0 =A0 =A0 | =A0 =A01 +
> =A0fs/ext4/inode.c =A0 =A0 =A0| =A0 50 ++++++++++++++++++++++++++++++++++=
++++++++++++++++
> =A0fs/ext4/namei.c =A0 =A0 =A0| =A0 =A02 ++
> =A0fs/ext4/symlink.c =A0 =A0| =A0 =A02 ++
> =A0include/linux/stat.h | =A0 47 ++++++++++++++++++++++++++++++++++++++++=
++++++-
> =A06 files changed, 103 insertions(+), 1 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 96823f3..26b8dd6 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1573,6 +1573,8 @@ extern int =A0ext4_getattr(struct vfsmount *mnt, st=
ruct dentry *dentry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct kst=
at *stat);
> =A0extern int =A0ext4_file_getattr(struct vfsmount *mnt, struct dentry *d=
entry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct kst=
at *stat);
> +extern int =A0ext4_getattr_extra(struct vfsmount *, struct dentry *,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat=
_extra_result *);
> =A0extern void ext4_delete_inode(struct inode *);
> =A0extern int =A0ext4_sync_inode(handle_t *, struct inode *);
> =A0extern void ext4_dirty_inode(struct inode *);
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 18c29ab..657ffa0 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -151,6 +151,7 @@ const struct inode_operations ext4_file_inode_operati=
ons =3D {
> =A0 =A0 =A0 =A0.truncate =A0 =A0 =A0 =3D ext4_truncate,
> =A0 =A0 =A0 =A0.setattr =A0 =A0 =A0 =A0=3D ext4_setattr,
> =A0 =A0 =A0 =A0.getattr =A0 =A0 =A0 =A0=3D ext4_file_getattr,
> + =A0 =A0 =A0 .getattr_extra =A0=3D ext4_getattr_extra,
> =A0#ifdef CONFIG_EXT4_FS_XATTR
> =A0 =A0 =A0 =A0.setxattr =A0 =A0 =A0 =3D generic_setxattr,
> =A0 =A0 =A0 =A0.getxattr =A0 =A0 =A0 =3D generic_getxattr,
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index f9a730a..efa17d6 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5595,6 +5595,56 @@ int ext4_file_getattr(struct vfsmount *mnt, struct=
 dentry *dentry,
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> +int ext4_getattr_inode_flags(struct inode *inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_ext=
ra_result *extra)
> +{
> + =A0 =A0 =A0 struct ext4_inode_info *ei =3D EXT4_I(inode);
> + =A0 =A0 =A0 struct xstat_inode_flags xif =3D { 0, 0 };
> +
> +#define _(FL, ST) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
> + =A0 =A0 =A0 xif.st_supported_flags |=3D ST; \
> + =A0 =A0 =A0 if (ei->i_flags & FL) =A0 =A0 =A0 =A0 \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 xif.st_flags |=3D ST;
> +
> + =A0 =A0 =A0 _(EXT4_COMPR_FL, =A0 =A0 =A0 =A0UF_COMPRESSED);
> + =A0 =A0 =A0 _(EXT4_SYNC_FL, =A0 =A0 =A0 =A0 XSTAT_LF_SYNC);
> + =A0 =A0 =A0 _(EXT4_IMMUTABLE_FL, =A0 =A0UF_IMMUTABLE | SF_IMMUTABLE);
> + =A0 =A0 =A0 _(EXT4_APPEND_FL, =A0 =A0 =A0 UF_APPEND | SF_APPEND);
> + =A0 =A0 =A0 _(EXT4_NODUMP_FL, =A0 =A0 =A0 UF_NODUMP);
> + =A0 =A0 =A0 _(EXT4_NOATIME_FL, =A0 =A0 =A0XSTAT_LF_NOATIME);
> + =A0 =A0 =A0 _(EXT4_JOURNAL_DATA_FL, XSTAT_LF_JOURNALLED_DATA);
> +
> + =A0 =A0 =A0 if (S_ISDIR(ei->vfs_inode.i_mode))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 _(EXT4_DIRSYNC_FL, =A0 =A0 =A0XSTAT_LF_SYNC=
);
> +
> + =A0 =A0 =A0 return extra->pass_result(extra, ilog2(XSTAT_REQUEST_INODE_=
FLAGS),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &xif, s=
izeof(xif));
> +}
> +
> +int ext4_getattr_extra(struct vfsmount *mnt, struct dentry *dentry,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct xstat_extra_result *e=
xtra)
> +{
> + =A0 =A0 =A0 struct inode *inode =3D dentry->d_inode;
> + =A0 =A0 =A0 u64 request_mask =3D extra->request_mask;
> + =A0 =A0 =A0 int request, ret;
> +
> + =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 request =3D __ffs64(request_mask);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 request_mask &=3D ~(1ULL << request);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (request) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case ilog2(XSTAT_REQUEST_INODE_FLAGS):
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ext4_getattr_inode_=
flags(inode, extra);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 } while (ret =3D=3D 0 && request_mask);
> + =A0 =A0 =A0 return ret;
> +}
> +
> =A0static int ext4_indirect_trans_blocks(struct inode *inode, int nrblock=
s,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0int chunk)
> =A0{
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 0f776c7..3c37b3f 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -2543,6 +2543,7 @@ const struct inode_operations ext4_dir_inode_operat=
ions =3D {
> =A0 =A0 =A0 =A0.rename =A0 =A0 =A0 =A0 =3D ext4_rename,
> =A0 =A0 =A0 =A0.setattr =A0 =A0 =A0 =A0=3D ext4_setattr,
> =A0 =A0 =A0 =A0.getattr =A0 =A0 =A0 =A0=3D ext4_getattr,
> + =A0 =A0 =A0 .getattr_extra =A0=3D ext4_getattr_extra,
> =A0#ifdef CONFIG_EXT4_FS_XATTR
> =A0 =A0 =A0 =A0.setxattr =A0 =A0 =A0 =3D generic_setxattr,
> =A0 =A0 =A0 =A0.getxattr =A0 =A0 =A0 =3D generic_getxattr,
> @@ -2556,6 +2557,7 @@ const struct inode_operations ext4_dir_inode_operat=
ions =3D {
> =A0const struct inode_operations ext4_special_inode_operations =3D {
> =A0 =A0 =A0 =A0.setattr =A0 =A0 =A0 =A0=3D ext4_setattr,
> =A0 =A0 =A0 =A0.getattr =A0 =A0 =A0 =A0=3D ext4_getattr,
> + =A0 =A0 =A0 .getattr_extra =A0=3D ext4_getattr_extra,
> =A0#ifdef CONFIG_EXT4_FS_XATTR
> =A0 =A0 =A0 =A0.setxattr =A0 =A0 =A0 =3D generic_setxattr,
> =A0 =A0 =A0 =A0.getxattr =A0 =A0 =A0 =3D generic_getxattr,
> diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
> index d8fe7fb..8c206b2 100644
> --- a/fs/ext4/symlink.c
> +++ b/fs/ext4/symlink.c
> @@ -36,6 +36,7 @@ const struct inode_operations ext4_symlink_inode_operat=
ions =3D {
> =A0 =A0 =A0 =A0.put_link =A0 =A0 =A0 =3D page_put_link,
> =A0 =A0 =A0 =A0.setattr =A0 =A0 =A0 =A0=3D ext4_setattr,
> =A0 =A0 =A0 =A0.getattr =A0 =A0 =A0 =A0=3D ext4_getattr,
> + =A0 =A0 =A0 .getattr_extra =A0=3D ext4_getattr_extra,
> =A0#ifdef CONFIG_EXT4_FS_XATTR
> =A0 =A0 =A0 =A0.setxattr =A0 =A0 =A0 =3D generic_setxattr,
> =A0 =A0 =A0 =A0.getxattr =A0 =A0 =A0 =3D generic_getxattr,
> @@ -49,6 +50,7 @@ const struct inode_operations ext4_fast_symlink_inode_o=
perations =3D {
> =A0 =A0 =A0 =A0.follow_link =A0 =A0=3D ext4_follow_link,
> =A0 =A0 =A0 =A0.setattr =A0 =A0 =A0 =A0=3D ext4_setattr,
> =A0 =A0 =A0 =A0.getattr =A0 =A0 =A0 =A0=3D ext4_getattr,
> + =A0 =A0 =A0 .getattr_extra =A0=3D ext4_getattr_extra,
> =A0#ifdef CONFIG_EXT4_FS_XATTR
> =A0 =A0 =A0 =A0.setxattr =A0 =A0 =A0 =3D generic_setxattr,
> =A0 =A0 =A0 =A0.getxattr =A0 =A0 =A0 =3D generic_getxattr,
> diff --git a/include/linux/stat.h b/include/linux/stat.h
> index 9e27f88..4c87878 100644
> --- a/include/linux/stat.h
> +++ b/include/linux/stat.h
> @@ -107,7 +107,8 @@ struct xstat_parameters {
> =A0#define XSTAT_REQUEST_GEN =A0 =A0 =A0 =A0 =A0 =A0 =A00x00001000ULL =A0=
 /* want/got st_gen */
> =A0#define XSTAT_REQUEST_DATA_VERSION =A0 =A0 0x00002000ULL =A0 /* want/g=
ot st_data_version */
> =A0#define XSTAT_REQUEST__EXTENDED_STATS =A00x00003fffULL =A0 /* the stuf=
f in the xstat struct */
> -#define XSTAT_REQUEST__ALL_STATS =A0 =A0 =A0 0x00003fffULL =A0 /* the de=
fined set of requestables */
> +#define XSTAT_REQUEST_INODE_FLAGS =A0 =A0 =A00x00004000ULL =A0 /* want/g=
ot xstat_inode_flags */
> +#define XSTAT_REQUEST__ALL_STATS =A0 =A0 =A0 0x00007fffULL =A0 /* the de=
fined set of requestables */
> =A0#define XSTAT_REQUEST__EXTRA_STATS =A0 =A0 (XSTAT_REQUEST__ALL_STATS &=
 ~XSTAT_REQUEST__EXTENDED_STATS)
> =A0};
>
> @@ -140,6 +141,50 @@ struct xstat {
> =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0st_extra_results[0]; /* extr=
a requested results */
> =A0};
>
> +/*
> + * Extra result field for inode flags (XSTAT_REQUEST_INODE_FLAGS)
> + */
> +struct xstat_inode_flags {
> + =A0 =A0 =A0 /* Flags set on the file
> + =A0 =A0 =A0 =A0* - the LSW matches the BSD st_flags
> + =A0 =A0 =A0 =A0* - the MSW are Linux-specific
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 unsigned long long =A0 =A0 =A0st_flags;
> + =A0 =A0 =A0 /* st_flags that users can set */
> +#define UF_SETTABLE =A0 =A00x0000ffff
> +#define UF_NODUMP =A0 =A0 =A00x00000001 =A0 =A0 =A0/* do not dump */
> +#define UF_IMMUTABLE =A0 0x00000002 =A0 =A0 =A0/* immutable */
> +#define UF_APPEND =A0 =A0 =A00x00000004 =A0 =A0 =A0/* append-only */
> +#define UF_OPAQUE =A0 =A0 =A00x00000008 =A0 =A0 =A0/* directory is opaqu=
e (unionfs) */
> +#define UF_NOUNLINK =A0 =A00x00000010 =A0 =A0 =A0/* can't be removed or =
renamed */
> +#define UF_COMPRESSED =A00x00000020 =A0 =A0 =A0/* file is compressed */
> +#define UF_HIDDEN =A0 =A0 =A00x00008000 =A0 =A0 =A0/* file shouldn't be =
displayed in a GUI */
> +
> + =A0 =A0 =A0 /* st_flags that only root can set */
> +#define SF_SETTABLE =A0 =A00xffff0000
> +#define SF_ARCHIVED =A0 =A00x00010000 =A0 =A0 =A0/* archived */
> +#define SF_IMMUTABLE =A0 0x00020000 =A0 =A0 =A0/* immutable */
> +#define SF_APPEND =A0 =A0 =A00x00040000 =A0 =A0 =A0/* append-only */
> +#define SF_NOUNLINK =A0 =A00x00100000 =A0 =A0 =A0/* can't be removed or =
renamed */
> +#define SF_SNAPSHOT =A0 =A00x00200000 =A0 =A0 =A0/* snapshot inode */
> +
> + =A0 =A0 =A0 /* Linux-specific st_flags */
> +#define XSTAT_LF_MAGIC_FILE =A0 =A0(1ULL << 32) =A0 =A0/* magic file, su=
ch as /proc/? and /sys/? */
> +#define XSTAT_LF_SYNC =A0 =A0 =A0 =A0 =A0(1ULL << 33) =A0 =A0/* file is =
written synchronously */
> +#define XSTAT_LF_NOATIME =A0 =A0 =A0 (1ULL << 34) =A0 =A0/* atime is not=
 updated on file */
> +#define XSTAT_LF_JOURNALLED_DATA (1ULL << 35) =A0/* data modifications t=
o file are journalled */
> +#define XSTAT_LF_ENCRYPTED =A0 =A0 (1ULL << 36) =A0 =A0/* file is encryp=
ted */
> +#define XSTAT_LF_SYSTEM =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(1ULL << 37) =A0 =
=A0/* system file */
> +#define XSTAT_LF_TEMPORARY =A0 =A0 (1ULL << 38) =A0 =A0/* temporary file=
 */
> +#define XSTAT_LF_OFFLINE =A0 =A0 =A0 (1ULL << 39) =A0 =A0/* file is curr=
ently unavailable */
> +
> + =A0 =A0 =A0 /* Which st_flags are actually supported by this filesystem=
 for this
> + =A0 =A0 =A0 =A0* file */
> + =A0 =A0 =A0 unsigned long long =A0 =A0 =A0st_supported_flags;
> +};
> +#define XSTAT_LENGTH_INODE_FLAGS (sizeof(struct xstat_inode_flags))
> +
> +
> =A0#ifdef __KERNEL__
> =A0#define S_IRWXUGO =A0 =A0 =A0(S_IRWXU|S_IRWXG|S_IRWXO)
> =A0#define S_IALLUGO =A0 =A0 =A0(S_ISUID|S_ISGID|S_ISVTX|S_IRWXUGO)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
