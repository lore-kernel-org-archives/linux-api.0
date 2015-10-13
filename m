From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 8/9] vfs: Add vfs_copy_file_range() support for
 pagecache copies
Date: Tue, 13 Oct 2015 00:19:56 -0700
Message-ID: <20151013071956.GJ850@birch.djwong.org>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1443634014-3026-9-git-send-email-Anna.Schumaker@Netapp.com>
 <20151011142203.GA31867@infradead.org>
 <20151012231749.GC11398@birch.djwong.org>
 <CAHQdGtQoV0g1p2FYC1vFtFwh=jNq5n+AYOxAuSORVfbfhRY1Hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHQdGtQoV0g1p2FYC1vFtFwh=jNq5n+AYOxAuSORVfbfhRY1Hg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux btrfs Developers List <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS-devel Mailing List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API Mailing List <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, William Andros Adamson <andros-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 12, 2015 at 11:36:31PM -0400, Trond Myklebust wrote:
> On Mon, Oct 12, 2015 at 7:17 PM, Darrick J. Wong
> <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > On Sun, Oct 11, 2015 at 07:22:03AM -0700, Christoph Hellwig wrote:
> >> On Wed, Sep 30, 2015 at 01:26:52PM -0400, Anna Schumaker wrote:
> >> > This allows us to have an in-kernel copy mechanism that avoids frequent
> >> > switches between kernel and user space.  This is especially useful so
> >> > NFSD can support server-side copies.
> >> >
> >> > I make pagecache copies configurable by adding three new (exclusive)
> >> > flags:
> >> > - COPY_FR_REFLINK tells vfs_copy_file_range() to only create a reflink.
> >> > - COPY_FR_COPY does a full data copy, but may be filesystem accelerated.
> >> > - COPY_FR_DEDUP creates a reflink, but only if the contents of both
> >> >   ranges are identical.
> >>
> >> All but FR_COPY really should be a separate system call.  Clones (an
> >> dedup as a special case of clones) are really a separate beast from file
> >> copies.
> >>
> >> If I want to clone a file I either want it clone fully or fail, not copy
> >> a certain amount.  That means that a) we need to return an error not
> >> short "write", and b) locking impementations are important - we need to
> >> prevent other applications from racing with our clone even if it is
> >> large, while to get these semantics for the possible short returning
> >> file copy will require a proper userland locking protocol. Last but not
> >> least file copies need to be interruptible while clones should be not.
> >> All this is already important for local file systems and even more
> >> important for NFS exporting.
> >>
> >> So I'd suggest to drop this patch and just let your syscall handle
> >> actualy copies with all their horrors.  We can go with Peng's patches
> >> to generalize the btrfs ioctls for clones for now which is what everyone
> >> already uses anyway, and then add a separate sys_file_clone later.
> >
> > Hm.  Peng's patches only generalize the CLONE and CLONE_RANGE ioctls from
> > btrfs, however they don't port over the (vastly different) EXTENT_SAME ioctl.
> >
> > What does everyone think about generalizing EXTENT_SAME?  The interface enables
> > one to ask the kernel to dedupe multiple file ranges in a single call.  That's
> > more complex than what I was proposing with COPY_FR_DEDUP(E), but I'm assuming
> > that the extra complexity buys us the ability to ... multi-dedupe at the same
> > time, with locks held on the source file?
> 
> How is this supposed to be implemented on something like NFS without
> protocol changes?

Quite frankly, I'm not sure.  Assuming NFS doesn't already have some sort of
deduplication primitive (I could be totally wrong about that) I'd probably just
leave the appropriate ops function pointer set to NULL and return -EOPNOTSUPP
to userspace.  Trying to fake it by comparing contents on the client and
issuing a reflink might be doable with hard locks but if I had to guess I'd say
that's even less palatable than simply bailing out. :)

IOW: I was only considering the filesystems that already support dedupe, which
is basically btrfs and future-XFS.

--D

> 
> Trond
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
