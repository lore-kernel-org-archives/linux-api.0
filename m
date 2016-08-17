From: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Context switch latency in tickless isolated CPU
Date: Wed, 17 Aug 2016 08:18:59 -0400
Message-ID: <86f3248c-defd-f200-9eb6-bdf420771745@mellanox.com>
References: <CANv7uPR+RidX41Jyzy-xpYqYHSPiw3TrBgAm11PzOfNEeP7wJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANv7uPR+RidX41Jyzy-xpYqYHSPiw3TrBgAm11PzOfNEeP7wJA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: GeHao Kang <kanghao0928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 8/17/2016 2:26 AM, GeHao Kang wrote:
> To investigate the cause, I use the kernel event tracer to find out
> the events, user_enter and user_exit, of context_tracking would happen
> on tickless isolated CPU. These two events means that this CPU enters
> and exits the RCU extended quiescent state. Besides, the execution
> time of these two events are 3us and 2us,
> which are measured by ktime. Is this the reason why the context switch
> has higher
> latency on the tickless isolated CPU?

The increased context switch time is likely from the increased
time to return from the kernel to userspace, due to ensuring
that various things in the kernel are quiesced.

Of course I'm sure it goes without saying that context switch
time is probably near the absolute bottom of things that
we care about as a metric for task isolation, since when you
are using it as designed, you never actually context switch.
But that said, it's always good to quantify what the overheads
are, so thanks.

-- 
Chris Metcalf, Mellanox Technologies
http://www.mellanox.com
