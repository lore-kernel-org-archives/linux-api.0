From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Fri, 27 Mar 2015 01:18:22 -0700
Message-ID: <20150327081822.GA28669@infradead.org>
References: <cover.1426528417.git.milosz@adfin.com>
 <20150326202824.65d03787.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150326202824.65d03787.akpm@linux-foundation.org>
Sender: owner-linux-aio@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 26, 2015 at 08:28:24PM -0700, Andrew Morton wrote:
> I still don't understand why pwritev() exists.  We discussed this last
> time but it seems nothing has changed.  I'm not seeing here an adequate
> description of why it exists nor a justification for its addition.

pwritev2?  I have patches to support per-I/O O_DSYNC with it, lots of
folks including Samba and SCSI targets want this because their protocols
support it.  The patches were posted with earlier versions of Miklos
series.

It's cleaner to add the two system calls in go when we plan using them
anyway and have symmetric infrastructure, and I did not hear any
disagreement with that on LSF.  Did you skip this session?

> And (again) we've discussed this before, but the patchset gets resent
> as if nothing had happened.

We had long discussiosn about it both here and at LSF.  We had everyone
agree and nod there, and only your repeated argument here, so maybe it's
not Miklos who is disonnected but you?

Also that whole fincore argument is rather hypothetic - it's only been
pushed in to ugly to live multiplexers that also expose things like
pfns,  while with preadv2 we have a trivial and easy to use API read to
merge, and various consumerms just waiting for it.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
