From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Context switch latency in tickless isolated CPU
Date: Mon, 22 Aug 2016 07:48:04 -0700
Message-ID: <20160822144804.GB3482@linux.vnet.ibm.com>
References: <CANv7uPR+RidX41Jyzy-xpYqYHSPiw3TrBgAm11PzOfNEeP7wJA@mail.gmail.com>
 <86f3248c-defd-f200-9eb6-bdf420771745@mellanox.com>
 <CANv7uPSwu=nxYYjWQFABcyj6ZpAemHyXbn4JnZ6WaVJQd3RX4A@mail.gmail.com>
 <20160819123437.GE10121@twins.programming.kicks-ass.net>
 <CANv7uPRh4RiSXwpRsOooNAJumMj2TmiRc3Qq5_kwzf9SetE_FA@mail.gmail.com>
 <20160821145302.GP3482@linux.vnet.ibm.com>
 <CANv7uPQ8rSU8foZv1GiLStiNX0Z6e+7tnRLJ_v2fspY5NZ8nwg@mail.gmail.com>
Reply-To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANv7uPQ8rSU8foZv1GiLStiNX0Z6e+7tnRLJ_v2fspY5NZ8nwg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: GeHao Kang <kanghao0928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Aug 22, 2016 at 05:40:03PM +0800, GeHao Kang wrote:
> On Sun, Aug 21, 2016 at 10:53 PM, Paul E. McKenney
> <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> > If latency is all you care about, one approach is to map the device
> > registers into userspace and do the I/O without assistance from the
> > kernel.
> In addition to the context switch latency, local interrupts are also
> closed during
> user_enter and user_exit of the context tracking. Therefore, the interrupt
> latency might be also increased on the isolated tickless CPU. That
> will degrade the
> real time performance. Are these two events determined?

Hmmm...  Why would you be taking interrupts on your isolated tickless
CPUs?  Doesn't that defeat the purpose of designating them as isolated
and tickless?

The key point being that effective use of NO_HZ_FULL requires
careful configuration and complete understanding of your workload.
And it is quite possible that you instead need to use something
other than NO_HZ_FULL.

If your question is instead "why must interrupts be disabled during
context tracking", I must defer to people who understand the x86
entry/exit code paths better than I do.

							Thanx, Paul
