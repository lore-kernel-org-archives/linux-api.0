From: Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Revised futex(2) man page for review
Date: Wed, 15 Apr 2015 12:28:45 +0200
Message-ID: <1429093725.2909.29.camel@triegel.csb>
References: <55166C01.7000803@gmail.com>
	 <20150328114725.GJ27490@worktop.programming.kicks-ass.net>
	 <alpine.DEB.2.11.1504142323290.3845@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.11.1504142323290.3845@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty@rustcorp.c>
List-Id: linux-api@vger.kernel.org

On Tue, 2015-04-14 at 23:40 +0200, Thomas Gleixner wrote:
> On Sat, 28 Mar 2015, Peter Zijlstra wrote:
> > On Sat, Mar 28, 2015 at 09:53:21AM +0100, Michael Kerrisk (man-pages) wrote:
> > > So, please take a look at the page below. At this point,
> > > I would most especially appreciate help with the FIXMEs.
> > 
> > For people who cannot read that troff gibberish (me)..
> 
> Ditto :)
>  
> > NOTES
> >        Glibc does not provide a wrapper for this system call;  call  it  using
> >        syscall(2).
> 
> You might mention that pthread_mutex, pthread_condvar interfaces are
> high level wrappers for the syscall and recommended to be used for
> normal use cases. IIRC unnamed semaphores are implemented with futexes
> as well.

If we add this, I'd rephrase it to something like that there are
high-level programming abstractions such as the pthread_condvar
interfaces or semaphores that are implemented using the syscall and that
are typically a better fit for normal use cases.  I'd consider only the
condvars as something like a wrapper, or targeting a similar use case.
