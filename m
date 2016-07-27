From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 8/9] vfs: hoist the btrfs deduplication ioctl to the vfs
Date: Thu, 28 Jul 2016 00:51:30 +0300
Message-ID: <20160727215130.GA18996@node.shutemov.name>
References: <20151219085505.12478.71157.stgit@birch.djwong.org>
 <20151219085559.12478.33700.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151219085559.12478.33700.stgit@birch.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, xfs@oss.sgi.com, Vlastimil Babka <vbabka@suse.cz>
List-Id: linux-api@vger.kernel.org

On Sat, Dec 19, 2015 at 12:55:59AM -0800, Darrick J. Wong wrote:
> Hoist the btrfs EXTENT_SAME ioctl up to the VFS and make the name
> more systematic (FIDEDUPERANGE).
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/compat_ioctl.c       |    1 
>  fs/ioctl.c              |   38 ++++++++++++++++++
>  fs/read_write.c         |  100 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h      |    4 ++
>  include/uapi/linux/fs.h |   30 ++++++++++++++
>  5 files changed, 173 insertions(+)
> 
> 
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index 70d4b10..eab31e7 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -1582,6 +1582,7 @@ COMPAT_SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd,
>  
>  	case FICLONE:
>  	case FICLONERANGE:
> +	case FIDEDUPERANGE:
>  		goto do_ioctl;
>  
>  	case FIBMAP:
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 84c6e79..fcdd33b 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -568,6 +568,41 @@ static int ioctl_fsthaw(struct file *filp)
>  	return thaw_super(sb);
>  }
>  
> +static long ioctl_file_dedupe_range(struct file *file, void __user *arg)
> +{
> +	struct file_dedupe_range __user *argp = arg;
> +	struct file_dedupe_range *same = NULL;
> +	int ret;
> +	unsigned long size;
> +	u16 count;
> +
> +	if (get_user(count, &argp->dest_count)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	size = offsetof(struct file_dedupe_range __user, info[count]);

Vlastimil triggered this during fuzzing:

http://paste.opensuse.org/view/raw/99203426

High order allocation without __GFP_NOWARN + fallback. That's not good.

Basically, we don't have any sanity check of 'dest_count' here. This u16
comes directly from userspace. And we call memdup_user() based on it.

Here's a program which makes kernel allocate order-9 page:

https://gist.github.com/kiryl/2b344b51da1fd2725be420a996b10d22

Should we put some reasonable upper limit for the 'dest_count'?
What is typical 'dest_count'?

> +
> +	same = memdup_user(argp, size);
> +	if (IS_ERR(same)) {
> +		ret = PTR_ERR(same);
> +		same = NULL;
> +		goto out;
> +	}
> +
> +	ret = vfs_dedupe_file_range(file, same);
> +	if (ret)
> +		goto out;
> +
> +	ret = copy_to_user(argp, same, size);
> +	if (ret)
> +		ret = -EFAULT;
> +
> +out:
> +	kfree(same);
> +	return ret;
> +}
> +

-- 
 Kirill A. Shutemov
