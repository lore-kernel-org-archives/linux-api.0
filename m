From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Thu, 17 Mar 2016 12:01:16 +1100
Message-ID: <20160317010116.GK30721@dastard>
References: <20160312003556.GF32214@thunk.org>
 <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
 <20160313233049.GA30721@dastard>
 <56E69398.7030508@redhat.com>
 <20160314144603.GO29218@thunk.org>
 <20160315201431.GG30721@dastard>
 <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
 <20160315223313.GH30721@dastard>
 <20160315225224.GD23848@thunk.org>
 <20160316015139.GC5826@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160316015139.GC5826-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 06:51:39PM -0700, Darrick J. Wong wrote:
> On Tue, Mar 15, 2016 at 06:52:24PM -0400, Theodore Ts'o wrote:
> > On Wed, Mar 16, 2016 at 09:33:13AM +1100, Dave Chinner wrote:
> > > 
> > > Stale data escaping containment is a security issue. Enabling
> > > generic kernel mechanisms to *enable containment escape* is
> > > fundamentally wrong, and relying on userspace to Do The Right Thing
> > > is even more of a gamble, IMO.
> > 
> > We already have generic kernel mechanisms such as "the block device".   P
> > 
> > > It's a practical concern because if we enable this functionality in
> > > fallocate because it will get used by more than just special storage
> > > apps. i.e. this can't be waved away with "only properly managed
> > > applications will use it" arguments.
> > 
> > It requires a mount option.  How is this going to allow random
> > applications to use this feature, again?
> > 
> > > I also don't make a habit of publicising the fact that since we
> > > disabled the "-d unwritten=X" mkfs parameter (because of speed racer
> > > blogs such as the above and configuration cargo-culting resulting in
> > > unsuspecting users exposing stale data unintentionally) that the
> > > functionality still exists in the kernel code and that it only takes
> > > a single xfs_db command to turn off unwritten extents in XFS. i.e.
> > > we can easily make fallocate on XFS expose stale data, filesystem
> > > wide, without requiring mount options, kernel or application
> > > modifications.
> > 
> > So you have something even more dangerous in XFS and it's in the
> > kernel tree?  Has Red Hat threatened to have a distro-specific patch
> 
> xfs_db is the XFS debugger, so you can only enable that bit of functionality
> with magical commands, which IMHO isn't much different than people messing
> with their ext4 filesystems with debugfs.  You had better know what you're
> doing and if you break the filesystem you can eat both pieces. :P
> 
> > to comment out this code to make sure irresponsible users can't use
> > it?  What I've been suggesting has even more controls that what you
> > have.  And I've been keeping it as an out-of-tree kernel patch mainly
> > because you've been arguing that it's such a horrible thing.
> 
> One could lock it down even more -- hide it behind a Kconfig option that
> depends on CONFIG_EXPERT=y and itself defaults to n, require a mount option,
> only allow the file owner to call no-hide-stale and only if the file is 0600
> (or the appropriate group equivalents like Ted's existing patch), and upon
> adding stale extents, set an inode flag that locks uid/gid/mode/flags.
> Obviously root can still get to the file, but at least there's hard evidence
> that one is entering the twilight zone.
> 
> > > Making Google's hack more widely available through the fallocate
> > > API is entirely dependent on proving that:
> > 
> > Ceph is about to completely bypass the file system because of your
> > intransigence, and reimplement a userspace file system.  They seem to
> > believe it's necessary.  I'll let them make the case, because they
> > seem to think it's necessary.  And if not, if Linus sides with you,
> > and doesn't want to take the patch, I'll just keep it as a
> > Google-specific out-of-tree patch.  I don't *need* to have this thing
> > upstream.
> 
> Frankly, I second Eric Sandeen's comments -- just how bad is ext4's
> unwritten extent conversion for these folks?
> 
> I ran this crappy looping microbenchmark against a ramdisk:
> 	fallocate 400M
> 	write 400M
> 	fsync
> 	rewrite the 400M
> 	fsync
> on kernel 4.5.
> 
> For writing 400M through the page cache in 4k chunks,
> ext4: ~460MB/s -> ~580MB/s (~20%)
> XFS: ~660 -> ~870 (~25%)
> btrfs: ~130 -> ~200 (~35%)
> 
> For writing 400M in 80M chunks,
> ext4: ~480MB/s -> ~720MB/s (~30%)
> XFS: ~1GB/s -> ~1.5GB/s (~35%)
> btrfs: ~590MB/s -> ~590MB/s (no change)
> 
> For directio writing 400MB in 4k chunks,
> ext4: 25MB/s -> 26MB/s (~5%)
> XFS: 25 -> 27 (~8%)
> btrfs: 22 -> 18 (...)
> 
> For directio writing 1200MB in 80M chunks,
> ext4: ~2.9GB/s -> ~3.3GB/s (~13%)
> XFS: 3.2 -> 3.5 (~9%)
> btrfs: 2.3 -> 2.2 (...)

That's not comparing apples to apples. overwrite does not require
allocation/extent manipulation at all so it is comparing performance
of completely different file extent operations. The operations we
should be comparing are "first write" operations, namely "write over
hole with allocation" vs "write over preallocation".  Overwrite
performance should be the same regardless of the method used for the
intial write/allocation.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
