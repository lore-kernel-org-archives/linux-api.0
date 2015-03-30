From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Mon, 30 Mar 2015 13:26:25 -0700
Message-ID: <20150330132625.52b1250527ca3dcda79e349e@linux-foundation.org>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326202824.65d03787.akpm@linux-foundation.org>
	<20150327081822.GA28669@infradead.org>
	<20150327013516.8c6788be.akpm@linux-foundation.org>
	<20150327084833.GA7689@infradead.org>
	<20150327020159.eadd0ce1.akpm@linux-foundation.org>
	<20150327155854.GA5548@samba2>
	<20150330073604.GB22229@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20150330073604.GB22229@infradead.org>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Allison <jra@samba.org>, Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>
List-Id: linux-api@vger.kernel.org

On Mon, 30 Mar 2015 00:36:04 -0700 Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Mar 27, 2015 at 08:58:54AM -0700, Jeremy Allison wrote:
> > The problem with the above is that we can't tell the difference
> > between pread2() returning a short read because the pages are not
> > in cache, or because someone truncated the file. So we need some
> > way to differentiate this.
> 
> Is a race vs truncate really that time critical that you can't
> wait for the thread pool to do the second read to notice it?
> 
> > My preference from userspace would be for pread2() to return
> > EAGAIN if *all* the data requested is not available (where
> > 'all' can be less than the size requested if the file has
> > been truncated in the meantime).
> 
> That is easily implementable, but I can see that for example web apps
> would be happy to get as much as possible.  So if Samba can be ok
> with short reads and only detecting the truncated case in the slow
> path that would make life simpler.  Otherwise we might indeed need two
> flags.

The problem is that many applications (including samba!) want
all-or-nothing behaviour, and preadv2() cannot provide it.  By the time
preadv2() discovers a not-present page, it has already copied bulk data
out to userspace.

To fix this, preadv2() would need to take two passes across the pages,
pinning them in between and somehow blocking out truncate.  That's a
big change.

With the current preadv2(), applications would have to do

	nr_read = preadv2(..., offset, len, ...);
	if (nr_read == len)
		process data;
	else
		punt(offset + nr_read, len - nr_read);

and the worker thread will later have to splice together the initial
data and the later-arriving data, probably on another CPU, probably
after the initial data has gone cache-cold.

A cleaner solution is

	if (fincore(fd, NULL, offset, len) == len) {
		preadv(..., offset, len);
		process data;
	} else {
		punt(offset, len);
	}

This way all the data gets copied in a single hit and is cache-hot when
userspace processes it.

Comparing fincore()+pread() to preadv2():

pros:

a) fincore() may be used to provide both all-or-nothing and
   part-read-ok behaviour cleanly and with optimum cache behaviour.

b) fincore() doesn't add overhead, complexity and stack depth to
   core pagecache read() code.  Nor does it expand VFS data structures.

c) with a non-NULL second argument, fincore provides the
   mincore()-style page map.

cons:

d) fincore() is more expensive

e) fincore() will very occasionally block


Tradeoffs are involved.  To decide on the best path we should examine
d).  I expect that the overhead will be significant for small reads but
not significant for medium and large reads.  Needs quantifying.

And I don't believe that e) will be a problem in the real world.  It's
a significant increase in worst-case latency and a negligible increase
in average latency.  I've asked at least three times for someone to
explain why this is unacceptable and no explanation has been provided.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
