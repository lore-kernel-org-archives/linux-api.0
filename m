From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH 0/3] epoll: Add epoll_pwait1 syscall
Date: Fri, 9 Jan 2015 09:52:48 +0800
Message-ID: <20150109015248.GA5034@fam-t430.nay.redhat.com>
References: <1420705550-24245-1-git-send-email-famz@redhat.com>
 <1420708372.18399.15.camel@suse.cz>
 <CALCETrVyPij1Zxwmw7p06UrZjoyYDXqEjmxyQ-KJ8Y7dx7mL3g@mail.gmail.com>
 <20150109011608.GA2924@fam-t430.nay.redhat.com>
 <CALCETrWHGwPw2cH3RruaCFKj2ND8PdEbdWjTi4OJ8m2eF9fpLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWHGwPw2cH3RruaCFKj2ND8PdEbdWjTi4OJ8m2eF9fpLw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <mszeredi@suse.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Juri Lelli <juri.lelli@gmail.com>, Zach Brown <zab@zabbo.net>, David Drysdale <drysdale@google.com>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Dario Faggioli <raistlin@linux.it>, Theodore Ts'o <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Oleg Nesterov <oleg@redhat.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

On Thu, 01/08 17:28, Andy Lutomirski wrote:
> On Thu, Jan 8, 2015 at 5:25 PM, Fam Zheng <famz@redhat.com> wrote:
> > On Thu, 01/08 09:57, Andy Lutomirski wrote:
> >> I'd like to see a more ambitious change, since the timer isn't the
> >> only problem like this.  Specifically, I'd like a syscall that does a
> >> list of epoll-related things and then waits.  The list of things could
> >> include, at least:
> >>
> >>  - EPOLL_CTL_MOD actions: level-triggered epoll users are likely to
> >> want to turn on and off their requests for events on a somewhat
> >> regular basis.
> >
> > This sounds good to me.
> >
> >>
> >>  - timerfd_settime actions: this allows a single syscall to wait and
> >> adjust *both* monotonic and real-time wakeups.
> >
> > I'm not sure, doesn't this break orthogonality between epoll and timerfd?
> 
> Yes.  It's not very elegant, and more elegant ideas are welcome.

What is the purpose of embedding timerfd operation here? Modifying timerfd
for each poll doesn't sound a common pattern to me.

> 
> >
> >>
> >> Would this make sense?  It could look like:
> >>
> >> int epoll_mod_and_pwait(int epfd,
> >>   struct epoll_event *events, int maxevents,
> >>   struct epoll_command *commands, int ncommands,
> >>   const sigset_t *sigmask);
> >
> > What about flags?
> >
> 
> No room.  Maybe it should just be a struct for everything instead of
> separate args.

Also no room for timeout. A single struct sounds the only way to go.

Fam
