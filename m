From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 1/2] open: add close_range()
Date: Thu, 23 May 2019 13:51:20 +0200
Message-ID: <20190523115118.pmscbd6kaqy37dym@brauner.io>
References: <20190522155259.11174-1-christian@brauner.io>
 <20190522165737.GC4915@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190522165737.GC4915@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, torvalds@linux-foundation.org, fweimer@redhat.com, jannh@google.com, tglx@linutronix.de, arnd@arndb.de, shuah@kernel.org, dhowells@redhat.com, tkjos@android.com, ldv@altlinux.org, miklos@szeredi.hu, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org, linux-arch@vger.kernel.org, linux-kselftest@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, May 22, 2019 at 06:57:37PM +0200, Oleg Nesterov wrote:
> On 05/22, Christian Brauner wrote:
> >
> > +static struct file *pick_file(struct files_struct *files, unsigned fd)
> >  {
> > -	struct file *file;
> > +	struct file *file = NULL;
> >  	struct fdtable *fdt;
> >  
> >  	spin_lock(&files->file_lock);
> > @@ -632,15 +629,65 @@ int __close_fd(struct files_struct *files, unsigned fd)
> >  		goto out_unlock;
> >  	rcu_assign_pointer(fdt->fd[fd], NULL);
> >  	__put_unused_fd(files, fd);
> > -	spin_unlock(&files->file_lock);
> > -	return filp_close(file, files);
> >  
> >  out_unlock:
> >  	spin_unlock(&files->file_lock);
> > -	return -EBADF;
> > +	return file;
> 
> ...
> 
> > +int __close_range(struct files_struct *files, unsigned fd, unsigned max_fd)
> > +{
> > +	unsigned int cur_max;
> > +
> > +	if (fd > max_fd)
> > +		return -EINVAL;
> > +
> > +	rcu_read_lock();
> > +	cur_max = files_fdtable(files)->max_fds;
> > +	rcu_read_unlock();
> > +
> > +	/* cap to last valid index into fdtable */
> > +	if (max_fd >= cur_max)
> > +		max_fd = cur_max - 1;
> > +
> > +	while (fd <= max_fd) {
> > +		struct file *file;
> > +
> > +		file = pick_file(files, fd++);
> 
> Well, how about something like
> 
> 	static unsigned int find_next_opened_fd(struct fdtable *fdt, unsigned start)
> 	{
> 		unsigned int maxfd = fdt->max_fds;
> 		unsigned int maxbit = maxfd / BITS_PER_LONG;
> 		unsigned int bitbit = start / BITS_PER_LONG;
> 
> 		bitbit = find_next_bit(fdt->full_fds_bits, maxbit, bitbit) * BITS_PER_LONG;
> 		if (bitbit > maxfd)
> 			return maxfd;
> 		if (bitbit > start)
> 			start = bitbit;
> 		return find_next_bit(fdt->open_fds, maxfd, start);
> 	}

> 
> 	unsigned close_next_fd(struct files_struct *files, unsigned start, unsigned maxfd)
> 	{
> 		unsigned fd;
> 		struct file *file;
> 		struct fdtable *fdt;
> 	
> 		spin_lock(&files->file_lock);
> 		fdt = files_fdtable(files);
> 		fd = find_next_opened_fd(fdt, start);
> 		if (fd >= fdt->max_fds || fd > maxfd) {
> 			fd = -1;
> 			goto out;
> 		}
> 
> 		file = fdt->fd[fd];
> 		rcu_assign_pointer(fdt->fd[fd], NULL);
> 		__put_unused_fd(files, fd);
> 	out:
> 		spin_unlock(&files->file_lock);
> 
> 		if (fd == -1u)
> 			return fd;
> 
> 		filp_close(file, files);
> 		return fd + 1;
> 	}

Thanks, Oleg!

I kept it dumb and was about to reply that your solution introduces more
code when it seemed we wanted to keep this very simple for now.
But then I saw that find_next_opened_fd() already exists as
find_next_fd(). So it's actually not bad compared to what I sent in v1.
So - with some small tweaks (need to test it and all now) - how do we
feel about?:

/**
 * __close_next_open_fd() - Close the nearest open fd.
 *
 * @curfd: lowest file descriptor to consider
 * @maxfd: highest file descriptor to consider
 *
 * This function will close the nearest open fd, i.e. it will either
 * close @curfd if it is open or the closest open file descriptor
 * c greater than @curfd that
 * is smaller or equal to maxfd.
 * If the function found a file descriptor to close it will return 0 and
 * place the file descriptor it closed in @curfd. If it did not find a
 * file descriptor to close it will return -EBADF.
 */
static int __close_next_open_fd(struct files_struct *files, unsigned *curfd, unsigned maxfd)
{
        struct file *file = NULL;
	unsigned fd;
	struct fdtable *fdt;

	spin_lock(&files->file_lock);
	fdt = files_fdtable(files);
	fd = find_next_fd(fdt, *curfd);
	if (fd >= fdt->max_fds || fd > maxfd)
		goto out_unlock;

	file = fdt->fd[fd];
	rcu_assign_pointer(fdt->fd[fd], NULL);
	__put_unused_fd(files, fd);

out_unlock:
	spin_unlock(&files->file_lock);

	if (!file)
		return -EBADF;

	*curfd = fd;
	filp_close(file, files);
	return 0;
}

int __close_range(struct files_struct *files, unsigned fd, unsigned max_fd)
{
	if (fd > max_fd)
		return -EINVAL;

	while (fd <= max_fd) {
		if (__close_next_fd(files, &fd, maxfd))
			break;

		cond_resched();
		fd++;
	}

	return 0;
}

SYSCALL_DEFINE3(close_range, unsigned int, fd, unsigned int, max_fd,
		unsigned int, flags)
{
	if (flags)
		return -EINVAL;

	return __close_range(current->files, fd, max_fd);
}
