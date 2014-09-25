From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC v3 0/4] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Thu, 25 Sep 2014 13:16:55 +0200
Message-ID: <20140925111655.GA8169@quack.suse.cz>
References: <cover.1410810247.git.milosz@adfin.com>
 <cover.1411594644.git.milosz@adfin.com>
 <CAHO5Pa2AbW+ndgUBjjB==NnwQjVuvbYaYdW8v0x-CjYYQEr9AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <CAHO5Pa2AbW+ndgUBjjB==NnwQjVuvbYaYdW8v0x-CjYYQEr9AA@mail.gmail.com>
Sender: owner-linux-aio@kvack.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Milosz Tanski <milosz@adfin.com>, Linux Kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-aio <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu 25-09-14 06:06:14, Michael Kerrisk wrote:
> Hello Milosz,
> 
> On Wed, Sep 24, 2014 at 11:46 PM, Milosz Tanski <milosz@adfin.com> wrote:
> > This patcheset introduces an ability to perform a non-blocking read from
> > regular files in buffered IO mode. This works by only for those filesystems
> > that have data in the page cache.
> >
> > It does this by introducing new syscalls new syscalls preadv2/pwritev2. These
> > new syscalls behave like the network sendmsg, recvmsg syscalls that accept an
> > extra flag argument (RWF_NONBLOCK).
> >
> > It's a very common patern today (samba, libuv, etc..) use a large threadpool to
> > perform buffered IO operations. They submit the work form another thread
> > that performs network IO and epoll or other threads that perform CPU work. This
> > leads to increased latency for processing, esp. in the case of data that's
> > already cached in the page cache.
> >
> > With the new interface the applications will now be able to fetch the data in
> > their network / cpu bound thread(s) and only defer to a threadpool if it's not
> > there. In our own application (VLDB) we've observed a decrease in latency for
> > "fast" request by avoiding unnecessary queuing and having to swap out current
> > tasks in IO bound work threads.
> 
> Since this is a change to the user-space API, could you CC future
> versions of this patch set to linux-api@vgerr.kernel.org please, as
  There's typo in the address. It should be:
linux-api@vger.kernel.org

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
