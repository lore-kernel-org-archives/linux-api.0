From: Paolo Abeni <pabeni@redhat.com>
Subject: Re: [net-next PATCH v3 4/8] net: Change return type of sk_busy_loop
 from bool to void
Date: Thu, 21 Mar 2019 10:45:41 +0100
Message-ID: <e532fdb97e142eca2484e5abbeca4c30d11fbad6.camel@redhat.com>
References: <20170324164902.15226.48358.stgit@localhost.localdomain>
         <20170324170812.15226.97497.stgit@localhost.localdomain>
         <CALMXkpb3MfLbNoBgLJc0rgMDbPg9yOevKOiq9N8pzVw-aeNb3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALMXkpb3MfLbNoBgLJc0rgMDbPg9yOevKOiq9N8pzVw-aeNb3g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Paasch <christoph.paasch@gmail.com>, Alexander Duyck <alexander.duyck@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, sridhar.samudrala@intel.com, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

On Wed, 2019-03-20 at 11:35 -0700, Christoph Paasch wrote:
> Hello,
> 
> On Fri, Mar 24, 2017 at 3:23 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> > From: Alexander Duyck <alexander.h.duyck@intel.com>
> > 
> > > From what I can tell there is only a couple spots where we are actually
> > checking the return value of sk_busy_loop. As there are only a few
> > consumers of that data, and the data being checked for can be replaced
> > with a check for !skb_queue_empty() we might as well just pull the code
> > out of sk_busy_loop and place it in the spots that actually need it.
> > 
> > Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> > Acked-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  include/net/busy_poll.h |    5 ++---
> >  net/core/datagram.c     |    8 ++++++--
> >  net/core/dev.c          |   25 +++++++++++--------------
> >  net/sctp/socket.c       |    9 ++++++---
> >  4 files changed, 25 insertions(+), 22 deletions(-)
> > 
> > diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
> > index b82d6ba70a14..c55760f4820f 100644
> > --- a/include/net/busy_poll.h
> > +++ b/include/net/busy_poll.h
> > @@ -74,7 +74,7 @@ static inline bool busy_loop_timeout(unsigned long end_time)
> >         return time_after(now, end_time);
> >  }
> > 
> > -bool sk_busy_loop(struct sock *sk, int nonblock);
> > +void sk_busy_loop(struct sock *sk, int nonblock);
> > 
> >  #else /* CONFIG_NET_RX_BUSY_POLL */
> >  static inline unsigned long net_busy_loop_on(void)
> > @@ -97,9 +97,8 @@ static inline bool busy_loop_timeout(unsigned long end_time)
> >         return true;
> >  }
> > 
> > -static inline bool sk_busy_loop(struct sock *sk, int nonblock)
> > +static inline void sk_busy_loop(struct sock *sk, int nonblock)
> >  {
> > -       return false;
> >  }
> > 
> >  #endif /* CONFIG_NET_RX_BUSY_POLL */
> > diff --git a/net/core/datagram.c b/net/core/datagram.c
> > index ea633342ab0d..4608aa245410 100644
> > --- a/net/core/datagram.c
> > +++ b/net/core/datagram.c
> > @@ -256,8 +256,12 @@ struct sk_buff *__skb_try_recv_datagram(struct
> > sock *sk, unsigned int flags,
> >                 }
> > 
> >                 spin_unlock_irqrestore(&queue->lock, cpu_flags);
> > -       } while (sk_can_busy_loop(sk) &&
> > -                sk_busy_loop(sk, flags & MSG_DONTWAIT));
> > +
> > +               if (!sk_can_busy_loop(sk))
> > +                       break;
> > +
> > +               sk_busy_loop(sk, flags & MSG_DONTWAIT);
> > +       } while (!skb_queue_empty(&sk->sk_receive_queue));
> 
> since this change I am hitting stalls where it's looping in this
> while-loop with syzkaller.
> 
> It worked prior to this change because sk->sk_napi_id was not set thus
> sk_busy_loop would make us get out of the loop.
> 
> Now, it keeps on looping because there is an skb in the queue with
> skb->len == 0 and we are peeking with an offset, thus
> __skb_try_recv_from_queue will return NULL and thus we have no way of
> getting out of the loop.
> 
> I'm not sure what would be the best way to fix it. I don't see why we
> end up with an skb in the list with skb->len == 0. So, shooting a
> quick e-mail, maybe somebody has an idea :-)
> 
> I have the syzkaller-reproducer if needed.

IIRC we can have 0 len UDP packet sitting on sk_receive_queue since:

commit e6afc8ace6dd5cef5e812f26c72579da8806f5ac
Author: samanthakumar <samanthakumar@google.com>
Date:   Tue Apr 5 12:41:15 2016 -0400

    udp: remove headers from UDP packets before queueing

Both __skb_try_recv_datagram() and napi_busy_loop() assume that we
received some packets if the queue is not empty. When peeking such
assumption is not true, we should check if the last packet is changed,
as __skb_recv_datagram() already does. So I *think* the root cause of
this issue is older than Alex's patch.

The following - completely untested - should avoid the unbounded loop,
but it's not a complete fix, I *think* we should also change
sk_busy_loop_end() in a similar way, but that is a little more complex
due to the additional indirections.

Could you please test it?

Any feedback welcome!


Could you please test it?

Paolo
---
diff --git a/net/core/datagram.c b/net/core/datagram.c
index b2651bb6d2a3..e657289db4ac 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -279,7 +279,7 @@ struct sk_buff *__skb_try_recv_datagram(struct sock
*sk, unsigned int flags,
                        break;
 
                sk_busy_loop(sk, flags & MSG_DONTWAIT);
-       } while (!skb_queue_empty(&sk->sk_receive_queue));
+       } while (sk->sk_receive_queue.prev != *last);
 
        error = -EAGAIN;
