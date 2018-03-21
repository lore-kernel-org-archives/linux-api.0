From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 12/28] net: convert datagram_poll users tp ->poll_mask
Date: Wed, 21 Mar 2018 10:11:57 +0100
Message-ID: <20180321091157.GH14085@kroah.com>
References: <20180321074032.14211-1-hch@lst.de>
 <20180321074032.14211-13-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <20180321074032.14211-13-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Mar 21, 2018 at 08:40:16AM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/isdn/mISDN/socket.c        |  2 +-
>  drivers/net/ppp/pppoe.c            |  2 +-
>  drivers/staging/ipx/af_ipx.c       |  2 +-
>  drivers/staging/irda/net/af_irda.c |  6 +++---

irda is now gone in linux-next, but that's an easy thing to handle when
merging.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
