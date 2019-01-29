From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 07:30:44 +0100
Message-ID: <20190129063043.GC2996@lst.de>
References: <20190123153536.7081-1-axboe@kernel.dk> <20190123153536.7081-6-axboe@kernel.dk> <20190128145700.GA9795@lst.de> <2729ab43-b2bf-44b0-d41d-dbb495ddffbf@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <2729ab43-b2bf-44b0-d41d-dbb495ddffbf@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-block@vger.kernel.org, jmoyer@redhat.com, avi@scylladb.com, linux-api@vger.kernel.org, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 28, 2019 at 11:25:12AM -0700, Jens Axboe wrote:
> > Especially with poll support now in the series, don't we need a ѕigmask
> > argument similar to pselect/ppoll/io_pgetevents now to deal with signal
> > blocking during waiting for events?
> 
> Is there any way to avoid passing in the sigset_t size? If it's just a
> 32-bit/64-bit thing, surely the in_compat_syscall() could cover it? Or
> are there other cases that need to be catered to?

As far as I can tell we never look at it, never looked at it and don't
have any plans to look at it anytime soon.  But when I tried to omit
it for io_pgetevents I got stong pushback and thus had to add the
crazy double indirection calling convention.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
