From: GeHao Kang <kanghao0928@gmail.com>
Subject: Re: Context switch latency in tickless isolated CPU
Date: Thu, 18 Aug 2016 11:25:00 +0800
Message-ID: <CANv7uPSwu=nxYYjWQFABcyj6ZpAemHyXbn4JnZ6WaVJQd3RX4A@mail.gmail.com>
References: <CANv7uPR+RidX41Jyzy-xpYqYHSPiw3TrBgAm11PzOfNEeP7wJA@mail.gmail.com>
 <86f3248c-defd-f200-9eb6-bdf420771745@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <86f3248c-defd-f200-9eb6-bdf420771745@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: fweisbec@gmail.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, paulmck@linux.vnet.ibm.com
List-Id: linux-api@vger.kernel.org

Hi Chris,

Thanks for your reply.

Is the increased time fixed in each context switch? Because this increased time
will be the latency of the real time application, we hope to confirm it.
Thanks.


Regards,
- Kang



On Wed, Aug 17, 2016 at 8:18 PM, Chris Metcalf <cmetcalf@mellanox.com> wrote:
> On 8/17/2016 2:26 AM, GeHao Kang wrote:
>>
>> To investigate the cause, I use the kernel event tracer to find out
>> the events, user_enter and user_exit, of context_tracking would happen
>> on tickless isolated CPU. These two events means that this CPU enters
>> and exits the RCU extended quiescent state. Besides, the execution
>> time of these two events are 3us and 2us,
>> which are measured by ktime. Is this the reason why the context switch
>> has higher
>> latency on the tickless isolated CPU?
>
>
> The increased context switch time is likely from the increased
> time to return from the kernel to userspace, due to ensuring
> that various things in the kernel are quiesced.
>
> Of course I'm sure it goes without saying that context switch
> time is probably near the absolute bottom of things that
> we care about as a metric for task isolation, since when you
> are using it as designed, you never actually context switch.
> But that said, it's always good to quantify what the overheads
> are, so thanks.
>
> --
> Chris Metcalf, Mellanox Technologies
> http://www.mellanox.com
>
