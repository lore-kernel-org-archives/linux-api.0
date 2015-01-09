From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 0/3] epoll: Add epoll_pwait1 syscall
Date: Thu, 8 Jan 2015 21:21:29 -0800
Message-ID: <20150109052129.GA6831@thin>
References: <1420705550-24245-1-git-send-email-famz@redhat.com>
 <1420708372.18399.15.camel@suse.cz>
 <CALCETrVyPij1Zxwmw7p06UrZjoyYDXqEjmxyQ-KJ8Y7dx7mL3g@mail.gmail.com>
 <20150109011608.GA2924@fam-t430.nay.redhat.com>
 <CALCETrWHGwPw2cH3RruaCFKj2ND8PdEbdWjTi4OJ8m2eF9fpLw@mail.gmail.com>
 <20150109015248.GA5034@fam-t430.nay.redhat.com>
 <CALCETrU+MKWCh1FBqvuf3MGo3dTcmdktcM4aVZZGGUAmDNoWtg@mail.gmail.com>
 <20150109044908.GA10966@fam-t430.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150109044908.GA10966@fam-t430.nay.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Miklos Szeredi <mszeredi@suse.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Juri Lelli <juri.lelli@gmail.com>, Zach Brown <zab@zabbo.net>, David Drysdale <drysdale@google.com>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@plumgrid.com>, David Herrmann <dh.herrmann@gmail.com>, Dario Faggioli <raistlin@linux.it>, Theodore Ts'o <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Oleg Nesterov <oleg@redhat.com>, Mathieu
List-Id: linux-api@vger.kernel.org

On Fri, Jan 09, 2015 at 12:49:08PM +0800, Fam Zheng wrote:
> On Thu, 01/08 18:24, Andy Lutomirski wrote:
> > On Thu, Jan 8, 2015 at 5:52 PM, Fam Zheng <famz@redhat.com> wrote:
> > > On Thu, 01/08 17:28, Andy Lutomirski wrote:
> > >> On Thu, Jan 8, 2015 at 5:25 PM, Fam Zheng <famz@redhat.com> wrote:
> > >> > On Thu, 01/08 09:57, Andy Lutomirski wrote:
> > >> >> I'd like to see a more ambitious change, since the timer isn't the
> > >> >> only problem like this.  Specifically, I'd like a syscall that does a
> > >> >> list of epoll-related things and then waits.  The list of things could
> > >> >> include, at least:
> > >> >>
> > >> >>  - EPOLL_CTL_MOD actions: level-triggered epoll users are likely to
> > >> >> want to turn on and off their requests for events on a somewhat
> > >> >> regular basis.
> > >> >
> > >> > This sounds good to me.
> > >> >
> > >> >>
> > >> >>  - timerfd_settime actions: this allows a single syscall to wait and
> > >> >> adjust *both* monotonic and real-time wakeups.
> > >> >
> > >> > I'm not sure, doesn't this break orthogonality between epoll and timerfd?
> > >>
> > >> Yes.  It's not very elegant, and more elegant ideas are welcome.
> > >
> > > What is the purpose of embedding timerfd operation here? Modifying timerfd
> > > for each poll doesn't sound a common pattern to me.
> > 
> > Setting a timeout is definitely a common pattern, hence this thread.
> > But the current timeout interface sucks, and people should really use
> > absolute time.  (My epoll software uses absolute time.)  But then
> > users need to decide whether to have their timeout based on the
> > monotonic clock or the realtime clock (or something else entirely).
> > Some bigger programs may want both -- they may have internal events
> > queued for certain times and for certain timeouts, and those should
> > use realtime and monotonic respectively.  Heck, users may also want
> > separate slack values on those.
> > 
> > Timerfd is the only thing we have right now that is anywhere near
> > flexible enough.  Obviously if epoll became fancy enough, then we
> > could do away with the timerfd entirely here.
> > 
> > >
> > >>
> > >> >
> > >> >>
> > >> >> Would this make sense?  It could look like:
> > >> >>
> > >> >> int epoll_mod_and_pwait(int epfd,
> > >> >>   struct epoll_event *events, int maxevents,
> > >> >>   struct epoll_command *commands, int ncommands,
> > >> >>   const sigset_t *sigmask);
> > >> >
> > >> > What about flags?
> > >> >
> > >>
> > >> No room.  Maybe it should just be a struct for everything instead of
> > >> separate args.
> > >
> > > Also no room for timeout. A single struct sounds the only way to go.
> > 
> > That's what timerfd is for.  I think it would be a bit weird to
> > support "timeout" and detailed timerfd control.
> 
> I see what you mean. Thanks.
> 
> I still don't like hooking timerfd in the interface. Besides the unclean
> interface, it also feels cubersome and overkill to let users setup and add a
> dedicated timerfd to implement timeout.
> 
> How about this:
> 
> int epoll_mod_wait(int epfd, struct epoll_mod_wait_data *data);
> 
> struct epoll_mod_wait_data {
> 	struct epoll_event *events;
> 	int maxevents;
> 	struct epoll_mod_cmd {
> 		int op,
> 		int fd;
> 		void *data;
> 	} *cmds;
> 	int ncmds;
> 	int flags;
> 	sigset_t *sigmask;
> };
> 
> Commands ops are:
> 
> 	EPOLL_CTL_ADD
> 		@fd is the fd to modify; @data is epoll_event.
> 	EPOLL_CTL_MOD
> 		@fd is the fd to modify; @data is epoll_event.
> 	EPOLL_CTL_DEL
> 		@fd is the fd to modify; @data is epoll_event.
> 
> 	EPOLL_CTL_SET_TIMEOUT
> 		@fd is ignored, @data is timespec.
> 		Clock type and relative/absolute are selected by flags as below.
> 
> Flags are given to override timeout defaults:
> 	EPOLL_FL_MONOTONIC_CLOCK
> 		If set, don't use realtime clock, use monotonic clock.
> 	EPOLL_FL_ABSOLUTE_TIMEOUT
> 		If set, don't use relative timeout, use absolute timeout.

I'd suggest using an "int clockid" field instead, like timerfd_settime;
even if it only accepts CLOCK_REALTIME and CLOCK_MONOTONIC, if it needs
extending in the future, it'd be painful to have to remap new CLOCK_*
constants into the EPOLL_FL_* namespace.  (I do think dropping timeouts
in favor of timerfds makes things more nicely orthogonal, but epoll_wait
already has a timeout parameter, so *shrug*.)

Also, I think that structure has too many levels of indirection; it'd
produce many unnecessary cache misses; considering you're trying to
eliminate the overhead of one or two extra syscalls, you don't want to
introduce a pile of unnecessary cache misses in the processes.  I'd
suggest inlining cmds as an array at the end of the structure, and
turning "void *data" into an inline epoll_event.  (Or, you could use
"events" as an in/out parameter.)

You could drop EPOLL_CTL_SET_TIMEOUT, and just include a clockid and
timespec directly in the top-level structure.

And I'd suggest either making flags a top-level parameter or putting it
at the start of the structure, to make future extension easier.

</bikeshed>

- Josh Triplett
