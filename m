From: GeHao Kang <kanghao0928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Context switch latency in tickless isolated CPU
Date: Mon, 22 Aug 2016 17:40:03 +0800
Message-ID: <CANv7uPQ8rSU8foZv1GiLStiNX0Z6e+7tnRLJ_v2fspY5NZ8nwg@mail.gmail.com>
References: <CANv7uPR+RidX41Jyzy-xpYqYHSPiw3TrBgAm11PzOfNEeP7wJA@mail.gmail.com>
 <86f3248c-defd-f200-9eb6-bdf420771745@mellanox.com> <CANv7uPSwu=nxYYjWQFABcyj6ZpAemHyXbn4JnZ6WaVJQd3RX4A@mail.gmail.com>
 <20160819123437.GE10121@twins.programming.kicks-ass.net> <CANv7uPRh4RiSXwpRsOooNAJumMj2TmiRc3Qq5_kwzf9SetE_FA@mail.gmail.com>
 <20160821145302.GP3482@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160821145302.GP3482-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Aug 21, 2016 at 10:53 PM, Paul E. McKenney
<paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> If latency is all you care about, one approach is to map the device
> registers into userspace and do the I/O without assistance from the
> kernel.
In addition to the context switch latency, local interrupts are also
closed during
user_enter and user_exit of the context tracking. Therefore, the interrupt
latency might be also increased on the isolated tickless CPU. That
will degrade the
real time performance. Are these two events determined?

Thanks,
Kang
