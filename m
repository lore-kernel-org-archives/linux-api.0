From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Wed, 16 Mar 2016 20:15:02 -0400
Message-ID: <20160317001502.GF23593@thunk.org>
References: <CA+55aFyLa0iFFkiVZq-nLH2yWoGzGnv8HB=4R1Xq2PRmjusJ=w@mail.gmail.com>
 <20160313233049.GA30721@dastard>
 <56E69398.7030508@redhat.com>
 <20160314144603.GO29218@thunk.org>
 <20160315201431.GG30721@dastard>
 <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
 <20160315223313.GH30721@dastard>
 <20160315225224.GD23848@thunk.org>
 <20160316015139.GC5826@birch.djwong.org>
 <7674C689-C07E-4D38-85EB-4FD9B55CBB35@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7674C689-C07E-4D38-85EB-4FD9B55CBB35-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, Martin Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Eric Sandeen <esandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 16, 2016 at 03:45:49PM -0600, Andreas Dilger wrote:
> > Clearly, the performance hit of unwritten extent conversion is large
> > enough to tempt people to ask for no-hide-stale.  But I'd rather hear
> > that directly from a developer, Ceph or otherwise.
> 
> I suspect that this gets significantly worse if you are running with
> random writes instead of sequential overwrites.  With sequential overwrites
> there is only a single boundary between init and uninit extents, so at
> most one extra extent in the tree.  The above performance deltas will also
> be much larger when real disks are involved and seek latency is a factor.

It will vary a lot depending on your use case.  If you are running
with data=ordered, and with journalled enabled, then even if it is a
single extent that is modified, the fact that a journal transaction
involved, with a forced data block flush to avoid revealing stale
data, that is certainly going to be measurable.

The other thing is if you are worried about tail latency, which is a
major concern at Google[1], and you are running your disks close to
flat out, the fact that you have to do an extra seek to update the
extent tree is a seek that you can't be using for useful work --- and
worse, could delay a low-latency read from completing within your SLO.

[1] https://research.google.com/pubs/pub44830.html

Part of what's challenging with giving numbers is that it's trivially
easy to give some worst case scneario where the numbers are really
terrible.  A random 4k random write benchmark into an fallocated file,
eeven with XFS, would have pretty bad numbers, But of course people
wouldn't say that it's very realistic.  But those are the easiest to
get.

The most realistic numbers are going to be a lot harder to get, and
wouldn't necessarily make a lot of sense without revealing a lot
proprietary information.  I will say that Google does have a fairly
large number of disks[2] and so even a small fractional percentage
gain multipled by gazillions of disks starts turning into a dollar
number with enough zeros that people really sit up and take notice.
I'll also note that map reduce can be quite nasty as far as random I/O
is concerned[3], and while map reduce jobs are often not high priority
jobs, they can interfere with low-latency reads from important
applications (e.g., web search, user-visible gmail operations, etc.)

[2] https://what-if.xkcd.com/63/
[3] https://pdfs.semanticscholar.org/6238/e5f0fd807f634f5999701c7aa6a09d88dfc8.pdf

So I'm not sure what numbers I can really give that would satisfy
people.  Doing a random write fio job is not hard, and will result in
fairly impressive numbers.  If that's enough, then either I can do
this, or Chris Mason can reproduce his experiment using XFS (which
would presumably eliminate the excuse that it's because ext4 sucks at
extent operations).  But if that's not going to convince people, then
I'd much rather not waste my time.

Besides, at Google it's easy enough for me to maintain the patch
out-of-tree.  It's the Ceph folks who would need to at the very least,
have such a patch ship in Red Hat Enterprise Linux.  So it's probably
better for them to justify it, if numbers are really necessary.

       	   	   	       	  	  - Ted
