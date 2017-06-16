From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/10 v12] No wait AIO
Date: Fri, 16 Jun 2017 10:54:55 +0200
Message-ID: <20170616085455.GQ1764@quack2.suse.cz>
References: <20170615160002.17233-1-rgoldwyn@suse.de>
 <20170615112528.7cbdfd6cdf26a5c13450acdf@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170615112528.7cbdfd6cdf26a5c13450acdf@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On Thu 15-06-17 11:25:28, Andrew Morton wrote:
> On Thu, 15 Jun 2017 10:59:52 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:
> 
> > This series adds nonblocking feature to asynchronous I/O writes.
> > io_submit() can be delayed because of a number of reason:
> >  - Block allocation for files
> >  - Data writebacks for direct I/O
> >  - Sleeping because of waiting to acquire i_rwsem
> >  - Congested block device
> > 
> > The goal of the patch series is to return -EAGAIN/-EWOULDBLOCK if
> > any of these conditions are met. This way userspace can push most
> > of the write()s to the kernel to the best of its ability to complete
> > and if it returns -EAGAIN, can defer it to another thread.
> > 
> > In order to enable this, IOCB_RW_FLAG_NOWAIT is introduced in
> > uapi/linux/aio_abi.h. If set for aio_rw_flags, it translates to
> > IOCB_NOWAIT for struct iocb, REQ_NOWAIT for bio.bi_opf and IOMAP_NOWAIT for
> > iomap. aio_rw_flags is a new flag replacing aio_reserved1. We could
> > not use aio_flags because it is not currently checked for invalidity
> > in the kernel.
> > 
> > This feature is provided for direct I/O of asynchronous I/O only. I have
> > tested it against xfs, ext4, and btrfs while I intend to add more filesystems.
> > The nowait feature is for request based devices. In the future, I intend to
> > add support to stacked devices such as md.
> > 
> > Applications will have to check supportability by sending a async direct write
> > and any other error besides -EAGAIN would mean it is not supported.
> > 
> 
> How accurate it this?  For example, the changes to
> generic_file_direct_write() appear to greatly reduce the chances of
> blocking but there are surely race opportunities which will still
> result in userspace unexpectedly experiencing blocking in a succeednig
> write() call?

Yes, so you are right that there are still possibilities for blocking -
e.g. we could get blocked in reclaim when allocating memory somewhere. Now
we hope what Goldwyn did will be enough for practical purposes as in the
end this is an API to improve performance and so in the worst case app
won't get the performance it expects (this just has to be rare enough that
it all pays off in the end). Also if we spot some place that ends up to
cause blocking in practice, we'll work on improving that...
 
> If correct then I think there should be some discussion and perhaps
> testing results in the changelog.

Probably we could add a note to the first paragraph of the changelog of
patch 4/10 like: Note that we can still block (put the process submitting
IO to sleep) in some rare cases like when there is not enough free memory
or when acquiring some fs-internal sleeping locks.

WRT test results, Goldwyn has some functional tests (for xfstests). We also
have a customer that is working on testing the series with their workload
however that will take some time given it requires updating their software
stack. If you are looking for some synthetic benchmark results, I suppose
we can put something together however it's going to be just a synthetic
benchmark and as such the relevance is limited.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
