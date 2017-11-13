From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC PATCH 0/2] x86: Fix missing core serialization on migration
Date: Mon, 13 Nov 2017 09:14:42 -0800
Message-ID: <CA+55aFz9JuQbt93uJn6-aLUE2OJS9xiS928d77MJmBdQoQLKrQ@mail.gmail.com>
References: <20171110211249.10742-1-mathieu.desnoyers@efficios.com>
 <CA+55aFzbroWqi+FTdYhRVSwUZ-M0wDVxjXqDbh40JEnXc2LdgQ@mail.gmail.com>
 <885227610.13045.1510351034488.JavaMail.zimbra@efficios.com> <617343212.13932.1510592207202.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <617343212.13932.1510592207202.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, maged michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrea Parri <parri.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Russell King, ARM Linux" <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

On Mon, Nov 13, 2017 at 8:56 AM, Mathieu Desnoyers
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>
> I figured out what you're pointing to: if exec() is executed by a previously
> running thread, and there is no core serializing instruction between program
> load and return to user-space, the kernel ends up acting like a JIT, indeed.

Well, exec() is actually the least of our problems, because it will
have caused the virtual m apping to be set up too.

But we have had cases that haven't had that basically forever. Your
example of user-space doing an _unintentional_ cross-modification is
just such a case, but so is anybody doing their own code management in
user space by just reading their own executable into memory etc.

So part of the problem is that it's perfectly valid to generate code
and then just jump to it in x86 space as long as you stay on the same
CPU. And there has never been any guarantee that that you wouldn't be
migrated in between.

In _practice_, I suspect that migration events are much much too big
for this to be an issue at all. And the trigger for migration is going
to be something like a timer interrupt that causes us to reschedule in
the first place - which ends up serializing due to the iret. And even
if the rescheduling is done by one CPU just doing a "schedule()", us
doing a re-balancing of CPU's, and another CPU then picking up the
process, there's been tens of thousands of instructions, several
spinlocks, lots of cross-CPU synchronization etc going on.

I do not believe for a second that the CPU prefetching queue will be
active over those kinds of ranges and events.

So I don't really think the problem can actually occur in the first
place. I think the SDK rules are garbage.

But that's exactly why I'd actually really want to get some more real
rules from Intel and AMD. Because I think your patch is pointless, and
doesn't really fix anything in reality, but it's triggered by reading
the Intel SDK and going "in theory, this means that we would need to
do XYZ".

And when theory and practice do not match, I think (a) the theory is
bad, and (b) reality trumps theory.

In this case (b) means that I'm not super-eager to apply the patch,
and (a) means that since the theory is based on the Intel SDK, I think
 we should consider the Intel SDK to be a problem, and ask for
clarification of just what the rules really are.

            Linus
