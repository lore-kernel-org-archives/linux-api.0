From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 02/25] vfs: Allow fsinfo() to query what's in an
 fs_context [ver #13]
Date: Fri, 21 Jun 2019 11:47:58 +0200
Message-ID: <20190621094757.zijugn6cfulmchnf@brauner.io>
References: <155905626142.1662.18430571708534506785.stgit@warthog.procyon.org.uk>
 <155905627927.1662.13276277442207649583.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <155905627927.1662.13276277442207649583.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, raven@themaw.net, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

On Tue, May 28, 2019 at 04:11:19PM +0100, David Howells wrote:
> Allow fsinfo() to be used to query the filesystem attached to an fs_context
> once a superblock has been created or if it comes from fspick().
> 
> This is done with something like:
> 
> 	fd = fsopen("ext4", 0);
> 	...
> 	fsconfig(fd, fsconfig_cmd_create, ...);
> 	fsinfo(fd, NULL, ...);
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/fsinfo.c |   30 +++++++++++++++++++++++++++++-
>  fs/statfs.c |    2 +-
>  2 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fsinfo.c b/fs/fsinfo.c
> index f9a63410e9a2..14db881dd02d 100644
> --- a/fs/fsinfo.c
> +++ b/fs/fsinfo.c
> @@ -8,6 +8,7 @@
>  #include <linux/security.h>
>  #include <linux/uaccess.h>
>  #include <linux/fsinfo.h>
> +#include <linux/fs_context.h>
>  #include <uapi/linux/mount.h>
>  #include "internal.h"
>  
> @@ -315,13 +316,40 @@ static int vfs_fsinfo_path(int dfd, const char __user *filename,
>  	return ret;
>  }
>  
> +static int vfs_fsinfo_fscontext(struct fs_context *fc,
> +				struct fsinfo_kparams *params)
> +{
> +	int ret;
> +
> +	if (fc->ops == &legacy_fs_context_ops)
> +		return -EOPNOTSUPP;
> +
> +	ret = mutex_lock_interruptible(&fc->uapi_mutex);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = -EIO;
> +	if (fc->root) {
> +		struct path path = { .dentry = fc->root };
> +
> +		ret = vfs_fsinfo(&path, params);
> +	}
> +
> +	mutex_unlock(&fc->uapi_mutex);
> +	return ret;
> +}
> +
>  static int vfs_fsinfo_fd(unsigned int fd, struct fsinfo_kparams *params)
>  {
>  	struct fd f = fdget_raw(fd);

You're using fdget_raw() which means you want to allow O_PATH fds but
below you're checking whether the f_ops correspond to
fscontext_fops. If it's an O_PATH f_ops will be set to empty_fops so
you'll always end up in the vfs_fsinfo branch. Is that your intention?

That means the new mount api doesn't support fsinfo() without using a
non-O_PATH fd, right? Why the fallback then?

Christian

>  	int ret = -EBADF;
>  
>  	if (f.file) {
> -		ret = vfs_fsinfo(&f.file->f_path, params);
> +		if (f.file->f_op == &fscontext_fops)
> +			ret = vfs_fsinfo_fscontext(f.file->private_data,
> +						   params);
> +		else
> +			ret = vfs_fsinfo(&f.file->f_path, params);
>  		fdput(f);
>  	}
>  	return ret;
> diff --git a/fs/statfs.c b/fs/statfs.c
> index eea7af6f2f22..b9b63d9f4f24 100644
> --- a/fs/statfs.c
> +++ b/fs/statfs.c
> @@ -86,7 +86,7 @@ int vfs_statfs(const struct path *path, struct kstatfs *buf)
>  	int error;
>  
>  	error = statfs_by_dentry(path->dentry, buf);
> -	if (!error)
> +	if (!error && path->mnt)
>  		buf->f_flags = calculate_f_flags(path->mnt);
>  	return error;
>  }
> 
