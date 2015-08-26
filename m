From: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Next round: revised futex(2) man page for review
Date: Tue, 25 Aug 2015 23:29:58 -0700
Message-ID: <20150826062958.GB50910@vmdeb7>
References: <55B61EF3.7080302@gmail.com>
 <alpine.DEB.2.11.1507282054370.3825@nanos>
 <55C5A787.9010806@gmail.com>
 <alpine.DEB.2.11.1508200042180.3873@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1508200042180.3873@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Aug 20, 2015 at 01:17:03AM +0200, Thomas Gleixner wrote:

...

> > >> .\" FIXME XXX In discussing errors for FUTEX_CMP_REQUEUE_PI, Darren Hart
> > >> .\"       made the observation that "EINVAL is returned if the non-pi 
> > >> .\"       to pi or op pairing semantics are violated."
> > >> .\"       Probably there needs to be a general statement about this
> > >> .\"       requirement, probably located at about this point in the page.
> > >> .\"       Darren (or someone else), care to take a shot at this?
> > > 
> > > Well, that's hard to describe because the kernel only has a limited
> > > way of detecting such mismatches. It only can detect it when there are
> > > non PI waiters on a futex and a PI function is called or vice versa.
> > 
> > Hmmm. Okay, I filed your comments away for reference, but
> > hopefully someone can help with some actual text.
> 
> I let Darren come up with something sensible :)

Heh, right, no pressure then...

I responded to Michael on this recently, copied here for reference:


FUTEX_WAIT_REQUEUE_PI can return -EINVAL if called with invalid parameters, such
as uaddr==uaddr2, or (in the case of SHARED futexes), the associated keys match
(meaning it's the same futex word - shared memory, inode, etc.). This can't
happen if the stated policy of requeueing from non-pi to pi is followed as the
same word cannot be both non-pi and pi at the same time, requiring them to be
unique futex words.

FUTEX_CMP_REQUEUE_PI will fail similarly if uaddr and uaddr2 are the same futex
word. Also, if nr_wake != 1.

But, to the point I was making above, FUTEX_CMP_REQUEUE_PI must requeue uaddr to
the same uaddr2 specified in the previous FUTEX_WAIT_REQUEUE_PI call.
FUTEX_WAIT_REQUEUE_PI sets up the operation, FUTEX_CMP_REQUEUE_PI completes it,
and they must agree on uaddr and uaddr2.


Michael, are you still looking for something more from me, or is this FIXME now
complete?



-- 
Darren Hart
Intel Open Source Technology Center
