From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] mnt: allow to add a mount into an existing group
Date: Tue, 24 Jan 2017 14:03:23 +1300
Message-ID: <87wpdlz2uc.fsf@xmission.com>
References: <1485214628-23812-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1485214628-23812-1-git-send-email-avagin@openvz.org> (Andrei
        Vagin's message of "Mon, 23 Jan 2017 15:37:08 -0800")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrei Vagin <avagin@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Ram Pai <linuxram@us.ibm.com>
List-Id: linux-api@vger.kernel.org

Andrei Vagin <avagin@openvz.org> writes:

> Now a shared group can be only inherited from a source mount.
> This patch adds an ability to add a mount into an existing shared
> group.

This sounds like a lot of the discussion on bind mounts accross
namespaces.  I am going to stay out of this for a bit until
we resolve my latest patch.

Eric


> mount(source, target, NULL, MS_SET_GROUP, NULL)
>
> mount() with the MS_SET_GROUP flag adds the "target" mount into a group
> of the "source" mount. The calling process has to have the CAP_SYS_ADMIN
> capability in namespaces of these mounts. The source and the target
> mounts have to have the same super block.
>
> This new functionality together with "mnt: Tuck mounts under others
> instead of creating shadow/side mounts." allows CRIU to dump and restore
> any set of mount namespaces.
>
> Currently we have a lot of issues about dumping and restoring mount
> namespaces. The bigest problem is that we can't construct mount trees
> directly due to several reasons:
> * groups can't be set, they can be only inherited
> * file systems has to be mounted from the specified user namespaces
> * the mount() syscall doesn't just create one mount -- the mount is
>   also propagated to all members of a parent group
> * umount() doesn't detach mounts from all members of a group
>   (mounts with children are not umounted)
> * mounts are propagated underneath of existing mounts
> * mount() doesn't allow to make bind-mounts between two namespaces
> * processes can have opened file descriptors to overmounted files
>
> All these operations are non-trivial, making the task of restoring
> a mount namespace practically unsolvable for reasonable time. The
> proposed change allows to restore a mount namespace in a direct
> manner, without any super complex logic.
>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Andrei Vagin <avagin@openvz.org>
> ---
>  fs/namespace.c          | 53 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/fs.h |  1 +
>  2 files changed, 54 insertions(+)
>
> diff --git a/fs/namespace.c b/fs/namespace.c
> index b5b1259..df52fd4 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -2301,6 +2301,57 @@ static inline int tree_contains_unbindable(struct mount *mnt)
>  	return 0;
>  }
>  
> +static int do_set_group(struct path *path, const char *sibling_name)
> +{
> +	struct mount *sibling, *mnt;
> +	struct path sibling_path;
> +	int err;
> +
> +	if (!sibling_name || !*sibling_name)
> +		return -EINVAL;
> +
> +	err = kern_path(sibling_name, LOOKUP_FOLLOW, &sibling_path);
> +	if (err)
> +		return err;
> +
> +	sibling = real_mount(sibling_path.mnt);
> +	mnt = real_mount(path->mnt);
> +
> +	namespace_lock();
> +
> +	err = -EPERM;
> +	if (!sibling->mnt_ns ||
> +	    !ns_capable(sibling->mnt_ns->user_ns, CAP_SYS_ADMIN))
> +		goto out_unlock;
> +
> +	err = -EINVAL;
> +	if (sibling->mnt.mnt_sb != mnt->mnt.mnt_sb)
> +		goto out_unlock;
> +
> +	if (IS_MNT_SHARED(mnt) || IS_MNT_SLAVE(mnt))
> +		goto out_unlock;
> +
> +	if (IS_MNT_SLAVE(sibling)) {
> +		struct mount *m = sibling->mnt_master;
> +
> +		list_add(&mnt->mnt_slave, &m->mnt_slave_list);
> +		mnt->mnt_master = m;
> +	}
> +
> +	if (IS_MNT_SHARED(sibling)) {
> +		mnt->mnt_group_id = sibling->mnt_group_id;
> +		list_add(&mnt->mnt_share, &sibling->mnt_share);
> +		set_mnt_shared(mnt);
> +	}
> +
> +	err = 0;
> +out_unlock:
> +	namespace_unlock();
> +
> +	path_put(&sibling_path);
> +	return err;
> +}
> +
>  static int do_move_mount(struct path *path, const char *old_name)
>  {
>  	struct path old_path, parent_path;
> @@ -2779,6 +2830,8 @@ long do_mount(const char *dev_name, const char __user *dir_name,
>  		retval = do_change_type(&path, flags);
>  	else if (flags & MS_MOVE)
>  		retval = do_move_mount(&path, dev_name);
> +	else if (flags & MS_SET_GROUP)
> +		retval = do_set_group(&path, dev_name);
>  	else
>  		retval = do_new_mount(&path, type_page, flags, mnt_flags,
>  				      dev_name, data_page);
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 36da93f..6e6e37d 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -130,6 +130,7 @@ struct inodes_stat_t {
>  #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
>  #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
>  #define MS_LAZYTIME	(1<<25) /* Update the on-disk [acm]times lazily */
> +#define MS_SET_GROUP	(1<<26) /* Add a mount into a shared group */
>  
>  /* These sb flags are internal to the kernel */
>  #define MS_NOREMOTELOCK	(1<<27)
