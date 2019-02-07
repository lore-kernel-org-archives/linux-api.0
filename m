From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Thu, 7 Feb 2019 04:05:48 +0000
Message-ID: <20190207040547.GX2217@ZenIV.linux.org.uk>
References: <20190129192702.3605-1-axboe@kernel.dk>
 <20190129192702.3605-14-axboe@kernel.dk>
 <CAG48ez2kLWUEambWesQQaeVn_u=PtjuMeDUc49yamhYspfd7Sg@mail.gmail.com>
 <20190204025612.GR2217@ZenIV.linux.org.uk>
 <785c6db4-095e-65b0-ded5-72b41af5174e@kernel.dk>
 <2b2137ed-8107-f7b6-f0ca-202dcfb87c97@kernel.dk>
 <40b27e78-9ee8-1395-feb3-a73aac87c9a7@kernel.dk>
 <0d2e5085-32ff-e86e-d628-6000071fd132@kernel.dk>
 <20190206010104.GV2217@ZenIV.linux.org.uk>
 <608c1102-5818-e38c-cfc7-b1cec5a1ecb4@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <608c1102-5818-e38c-cfc7-b1cec5a1ecb4@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Jann Horn <jannh@google.com>, linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Feb 06, 2019 at 10:56:41AM -0700, Jens Axboe wrote:
> On 2/5/19 6:01 PM, Al Viro wrote:
> > On Tue, Feb 05, 2019 at 05:27:29PM -0700, Jens Axboe wrote:
> > 
> >> This should be better, passes some basic testing, too:
> >>
> >> http://git.kernel.dk/cgit/linux-block/commit/?h=io_uring&id=01a93aa784319a02ccfa6523371b93401c9e0073
> >>
> >> Verified that we're grabbing the right refs, and don't hold any
> >> ourselves. For the file registration, forbid registration of the
> >> io_uring fd, as that is pointless and will introduce a loop regardless
> >> of fd passing.
> > 
> > *shrug*
> > 
> > So pass it to AF_UNIX socket and register _that_ - does't change the
> > underlying problem.
> 
> Maybe I'm being dense here, but it's an f_op match. Should catch a
> passed fd as well, correct?

f_op match on _what_?

> With that, how can there be a loop?

	io_uring_fd = ....
	socketpair(PF_UNIX, SOCK_STREAM, 0, sock_fds);
	register sock_fds[0] and sock_fds[1] to io_uring_fd
	send SCM_RIGHTS datagram with io_uring_fd to sock_fds[0]
	close sock_fds[0], sock_fds[1] and io_uring_fd

And there's your unreachable loop.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
