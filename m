From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 34/38] vfs: syscall: Add fsinfo() to query filesystem
 information [ver #10]
Date: Tue, 31 Jul 2018 16:49:09 -0700
Message-ID: <20180731234909.GA4206@magnolia>
References: <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk>
 <153271291017.9458.7827028432894772673.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <153271291017.9458.7827028432894772673.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-api@vger.kernel.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 27, 2018 at 06:35:10PM +0100, David Howells wrote:
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
> 		__u32	__reserved[6];
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
> 	fsinfo_attr_statfs		- statfs-style info
> 	fsinfo_attr_fsinfo		- Information about fsinfo()
> 	fsinfo_attr_ids			- Filesystem IDs
> 	fsinfo_attr_limits		- Filesystem limits
> 	fsinfo_attr_supports		- What's supported in statx(), IOC flags
> 	fsinfo_attr_capabilities	- Filesystem capabilities
> 	fsinfo_attr_timestamp_info	- Inode timestamp info
> 	fsinfo_attr_volume_id		- Volume ID (string)
> 	fsinfo_attr_volume_uuid		- Volume UUID
> 	fsinfo_attr_volume_name		- Volume name (string)
> 	fsinfo_attr_cell_name		- Cell name (string)
> 	fsinfo_attr_domain_name		- Domain name (string)
> 	fsinfo_attr_realm_name		- Realm name (string)
> 	fsinfo_attr_server_name		- Name of the Nth server (string)
> 	fsinfo_attr_server_address	- Mth address of the Nth server
> 	fsinfo_attr_parameter		- Nth mount parameter (string)
> 	fsinfo_attr_source		- Nth mount source name (string)
> 	fsinfo_attr_name_encoding	- Filename encoding (string)
> 	fsinfo_attr_name_codepage	- Filename codepage (string)
> 	fsinfo_attr_io_size		- I/O size hints
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

<snip> I only have time today to review the user interface bits...

> diff --git a/include/uapi/linux/fsinfo.h b/include/uapi/linux/fsinfo.h
> new file mode 100644
> index 000000000000..abcf414dd3be
> --- /dev/null
> +++ b/include/uapi/linux/fsinfo.h
> @@ -0,0 +1,234 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/* fsinfo() definitions.
> + *
> + * Copyright (C) 2018 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + */
> +#ifndef _UAPI_LINUX_FSINFO_H
> +#define _UAPI_LINUX_FSINFO_H
> +
> +#include <linux/types.h>
> +#include <linux/socket.h>
> +
> +/*
> + * The filesystem attributes that can be requested.  Note that some attributes
> + * may have multiple instances which can be switched in the parameter block.
> + */
> +enum fsinfo_attribute {
> +	fsinfo_attr_statfs		= 0,	/* statfs()-style state */
> +	fsinfo_attr_fsinfo		= 1,	/* Information about fsinfo() */
> +	fsinfo_attr_ids			= 2,	/* Filesystem IDs */
> +	fsinfo_attr_limits		= 3,	/* Filesystem limits */
> +	fsinfo_attr_supports		= 4,	/* What's supported in statx, iocflags, ... */
> +	fsinfo_attr_capabilities	= 5,	/* Filesystem capabilities (bits) */
> +	fsinfo_attr_timestamp_info	= 6,	/* Inode timestamp info */
> +	fsinfo_attr_volume_id		= 7,	/* Volume ID (string) */
> +	fsinfo_attr_volume_uuid		= 8,	/* Volume UUID (LE uuid) */
> +	fsinfo_attr_volume_name		= 9,	/* Volume name (string) */

What's the difference between a volume name and a volume string?

XFS has a uuid and a label that can be set by userspace (sort of);
should we return the label for volume_id and volume_name?

Hmmm, I see that the default implementations set volume_id from s_id,
and s_id (for block device filesystems anyway) tends to be the device, I
guess?

So if blkid told me that:
/dev/sda1: LABEL="music" UUID="8d9e5b1e-a094-49e5-a179-6d94f7fd8399" TYPE="xfs"

volume_id == sda1, volume_uuid == 8d9e5b1e-a094-49e5-a179-6d94f7fd8399,
and volume_name == "music" ?

> +	fsinfo_attr_cell_name		= 10,	/* Cell name (string) */
> +	fsinfo_attr_domain_name		= 11,	/* Domain name (string) */
> +	fsinfo_attr_realm_name		= 12,	/* Realm name (string) */
> +	fsinfo_attr_server_name		= 13,	/* Name of the Nth server */
> +	fsinfo_attr_server_address	= 14,	/* Mth address of the Nth server */
> +	fsinfo_attr_parameter		= 15,	/* Nth mount parameter (string) */
> +	fsinfo_attr_source		= 16,	/* Nth mount source name (string) */

Hmm, so I guess external log devices and realtime device(s) go here?

> +	fsinfo_attr_name_encoding	= 17,	/* Filename encoding (string) */
> +	fsinfo_attr_name_codepage	= 18,	/* Filename codepage (string) */
> +	fsinfo_attr_io_size		= 19,	/* Optimal I/O sizes */

Are we tied to this enum forever, or do you plan to split up the number
space to allow filesystems to define their own attributes without having
to add them here?

For example, say you let the upper 8 bits be some sort of per-fs code
(like how _IO{,R,W} work) and the lower 24 bits can be the subcommand.
0x00 would be the generic space; XFS could (say) reserve 0x58000000 -
0x58ffffff for XFS (0x58 is the prefix code used for xfs ioctls).  If
there ever are subdivisions of the number space it might be nice to have
fsinfo_fsinfo return prefix number of the fs-specific subcommands, and
how many fs-specific subcommands there are.

I mean, I guess each fs' ->fsinfo function can do that privately but I
suggest having some mechanism in mind to handle these things.  XFS's
geometry ioctl structure is nearly out of space and (some day soon) we
will have to expand and maybe we can use fsinfo instead.

> +	fsinfo_attr__nr
> +};
> +
> +/*
> + * Optional fsinfo() parameter structure.
> + *
> + * If this is not given, it is assumed that fsinfo_attr_statfs instance 0,0 is
> + * desired.
> + */
> +struct fsinfo_params {
> +	__u32	at_flags;	/* AT_SYMLINK_NOFOLLOW and similar flags */
> +	__u32	request;	/* What is being asking for (enum fsinfo_attribute) */
> +	__u32	Nth;		/* Instance of it (some may have multiple) */
> +	__u32	Mth;		/* Subinstance of Nth instance */
> +	__u32	__reserved[6];	/* Reserved params; all must be 0 */
> +};
> +
> +/*
> + * Information struct for fsinfo(fsinfo_attr_statfs).
> + * - This gives extended filesystem information.
> + */
> +struct fsinfo_statfs {
> +	__u64	f_blocks;	/* Total number of blocks in fs */
> +	__u64	f_bfree;	/* Total number of free blocks */
> +	__u64	f_bavail;	/* Number of free blocks available to ordinary user */
> +	__u64	f_files;	/* Total number of file nodes in fs */
> +	__u64	f_ffree;	/* Number of free file nodes */
> +	__u64	f_favail;	/* Number of free file nodes available to ordinary user */
> +	__u32	f_bsize;	/* Optimal block size */
> +	__u32	f_frsize;	/* Fragment size */
> +};
> +
> +/*
> + * Information struct for fsinfo(fsinfo_attr_ids).
> + *
> + * List of basic identifiers as is normally found in statfs().
> + */
> +struct fsinfo_ids {
> +	char	f_fs_name[15 + 1];
> +	__u64	f_flags;	/* Filesystem mount flags (MS_*) */
> +	__u64	f_fsid;		/* Short 64-bit Filesystem ID (as statfs) */
> +	__u64	f_sb_id;	/* Internal superblock ID for sbnotify()/mntnotify() */
> +	__u32	f_fstype;	/* Filesystem type from linux/magic.h [uncond] */
> +	__u32	f_dev_major;	/* As st_dev_* from struct statx [uncond] */
> +	__u32	f_dev_minor;
> +};

This structure doesn't end on a 64-bit boundary and may cause padding
problems...

> +
> +/*
> + * Information struct for fsinfo(fsinfo_attr_limits).
> + *
> + * List of supported filesystem limits.
> + */
> +struct fsinfo_limits {
> +	__u64	max_file_size;			/* Maximum file size */
> +	__u64	max_uid;			/* Maximum UID supported */
> +	__u64	max_gid;			/* Maximum GID supported */
> +	__u64	max_projid;			/* Maximum project ID supported */
> +	__u32	max_dev_major;			/* Maximum device major representable */
> +	__u32	max_dev_minor;			/* Maximum device minor representable */
> +	__u32	max_hard_links;			/* Maximum number of hard links on a file */
> +	__u32	max_xattr_body_len;		/* Maximum xattr content length */
> +	__u32	max_xattr_name_len;		/* Maximum xattr name length */
> +	__u32	max_filename_len;		/* Maximum filename length */
> +	__u32	max_symlink_len;		/* Maximum symlink content length */
> +	__u32	__reserved[1];

Maximum inode number possible, for filesystems that can allocate inodes
dynamically?

Granted, XFS will probably only ever advertise "0xffffffffffffffff"...

> +};
> +
> +/*
> + * Information struct for fsinfo(fsinfo_attr_supports).
> + *
> + * What's supported in various masks, such as statx() attribute and mask bits
> + * and IOC flags.
> + */
> +struct fsinfo_supports {
> +	__u64	stx_attributes;		/* What statx::stx_attributes are supported */
> +	__u32	stx_mask;		/* What statx::stx_mask bits are supported */
> +	__u32	ioc_flags;		/* What FS_IOC_* flags are supported */
> +	__u32	win_file_attrs;		/* What DOS/Windows FILE_* attributes are supported */
> +	__u32	__reserved[1];
> +};
> +
> +/*
> + * Information struct for fsinfo(fsinfo_attr_capabilities).
> + *
> + * Bitmask indicating filesystem capabilities where renderable as single bits.
> + */
> +enum fsinfo_capability {
> +	fsinfo_cap_is_kernel_fs		= 0,	/* fs is kernel-special filesystem */
> +	fsinfo_cap_is_block_fs		= 1,	/* fs is block-based filesystem */
> +	fsinfo_cap_is_flash_fs		= 2,	/* fs is flash filesystem */
> +	fsinfo_cap_is_network_fs	= 3,	/* fs is network filesystem */
> +	fsinfo_cap_is_automounter_fs	= 4,	/* fs is automounter special filesystem */
> +	fsinfo_cap_automounts		= 5,	/* fs supports automounts */
> +	fsinfo_cap_adv_locks		= 6,	/* fs supports advisory file locking */
> +	fsinfo_cap_mand_locks		= 7,	/* fs supports mandatory file locking */
> +	fsinfo_cap_leases		= 8,	/* fs supports file leases */
> +	fsinfo_cap_uids			= 9,	/* fs supports numeric uids */
> +	fsinfo_cap_gids			= 10,	/* fs supports numeric gids */
> +	fsinfo_cap_projids		= 11,	/* fs supports numeric project ids */
> +	fsinfo_cap_id_names		= 12,	/* fs supports user names */
> +	fsinfo_cap_id_guids		= 13,	/* fs supports user guids */
> +	fsinfo_cap_windows_attrs	= 14,	/* fs has windows attributes */
> +	fsinfo_cap_user_quotas		= 15,	/* fs has per-user quotas */
> +	fsinfo_cap_group_quotas		= 16,	/* fs has per-group quotas */
> +	fsinfo_cap_project_quotas	= 17,	/* fs has per-project quotas */
> +	fsinfo_cap_xattrs		= 18,	/* fs has xattrs */
> +	fsinfo_cap_journal		= 19,	/* fs has a journal */
> +	fsinfo_cap_data_is_journalled	= 20,	/* fs is using data journalling */
> +	fsinfo_cap_o_sync		= 21,	/* fs supports O_SYNC */
> +	fsinfo_cap_o_direct		= 22,	/* fs supports O_DIRECT */
> +	fsinfo_cap_volume_id		= 23,	/* fs has a volume ID */
> +	fsinfo_cap_volume_uuid		= 24,	/* fs has a volume UUID */
> +	fsinfo_cap_volume_name		= 25,	/* fs has a volume name */
> +	fsinfo_cap_volume_fsid		= 26,	/* fs has a volume FSID */
> +	fsinfo_cap_cell_name		= 27,	/* fs has a cell name */
> +	fsinfo_cap_domain_name		= 28,	/* fs has a domain name */
> +	fsinfo_cap_realm_name		= 29,	/* fs has a realm name */
> +	fsinfo_cap_iver_all_change	= 30,	/* i_version represents data + meta changes */
> +	fsinfo_cap_iver_data_change	= 31,	/* i_version represents data changes only */
> +	fsinfo_cap_iver_mono_incr	= 32,	/* i_version incremented monotonically */
> +	fsinfo_cap_symlinks		= 33,	/* fs supports symlinks */
> +	fsinfo_cap_hard_links		= 34,	/* fs supports hard links */
> +	fsinfo_cap_hard_links_1dir	= 35,	/* fs supports hard links in same dir only */
> +	fsinfo_cap_device_files		= 36,	/* fs supports bdev, cdev */
> +	fsinfo_cap_unix_specials	= 37,	/* fs supports pipe, fifo, socket */
> +	fsinfo_cap_resource_forks	= 38,	/* fs supports resource forks/streams */
> +	fsinfo_cap_name_case_indep	= 39,	/* Filename case independence is mandatory */
> +	fsinfo_cap_name_non_utf8	= 40,	/* fs has non-utf8 names */
> +	fsinfo_cap_name_has_codepage	= 41,	/* fs has a filename codepage */
> +	fsinfo_cap_sparse		= 42,	/* fs supports sparse files */
> +	fsinfo_cap_not_persistent	= 43,	/* fs is not persistent */
> +	fsinfo_cap_no_unix_mode		= 44,	/* fs does not support unix mode bits */
> +	fsinfo_cap_has_atime		= 45,	/* fs supports access time */
> +	fsinfo_cap_has_btime		= 46,	/* fs supports birth/creation time */
> +	fsinfo_cap_has_ctime		= 47,	/* fs supports change time */
> +	fsinfo_cap_has_mtime		= 48,	/* fs supports modification time */
> +	fsinfo_cap__nr
> +};
> +
> +struct fsinfo_capabilities {
> +	__u8	capabilities[(fsinfo_cap__nr + 7) / 8];
> +};
> +
> +/*
> + * Information struct for fsinfo(fsinfo_attr_timestamp_info).
> + */
> +struct fsinfo_timestamp_info {
> +	__s64	minimum_timestamp;	/* Minimum timestamp value in seconds */
> +	__s64	maximum_timestamp;	/* Maximum timestamp value in seconds */
> +	__u16	atime_gran_mantissa;	/* Granularity(secs) = mant * 10^exp */
> +	__u16	btime_gran_mantissa;
> +	__u16	ctime_gran_mantissa;
> +	__u16	mtime_gran_mantissa;
> +	__s8	atime_gran_exponent;
> +	__s8	btime_gran_exponent;
> +	__s8	ctime_gran_exponent;
> +	__s8	mtime_gran_exponent;
> +	__u32	__reserved[1];
> +};
> +
> +/*
> + * Information struct for fsinfo(fsinfo_attr_volume_uuid).
> + */
> +struct fsinfo_volume_uuid {
> +	__u8	uuid[16];
> +};
> +
> +/*
> + * Information struct for fsinfo(fsinfo_attr_server_addresses).
> + *
> + * Find the Mth address of the Nth server for a network mount.
> + */
> +struct fsinfo_server_address {
> +	struct __kernel_sockaddr_storage address;
> +};
> +
> +/*
> + * Information struct for fsinfo(fsinfo_attr_io_size).
> + *
> + * Retrieve I/O size hints for a filesystem.
> + */
> +struct fsinfo_io_size {
> +	__u32		dio_size_gran;	/* Size granularity for O_DIRECT */
> +	__u32		dio_mem_align;	/* Memory alignment for O_DIRECT */

max io size too?

64-bit too, in case we ever get that insane?

--D

> +};
> +
> +/*
> + * Information struct for fsinfo(fsinfo_attr_fsinfo).
> + *
> + * This gives information about fsinfo() itself.
> + */
> +struct fsinfo_fsinfo {
> +	__u32	max_attr;	/* Number of supported attributes (fsinfo_attr__nr) */
> +	__u32	max_cap;	/* Number of supported capabilities (fsinfo_cap__nr) */
> +};
> +
> +#endif /* _UAPI_LINUX_FSINFO_H */
> diff --git a/samples/statx/Makefile b/samples/statx/Makefile
> index 59df7c25a9d1..9cb9a88e3a10 100644
> --- a/samples/statx/Makefile
> +++ b/samples/statx/Makefile
> @@ -1,7 +1,10 @@
>  # List of programs to build
> -hostprogs-$(CONFIG_SAMPLE_STATX) := test-statx
> +hostprogs-$(CONFIG_SAMPLE_STATX) := test-statx test-fsinfo
>  
>  # Tell kbuild to always build the programs
>  always := $(hostprogs-y)
>  
>  HOSTCFLAGS_test-statx.o += -I$(objtree)/usr/include
> +
> +HOSTCFLAGS_test-fsinfo.o += -I$(objtree)/usr/include
> +HOSTLOADLIBES_test-fsinfo += -lm
> diff --git a/samples/statx/test-fsinfo.c b/samples/statx/test-fsinfo.c
> new file mode 100644
> index 000000000000..deab0081ecd1
> --- /dev/null
> +++ b/samples/statx/test-fsinfo.c
> @@ -0,0 +1,539 @@
> +/* Test the fsinfo() system call
> + *
> + * Copyright (C) 2018 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +#define _GNU_SOURCE
> +#define _ATFILE_SOURCE
> +#include <stdbool.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <stdint.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <ctype.h>
> +#include <errno.h>
> +#include <time.h>
> +#include <math.h>
> +#include <fcntl.h>
> +#include <sys/syscall.h>
> +#include <linux/fsinfo.h>
> +#include <linux/socket.h>
> +#include <sys/stat.h>
> +
> +static __attribute__((unused))
> +ssize_t fsinfo(int dfd, const char *filename, struct fsinfo_params *params,
> +	       void *buffer, size_t buf_size)
> +{
> +	return syscall(__NR_fsinfo, dfd, filename, params, buffer, buf_size);
> +}
> +
> +#define FSINFO_STRING(N)	 [fsinfo_attr_##N] = 0x00
> +#define FSINFO_STRUCT(N)	 [fsinfo_attr_##N] = sizeof(struct fsinfo_##N)/sizeof(__u32)
> +#define FSINFO_STRING_N(N)	 [fsinfo_attr_##N] = 0x40
> +#define FSINFO_STRUCT_N(N)	 [fsinfo_attr_##N] = 0x40 | sizeof(struct fsinfo_##N)/sizeof(__u32)
> +#define FSINFO_STRUCT_NM(N)	 [fsinfo_attr_##N] = 0x80 | sizeof(struct fsinfo_##N)/sizeof(__u32)
> +static const __u8 fsinfo_buffer_sizes[fsinfo_attr__nr] = {
> +	FSINFO_STRUCT		(statfs),
> +	FSINFO_STRUCT		(fsinfo),
> +	FSINFO_STRUCT		(ids),
> +	FSINFO_STRUCT		(limits),
> +	FSINFO_STRUCT		(supports),
> +	FSINFO_STRUCT		(capabilities),
> +	FSINFO_STRUCT		(timestamp_info),
> +	FSINFO_STRING		(volume_id),
> +	FSINFO_STRUCT		(volume_uuid),
> +	FSINFO_STRING		(volume_name),
> +	FSINFO_STRING		(cell_name),
> +	FSINFO_STRING		(domain_name),
> +	FSINFO_STRING		(realm_name),
> +	FSINFO_STRING_N		(server_name),
> +	FSINFO_STRUCT_NM	(server_address),
> +	FSINFO_STRING_N		(parameter),
> +	FSINFO_STRING_N		(source),
> +	FSINFO_STRING		(name_encoding),
> +	FSINFO_STRING		(name_codepage),
> +	FSINFO_STRUCT		(io_size),
> +};
> +
> +#define FSINFO_NAME(N) [fsinfo_attr_##N] = #N
> +static const char *fsinfo_attr_names[fsinfo_attr__nr] = {
> +	FSINFO_NAME(statfs),
> +	FSINFO_NAME(fsinfo),
> +	FSINFO_NAME(ids),
> +	FSINFO_NAME(limits),
> +	FSINFO_NAME(supports),
> +	FSINFO_NAME(capabilities),
> +	FSINFO_NAME(timestamp_info),
> +	FSINFO_NAME(volume_id),
> +	FSINFO_NAME(volume_uuid),
> +	FSINFO_NAME(volume_name),
> +	FSINFO_NAME(cell_name),
> +	FSINFO_NAME(domain_name),
> +	FSINFO_NAME(realm_name),
> +	FSINFO_NAME(server_name),
> +	FSINFO_NAME(server_address),
> +	FSINFO_NAME(parameter),
> +	FSINFO_NAME(source),
> +	FSINFO_NAME(name_encoding),
> +	FSINFO_NAME(name_codepage),
> +	FSINFO_NAME(io_size),
> +};
> +
> +union reply {
> +	char buffer[4096];
> +	struct fsinfo_statfs statfs;
> +	struct fsinfo_fsinfo fsinfo;
> +	struct fsinfo_ids ids;
> +	struct fsinfo_limits limits;
> +	struct fsinfo_supports supports;
> +	struct fsinfo_capabilities caps;
> +	struct fsinfo_timestamp_info timestamps;
> +	struct fsinfo_volume_uuid uuid;
> +	struct fsinfo_server_address srv_addr;
> +	struct fsinfo_io_size io_size;
> +};
> +
> +static void dump_hex(unsigned int *data, int from, int to)
> +{
> +	unsigned offset, print_offset = 1, col = 0;
> +
> +	from /= 4;
> +	to = (to + 3) / 4;
> +
> +	for (offset = from; offset < to; offset++) {
> +		if (print_offset) {
> +			printf("%04x: ", offset * 8);
> +			print_offset = 0;
> +		}
> +		printf("%08x", data[offset]);
> +		col++;
> +		if ((col & 3) == 0) {
> +			printf("\n");
> +			print_offset = 1;
> +		} else {
> +			printf(" ");
> +		}
> +	}
> +
> +	if (!print_offset)
> +		printf("\n");
> +}
> +
> +static void dump_attr_statfs(union reply *r, int size)
> +{
> +	struct fsinfo_statfs *f = &r->statfs;
> +
> +	printf("\n");
> +	printf("\tblocks: n=%llu fr=%llu av=%llu\n",
> +	       (unsigned long long)f->f_blocks,
> +	       (unsigned long long)f->f_bfree,
> +	       (unsigned long long)f->f_bavail);
> +
> +	printf("\tfiles : n=%llu fr=%llu av=%llu\n",
> +	       (unsigned long long)f->f_files,
> +	       (unsigned long long)f->f_ffree,
> +	       (unsigned long long)f->f_favail);
> +	printf("\tbsize : %u\n", f->f_bsize);
> +	printf("\tfrsize: %u\n", f->f_frsize);
> +}
> +
> +static void dump_attr_fsinfo(union reply *r, int size)
> +{
> +	struct fsinfo_fsinfo *f = &r->fsinfo;
> +
> +	printf("max_attr=%u max_cap=%u\n", f->max_attr, f->max_cap);
> +}
> +
> +static void dump_attr_ids(union reply *r, int size)
> +{
> +	struct fsinfo_ids *f = &r->ids;
> +
> +	printf("\n");
> +	printf("\tdev   : %02x:%02x\n", f->f_dev_major, f->f_dev_minor);
> +	printf("\tfs    : type=%x name=%s\n", f->f_fstype, f->f_fs_name);
> +	printf("\tflags : %llx\n", (unsigned long long)f->f_flags);
> +	printf("\tfsid  : %llx\n", (unsigned long long)f->f_fsid);
> +}
> +
> +static void dump_attr_limits(union reply *r, int size)
> +{
> +	struct fsinfo_limits *f = &r->limits;
> +
> +	printf("\n");
> +	printf("\tmax file size: %llx\n", f->max_file_size);
> +	printf("\tmax ids      : u=%llx g=%llx p=%llx\n",
> +	       f->max_uid, f->max_gid, f->max_projid);
> +	printf("\tmax dev      : maj=%x min=%x\n",
> +	       f->max_dev_major, f->max_dev_minor);
> +	printf("\tmax links    : %x\n", f->max_hard_links);
> +	printf("\tmax xattr    : n=%x b=%x\n",
> +	       f->max_xattr_name_len, f->max_xattr_body_len);
> +	printf("\tmax len      : file=%x sym=%x\n",
> +	       f->max_filename_len, f->max_symlink_len);
> +}
> +
> +static void dump_attr_supports(union reply *r, int size)
> +{
> +	struct fsinfo_supports *f = &r->supports;
> +
> +	printf("\n");
> +	printf("\tstx_attr=%llx\n", f->stx_attributes);
> +	printf("\tstx_mask=%x\n", f->stx_mask);
> +	printf("\tioc_flags=%x\n", f->ioc_flags);
> +	printf("\twin_fattrs=%x\n", f->win_file_attrs);
> +}
> +
> +#define FSINFO_CAP_NAME(C) [fsinfo_cap_##C] = #C
> +static const char *fsinfo_cap_names[fsinfo_cap__nr] = {
> +	FSINFO_CAP_NAME(is_kernel_fs),
> +	FSINFO_CAP_NAME(is_block_fs),
> +	FSINFO_CAP_NAME(is_flash_fs),
> +	FSINFO_CAP_NAME(is_network_fs),
> +	FSINFO_CAP_NAME(is_automounter_fs),
> +	FSINFO_CAP_NAME(automounts),
> +	FSINFO_CAP_NAME(adv_locks),
> +	FSINFO_CAP_NAME(mand_locks),
> +	FSINFO_CAP_NAME(leases),
> +	FSINFO_CAP_NAME(uids),
> +	FSINFO_CAP_NAME(gids),
> +	FSINFO_CAP_NAME(projids),
> +	FSINFO_CAP_NAME(id_names),
> +	FSINFO_CAP_NAME(id_guids),
> +	FSINFO_CAP_NAME(windows_attrs),
> +	FSINFO_CAP_NAME(user_quotas),
> +	FSINFO_CAP_NAME(group_quotas),
> +	FSINFO_CAP_NAME(project_quotas),
> +	FSINFO_CAP_NAME(xattrs),
> +	FSINFO_CAP_NAME(journal),
> +	FSINFO_CAP_NAME(data_is_journalled),
> +	FSINFO_CAP_NAME(o_sync),
> +	FSINFO_CAP_NAME(o_direct),
> +	FSINFO_CAP_NAME(volume_id),
> +	FSINFO_CAP_NAME(volume_uuid),
> +	FSINFO_CAP_NAME(volume_name),
> +	FSINFO_CAP_NAME(volume_fsid),
> +	FSINFO_CAP_NAME(cell_name),
> +	FSINFO_CAP_NAME(domain_name),
> +	FSINFO_CAP_NAME(realm_name),
> +	FSINFO_CAP_NAME(iver_all_change),
> +	FSINFO_CAP_NAME(iver_data_change),
> +	FSINFO_CAP_NAME(iver_mono_incr),
> +	FSINFO_CAP_NAME(symlinks),
> +	FSINFO_CAP_NAME(hard_links),
> +	FSINFO_CAP_NAME(hard_links_1dir),
> +	FSINFO_CAP_NAME(device_files),
> +	FSINFO_CAP_NAME(unix_specials),
> +	FSINFO_CAP_NAME(resource_forks),
> +	FSINFO_CAP_NAME(name_case_indep),
> +	FSINFO_CAP_NAME(name_non_utf8),
> +	FSINFO_CAP_NAME(name_has_codepage),
> +	FSINFO_CAP_NAME(sparse),
> +	FSINFO_CAP_NAME(not_persistent),
> +	FSINFO_CAP_NAME(no_unix_mode),
> +	FSINFO_CAP_NAME(has_atime),
> +	FSINFO_CAP_NAME(has_btime),
> +	FSINFO_CAP_NAME(has_ctime),
> +	FSINFO_CAP_NAME(has_mtime),
> +};
> +
> +static void dump_attr_capabilities(union reply *r, int size)
> +{
> +	struct fsinfo_capabilities *f = &r->caps;
> +	int i;
> +
> +	for (i = 0; i < sizeof(f->capabilities); i++)
> +		printf("%02x", f->capabilities[i]);
> +	printf("\n");
> +	for (i = 0; i < fsinfo_cap__nr; i++)
> +		if (f->capabilities[i / 8] & (1 << (i % 8)))
> +			printf("\t- %s\n", fsinfo_cap_names[i]);
> +}
> +
> +static void dump_attr_timestamp_info(union reply *r, int size)
> +{
> +	struct fsinfo_timestamp_info *f = &r->timestamps;
> +
> +	printf("range=%llx-%llx\n",
> +	       (unsigned long long)f->minimum_timestamp,
> +	       (unsigned long long)f->maximum_timestamp);
> +
> +#define print_time(G) \
> +	printf("\t"#G"time : gran=%gs\n",			\
> +	       (f->G##time_gran_mantissa *		\
> +		pow(10., f->G##time_gran_exponent)))
> +	print_time(a);
> +	print_time(b);
> +	print_time(c);
> +	print_time(m);
> +}
> +
> +static void dump_attr_volume_uuid(union reply *r, int size)
> +{
> +	struct fsinfo_volume_uuid *f = &r->uuid;
> +
> +	printf("%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x"
> +	       "-%02x%02x%02x%02x%02x%02x\n",
> +	       f->uuid[ 0], f->uuid[ 1],
> +	       f->uuid[ 2], f->uuid[ 3],
> +	       f->uuid[ 4], f->uuid[ 5],
> +	       f->uuid[ 6], f->uuid[ 7],
> +	       f->uuid[ 8], f->uuid[ 9],
> +	       f->uuid[10], f->uuid[11],
> +	       f->uuid[12], f->uuid[13],
> +	       f->uuid[14], f->uuid[15]);
> +}
> +
> +static void dump_attr_server_address(union reply *r, int size)
> +{
> +	struct fsinfo_server_address *f = &r->srv_addr;
> +
> +	printf("family=%u\n", f->address.ss_family);
> +}
> +
> +static void dump_attr_io_size(union reply *r, int size)
> +{
> +	struct fsinfo_io_size *f = &r->io_size;
> +
> +	printf("dio_size=%u\n", f->dio_size_gran);
> +}
> +
> +/*
> + *
> + */
> +typedef void (*dumper_t)(union reply *r, int size);
> +
> +#define FSINFO_DUMPER(N) [fsinfo_attr_##N] = dump_attr_##N
> +static const dumper_t fsinfo_attr_dumper[fsinfo_attr__nr] = {
> +	FSINFO_DUMPER(statfs),
> +	FSINFO_DUMPER(fsinfo),
> +	FSINFO_DUMPER(ids),
> +	FSINFO_DUMPER(limits),
> +	FSINFO_DUMPER(supports),
> +	FSINFO_DUMPER(capabilities),
> +	FSINFO_DUMPER(timestamp_info),
> +	FSINFO_DUMPER(volume_uuid),
> +	FSINFO_DUMPER(server_address),
> +	FSINFO_DUMPER(io_size),
> +};
> +
> +static void dump_fsinfo(enum fsinfo_attribute attr, __u8 about,
> +			union reply *r, int size)
> +{
> +	dumper_t dumper = fsinfo_attr_dumper[attr];
> +	unsigned int len;
> +
> +	if (!dumper) {
> +		printf("<no dumper>\n");
> +		return;
> +	}
> +
> +	len = (about & 0x3f) * sizeof(__u32);
> +	if (size < len) {
> +		printf("<short data %u/%u>\n", size, len);
> +		return;
> +	}
> +
> +	dumper(r, size);
> +}
> +
> +/*
> + * Try one subinstance of an attribute.
> + */
> +static int try_one(const char *file, struct fsinfo_params *params, bool raw)
> +{
> +	union reply r;
> +	char *p;
> +	int ret;
> +	__u8 about;
> +
> +	memset(&r.buffer, 0xbd, sizeof(r.buffer));
> +
> +	errno = 0;
> +	ret = fsinfo(AT_FDCWD, file, params, r.buffer, sizeof(r.buffer));
> +	if (params->request >= fsinfo_attr__nr) {
> +		if (ret == -1 && errno == EOPNOTSUPP)
> +			exit(0);
> +		fprintf(stderr, "Unexpected error for too-large command %u: %m\n",
> +			params->request);
> +		exit(1);
> +	}
> +
> +	//printf("fsinfo(%s,%s,%u,%u) = %d: %m\n",
> +	//       file, fsinfo_attr_names[params->request],
> +	//       params->Nth, params->Mth, ret);
> +
> +	about = fsinfo_buffer_sizes[params->request];
> +	if (ret == -1) {
> +		if (errno == ENODATA) {
> +			switch (about & 0xc0) {
> +			case 0x00:
> +				if (params->Nth == 0 && params->Mth == 0) {
> +					fprintf(stderr,
> +						"Unexpected ENODATA1 (%u[%u][%u])\n",
> +						params->request, params->Nth, params->Mth);
> +					exit(1);
> +				}
> +				break;
> +			case 0x40:
> +				if (params->Nth == 0 && params->Mth == 0) {
> +					fprintf(stderr,
> +						"Unexpected ENODATA2 (%u[%u][%u])\n",
> +						params->request, params->Nth, params->Mth);
> +					exit(1);
> +				}
> +				break;
> +			}
> +			return (params->Mth == 0) ? 2 : 1;
> +		}
> +		if (errno == EOPNOTSUPP) {
> +			if (params->Nth > 0 || params->Mth > 0) {
> +				fprintf(stderr,
> +					"Should return -ENODATA (%u[%u][%u])\n",
> +					params->request, params->Nth, params->Mth);
> +				exit(1);
> +			}
> +			//printf("\e[33m%s\e[m: <not supported>\n",
> +			//       fsinfo_attr_names[attr]);
> +			return 2;
> +		}
> +		perror(file);
> +		exit(1);
> +	}
> +
> +	if (raw) {
> +		if (ret > 4096)
> +			ret = 4096;
> +		dump_hex((unsigned int *)&r.buffer, 0, ret);
> +		return 0;
> +	}
> +
> +	switch (about & 0xc0) {
> +	case 0x00:
> +		printf("\e[33m%s\e[m: ",
> +		       fsinfo_attr_names[params->request]);
> +		break;
> +	case 0x40:
> +		printf("\e[33m%s[%u]\e[m: ",
> +		       fsinfo_attr_names[params->request],
> +		       params->Nth);
> +		break;
> +	case 0x80:
> +		printf("\e[33m%s[%u][%u]\e[m: ",
> +		       fsinfo_attr_names[params->request],
> +		       params->Nth, params->Mth);
> +		break;
> +	}
> +
> +	switch (about) {
> +		/* Struct */
> +	case 0x01 ... 0x3f:
> +	case 0x41 ... 0x7f:
> +	case 0x81 ... 0xbf:
> +		dump_fsinfo(params->request, about, &r, ret);
> +		return 0;
> +
> +		/* String */
> +	case 0x00:
> +	case 0x40:
> +	case 0x80:
> +		if (ret >= 4096) {
> +			ret = 4096;
> +			r.buffer[4092] = '.';
> +			r.buffer[4093] = '.';
> +			r.buffer[4094] = '.';
> +			r.buffer[4095] = 0;
> +		} else {
> +			r.buffer[ret] = 0;
> +		}
> +		for (p = r.buffer; *p; p++) {
> +			if (!isprint(*p)) {
> +				printf("<non-printable>\n");
> +				continue;
> +			}
> +		}
> +		printf("%s\n", r.buffer);
> +		return 0;
> +
> +	default:
> +		fprintf(stderr, "Fishy about %u %02x\n", params->request, about);
> +		exit(1);
> +	}
> +}
> +
> +/*
> + *
> + */
> +int main(int argc, char **argv)
> +{
> +	struct fsinfo_params params = {
> +		.at_flags = AT_SYMLINK_NOFOLLOW,
> +	};
> +	unsigned int attr;
> +	int raw = 0, opt, Nth, Mth;
> +
> +	while ((opt = getopt(argc, argv, "alr"))) {
> +		switch (opt) {
> +		case 'a':
> +			params.at_flags |= AT_NO_AUTOMOUNT;
> +			continue;
> +		case 'l':
> +			params.at_flags &= ~AT_SYMLINK_NOFOLLOW;
> +			continue;
> +		case 'r':
> +			raw = 1;
> +			continue;
> +		}
> +		break;
> +	}
> +
> +	argc -= optind;
> +	argv += optind;
> +
> +	if (argc != 1) {
> +		printf("Format: test-fsinfo [-alr] <file>\n");
> +		exit(2);
> +	}
> +
> +	for (attr = 0; attr <= fsinfo_attr__nr; attr++) {
> +		Nth = 0;
> +		do {
> +			Mth = 0;
> +			do {
> +				params.request = attr;
> +				params.Nth = Nth;
> +				params.Mth = Mth;
> +
> +				switch (try_one(argv[0], &params, raw)) {
> +				case 0:
> +					continue;
> +				case 1:
> +					goto done_M;
> +				case 2:
> +					goto done_N;
> +				}
> +			} while (++Mth < 100);
> +
> +		done_M:
> +			if (Mth >= 100) {
> +				fprintf(stderr, "Fishy: Mth == %u\n", Mth);
> +				break;
> +			}
> +
> +		} while (++Nth < 100);
> +
> +	done_N:
> +		if (Nth >= 100) {
> +			fprintf(stderr, "Fishy: Nth == %u\n", Nth);
> +			break;
> +		}
> +	}
> +
> +	return 0;
> +}
> 
