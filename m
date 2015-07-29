From: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Next round: revised futex(2) man page for review
Date: Tue, 28 Jul 2015 21:11:41 -0700
Message-ID: <20150729041141.GE3171@vmdeb7>
References: <55B61EF3.7080302@gmail.com>
 <alpine.DEB.2.11.1507282054370.3825@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1507282054370.3825@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 28, 2015 at 10:23:51PM +0200, Thomas Gleixner wrote:
> On Mon, 27 Jul 2015, Michael Kerrisk (man-pages) wrote:

...

> >        FUTEX_REQUEUE (since Linux 2.6.0)
> > .\" FIXME(Torvald) Is there some indication that FUTEX_REQUEUE is broken
> > .\"     in general, or is this comment implicitly speaking about the
> > .\"     condvar (?) use case? If the latter we might want to weaken the
> > .\"     advice below a little.
> > .\" [Anyone else have input on this?]
> 
> The condvar use case exposes the flaw nicely, but that's pretty much
> true for everything which wants a sane requeue operation.

In an earlier discussion I argued this point (that FUTURE_REQUEUE is broken and
should not be used in new code) and someone argued strongly against... stating
that there were legitimate uses for it. Of course I'm struggling to find the
thread and the reference at the moment - immensely useful, I know.

I'll continue trying to find it and see if it can be useful here. I believe
Torvald was on the thread as well.

> 
> >               Avoid using this operation.  It is broken for its intended
> >               purpose.  Use FUTEX_CMP_REQUEUE instead.
> > 
> >               This    operation    performs    the    same    task    as
> >               FUTEX_CMP_REQUEUE, except that no check is made using  the
> >               value in val3.  (The argument val3 is ignored.)
> > 

-- 
Darren Hart
Intel Open Source Technology Center
