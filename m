From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH 09/25] vfs: Allow mount information to be queried by
 fsinfo() [ver #13]
Date: Sat, 1 Jun 2019 12:08:22 -0400
Message-ID: <20190601160822.GA77761@google.com>
References: <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk>
 <155905633578.1662.8087594848892366318.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <155905633578.1662.8087594848892366318.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, raven@themaw.net, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

On Tue, May 28, 2019 at 04:12:15PM +0100, David Howells wrote:
[snip]
> +
> +/*
> + * Store a mount record into the fsinfo buffer.
> + */
> +static void store_mount_fsinfo(struct fsinfo_kparams *params,
> +			       struct fsinfo_mount_child *child)
> +{
> +	unsigned int usage = params->usage;
> +	unsigned int total = sizeof(*child);
> +
> +	if (params->usage >= INT_MAX)
> +		return;
> +	params->usage = usage + total;
> +	if (params->buffer && params->usage <= params->buf_size)
> +		memcpy(params->buffer + usage, child, total);
> +}
> +
> +/*
> + * Return information about the submounts relative to path.
> + */
> +int fsinfo_generic_mount_children(struct path *path, struct fsinfo_kparams *params)
> +{
> +	struct fsinfo_mount_child record;
> +	struct mount *m, *child;
> +
> +	if (!path->mnt)
> +		return -ENODATA;
> +
> +	rcu_read_lock();
> +
> +	m = real_mount(path->mnt);
> +	list_for_each_entry_rcu(child, &m->mnt_mounts, mnt_child) {
> +		if (child->mnt_parent != m)
> +			continue;
> +		record.mnt_id = child->mnt_id;
> +		record.notify_counter = atomic_read(&child->mnt_notify_counter);
> +		store_mount_fsinfo(params, &record);
> +	}
> +
> +	record.mnt_id = m->mnt_id;
> +	record.notify_counter = atomic_read(&m->mnt_notify_counter);
> +	store_mount_fsinfo(params, &record);
> +
> +	rcu_read_unlock();

Not super familiar with this code, but wanted to check with you:

Here, if the rcu_read_lock is supposed to protect the RCU list, can
rcu_read_lock() scope be reduced to just wrapping around the
list_for_each_entry_rcu?

  rcu_read_lock();
  list_for_each_entry_rcu(..) {
  	...
  }
  rcu_read_unlock();

(and similarly to other similar parts of this patch).

thanks,

  - Joel

> +	return params->usage;
> +}
> +
> +/*
> + * Return the path of the Nth submount relative to path.  This is derived from
> + * d_path(), but the root determination is more complicated.
> + */
> +int fsinfo_generic_mount_submount(struct path *path, struct fsinfo_kparams *params)
> +{
> +	struct mountpoint *mp;
> +	struct mount *m, *child;
> +	struct path mountpoint, root;
> +	unsigned int n = params->Nth;
> +	size_t len;
> +	void *p;
> +
> +	if (!path->mnt)
> +		return -ENODATA;
> +
> +	rcu_read_lock();
> +
> +	m = real_mount(path->mnt);
> +	list_for_each_entry_rcu(child, &m->mnt_mounts, mnt_child) {
> +		mp = READ_ONCE(child->mnt_mp);
> +		if (child->mnt_parent != m || !mp)
> +			continue;
> +		if (n-- == 0)
> +			goto found;
> +	}
> +	rcu_read_unlock();
> +	return -ENODATA;
> +
> +found:
> +	mountpoint.mnt = path->mnt;
> +	mountpoint.dentry = READ_ONCE(mp->m_dentry);
> +
> +	get_fs_root_rcu(current->fs, &root);
> +	if (root.mnt != path->mnt) {
> +		root.mnt = path->mnt;
> +		root.dentry = path->mnt->mnt_root;
> +	}
> +
> +	p = __d_path(&mountpoint, &root, params->buffer, params->buf_size);
> +	rcu_read_unlock();
> +
> +	if (IS_ERR(p))
> +		return PTR_ERR(p);
> +	if (!p)
> +		return -EPERM;
> +
> +	len = (params->buffer + params->buf_size) - p;
> +	memmove(params->buffer, p, len);
> +	return len;
> +}
> +#endif /* CONFIG_FSINFO */
> diff --git a/include/uapi/linux/fsinfo.h b/include/uapi/linux/fsinfo.h
> index dae2e8dd757e..7f7a75e9758a 100644
> --- a/include/uapi/linux/fsinfo.h
> +++ b/include/uapi/linux/fsinfo.h
> @@ -32,6 +32,10 @@ enum fsinfo_attribute {
>  	FSINFO_ATTR_PARAM_ENUM		= 14,	/* Nth enum-to-val */
>  	FSINFO_ATTR_PARAMETERS		= 15,	/* Mount parameters (large string) */
>  	FSINFO_ATTR_LSM_PARAMETERS	= 16,	/* LSM Mount parameters (large string) */
> +	FSINFO_ATTR_MOUNT_INFO		= 17,	/* Mount object information */
> +	FSINFO_ATTR_MOUNT_DEVNAME	= 18,	/* Mount object device name (string) */
> +	FSINFO_ATTR_MOUNT_CHILDREN	= 19,	/* Submount list (array) */
> +	FSINFO_ATTR_MOUNT_SUBMOUNT	= 20,	/* Relative path of Nth submount (string) */
>  	FSINFO_ATTR__NR
>  };
>  
> @@ -268,4 +272,28 @@ struct fsinfo_param_enum {
>  	char		name[252];	/* Name of the enum value */
>  };
>  
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
>  #endif /* _UAPI_LINUX_FSINFO_H */
> diff --git a/samples/vfs/test-fsinfo.c b/samples/vfs/test-fsinfo.c
> index 90926024e1c5..a838adcdca9e 100644
> --- a/samples/vfs/test-fsinfo.c
> +++ b/samples/vfs/test-fsinfo.c
> @@ -21,10 +21,10 @@
>  #include <errno.h>
>  #include <time.h>
>  #include <math.h>
> -#include <fcntl.h>
>  #include <sys/syscall.h>
>  #include <linux/fsinfo.h>
>  #include <linux/socket.h>
> +#include <linux/fcntl.h>
>  #include <sys/stat.h>
>  #include <arpa/inet.h>
>  
> @@ -83,6 +83,10 @@ static const struct fsinfo_attr_info fsinfo_buffer_info[FSINFO_ATTR__NR] = {
>  	FSINFO_STRUCT_N		(PARAM_ENUM,		param_enum),
>  	FSINFO_OVERLARGE	(PARAMETERS,		-),
>  	FSINFO_OVERLARGE	(LSM_PARAMETERS,	-),
> +	FSINFO_STRUCT		(MOUNT_INFO,		mount_info),
> +	FSINFO_STRING		(MOUNT_DEVNAME,		mount_devname),
> +	FSINFO_STRUCT_ARRAY	(MOUNT_CHILDREN,	mount_child),
> +	FSINFO_STRING_N		(MOUNT_SUBMOUNT,	mount_submount),
>  };
>  
>  #define FSINFO_NAME(X,Y) [FSINFO_ATTR_##X] = #Y
> @@ -104,6 +108,10 @@ static const char *fsinfo_attr_names[FSINFO_ATTR__NR] = {
>  	FSINFO_NAME		(PARAM_ENUM,		param_enum),
>  	FSINFO_NAME		(PARAMETERS,		parameters),
>  	FSINFO_NAME		(LSM_PARAMETERS,	lsm_parameters),
> +	FSINFO_NAME		(MOUNT_INFO,		mount_info),
> +	FSINFO_NAME		(MOUNT_DEVNAME,		mount_devname),
> +	FSINFO_NAME		(MOUNT_CHILDREN,	mount_children),
> +	FSINFO_NAME		(MOUNT_SUBMOUNT,	mount_submount),
>  };
>  
>  union reply {
> @@ -116,6 +124,8 @@ union reply {
>  	struct fsinfo_capabilities caps;
>  	struct fsinfo_timestamp_info timestamps;
>  	struct fsinfo_volume_uuid uuid;
> +	struct fsinfo_mount_info mount_info;
> +	struct fsinfo_mount_child mount_children[1];
>  };
>  
>  static void dump_hex(unsigned int *data, int from, int to)
> @@ -312,6 +322,29 @@ static void dump_attr_VOLUME_UUID(union reply *r, int size)
>  	       f->uuid[14], f->uuid[15]);
>  }
>  
> +static void dump_attr_MOUNT_INFO(union reply *r, int size)
> +{
> +	struct fsinfo_mount_info *f = &r->mount_info;
> +
> +	printf("\n");
> +	printf("\tsb_id   : %llx\n", (unsigned long long)f->f_sb_id);
> +	printf("\tmnt_id  : %x\n", f->mnt_id);
> +	printf("\tparent  : %x\n", f->parent_id);
> +	printf("\tgroup   : %x\n", f->group_id);
> +	printf("\tattr    : %x\n", f->attr);
> +	printf("\tnotifs  : %x\n", f->notify_counter);
> +}
> +
> +static void dump_attr_MOUNT_CHILDREN(union reply *r, int size)
> +{
> +	struct fsinfo_mount_child *f = r->mount_children;
> +	int i = 0;
> +
> +	printf("\n");
> +	for (; size >= sizeof(*f); size -= sizeof(*f), f++)
> +		printf("\t[%u] %8x %8x\n", i++, f->mnt_id, f->notify_counter);
> +}
> +
>  /*
>   *
>   */
> @@ -327,6 +360,8 @@ static const dumper_t fsinfo_attr_dumper[FSINFO_ATTR__NR] = {
>  	FSINFO_DUMPER(CAPABILITIES),
>  	FSINFO_DUMPER(TIMESTAMP_INFO),
>  	FSINFO_DUMPER(VOLUME_UUID),
> +	FSINFO_DUMPER(MOUNT_INFO),
> +	FSINFO_DUMPER(MOUNT_CHILDREN),
>  };
>  
>  static void dump_fsinfo(enum fsinfo_attribute attr,
> @@ -529,16 +564,21 @@ int main(int argc, char **argv)
>  	unsigned int attr;
>  	int raw = 0, opt, Nth, Mth;
>  
> -	while ((opt = getopt(argc, argv, "adlr"))) {
> +	while ((opt = getopt(argc, argv, "Madlr"))) {
>  		switch (opt) {
> +		case 'M':
> +			params.at_flags = AT_FSINFO_MOUNTID_PATH;
> +			continue;
>  		case 'a':
>  			params.at_flags |= AT_NO_AUTOMOUNT;
> +			params.at_flags &= ~AT_FSINFO_MOUNTID_PATH;
>  			continue;
>  		case 'd':
>  			debug = true;
>  			continue;
>  		case 'l':
>  			params.at_flags &= ~AT_SYMLINK_NOFOLLOW;
> +			params.at_flags &= ~AT_FSINFO_MOUNTID_PATH;
>  			continue;
>  		case 'r':
>  			raw = 1;
> @@ -551,7 +591,8 @@ int main(int argc, char **argv)
>  	argv += optind;
>  
>  	if (argc != 1) {
> -		printf("Format: test-fsinfo [-alr] <file>\n");
> +		printf("Format: test-fsinfo [-adlr] <file>\n");
> +		printf("Format: test-fsinfo [-dr] -M <mnt_id>\n");
>  		exit(2);
>  	}
>  
> 
