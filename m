From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Date: Thu, 22 Jan 2009 06:51:04 -0800
Message-ID: <20090122065104.2787df2d.akpm@linux-foundation.org>
References: <20090115153211.663df310@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090115153211.663df310-vw3g6Xz/EtPk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org
List-Id: linux-api@vger.kernel.org

> On Thu, 15 Jan 2009 15:32:11 -0700 Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org> wrote:
> One of these years I've got to get this right.  I've fixed the problem
> pointed out by Oleg where f_flags would get changed even if fasync()
> fails.  
> 
> I have also taken out the ABI change.  CCing the linux-api list because
> I still think it's not quite right; fcntl() should not silently let
> applications set the FASYNC flag if the underlying driver/filesystem
> does not support it.  But that's How We've Always Done It, and one
> messes with such things at great risk.  If we want fcntl() to return an
> error in this case, it's an easy change.
> 
> This one's against 2.6.29-rc1.  If I don't hear screaming, I'll drop
> this one into linux-next.
> 

scream.

> 
> jon
> 
> --
> 
> Accesses to the f_flags member of struct file involve read-modify-write
> cycles; they have traditionally been done in a racy way.  This patch
> introduces a global spinlock to protect f_flags against concurrent
> modifications.
> 
> Additionally, changes to the FASYNC flag and resulting calls to
> f_op->fasync() need to be done in an atomic manner.  Here, the BKL is
> removed and FASYNC modifications are protected with a mutex.
> 
> Signed-off-by: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
> ---
>  drivers/char/tty_io.c |    5 +--
>  fs/fcntl.c            |   65 +++++++++++++++++++++++++++++++++++++++----------
>  fs/ioctl.c            |   25 ++++---------------
>  fs/nfsd/vfs.c         |    5 +++-
>  include/linux/fs.h    |   17 +++++++++++++
>  5 files changed, 80 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index d33e5ab..8450316 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -2160,13 +2160,12 @@ static int fionbio(struct file *file, int __user *p)
>  	if (get_user(nonblock, p))
>  		return -EFAULT;
>  
> -	/* file->f_flags is still BKL protected in the fs layer - vomit */
> -	lock_kernel();
> +	lock_file_flags();
>  	if (nonblock)
>  		file->f_flags |= O_NONBLOCK;
>  	else
>  		file->f_flags &= ~O_NONBLOCK;
> -	unlock_kernel();
> +	unlock_file_flags();

OK, replacing a lock_kernel() with a spin_lock(&global_lock) is pretty
straightforwad.  But it's really really sad.  It basically leaves a great
big FIXME in there.  It'd be better to fix it.

We don't have a handy lock in struct file which could be borrowed.

- We could add one

- We could borrow file->f_path.dentry->d_inode->i_lock

- We could convert that field to long and use bitops (sounds nice?)

>  	return 0;
>  }
>  
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index cdc1419..ddd497d 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
>
> ...
>
> +/*
> + * Change the setting of fasync, let the driver know.
> + * Not static because ioctl_fioasync() uses it too.
> + */
> +int fasync_change(int fd, struct file *filp, int on)
> +{
> +	int ret = 0;
> +	static DEFINE_MUTEX(fasync_mutex);
> +
> +	if (filp->f_op->fasync == NULL)
> +		return -ENOTTY;
> +
> +	mutex_lock(&fasync_mutex);
> +	/* Can test without flags lock, nobody else will change it */
> +	if (((filp->f_flags & FASYNC) == 0) == (on == 0))
> +		goto out;
> +	ret = filp->f_op->fasync(fd, filp, on);
> +	if (ret >= 0) {
> +		lock_file_flags();
> +		if (on)
> +			filp->f_flags |= FASYNC;
> +		else
> +			filp->f_flags &= ~FASYNC;
> +		unlock_file_flags();
> +	}
> +  out:

column zero, please.

> +	mutex_unlock(&fasync_mutex);
> +	return ret;
> +}

It isn't completely obvious what fasync_mutex is protecting, why it exists.

A comment which explains this would be appropriate?


--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
