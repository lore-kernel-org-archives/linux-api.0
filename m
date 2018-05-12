From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/32] net/tcp: convert to ->poll_mask
Date: Sat, 12 May 2018 12:09:50 +0200
Message-ID: <20180512100950.GA5954@lst.de>
References: <20180511110803.10910-1-hch@lst.de> <20180511110803.10910-15-hch@lst.de> <96284b0e-0d4e-a944-4fd5-933d12cf53cb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <96284b0e-0d4e-a944-4fd5-933d12cf53cb@gmail.com>
Sender: owner-linux-aio@kvack.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, viro@zeniv.linux.org.uk, Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, May 11, 2018 at 06:13:11AM -0700, Eric Dumazet wrote:
> > +struct wait_queue_head *tcp_get_poll_head(struct socket *sock, __poll_t events)
> > +{
> > +	sock_poll_busy_loop(sock, events);
> > +	sock_rps_record_flow(sock->sk);
> 
> Why are you adding sock_rps_record_flow() ?

Because I mismerged the removal of it from tcp_poll in
'net: revert "Update RFS target at poll for tcp/udp"'

Thanks for the headsup, this will be removed for the next version.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
