From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Tue, 15 Mar 2016 18:52:24 -0400
Message-ID: <20160315225224.GD23848@thunk.org>
References: <CA+55aFxQOgDjL643J33d-3q7gYGvyN84vCn4qJq-Ox8E-WRx9w@mail.gmail.com>
 <20160311223047.GZ30721@dastard>
 <20160312003556.GF32214@thunk.org>
 <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
 <20160313233049.GA30721@dastard>
 <56E69398.7030508@redhat.com>
 <20160314144603.GO29218@thunk.org>
 <20160315201431.GG30721@dastard>
 <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
 <20160315223313.GH30721@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160315223313.GH30721@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ric Wheeler <rwheeler@redhat.com>, Andy Lutomirski <luto@amacapital.net>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Gregory Farnum <greg@gregs42.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, shane.seymour@hpe.com, Bruce Fields <bfields@fieldses.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Eric Sandeen <esandeen@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 16, 2016 at 09:33:13AM +1100, Dave Chinner wrote:
> 
> Stale data escaping containment is a security issue. Enabling
> generic kernel mechanisms to *enable containment escape* is
> fundamentally wrong, and relying on userspace to Do The Right Thing
> is even more of a gamble, IMO.

We already have generic kernel mechanisms such as "the block device".   P

> It's a practical concern because if we enable this functionality in
> fallocate because it will get used by more than just special storage
> apps. i.e. this can't be waved away with "only properly managed
> applications will use it" arguments.

It requires a mount option.  How is this going to allow random
applications to use this feature, again?

> I also don't make a habit of publicising the fact that since we
> disabled the "-d unwritten=X" mkfs parameter (because of speed racer
> blogs such as the above and configuration cargo-culting resulting in
> unsuspecting users exposing stale data unintentionally) that the
> functionality still exists in the kernel code and that it only takes
> a single xfs_db command to turn off unwritten extents in XFS. i.e.
> we can easily make fallocate on XFS expose stale data, filesystem
> wide, without requiring mount options, kernel or application
> modifications.

So you have something even more dangerous in XFS and it's in the
kernel tree?  Has Red Hat threatened to have a distro-specific patch
to comment out this code to make sure irresponsible users can't use
it?  What I've been suggesting has even more controls that what you
have.  And I've been keeping it as an out-of-tree kernel patch mainly
because you've been arguing that it's such a horrible thing.

> Making Google's hack more widely available through the fallocate
> API is entirely dependent on proving that:

Ceph is about to completely bypass the file system because of your
intransigence, and reimplement a userspace file system.  They seem to
believe it's necessary.  I'll let them make the case, because they
seem to think it's necessary.  And if not, if Linus sides with you,
and doesn't want to take the patch, I'll just keep it as a
Google-specific out-of-tree patch.  I don't *need* to have this thing
upstream.

			    	      	    	   - Ted
