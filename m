From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] afs: Add metadata xattrs
Date: Thu, 6 Jul 2017 08:23:04 -0700
Message-ID: <20170706152304.GA10584@infradead.org>
References: <149935261019.29744.8564287571048506851.stgit@warthog.procyon.org.uk>
 <149935262759.29744.6299062653432480230.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <149935262759.29744.6299062653432480230.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

NAK.  Don't overload xattrs with magic behavior just to avoid the need
to do proper syscalls or ioctls.  This makes them harder to discover,
audit and security fix.

On Thu, Jul 06, 2017 at 03:50:27PM +0100, David Howells wrote:
> Add xattrs to allow the user to get/set metadata in lieu of having pioctl()
> available.  The following xattrs are now available:
> 
>  (*) afs.cell
> 
>      The name of the cell in which the vnode's volume resides.
> 
>  (*) afs.fid
> 
>      The volume ID, vnode ID and vnode uniquifier of the file as three hex
>      numbers separated by colons.
> 
>  (*) afs.volume
> 
>      The name of the volume in which the vnode resides.
> 
> For example:
> 
> 	# getfattr -d -m ".*" /mnt/scratch
> 	getfattr: Removing leading '/' from absolute path names
> 	# file: mnt/scratch
> 	afs.cell="mycell.myorg.org"
> 	afs.fid="10000b:1:1"
> 	afs.volume="scratch"
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/afs/Makefile   |    3 +
>  fs/afs/dir.c      |    1 
>  fs/afs/file.c     |    1 
>  fs/afs/inode.c    |    7 +++
>  fs/afs/internal.h |    5 ++
>  fs/afs/mntpt.c    |    1 
>  fs/afs/super.c    |    1 
>  fs/afs/xattr.c    |  121 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  8 files changed, 138 insertions(+), 2 deletions(-)
>  create mode 100644 fs/afs/xattr.c
> 
> diff --git a/fs/afs/Makefile b/fs/afs/Makefile
> index 4f64b95d57bd..095c54165dfd 100644
> --- a/fs/afs/Makefile
> +++ b/fs/afs/Makefile
> @@ -27,6 +27,7 @@ kafs-objs := \
>  	vlocation.o \
>  	vnode.o \
>  	volume.o \
> -	write.o
> +	write.o \
> +	xattr.o
>  
>  obj-$(CONFIG_AFS_FS)  := kafs.o
> diff --git a/fs/afs/dir.c b/fs/afs/dir.c
> index 949f960337f5..613a77058263 100644
> --- a/fs/afs/dir.c
> +++ b/fs/afs/dir.c
> @@ -61,6 +61,7 @@ const struct inode_operations afs_dir_inode_operations = {
>  	.permission	= afs_permission,
>  	.getattr	= afs_getattr,
>  	.setattr	= afs_setattr,
> +	.listxattr	= afs_listxattr,
>  };
>  
>  const struct dentry_operations afs_fs_dentry_operations = {
> diff --git a/fs/afs/file.c b/fs/afs/file.c
> index 0d5b8508869b..510cba15fa56 100644
> --- a/fs/afs/file.c
> +++ b/fs/afs/file.c
> @@ -46,6 +46,7 @@ const struct inode_operations afs_file_inode_operations = {
>  	.getattr	= afs_getattr,
>  	.setattr	= afs_setattr,
>  	.permission	= afs_permission,
> +	.listxattr	= afs_listxattr,
>  };
>  
>  const struct address_space_operations afs_fs_aops = {
> diff --git a/fs/afs/inode.c b/fs/afs/inode.c
> index aae55dd15108..342316a9e3e0 100644
> --- a/fs/afs/inode.c
> +++ b/fs/afs/inode.c
> @@ -28,6 +28,11 @@ struct afs_iget_data {
>  	struct afs_volume	*volume;	/* volume on which resides */
>  };
>  
> +static const struct inode_operations afs_symlink_inode_operations = {
> +	.get_link	= page_get_link,
> +	.listxattr	= afs_listxattr,
> +};
> +
>  /*
>   * map the AFS file status to the inode member variables
>   */
> @@ -67,7 +72,7 @@ static int afs_inode_map_status(struct afs_vnode *vnode, struct key *key)
>  			inode->i_fop	= &afs_mntpt_file_operations;
>  		} else {
>  			inode->i_mode	= S_IFLNK | vnode->status.mode;
> -			inode->i_op	= &page_symlink_inode_operations;
> +			inode->i_op	= &afs_symlink_inode_operations;
>  		}
>  		inode_nohighmem(inode);
>  		break;
> diff --git a/fs/afs/internal.h b/fs/afs/internal.h
> index 4e2556606623..82e16556afea 100644
> --- a/fs/afs/internal.h
> +++ b/fs/afs/internal.h
> @@ -731,6 +731,11 @@ extern int afs_writeback_all(struct afs_vnode *);
>  extern int afs_flush(struct file *, fl_owner_t);
>  extern int afs_fsync(struct file *, loff_t, loff_t, int);
>  
> +/*
> + * xattr.c
> + */
> +extern const struct xattr_handler *afs_xattr_handlers[];
> +extern ssize_t afs_listxattr(struct dentry *, char *, size_t);
>  
>  /*****************************************************************************/
>  /*
> diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
> index bd3b65cde282..690fea9d84c3 100644
> --- a/fs/afs/mntpt.c
> +++ b/fs/afs/mntpt.c
> @@ -35,6 +35,7 @@ const struct inode_operations afs_mntpt_inode_operations = {
>  	.lookup		= afs_mntpt_lookup,
>  	.readlink	= page_readlink,
>  	.getattr	= afs_getattr,
> +	.listxattr	= afs_listxattr,
>  };
>  
>  const struct inode_operations afs_autocell_inode_operations = {
> diff --git a/fs/afs/super.c b/fs/afs/super.c
> index c79633e5cfd8..67680c2d96cf 100644
> --- a/fs/afs/super.c
> +++ b/fs/afs/super.c
> @@ -319,6 +319,7 @@ static int afs_fill_super(struct super_block *sb,
>  	sb->s_blocksize_bits	= PAGE_SHIFT;
>  	sb->s_magic		= AFS_FS_MAGIC;
>  	sb->s_op		= &afs_super_ops;
> +	sb->s_xattr		= afs_xattr_handlers;
>  	ret = super_setup_bdi(sb);
>  	if (ret)
>  		return ret;
> diff --git a/fs/afs/xattr.c b/fs/afs/xattr.c
> new file mode 100644
> index 000000000000..2830e4f48d85
> --- /dev/null
> +++ b/fs/afs/xattr.c
> @@ -0,0 +1,121 @@
> +/* Extended attribute handling for AFS.  We use xattrs to get and set metadata
> + * instead of providing pioctl().
> + *
> + * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/fs.h>
> +#include <linux/xattr.h>
> +#include "internal.h"
> +
> +static const char afs_xattr_list[] =
> +	"afs.cell\0"
> +	"afs.fid\0"
> +	"afs.volume";
> +
> +/*
> + * Retrieve a list of the supported xattrs.
> + */
> +ssize_t afs_listxattr(struct dentry *dentry, char *buffer, size_t size)
> +{
> +	if (size == 0)
> +		return sizeof(afs_xattr_list);
> +	if (size < sizeof(afs_xattr_list))
> +		return -ERANGE;
> +	memcpy(buffer, afs_xattr_list, sizeof(afs_xattr_list));
> +	return sizeof(afs_xattr_list);
> +}
> +
> +/*
> + * Get the name of the cell on which a file resides.
> + */
> +static int afs_xattr_get_cell(const struct xattr_handler *handler,
> +			      struct dentry *dentry,
> +			      struct inode *inode, const char *name,
> +			      void *buffer, size_t size)
> +{
> +	struct afs_vnode *vnode = AFS_FS_I(inode);
> +	struct afs_cell *cell = vnode->volume->cell;
> +	size_t namelen;
> +
> +	namelen = strlen(cell->name);
> +	if (size == 0)
> +		return namelen;
> +	if (namelen > size)
> +		return -ERANGE;
> +	memcpy(buffer, cell->name, size);
> +	return namelen;
> +}
> +
> +static const struct xattr_handler afs_xattr_afs_cell_handler = {
> +	.name	= "afs.cell",
> +	.get	= afs_xattr_get_cell,
> +};
> +
> +/*
> + * Get the volume ID, vnode ID and vnode uniquifier of a file as a sequence of
> + * hex numbers separated by colons.
> + */
> +static int afs_xattr_get_fid(const struct xattr_handler *handler,
> +			     struct dentry *dentry,
> +			     struct inode *inode, const char *name,
> +			     void *buffer, size_t size)
> +{
> +	struct afs_vnode *vnode = AFS_FS_I(inode);
> +	char text[8 + 1 + 8 + 1 + 8 + 1];
> +	size_t len;
> +
> +	len = sprintf(text, "%x:%x:%x",
> +		      vnode->fid.vid, vnode->fid.vnode, vnode->fid.unique);
> +	if (size == 0)
> +		return len;
> +	if (len > size)
> +		return -ERANGE;
> +	memcpy(buffer, text, len);
> +	return len;
> +}
> +
> +static const struct xattr_handler afs_xattr_afs_fid_handler = {
> +	.name	= "afs.fid",
> +	.get	= afs_xattr_get_fid,
> +};
> +
> +/*
> + * Get the name of the volume on which a file resides.
> + */
> +static int afs_xattr_get_volume(const struct xattr_handler *handler,
> +			      struct dentry *dentry,
> +			      struct inode *inode, const char *name,
> +			      void *buffer, size_t size)
> +{
> +	struct afs_vnode *vnode = AFS_FS_I(inode);
> +	const char *volname = vnode->volume->vlocation->vldb.name;
> +	size_t namelen;
> +
> +	namelen = strlen(volname);
> +	if (size == 0)
> +		return namelen;
> +	if (namelen > size)
> +		return -ERANGE;
> +	memcpy(buffer, volname, size);
> +	return namelen;
> +}
> +
> +static const struct xattr_handler afs_xattr_afs_volume_handler = {
> +	.name	= "afs.volume",
> +	.get	= afs_xattr_get_volume,
> +};
> +
> +const struct xattr_handler *afs_xattr_handlers[] = {
> +	&afs_xattr_afs_cell_handler,
> +	&afs_xattr_afs_fid_handler,
> +	&afs_xattr_afs_volume_handler,
> +	NULL
> +};
> 
> 
> _______________________________________________
> linux-afs mailing list
> http://lists.infradead.org/mailman/listinfo/linux-afs
---end quoted text---
