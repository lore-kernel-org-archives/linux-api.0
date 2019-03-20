From: David Miller <davem@davemloft.net>
Subject: Re: [net-next PATCH v3 4/8] net: Change return type of
 sk_busy_loop from bool to void
Date: Wed, 20 Mar 2019 12:40:11 -0700 (PDT)
Message-ID: <20190320.124011.1280345923671369921.davem@davemloft.net>
References: <20170324164902.15226.48358.stgit@localhost.localdomain>
        <20170324170812.15226.97497.stgit@localhost.localdomain>
        <CALMXkpb3MfLbNoBgLJc0rgMDbPg9yOevKOiq9N8pzVw-aeNb3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALMXkpb3MfLbNoBgLJc0rgMDbPg9yOevKOiq9N8pzVw-aeNb3g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: christoph.paasch@gmail.com
Cc: alexander.duyck@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sridhar.samudrala@intel.com, edumazet@google.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Christoph Paasch <christoph.paasch@gmail.com>
Date: Wed, 20 Mar 2019 11:35:31 -0700

> On Fri, Mar 24, 2017 at 3:23 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
>> diff --git a/net/core/datagram.c b/net/core/datagram.c
>> index ea633342ab0d..4608aa245410 100644
>> --- a/net/core/datagram.c
>> +++ b/net/core/datagram.c
>> @@ -256,8 +256,12 @@ struct sk_buff *__skb_try_recv_datagram(struct sock *sk, unsigned int flags,
>>                 }
>>
>>                 spin_unlock_irqrestore(&queue->lock, cpu_flags);
>> -       } while (sk_can_busy_loop(sk) &&
>> -                sk_busy_loop(sk, flags & MSG_DONTWAIT));
>> +
>> +               if (!sk_can_busy_loop(sk))
>> +                       break;
>> +
>> +               sk_busy_loop(sk, flags & MSG_DONTWAIT);
>> +       } while (!skb_queue_empty(&sk->sk_receive_queue));
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

Just for the record, __skb_try_recv_datagram() and it's friend
__skb_try_recv_from_queue() are my least favorite functions in the
entire tree for the past year or so.

Their current design, and how they assume things about the
implementation of SKB queues, together result in all the weird
problems we keep fixing in them.

There has to be a much better way to do this.
