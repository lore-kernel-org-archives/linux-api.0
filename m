From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 28/28] random: convert to ->poll_mask
Date: Wed, 21 Mar 2018 10:10:47 +0100
Message-ID: <20180321091047.GG14085@kroah.com>
References: <20180321074032.14211-1-hch@lst.de>
 <20180321074032.14211-29-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180321074032.14211-29-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 08:40:32AM +0100, Christoph Hellwig wrote:
> The big change is that random_read_wait and random_write_wait are merged
> into a single waitqueue that uses keyed wakeups.  Because wait_event_*
> doesn't know about that this will lead to occassional spurious wakeups
> in _random_read and add_hwgenerator_randomness, but wait_event_* is
> designed to handle these and were are not in a a hot path there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/char/random.c | 27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
