From: Chris Mason <clm-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 2/2] block: create ioctl to discard-or-zeroout a range of
 blocks
Date: Tue, 15 Mar 2016 17:51:17 -0700
Message-ID: <20160316005117.GA34410@clm-mbp.thefacebook.com>
References: <20160313233049.GA30721@dastard>
 <56E69398.7030508@redhat.com>
 <20160314144603.GO29218@thunk.org>
 <20160315201431.GG30721@dastard>
 <CA+55aFwHLJffmN-Dw=yZCGKzxe_2Tm9h2GjdaFL3JdvYXNstRw@mail.gmail.com>
 <20160315223313.GH30721@dastard>
 <CA+55aFxCpza3_3J8kP9E0gLKHiSitZHjC4UMS_ZfZ_HBTC9=Bg@mail.gmail.com>
 <20160315235216.GI30721@dastard>
 <CA+55aFxZ=feGd+QGdhCN28kjd2XJO3PCj9NBoJJZ5E8_WMJiMA@mail.gmail.com>
 <56E8A916.8050702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56E8A916.8050702-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Ric Wheeler <rwheeler-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Gregory Farnum <greg-3KCAGdo1P2hBDgjK7y7TUQ@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shane.seymour-ZPxbGqLxI0U@public.gmane.org, Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 07:30:14PM -0500, Eric Sandeen wrote:
> On 3/15/16 7:06 PM, Linus Torvalds wrote:
> > On Tue, Mar 15, 2016 at 4:52 PM, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> >> >
> >> > It is pretty clear that the onus is on the patch submitter to
> >> > provide justification for inclusion, not for the reviewer/Maintainer
> >> > to have to prove that the solution is unworkable.
> > I agree, but quite frankly, performance is a good justification.
> > 
> > So if Ted can give performance numbers, that's justification enough.
> > We've certainly taken changes with less.
> 
> I've been away from ext4 for a while, so I'm really not on top of the
> mechanics of the underlying problem at the moment.
> 
> But I would say that in addition to numbers showing that ext4 has trouble
> with unwritten extent conversion, we should have an explanation of
> why it can't be solved in a way that doesn't open up these concerns.
> 
> XFS certainly has different mechanisms, but is the demonstrated workload
> problematic on XFS (or btrfs) as well?  If not, can ext4 adopt any of the
> solutions that make the workload perform better on other filesystems?

When I've benchmarked this in the past, doing small random buffered writes
into an preallocated extent was dramatically (3x or more) slower on xfs
than doing them into a fully written extent.  That was two years ago,
but I can redo it.

On a fio card, this gets 16,000 iops on a preallocated extent and 40,000
iops if you run it a second time.  It's not random writes, but the fsync
probably means the preallocated conversion is more expensive.  That's
on a 4.0 kernel, but I'll rerun it on nvme on newer kernels.

fio --name=fsync --rw=write --fsync=1 --bs=4k --filename=/xfs/fio_4096  --size=4g --overwrite=0

I'm happy to run variations on things, just let me know what workloads
are interesting.

-chris
