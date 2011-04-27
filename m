From: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Subject: Re: [RFC] [PATCH] drop_pagecache syscall
Date: Wed, 27 Apr 2011 11:01:28 +0200
Message-ID: <20110427085910.GA1749@linux.betterlinux.com>
References: <1303853727-21444-1-git-send-email-andrea@betterlinux.com>
 <20110427001453.GD12436@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110427001453.GD12436@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 27, 2011 at 10:14:53AM +1000, Dave Chinner wrote:
> On Tue, Apr 26, 2011 at 11:35:27PM +0200, Andrea Righi wrote:
> > Introduce sys_drop_pagecache() system call to drop the page cache pages of
> > a single filesystem.
> > 
> > This new system call takes a file descriptor as argument and drops only
> > the page cache pages of the file system it references.
> > 
> > At the moment it is possible to drop page cache pages via
> > /proc/sys/vm/drop_pagecache or via posix_fadvise(POSIX_FADV_DONTNEED).
> > 
> > The first method drops the whole page cache while the second can be used
> > to drop page cache pages of a single file descriptor. But there's not a
> > simple way to drop all the pages of a filesystem (we could scan all the
> > file descriptors and use posix_fadvise(), but this solution doesn't scale
> > very well in some cases).
> 
> Why not just add a new posix_fadvise() command? e.g.
> POSIX_FADV_DONTNEED_FS. Simpler than adding a new syscall...

Agreed.

> 
> > This functionality can be used by all the applications that want to have a
> > better control over the page cache management (for example to immediately drop
> > pages that for sure will not be reused in the near future, without calling
> > posix_fadvise() for all the files they've touched), or to provide a more fine
> > grained debugging feature usable by the filesystem benchmarks.
> > 
> > The system call does not require root privileges and it can be called by any
> > unprivileged application. For example, we can write a userspace tool to run
> > something like this:
> > 
> >   $ drop-pagecache /path/file_or_dir
> 
> That's a potential DOS vector, I think. Drop the pagecache in a hard
> loop on the root fs of a busy server and watch it crawl...

Yes, probably we could allow only the CAP_SYS_ADMIN tasks to execute
this syscall.

> 
> > +/*
> > + * Drop page cache of a single superblock
> > + */
> > +SYSCALL_DEFINE1(drop_pagecache, int, fd)
> > +{
> > +	struct file *file;
> > +	struct super_block *sb;
> > +	int fput_needed;
> > +
> > +	file = fget_light(fd, &fput_needed);
> > +	if (!file)
> > +		return -EBADF;
> > +	sb = file->f_dentry->d_sb;
> > +
> > +	down_read(&sb->s_umount);
> > +	drop_pagecache_sb(sb, NULL);
> > +	up_read(&sb->s_umount);
> > +
> > +	fput_light(file, fput_needed);
> > +	return 0;
> 
> You're holding an open reference to a file/dir on the fs so it can't
> be unmounted from under you. Hence I don't think you need the
> s_umount locking.

Yes, you're right. The fs can't be unmounted, so I also think we can do
it without the s_umount locking.

I'll apply your suggestions, do some tests and post a new version of the
patch.

Thanks for the review.

-Andrea
