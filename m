From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Tue, 15 Mar 2016 18:51:39 -0700
Message-ID: <20160316015139.GC5826@birch.djwong.org>
References: <20160311223047.GZ30721@dastard>
 <20160312003556.GF32214@thunk.org>
 <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
 <20160313233049.GA30721@dastard>
 <56E69398.7030508@redhat.com>
 <20160314144603.GO29218@thunk.org>
 <20160315201431.GG30721@dastard>
 <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
 <20160315223313.GH30721@dastard>
 <20160315225224.GD23848@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160315225224.GD23848@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ric Wheeler <rwheeler@redhat.com>, Andy Lutomirski <luto@amacapital.net>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Gregory Farnum <greg@gregs42.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Eric Sandeen <esandeen@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 06:52:24PM -0400, Theodore Ts'o wrote:
> On Wed, Mar 16, 2016 at 09:33:13AM +1100, Dave Chinner wrote:
> > 
> > Stale data escaping containment is a security issue. Enabling
> > generic kernel mechanisms to *enable containment escape* is
> > fundamentally wrong, and relying on userspace to Do The Right Thing
> > is even more of a gamble, IMO.
> 
> We already have generic kernel mechanisms such as "the block device".   P
> 
> > It's a practical concern because if we enable this functionality in
> > fallocate because it will get used by more than just special storage
> > apps. i.e. this can't be waved away with "only properly managed
> > applications will use it" arguments.
> 
> It requires a mount option.  How is this going to allow random
> applications to use this feature, again?
> 
> > I also don't make a habit of publicising the fact that since we
> > disabled the "-d unwritten=X" mkfs parameter (because of speed racer
> > blogs such as the above and configuration cargo-culting resulting in
> > unsuspecting users exposing stale data unintentionally) that the
> > functionality still exists in the kernel code and that it only takes
> > a single xfs_db command to turn off unwritten extents in XFS. i.e.
> > we can easily make fallocate on XFS expose stale data, filesystem
> > wide, without requiring mount options, kernel or application
> > modifications.
> 
> So you have something even more dangerous in XFS and it's in the
> kernel tree?  Has Red Hat threatened to have a distro-specific patch

xfs_db is the XFS debugger, so you can only enable that bit of functionality
with magical commands, which IMHO isn't much different than people messing
with their ext4 filesystems with debugfs.  You had better know what you're
doing and if you break the filesystem you can eat both pieces. :P

> to comment out this code to make sure irresponsible users can't use
> it?  What I've been suggesting has even more controls that what you
> have.  And I've been keeping it as an out-of-tree kernel patch mainly
> because you've been arguing that it's such a horrible thing.

One could lock it down even more -- hide it behind a Kconfig option that
depends on CONFIG_EXPERT=y and itself defaults to n, require a mount option,
only allow the file owner to call no-hide-stale and only if the file is 0600
(or the appropriate group equivalents like Ted's existing patch), and upon
adding stale extents, set an inode flag that locks uid/gid/mode/flags.
Obviously root can still get to the file, but at least there's hard evidence
that one is entering the twilight zone.

> > Making Google's hack more widely available through the fallocate
> > API is entirely dependent on proving that:
> 
> Ceph is about to completely bypass the file system because of your
> intransigence, and reimplement a userspace file system.  They seem to
> believe it's necessary.  I'll let them make the case, because they
> seem to think it's necessary.  And if not, if Linus sides with you,
> and doesn't want to take the patch, I'll just keep it as a
> Google-specific out-of-tree patch.  I don't *need* to have this thing
> upstream.

Frankly, I second Eric Sandeen's comments -- just how bad is ext4's
unwritten extent conversion for these folks?

I ran this crappy looping microbenchmark against a ramdisk:
	fallocate 400M
	write 400M
	fsync
	rewrite the 400M
	fsync
on kernel 4.5.

For writing 400M through the page cache in 4k chunks,
ext4: ~460MB/s -> ~580MB/s (~20%)
XFS: ~660 -> ~870 (~25%)
btrfs: ~130 -> ~200 (~35%)

For writing 400M in 80M chunks,
ext4: ~480MB/s -> ~720MB/s (~30%)
XFS: ~1GB/s -> ~1.5GB/s (~35%)
btrfs: ~590MB/s -> ~590MB/s (no change)

For directio writing 400MB in 4k chunks,
ext4: 25MB/s -> 26MB/s (~5%)
XFS: 25 -> 27 (~8%)
btrfs: 22 -> 18 (...)

For directio writing 1200MB in 80M chunks,
ext4: ~2.9GB/s -> ~3.3GB/s (~13%)
XFS: 3.2 -> 3.5 (~9%)
btrfs: 2.3 -> 2.2 (...)

Clearly, the performance hit of unwritten extent conversion is large
enough to tempt people to ask for no-hide-stale.  But I'd rather hear
that directly from a developer, Ceph or otherwise.

In the meantime, please have a look at the v7 blockdev fallocate patches,
which implement only the "you can read zeroes afterwards" commands.

--D

> 
> 			    	      	    	   - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
