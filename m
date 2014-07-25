From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 11/11] seccomp: Add tgid and tid into seccomp_data
Date: Fri, 25 Jul 2014 11:32:54 -0700
Message-ID: <CALCETrWrCU1bw+-xP_xxoRfv6L7j+GhZS_YwrWFHd2uhSp8ySw@mail.gmail.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
 <1406296033-32693-12-git-send-email-drysdale@google.com> <CALCETrVJX4+-6vkRaDj4kV_bXiYL5fj_PtO53g9fRf=i4X2Tww@mail.gmail.com>
 <CAGXu5jJZ7mhmq1BrdTP5Ww15+C2iLQKjLy1Xh0=9qZvVK5E9Cw@mail.gmail.com>
 <CALCETrVChObsQpL6dt-ByiCjbPrtpXAXQgy_apBY-OpGQHaPjg@mail.gmail.com>
 <CAGXu5jLPrKA5LR-9=M6jAfPXYoztGzXPiaSiXgEcUE=+na73GA@mail.gmail.com> <CAKyRK=j-f92xHTL3+TNr9WOv_y47dkZR=WZkpY_a5YW3Q8HfaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKyRK=j-f92xHTL3+TNr9WOv_y47dkZR=WZkpY_a5YW3Q8HfaQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julien Tinnes <jln@google.com>
Cc: Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, David Drysdale <drysdale@google.com>, Al Viro <viro@zeniv.linux.org.uk>, Paolo Bonzini <pbonzini@redhat.com>, LSM List <linux-security-module@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul Moore <paul@paul-moore.com>, James Morris <james.l.morris@oracle.com>, Linux API <linux-api@vger.kernel.org>, Meredydd Luff <meredydd@senatehouse.org>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 25, 2014 at 11:22 AM, Julien Tinnes <jln@google.com> wrote:
> On Fri, Jul 25, 2014 at 10:38 AM, Kees Cook <keescook@chromium.org> wrote:
>>
>> On Fri, Jul 25, 2014 at 10:18 AM, Andy Lutomirski <luto@amacapital.net>
>> wrote:
>> > [cc: Eric Biederman]
>> >
>> > On Fri, Jul 25, 2014 at 10:10 AM, Kees Cook <keescook@chromium.org>
>> > wrote:
>>
>> >> Julien had been wanting something like this too (though he'd suggested
>> >> it via prctl): limit the signal functions to "self" only. I wonder if
>> >> adding a prctl like done for O_BENEATH could work for signal sending?
>> >>
>> >
>> >
>> > Can we do one better and add a flag to prevent any non-self pid
>> > lookups?  This might actually be easy on top of the pid namespace work
>> > (e.g. we could change the way that find_task_by_vpid works).
>>
>> Ooh, that would be extremely interesting, yes. Kind of an extreme form
>> of pid namespace without actually being a namespace.
>>
>> > It's far from just being signals.  There's access_process_vm, ptrace,
>> > all the signal functions, clock_gettime (see CPUCLOCK_PID -- yes, this
>> > is ridiculous), and probably some others that I've forgotten about or
>> > never noticed in the first place.
>>
>> Yeah, that would be very interesting.
>
>
> Yes, this would be incredibly useful.
>
> 1. For Chromium [1], I dislike relying on seccomp purely for
> "access-control" (to other processes or files). Because it's really hard to
> think about everything (things like CPUCLOCK_PID bite, see
> https://crbug.com/374479).

Not public :(

> Se we have a first layer of sandboxing (using PID + NET namespaces and
> chroot) for "access-control" and a second layer for kernel attack surface
> reduction and a few other things using seccomp-bpf.
>
> The first layer isn't currently very good; it's heavyweight and complex (you
> need an init(1) per namespace and that init cannot be multi-purposed as a
> useful process because pid = 1 can never receive signals). One PID namespace
> per process isn't something that scales well. (Also before USER_NS it
> required a setuid root program).
>
> 2. Even with a safe pure seccomp-bpf sandbox that prevents sending signals
> to other process / ptrace() et al and that restrict clock_gettime(2)
> properly, things become quickly very tedious because as far as the kernel is
> concerned, the process under this BPF program can still pass
> ptrace_may_access() to other processes. This means for instance that no
> matter what you do, a model where open() is allowed can't work if /proc is
> available. We need a mode that says "ptrace_may_access()" will never pass.
>
> So yes, I really would like:
> - a prctl that says: "I'm dropping privileges and I now can't interact with
> other thread groups (via signals, ptrace, etc..)".
> - Something to drop access to the file system. It could be an unprivileged
> way to chroot() to an empty directory (unprivileged namespaces work for
> that, - except if you're already in a chroot -). This is a little tricky
> without allowing chroot escapes, so I suspect we would want to express it in
> terms of mount namespace, or something else, rather than chroot.

Capsicum will give you this.

See the other thread for a more concrete proposal.  prctl is getting
out of hand.

--Andy
