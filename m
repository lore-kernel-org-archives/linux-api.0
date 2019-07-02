From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 01/11] vfs: syscall: Add fsinfo() to query filesystem
 information [ver #15]
Date: Tue, 2 Jul 2019 15:02:04 +0200
Message-ID: <20190702130203.rz5mlnsvabvvenpk@brauner.io>
References: <156173661696.14042.17822154531324224780.stgit@warthog.procyon.org.uk>
 <156173662509.14042.3867242748127323502.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <156173662509.14042.3867242748127323502.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, raven@themaw.net, mszeredi@redhat.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jun 28, 2019 at 04:43:45PM +0100, David Howells wrote:
> Add a system call to allow filesystem information to be queried.  A request
> value can be given to indicate the desired attribute.  Support is provided
> for enumerating multi-value attributes.
> 
> ===============
> NEW SYSTEM CALL
> ===============
> 
> The new system call looks like:
> 
> 	int ret = fsinfo(int dfd,
> 			 const char *filename,
> 			 const struct fsinfo_params *params,
> 			 void *buffer,
> 			 size_t buf_size);
> 
> The params parameter optionally points to a block of parameters:
> 
> 	struct fsinfo_params {
> 		__u32	at_flags;
> 		__u32	request;
> 		__u32	Nth;
> 		__u32	Mth;
> 		__u64	__reserved[3];
> 	};
> 
> If params is NULL, it is assumed params->request should be
> fsinfo_attr_statfs, params->Nth should be 0, params->Mth should be 0 and
> params->at_flags should be 0.
> 
> If params is given, all of params->__reserved[] must be 0.
> 
> dfd, filename and params->at_flags indicate the file to query.  There is no
> equivalent of lstat() as that can be emulated with fsinfo() by setting
> AT_SYMLINK_NOFOLLOW in params->at_flags.  There is also no equivalent of
> fstat() as that can be emulated by passing a NULL filename to fsinfo() with
> the fd of interest in dfd.  AT_NO_AUTOMOUNT can also be used to an allow
> automount point to be queried without triggering it.
> 
> params->request indicates the attribute/attributes to be queried.  This can
> be one of:
> 
> 	FSINFO_ATTR_STATFS		- statfs-style info
> 	FSINFO_ATTR_FSINFO		- Information about fsinfo()
> 	FSINFO_ATTR_IDS			- Filesystem IDs
> 	FSINFO_ATTR_LIMITS		- Filesystem limits
> 	FSINFO_ATTR_SUPPORTS		- What's supported in statx(), IOC flags
> 	FSINFO_ATTR_CAPABILITIES	- Filesystem capabilities
> 	FSINFO_ATTR_TIMESTAMP_INFO	- Inode timestamp info
> 	FSINFO_ATTR_VOLUME_ID		- Volume ID (string)
> 	FSINFO_ATTR_VOLUME_UUID		- Volume UUID
> 	FSINFO_ATTR_VOLUME_NAME		- Volume name (string)
> 	FSINFO_ATTR_NAME_ENCODING	- Filename encoding (string)
> 	FSINFO_ATTR_NAME_CODEPAGE	- Filename codepage (string)
> 
> Some attributes (such as the servers backing a network filesystem) can have
> multiple values.  These can be enumerated by setting params->Nth and
> params->Mth to 0, 1, ... until ENODATA is returned.
> 
> buffer and buf_size point to the reply buffer.  The buffer is filled up to
> the specified size, even if this means truncating the reply.  The full size
> of the reply is returned.  In future versions, this will allow extra fields
> to be tacked on to the end of the reply, but anyone not expecting them will
> only get the subset they're expecting.  If either buffer of buf_size are 0,
> no copy will take place and the data size will be returned.
> 
> At the moment, this will only work on x86_64 and i386 as it requires the
> system call to be wired up.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: linux-api@vger.kernel.org
> ---
> 
>  arch/x86/entry/syscalls/syscall_32.tbl |    1 
>  arch/x86/entry/syscalls/syscall_64.tbl |    1 
>  fs/Kconfig                             |    7 
>  fs/Makefile                            |    1 
>  fs/fsinfo.c                            |  545 ++++++++++++++++++++++++++++++++
>  include/linux/fs.h                     |    5 
>  include/linux/fsinfo.h                 |   65 ++++
>  include/linux/syscalls.h               |    4 
>  include/uapi/asm-generic/unistd.h      |    4 
>  include/uapi/linux/fsinfo.h            |  219 +++++++++++++
>  kernel/sys_ni.c                        |    1 
>  samples/vfs/Makefile                   |    4 
>  samples/vfs/test-fsinfo.c              |  551 ++++++++++++++++++++++++++++++++
>  13 files changed, 1407 insertions(+), 1 deletion(-)
>  create mode 100644 fs/fsinfo.c
>  create mode 100644 include/linux/fsinfo.h
>  create mode 100644 include/uapi/linux/fsinfo.h
>  create mode 100644 samples/vfs/test-fsinfo.c
> 
> diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
> index ad968b7bac72..03decae51513 100644
> --- a/arch/x86/entry/syscalls/syscall_32.tbl
> +++ b/arch/x86/entry/syscalls/syscall_32.tbl
> @@ -438,3 +438,4 @@
>  431	i386	fsconfig		sys_fsconfig			__ia32_sys_fsconfig
>  432	i386	fsmount			sys_fsmount			__ia32_sys_fsmount
>  433	i386	fspick			sys_fspick			__ia32_sys_fspick
> +434	i386	fsinfo			sys_fsinfo			__ia32_sys_fsinfo
> diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
> index b4e6f9e6204a..ea63df9a1020 100644
> --- a/arch/x86/entry/syscalls/syscall_64.tbl
> +++ b/arch/x86/entry/syscalls/syscall_64.tbl
> @@ -355,6 +355,7 @@
>  431	common	fsconfig		__x64_sys_fsconfig
>  432	common	fsmount			__x64_sys_fsmount
>  433	common	fspick			__x64_sys_fspick
> +434	common	fsinfo			__x64_sys_fsinfo
>  
>  #
>  # x32-specific system call numbers start at 512 to avoid cache impact
> diff --git a/fs/Kconfig b/fs/Kconfig
> index cbbffc8b9ef5..9e7d2f2c0111 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -15,6 +15,13 @@ config VALIDATE_FS_PARSER
>  	  Enable this to perform validation of the parameter description for a
>  	  filesystem when it is registered.
>  
> +config FSINFO
> +	bool "Enable the fsinfo() system call"
> +	help
> +	  Enable the file system information querying system call to allow
> +	  comprehensive information to be retrieved about a filesystem,
> +	  superblock or mount object.
> +
>  if BLOCK
>  
>  config FS_IOMAP
> diff --git a/fs/Makefile b/fs/Makefile
> index c9aea23aba56..26eaeae4b9a1 100644
> --- a/fs/Makefile
> +++ b/fs/Makefile
> @@ -53,6 +53,7 @@ obj-$(CONFIG_SYSCTL)		+= drop_caches.o
>  
>  obj-$(CONFIG_FHANDLE)		+= fhandle.o
>  obj-$(CONFIG_FS_IOMAP)		+= iomap.o
> +obj-$(CONFIG_FSINFO)		+= fsinfo.o
>  
>  obj-y				+= quota/
>  
> diff --git a/fs/fsinfo.c b/fs/fsinfo.c
> new file mode 100644
> index 000000000000..09e743b16235
> --- /dev/null
> +++ b/fs/fsinfo.c
> @@ -0,0 +1,545 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Filesystem information query.
> + *
> + * Copyright (C) 2019 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + */
> +#include <linux/syscalls.h>
> +#include <linux/fs.h>
> +#include <linux/file.h>
> +#include <linux/mount.h>
> +#include <linux/namei.h>
> +#include <linux/statfs.h>
> +#include <linux/security.h>
> +#include <linux/uaccess.h>
> +#include <linux/fsinfo.h>
> +#include <uapi/linux/mount.h>
> +#include "internal.h"
> +
> +static u32 calc_mount_attrs(u32 mnt_flags)

I totally forgot to mention this:
I had a patchset that extended statfs to also report back when a
mountpoint is shared, slave, private, or unbindable to avoid parsing
/proc/1/mountinfo which is unreliable and slow. I've given a lengthier
argument in the patchset I sent more than a year ago:
https://lkml.org/lkml/2018/5/25/397

Pretty please, make it possible to retrieve propagation attributes with
fsinfo(). We desperately need this and it's trivial to add imho.

> +{
> +	u32 attrs = 0;
> +
> +	if (mnt_flags & MNT_READONLY)
> +		attrs |= MOUNT_ATTR_RDONLY;
> +	if (mnt_flags & MNT_NOSUID)
> +		attrs |= MOUNT_ATTR_NOSUID;
> +	if (mnt_flags & MNT_NODEV)
> +		attrs |= MOUNT_ATTR_NODEV;
> +	if (mnt_flags & MNT_NOEXEC)
> +		attrs |= MOUNT_ATTR_NOEXEC;
> +	if (mnt_flags & MNT_NODIRATIME)
> +		attrs |= MOUNT_ATTR_NODIRATIME;
> +
> +	if (mnt_flags & MNT_NOATIME)
> +		attrs |= MOUNT_ATTR_NOATIME;
> +	else if (mnt_flags & MNT_RELATIME)
> +		attrs |= MOUNT_ATTR_RELATIME;
> +	else
> +		attrs |= MOUNT_ATTR_STRICTATIME;
> +	return attrs;
> +}
