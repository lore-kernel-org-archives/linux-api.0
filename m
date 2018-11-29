From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Thu, 29 Nov 2018 22:35:00 +0100
Message-ID: <20181129213458.4h44dpg6ltqow4k4@brauner.io>
References: <20181120105124.14733-1-christian@brauner.io>
 <87in0g5aqo.fsf@oldenburg.str.redhat.com>
 <36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net>
 <993B98AC-51DF-4131-AF7F-7DA2A7F485F1@brauner.io>
 <CALCETrWnQNMQcCmFZrftVVYgAMW6DT3gyxvVb_v9_enUCUkHiw@mail.gmail.com>
 <20181129195551.woe2bl3z3yaysqb6@brauner.io>
 <6E21165F-2C76-4877-ABD9-0C86D55FD6AA@amacapital.net>
 <CAK8P3a2i9DFaS9-3A9V_pKwFfwVR0bDqgLosmivge3Cx2VyiuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a2i9DFaS9-3A9V_pKwFfwVR0bDqgLosmivge3Cx2VyiuQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, cyphar@cyphar.com, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 29, 2018 at 10:02:13PM +0100, Arnd Bergmann wrote:
> On Thu, Nov 29, 2018 at 9:14 PM Andy Lutomirski <luto@amacapital.net> wrote:
> > > On Nov 29, 2018, at 11:55 AM, Christian Brauner <christian@brauner.io> wrote:
> > >> On Thu, Nov 29, 2018 at 11:22:58AM -0800, Andy Lutomirski wrote:
> > >>> On Thu, Nov 29, 2018 at 11:17 AM Christian Brauner <christian@brauner.io> wrote:
> > >>>> On November 30, 2018 5:54:18 AM GMT+13:00, Andy Lutomirski <luto@amacapital.net> wrote:
> > >>
> > >> The #1 fix would add a copy_siginfo_from_user64() or similar.
> > >
> > > Thanks very much! That all helped a bunch already! I'll try to go the
> > > copy_siginfo_from_user64() way first and see if I can make this work. If
> > > we do this I would however only want to use it for the new syscall first
> > > and not change all other signal syscalls over to it too. I'd rather keep
> > > this patchset focussed and small and do such conversions caused by the
> > > new approach later. Does that sound reasonable?
> >
> > Absolutely. I don’t think we can change old syscalls — the ABI is set in stone.
> > But for new syscalls, I think the always-64-bit behavior makes sense.
> 
> It looks like we already have a 'struct signalfd_siginfo' that is defined in a
> sane architecture-independent way, so I'd suggest we use that.

Just so that I understand you correctly: swapping out struct signinfo
for struct signalfd_siginfo in procfd_<whatever-suffix>? If so that
sounds great to me!

> 
> We may then also want to make sure that any system call that takes a
> siginfo has a replacement that takes a signalfd_siginfo, and that this
> replacement can be used to implement the old version purely in
> user space.

Sounds good but is unrelated to this patchset I take it. :)

> 
> Is the current procfd_signal() proposal (under whichever name) sufficient
> to correctly implement both sys_rt_sigqueueinfo() and sys_rt_tgsigqueueinfo()?

Yes, I see no reason why not. My idea is to extend it - after we have a
basic version in - to also work with:
/proc/<pid>/task/<tid>
If I'm not mistaken this should be sufficient to get rt_tgsigqueueinfo.
The thread will be uniquely identified by the tid descriptor and no
combination of /proc/<pid> and /proc/<pid>/task/<tid> is needed. Does
that sound reasonable?

> Can we implement sys_rt_sigtimedwait() based on signalfd()?
> If yes, that would leave waitid(), which already needs a replacement
> for y2038, and that should then also return a signalfd_siginfo.
> My current preference for waitid() would be to do a version that
> closely resembles the current interface, but takes a signalfd_siginfo
> and a __kernel_timespec based rusage replacement (possibly
> two of them to let us map wait6), but does not operate on procfd or
> take a signal mask. That would require yet another syscall, but I
> don't think I can do that before we want to have the set of y2038
> safe syscalls.

All sounds reasonable to me but that's not a blocker for the current
syscall though, is it?

Christian
