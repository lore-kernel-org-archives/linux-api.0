From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 0/3] epoll: Add epoll_pwait1 syscall
Date: Thu, 8 Jan 2015 18:24:44 -0800
Message-ID: <CALCETrU+MKWCh1FBqvuf3MGo3dTcmdktcM4aVZZGGUAmDNoWtg@mail.gmail.com>
References: <1420705550-24245-1-git-send-email-famz@redhat.com>
 <1420708372.18399.15.camel@suse.cz> <CALCETrVyPij1Zxwmw7p06UrZjoyYDXqEjmxyQ-KJ8Y7dx7mL3g@mail.gmail.com>
 <20150109011608.GA2924@fam-t430.nay.redhat.com> <CALCETrWHGwPw2cH3RruaCFKj2ND8PdEbdWjTi4OJ8m2eF9fpLw@mail.gmail.com>
 <20150109015248.GA5034@fam-t430.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150109015248.GA5034-+wGkCoP0yD+sDdueE5tM26fLeoKvNuZc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Juri Lelli <juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dario Faggioli <raistlin-k2GhghHVRtY@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 8, 2015 at 5:52 PM, Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 01/08 17:28, Andy Lutomirski wrote:
>> On Thu, Jan 8, 2015 at 5:25 PM, Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Thu, 01/08 09:57, Andy Lutomirski wrote:
>> >> I'd like to see a more ambitious change, since the timer isn't the
>> >> only problem like this.  Specifically, I'd like a syscall that does a
>> >> list of epoll-related things and then waits.  The list of things could
>> >> include, at least:
>> >>
>> >>  - EPOLL_CTL_MOD actions: level-triggered epoll users are likely to
>> >> want to turn on and off their requests for events on a somewhat
>> >> regular basis.
>> >
>> > This sounds good to me.
>> >
>> >>
>> >>  - timerfd_settime actions: this allows a single syscall to wait and
>> >> adjust *both* monotonic and real-time wakeups.
>> >
>> > I'm not sure, doesn't this break orthogonality between epoll and timerfd?
>>
>> Yes.  It's not very elegant, and more elegant ideas are welcome.
>
> What is the purpose of embedding timerfd operation here? Modifying timerfd
> for each poll doesn't sound a common pattern to me.

Setting a timeout is definitely a common pattern, hence this thread.
But the current timeout interface sucks, and people should really use
absolute time.  (My epoll software uses absolute time.)  But then
users need to decide whether to have their timeout based on the
monotonic clock or the realtime clock (or something else entirely).
Some bigger programs may want both -- they may have internal events
queued for certain times and for certain timeouts, and those should
use realtime and monotonic respectively.  Heck, users may also want
separate slack values on those.

Timerfd is the only thing we have right now that is anywhere near
flexible enough.  Obviously if epoll became fancy enough, then we
could do away with the timerfd entirely here.

>
>>
>> >
>> >>
>> >> Would this make sense?  It could look like:
>> >>
>> >> int epoll_mod_and_pwait(int epfd,
>> >>   struct epoll_event *events, int maxevents,
>> >>   struct epoll_command *commands, int ncommands,
>> >>   const sigset_t *sigmask);
>> >
>> > What about flags?
>> >
>>
>> No room.  Maybe it should just be a struct for everything instead of
>> separate args.
>
> Also no room for timeout. A single struct sounds the only way to go.

That's what timerfd is for.  I think it would be a bit weird to
support "timeout" and detailed timerfd control.

--Andy
