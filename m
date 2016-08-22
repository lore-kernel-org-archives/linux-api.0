From: Mark Hounschell <markh@compro.net>
Subject: Re: Context switch latency in tickless isolated CPU
Date: Mon, 22 Aug 2016 11:12:45 -0400
Message-ID: <5e71b00a-fe6c-6fbe-6a04-d62e96f9e1ba@compro.net>
References: <CANv7uPR+RidX41Jyzy-xpYqYHSPiw3TrBgAm11PzOfNEeP7wJA@mail.gmail.com>
 <86f3248c-defd-f200-9eb6-bdf420771745@mellanox.com>
 <CANv7uPSwu=nxYYjWQFABcyj6ZpAemHyXbn4JnZ6WaVJQd3RX4A@mail.gmail.com>
 <20160819123437.GE10121@twins.programming.kicks-ass.net>
 <CANv7uPRh4RiSXwpRsOooNAJumMj2TmiRc3Qq5_kwzf9SetE_FA@mail.gmail.com>
 <20160821145302.GP3482@linux.vnet.ibm.com>
 <CANv7uPQ8rSU8foZv1GiLStiNX0Z6e+7tnRLJ_v2fspY5NZ8nwg@mail.gmail.com>
 <20160822144804.GB3482@linux.vnet.ibm.com>
Reply-To: markh@compro.net
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160822144804.GB3482@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: paulmck@linux.vnet.ibm.com, GeHao Kang <kanghao0928@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Chris Metcalf <cmetcalf@mellanox.com>, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@kernel.org
List-Id: linux-api@vger.kernel.org

On 08/22/2016 10:48 AM, Paul E. McKenney wrote:
> On Mon, Aug 22, 2016 at 05:40:03PM +0800, GeHao Kang wrote:
>> On Sun, Aug 21, 2016 at 10:53 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>>> If latency is all you care about, one approach is to map the device
>>> registers into userspace and do the I/O without assistance from the
>>> kernel.
>> In addition to the context switch latency, local interrupts are also
>> closed during
>> user_enter and user_exit of the context tracking. Therefore, the interrupt
>> latency might be also increased on the isolated tickless CPU. That
>> will degrade the
>> real time performance. Are these two events determined?
>
> Hmmm...  Why would you be taking interrupts on your isolated tickless
> CPUs?  Doesn't that defeat the purpose of designating them as isolated
> and tickless?
>

Don't mean to butt in here but think about a "special" PCI card that 
does nothing but take an external interrupt or external interrupts from 
an outside source where the latency between the time it occurs on the 
outside and the time an isolated processor can act on that event. The 
IRQ of that card also being pinned/isolated to that processor. This is a 
very common thing in the RT world.

Mark

> The key point being that effective use of NO_HZ_FULL requires
> careful configuration and complete understanding of your workload.
> And it is quite possible that you instead need to use something
> other than NO_HZ_FULL.
>
> If your question is instead "why must interrupts be disabled during
> context tracking", I must defer to people who understand the x86
> entry/exit code paths better than I do.
>
> 							Thanx, Paul
>
>
