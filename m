From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v7 0/4] VFS: In-kernel copy system call
Date: Sun, 25 Oct 2015 20:45:40 -0700
Message-ID: <20151026034540.GB9945@infradead.org>
References: <1445628736-13058-1-git-send-email-Anna.Schumaker@Netapp.com>
 <20151024165237.GA6436@zzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151024165237.GA6436@zzz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, clm-b10kYP2dOMg@public.gmane.org, darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, Oct 24, 2015 at 11:52:37AM -0500, Eric Biggers wrote:
> A few comments:
> 
> >       if (!(file_in->f_mode & FMODE_READ) ||
> >           !(file_out->f_mode & FMODE_WRITE) ||
> >           (file_out->f_flags & O_APPEND) ||
> >           !file_out->f_op)
> >               return -EBADF;
> 
> Isn't 'f_op' always non-NULL?

Yes, its is.

> If the destination file cannot be append-only, shouldn't this be documented?

Yes.

> >	if (inode_in->i_sb != inode_out->i_sb ||
> >		file_in->f_path.mnt != file_out->f_path.mnt)
> >		return -EXDEV;
> 
> Doesn't the same mount already imply the same superblock?

It does.

> > /*
> >  * copy_file_range() differs from regular file read and write in that it
> >  * specifically allows return partial success.  When it does so is up to
> >  * the copy_file_range method.
> >  */
> 
> What does this mean?  I thought that read() and write() can also return
> partial success.

The syscalls are allow to return short from the standards perspective,
but if you actually do that for regualr fiels hell will break loose as
applications don't expect it.  That's why we can't actually ever do it.

> Should FMODE_PREAD or FMODE_PWRITE access be checked if the user specifies their
> own 'off_in' or 'off_out', respectively?

Maybe.

> What is supposed to happen if the user passes provides a file descriptor to a
> non-regular file, such as a block device or char device?

If they implement the proper method I see no reason why we can't support
it.  For block device we only have one file_ops instance and mapping
that to the bio-level XCOPY abstraction that's been posted a couple of
times would seem sensible.  For character devices that's entirely up to
the driver.

> If the 'in' file has fewer than 'len' bytes remaining until EOF, what is the
> expected behavior?  It looks like the btrfs implementation has different
> behavior from the pagecache implementation.

Good question.  I'd say failure is the right way to handle a mismatching
length.

> It appears the btrfs implementation has alignment restrictions --- where is this
> documented and how will users know what alignment to use?

For actual clones we're limited to the file system block size (NFS adds
an extra attribute for the clone block size), but for regaulr copies we
probably should fall back to the dumb implementation if we don't match
it.

> Are copies within the same file permitted and can the ranges overlap?  The man
> page doesn't say.

For clones we defintively want to support it, but for copies I'd be
tempted to say no.  Does anyone else have an opinion?

> It looks like the initial patch defines __NR_copy_file_range for the ARM
> architecture but doesn't actually hook that system call up for ARM; why is that?

Looks like that should be dropped.  I really wish we had a way to just
wire up syscalls everywhere.
