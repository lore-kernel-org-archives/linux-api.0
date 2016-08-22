From: Mark Hounschell <markh-n2QNKt385d+sTnJN9+BGXg@public.gmane.org>
Subject: Re: Context switch latency in tickless isolated CPU
Date: Mon, 22 Aug 2016 12:35:44 -0400
Message-ID: <205710c7-774c-0f9d-c336-72da56844646@compro.net>
References: <CANv7uPR+RidX41Jyzy-xpYqYHSPiw3TrBgAm11PzOfNEeP7wJA@mail.gmail.com>
 <86f3248c-defd-f200-9eb6-bdf420771745@mellanox.com>
 <CANv7uPSwu=nxYYjWQFABcyj6ZpAemHyXbn4JnZ6WaVJQd3RX4A@mail.gmail.com>
 <20160819123437.GE10121@twins.programming.kicks-ass.net>
 <CANv7uPRh4RiSXwpRsOooNAJumMj2TmiRc3Qq5_kwzf9SetE_FA@mail.gmail.com>
 <20160821145302.GP3482@linux.vnet.ibm.com>
 <CANv7uPQ8rSU8foZv1GiLStiNX0Z6e+7tnRLJ_v2fspY5NZ8nwg@mail.gmail.com>
 <20160822144804.GB3482@linux.vnet.ibm.com>
 <5e71b00a-fe6c-6fbe-6a04-d62e96f9e1ba@compro.net>
 <20160822153714.GC3482@linux.vnet.ibm.com>
Reply-To: markh-n2QNKt385d+sTnJN9+BGXg@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160822153714.GC3482-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Cc: GeHao Kang <kanghao0928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 08/22/2016 11:37 AM, Paul E. McKenney wrote:
> On Mon, Aug 22, 2016 at 11:12:45AM -0400, Mark Hounschell wrote:
>> On 08/22/2016 10:48 AM, Paul E. McKenney wrote:
>>> On Mon, Aug 22, 2016 at 05:40:03PM +0800, GeHao Kang wrote:
>>>> On Sun, Aug 21, 2016 at 10:53 PM, Paul E. McKenney
>>>> <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
>>>>> If latency is all you care about, one approach is to map the device
>>>>> registers into userspace and do the I/O without assistance from the
>>>>> kernel.
>>>> In addition to the context switch latency, local interrupts are also
>>>> closed during
>>>> user_enter and user_exit of the context tracking. Therefore, the interrupt
>>>> latency might be also increased on the isolated tickless CPU. That
>>>> will degrade the
>>>> real time performance. Are these two events determined?
>>>
>>> Hmmm...  Why would you be taking interrupts on your isolated tickless
>>> CPUs?  Doesn't that defeat the purpose of designating them as isolated
>>> and tickless?
>>
>> Don't mean to butt in here but think about a "special" PCI card that
>> does nothing but take an external interrupt or external interrupts
>> from an outside source where the latency between the time it occurs
>> on the outside and the time an isolated processor can act on that
>> event. The IRQ of that card also being pinned/isolated to that
>> processor. This is a very common thing in the RT world.
>
> In this case, the host OS would see an event-driven real-time workload
> from the PCI card, which would lead me to suggest -not- using NO_HZ_FULL
> on the host OS.
>
> Of course, if you are instead building an OS to run on the PCI card
> itself, then the choice of configuration would depend on how the PCI
> card was set up.  If it polled hardware, then NO_HZ_FULL on the PCI card
> might work quite well.  But then you wouldn't have interrupts (on the
> PCI card), so I am guessing that you mean the scenario covered in the
> first paragraph.
>
> Or am I missing your point?
>
> 							Thanx, Paul
>

First paragraph scenario is the one I was referring.

Thanks
Mark

>> Mark
>>
>>> The key point being that effective use of NO_HZ_FULL requires
>>> careful configuration and complete understanding of your workload.
>>> And it is quite possible that you instead need to use something
>>> other than NO_HZ_FULL.
>>>
>>> If your question is instead "why must interrupts be disabled during
>>> context tracking", I must defer to people who understand the x86
>>> entry/exit code paths better than I do.
>>>
>>> 							Thanx, Paul
>>>
>>>
>>
>
>
