From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v3 2/3] fs: Convert kiocb rw_hint from enum to u16
Date: Wed, 9 May 2018 11:21:49 -0400
Message-ID: <20180509152149.GG28388@thunk.org>
References: <20180508174202.2537-1-adam.manzanares@wdc.com>
 <20180508174202.2537-3-adam.manzanares@wdc.com>
 <20180509133432.GD28388@thunk.org>
 <0aad993b-448c-3586-cfc0-f2e50b1dda28@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <0aad993b-448c-3586-cfc0-f2e50b1dda28@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, bcrl@kvack.org, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, May 09, 2018 at 08:23:00AM -0600, Jens Axboe wrote:
> Streams is essentially the only thing ki_hint is currently used for,
> with the write life time hints mapping to a stream. The idea for the
> user side API was to have other things than just write life time hints.
> 
> Since Adam wants to do priorities, he'd either need to pack into the
> existing ki_hint, or do this patch does, which is make it smaller and
> add a new member. I think the latter is cleaner.

Fair enough; but maybe we can use a u8 instead of a u16?  65,535
priorities still seem like way more than would ever make sense.  I
think 256 priorities is still way to many, but it's simpler while
still reserving number of bits for future se.

            		       	       	   - Ted

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
