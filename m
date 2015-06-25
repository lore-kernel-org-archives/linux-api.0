From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences: fast user-space percpu
 critical sections
Date: Wed, 24 Jun 2015 17:07:28 -0700
Message-ID: <CALCETrXAtYDZBbpwZceFyhLOnqFmTDqTxhGfbrrVrY+34cxSFg@mail.gmail.com>
References: <20150624222609.6116.86035.stgit@kitami.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150624222609.6116.86035.stgit-tdHu5vqousHHt/MElyovVYaSKrA+ACpX0E9HWUfgJXw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 24, 2015 at 3:26 PM, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> This is a fairly small series demonstrating a feature we've found to be quite
> powerful in practice, "restartable sequences".
>

On an extremely short glance, I'm starting to think that the right
approach, at least for x86, is to implement per-cpu gsbase.  Then you
could do cmpxchg with a gs prefix to atomically take a percpu lock and
atomically release a percpu lock and check whether someone else stole
the lock from you.  (Note: cmpxchg, unlike lock cmpxchg, is very
fast.)

This is totally useless for other architectures, but I think it would
be reasonable clean on x86.  Thoughts?

I can elaborate if necessary.

--Andy
