From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] io_uring: add support for barrier fsync
Date: Tue, 9 Apr 2019 11:17:42 -0700
Message-ID: <20190409181742.GA24925@infradead.org>
References: <7c7276e4-8ffa-495a-6abf-926a58ee899e@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7c7276e4-8ffa-495a-6abf-926a58ee899e@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Apr 09, 2019 at 10:27:43AM -0600, Jens Axboe wrote:
> It's a quite common use case to issue a bunch of writes, then an fsync
> or fdatasync when they complete. Since io_uring doesn't guarantee any
> type of ordering, the application must track issued writes and wait
> with the fsync issue until they have completed.
> 
> Add an IORING_FSYNC_BARRIER flag that helps with this so the application
> doesn't have to do this manually. If this flag is set for the fsync
> request, we won't issue it until pending IO has already completed.

I think we need a much more detailed explanation of the semantics,
preferably in man page format.

Barrier at least in Linux traditionally means all previously submitted
requests have finished and no new ones are started until the
barrier request finishes, which is very heavy handed.  Is that what
this is supposed to do?  If not what are the exact guarantees vs
ordering and or barrier semantics?
