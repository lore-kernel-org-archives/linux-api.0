From: Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: [PATCH 0/3] epoll: Add epoll_pwait1 syscall
Date: Thu, 8 Jan 2015 11:31:19 -0800
Message-ID: <CAMEtUuweb4cfC9DsLUmDMVx6Nw1_+0afp8ExeUS49OCARa3D+g@mail.gmail.com>
References: <1420705550-24245-1-git-send-email-famz@redhat.com>
 <1420708372.18399.15.camel@suse.cz> <CALCETrVyPij1Zxwmw7p06UrZjoyYDXqEjmxyQ-KJ8Y7dx7mL3g@mail.gmail.com>
 <20150108184201.GB13974@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150108184201.GB13974@cloud>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Miklos Szeredi <mszeredi@suse.cz>, Fam Zheng <famz@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Juri Lelli <juri.lelli@gmail.com>, Zach Brown <zab@zabbo.net>, David Drysdale <drysdale@google.com>, Kees Cook <keescook@chromium.org>, David Herrmann <dh.herrmann@gmail.com>, Dario Faggioli <raistlin@linux.it>, Theodore Ts'o <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, Mike Frysinger <vapier@gentoo.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Oleg Nesterov <oleg@redhat.com>Mathieu Desnoyers <ma>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 8, 2015 at 10:42 AM,  <josh@joshtriplett.org> wrote:
>> I'd like to see a more ambitious change, since the timer isn't the
>> only problem like this.  Specifically, I'd like a syscall that does a
>> list of epoll-related things and then waits.  The list of things could
>> include, at least:
>>
>>  - EPOLL_CTL_MOD actions: level-triggered epoll users are likely to
>> want to turn on and off their requests for events on a somewhat
>> regular basis.
>>
>>  - timerfd_settime actions: this allows a single syscall to wait and
>> adjust *both* monotonic and real-time wakeups.
>>
>> Would this make sense?  It could look like:
>>
>> int epoll_mod_and_pwait(int epfd,
>>   struct epoll_event *events, int maxevents,
>>   struct epoll_command *commands, int ncommands,
>>   const sigset_t *sigmask);
>
> That's a complicated syscall.  (And it also doesn't have room for the
> flags argument.)
>
> At that point, why not just have a syscall like this:
>
> struct syscall {
>         unsigned long num;
>         unsigned long params[6];
> };
>
> int sys_many(size_t count, struct syscall *syscalls, int *results, unsigned long flags);
>
> I think that has been discussed in the past.
>
> Or, these days, that might be better done via eBPF, which would avoid
> the need for flags like "return on error"; an eBPF program could decide
> how to proceed after each call.

I'm afraid that will break seccomp or will make it much more
complicated.
Also I think syscall latency with the latest improvements is
actually quite fast, so chaining of syscalls is probably an overkill.
Same goes to Andy's argument of doing immediate CTL_MOD.
Let user space do it. It makes sense to combine things only
when atomicity is needed. Here it's not the case.
