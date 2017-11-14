From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 00/24] Restartable sequences and CPU op
 vector v11
Date: Tue, 14 Nov 2017 13:15:18 -0800
Message-ID: <CALCETrVMvk0dsBMF8F-gPZCGnfJt=RQOvTnVzJhVaAFhEFbq2w@mail.gmail.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com> <CA+55aFzZcQKEvu5S3TwD9MscqDhqq3pKa0Kam79NncjP8RnvoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzZcQKEvu5S3TwD9MscqDhqq3pKa0Kam79NncjP8RnvoQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Catalin Marinas <catalin.marinas@a>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 14, 2017 at 1:08 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Tue, Nov 14, 2017 at 12:03 PM, Mathieu Desnoyers
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> Here is the last RFC round of the updated rseq patchset containing:
>
> Andy? You were the one with concerns here and said you'd have
> something else ready for comparison.
>

I had a long discussion with Mathieu and KS and I think that this is a
good compromise.  I haven't reviewed the series all that carefully,
but I think the idea is sound.

Basically, event_counter is gone (to be re-added in a later kernel if
it really ends up being necessary, but it looks like it may primarily
be a temptation to write subtly incorrect user code and to see
scheduling details that shouldn't be readily exposed rather than a
genuinely useful feature) and the versioning mechanism for the asm
critical section bit is improved.  My crazy proposal should be doable
on top of this if there's demand and if anyone wants to write the
gnarly code involved.

IOW no objection from me as long as those changes were made, which I
*think* they were.  Mathieu?
