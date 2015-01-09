From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH 0/3] epoll: Add epoll_pwait1 syscall
Date: Fri, 9 Jan 2015 12:49:08 +0800
Message-ID: <20150109044908.GA10966@fam-t430.nay.redhat.com>
References: <1420705550-24245-1-git-send-email-famz@redhat.com>
 <1420708372.18399.15.camel@suse.cz>
 <CALCETrVyPij1Zxwmw7p06UrZjoyYDXqEjmxyQ-KJ8Y7dx7mL3g@mail.gmail.com>
 <20150109011608.GA2924@fam-t430.nay.redhat.com>
 <CALCETrWHGwPw2cH3RruaCFKj2ND8PdEbdWjTi4OJ8m2eF9fpLw@mail.gmail.com>
 <20150109015248.GA5034@fam-t430.nay.redhat.com>
 <CALCETrU+MKWCh1FBqvuf3MGo3dTcmdktcM4aVZZGGUAmDNoWtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrU+MKWCh1FBqvuf3MGo3dTcmdktcM4aVZZGGUAmDNoWtg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <mszeredi@suse.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Juri Lelli <juri.lelli@gmail.com>, Zach Brown <zab@zabbo.net>, David Drysdale <drysdale@google.com>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Dario Faggioli <raistlin@linux.it>, Theodore Ts'o <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Oleg Nesterov <oleg@redhat.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
List-Id: linux-api@vger.kernel.org

On Thu, 01/08 18:24, Andy Lutomirski wrote:
> On Thu, Jan 8, 2015 at 5:52 PM, Fam Zheng <famz@redhat.com> wrote:
> > On Thu, 01/08 17:28, Andy Lutomirski wrote:
> >> On Thu, Jan 8, 2015 at 5:25 PM, Fam Zheng <famz@redhat.com> wrote:
> >> > On Thu, 01/08 09:57, Andy Lutomirski wrote:
> >> >> I'd like to see a more ambitious change, since the timer isn't the
> >> >> only problem like this.  Specifically, I'd like a syscall that does a
> >> >> list of epoll-related things and then waits.  The list of things could
> >> >> include, at least:
> >> >>
> >> >>  - EPOLL_CTL_MOD actions: level-triggered epoll users are likely to
> >> >> want to turn on and off their requests for events on a somewhat
> >> >> regular basis.
> >> >
> >> > This sounds good to me.
> >> >
> >> >>
> >> >>  - timerfd_settime actions: this allows a single syscall to wait and
> >> >> adjust *both* monotonic and real-time wakeups.
> >> >
> >> > I'm not sure, doesn't this break orthogonality between epoll and timerfd?
> >>
> >> Yes.  It's not very elegant, and more elegant ideas are welcome.
> >
> > What is the purpose of embedding timerfd operation here? Modifying timerfd
> > for each poll doesn't sound a common pattern to me.
> 
> Setting a timeout is definitely a common pattern, hence this thread.
> But the current timeout interface sucks, and people should really use
> absolute time.  (My epoll software uses absolute time.)  But then
> users need to decide whether to have their timeout based on the
> monotonic clock or the realtime clock (or something else entirely).
> Some bigger programs may want both -- they may have internal events
> queued for certain times and for certain timeouts, and those should
> use realtime and monotonic respectively.  Heck, users may also want
> separate slack values on those.
> 
> Timerfd is the only thing we have right now that is anywhere near
> flexible enough.  Obviously if epoll became fancy enough, then we
> could do away with the timerfd entirely here.
> 
> >
> >>
> >> >
> >> >>
> >> >> Would this make sense?  It could look like:
> >> >>
> >> >> int epoll_mod_and_pwait(int epfd,
> >> >>   struct epoll_event *events, int maxevents,
> >> >>   struct epoll_command *commands, int ncommands,
> >> >>   const sigset_t *sigmask);
> >> >
> >> > What about flags?
> >> >
> >>
> >> No room.  Maybe it should just be a struct for everything instead of
> >> separate args.
> >
> > Also no room for timeout. A single struct sounds the only way to go.
> 
> That's what timerfd is for.  I think it would be a bit weird to
> support "timeout" and detailed timerfd control.

I see what you mean. Thanks.

I still don't like hooking timerfd in the interface. Besides the unclean
interface, it also feels cubersome and overkill to let users setup and add a
dedicated timerfd to implement timeout.

How about this:

int epoll_mod_wait(int epfd, struct epoll_mod_wait_data *data);

struct epoll_mod_wait_data {
	struct epoll_event *events;
	int maxevents;
	struct epoll_mod_cmd {
		int op,
		int fd;
		void *data;
	} *cmds;
	int ncmds;
	int flags;
	sigset_t *sigmask;
};

Commands ops are:

	EPOLL_CTL_ADD
		@fd is the fd to modify; @data is epoll_event.
	EPOLL_CTL_MOD
		@fd is the fd to modify; @data is epoll_event.
	EPOLL_CTL_DEL
		@fd is the fd to modify; @data is epoll_event.

	EPOLL_CTL_SET_TIMEOUT
		@fd is ignored, @data is timespec.
		Clock type and relative/absolute are selected by flags as below.

Flags are given to override timeout defaults:
	EPOLL_FL_MONOTONIC_CLOCK
		If set, don't use realtime clock, use monotonic clock.
	EPOLL_FL_ABSOLUTE_TIMEOUT
		If set, don't use relative timeout, use absolute timeout.

Thanks,
Fam
