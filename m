From: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Subject: Re: [PATCH 09/25] vfs: Allow mount information to be queried by
 fsinfo() [ver #13]
Date: Wed, 5 Jun 2019 13:21:40 +0100
Message-ID: <60136f9f-8eb6-a7f4-11c6-daf988274420@gmail.com>
References: <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk>
 <155905633578.1662.8087594848892366318.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155905633578.1662.8087594848892366318.stgit@warthog.procyon.org.uk>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk
Cc: raven@themaw.net, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

On 28/05/2019 16:12, David Howells wrote:
> Allow mount information, including information about the topology tree to
> be queried with the fsinfo() system call.  Usage of AT_FSINFO_MOUNTID_PATH
> allows overlapping mounts to be queried.
>
> To this end, four fsinfo() attributes are provided:
>
>   (1) FSINFO_ATTR_MOUNT_INFO.
>
>       This is a structure providing information about a mount, including:
>
> 	- Mounted superblock ID.
> 	- Mount ID (as AT_FSINFO_MOUNTID_PATH).
> 	- Parent mount ID.
> 	- Mount attributes (eg. R/O, NOEXEC).
> 	- Number of change notifications generated.
>
>       Note that the parent mount ID is overridden to the ID of the queried
>       mount if the parent lies outside of the chroot or dfd tree.
>
>   (2) FSINFO_ATTR_MOUNT_DEVNAME.
>
>       This a string providing the device name associated with the mount.
>
>       Note that the device name may be a path that lies outside of the root.
>
>   (3) FSINFO_ATTR_MOUNT_CHILDREN.
>
>       This produces an array of structures, one for each child and capped
>       with one for the argument mount (checked after listing all the
>       children).  Each element contains the mount ID and the notification
>       counter of the respective mount object.
>
>   (4) FSINFO_ATTR_MOUNT_SUBMOUNT.
>
>       This is a 1D array of strings, indexed with struct fsinfo_params::Nth.
>       Each string is the relative pathname of the corresponding child
>       returned by FSINFO_ATTR_MOUNT_CHILD.

FSINFO_ATTR_MOUNT_CHILD -> FSINFO_ATTR_MOUNT_CHILDREN


>       Note that paths in the mount at the base of the tree (whether that be
>       dfd or chroot) are relative to the base of the tree, not the root
>       directory of that mount.
>
> Signed-off-by: David Howells<dhowells@redhat.com>
> ---
>
>   fs/d_path.c                 |    2
>   fs/fsinfo.c                 |    9 ++
>   fs/internal.h               |    9 ++
>   fs/namespace.c              |  175 +++++++++++++++++++++++++++++++++++++++++++
>   include/uapi/linux/fsinfo.h |   28 +++++++
>   samples/vfs/test-fsinfo.c   |   47 +++++++++++-
>   6 files changed, 266 insertions(+), 4 deletions(-)

> +/*
> + * Information struct for fsinfo(FSINFO_ATTR_MOUNT_INFO).
> + */
> +struct fsinfo_mount_info {
> +	__u64		f_sb_id;	/* Superblock ID */
> +	__u32		mnt_id;		/* Mount identifier (use with AT_FSINFO_MOUNTID_PATH) */
> +	__u32		parent_id;	/* Parent mount identifier */
> +	__u32		group_id;	/* Mount group ID */
> +	__u32		master_id;	/* Slave master group ID */
> +	__u32		from_id;	/* Slave propogated from ID */

propogated -> propagated

> +	__u32		attr;		/* MOUNT_ATTR_* flags */
> +	__u32		notify_counter;	/* Number of notifications generated. */
> +	__u32		__reserved[1];
> +};
> +
> +/*
> + * Information struct element for fsinfo(FSINFO_ATTR_MOUNT_CHILDREN).
> + * - An extra element is placed on the end representing the parent mount.
> + */
> +struct fsinfo_mount_child {
> +	__u32		mnt_id;		/* Mount identifier (use with AT_FSINFO_MOUNTID_PATH) */
> +	__u32		notify_counter;	/* Number of notifications generated on mount. */
> +};
> +
>   #endif /* _UAPI_LINUX_FSINFO_H */
