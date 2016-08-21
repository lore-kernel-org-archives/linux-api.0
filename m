From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Context switch latency in tickless isolated CPU
Date: Sun, 21 Aug 2016 07:53:02 -0700
Message-ID: <20160821145302.GP3482@linux.vnet.ibm.com>
References: <CANv7uPR+RidX41Jyzy-xpYqYHSPiw3TrBgAm11PzOfNEeP7wJA@mail.gmail.com>
 <86f3248c-defd-f200-9eb6-bdf420771745@mellanox.com>
 <CANv7uPSwu=nxYYjWQFABcyj6ZpAemHyXbn4JnZ6WaVJQd3RX4A@mail.gmail.com>
 <20160819123437.GE10121@twins.programming.kicks-ass.net>
 <CANv7uPRh4RiSXwpRsOooNAJumMj2TmiRc3Qq5_kwzf9SetE_FA@mail.gmail.com>
Reply-To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANv7uPRh4RiSXwpRsOooNAJumMj2TmiRc3Qq5_kwzf9SetE_FA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: GeHao Kang <kanghao0928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Aug 21, 2016 at 07:26:04PM +0800, GeHao Kang wrote:
> On Fri, Aug 19, 2016 at 8:34 PM, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
> > Why are you wanting to use nohz_full if you do syscalls?
> 
> We hope to reduce the overhead of the tick while the real time
> applications run,
> and these applications might do some syscalls to operate the I/O devices like
> EtherCAT.

If latency is all you care about, one approach is to map the device
registers into userspace and do the I/O without assistance from the
kernel.

Alternatively, use in-memory mailbox/queuing techniques to hand the
I/O off to some other thread.

							Thanx, Paul
