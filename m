From: Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 11/11] seccomp: Add tgid and tid into seccomp_data
Date: Fri, 25 Jul 2014 11:24:51 -0700
Message-ID: <CAKyRK=gTVV+isc8=MpQ=x9xXj+wVsd7WtHzxHknZ=9WxT+c01g@mail.gmail.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
	<1406296033-32693-12-git-send-email-drysdale@google.com>
	<CALCETrVJX4+-6vkRaDj4kV_bXiYL5fj_PtO53g9fRf=i4X2Tww@mail.gmail.com>
	<CAGXu5jJZ7mhmq1BrdTP5Ww15+C2iLQKjLy1Xh0=9qZvVK5E9Cw@mail.gmail.com>
	<CALCETrVChObsQpL6dt-ByiCjbPrtpXAXQgy_apBY-OpGQHaPjg@mail.gmail.com>
	<CAGXu5jLPrKA5LR-9=M6jAfPXYoztGzXPiaSiXgEcUE=+na73GA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jLPrKA5LR-9=M6jAfPXYoztGzXPiaSiXgEcUE=+na73GA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 25, 2014 at 10:38 AM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> On Fri, Jul 25, 2014 at 10:18 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> [cc: Eric Biederman]
>>
>> On Fri, Jul 25, 2014 at 10:10 AM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:

>>> Julien had been wanting something like this too (though he'd suggested
>>> it via prctl): limit the signal functions to "self" only. I wonder if
>>> adding a prctl like done for O_BENEATH could work for signal sending?
>>>
>>
>>
>> Can we do one better and add a flag to prevent any non-self pid
>> lookups?  This might actually be easy on top of the pid namespace work
>> (e.g. we could change the way that find_task_by_vpid works).
>
> Ooh, that would be extremely interesting, yes. Kind of an extreme form
> of pid namespace without actually being a namespace.
>
>> It's far from just being signals.  There's access_process_vm, ptrace,
>> all the signal functions, clock_gettime (see CPUCLOCK_PID -- yes, this
>> is ridiculous), and probably some others that I've forgotten about or
>> never noticed in the first place.
>
> Yeah, that would be very interesting.

Yes, this would be incredibly useful.

1. For Chromium [1], I dislike relying on seccomp purely for
"access-control" (to other processes or files). Because it's really
hard to think about everything (things like CPUCLOCK_PID bite,
seehttps://crbug.com/374479).
Se we have a first layer of sandboxing (using PID + NET namespaces and
chroot) for "access-control" and a second layer for kernel attack
surface reduction and a few other things using seccomp-bpf.

The first layer isn't currently very good; it's heavyweight and
complex (you need an init(1) per namespace and that init cannot be
multi-purposed as a useful process because pid = 1 can never receive
signals). One PID namespace per process isn't something that scales
well. (Also before USER_NS it required a setuid root program).

2. Even with a safe pure seccomp-bpf sandbox that prevents sending
signals to other process / ptrace() et al and that restrict
clock_gettime(2) properly, things become quickly very tedious because
as far as the kernel is concerned, the process under this BPF program
can still pass ptrace_may_access() to other processes. This means for
instance that no matter what you do, a model where open() is allowed
can't work if /proc is available. We need a mode that says
"ptrace_may_access()" will never pass.

So yes, I really would like:
- a prctl that says: "I'm dropping privileges and I now can't interact
with other thread groups (via signals, ptrace, etc..)".
- Something to drop access to the file system. It could be an
unprivileged way to chroot() to an empty directory (unprivileged
namespaces work for that, - except if you're already in a chroot -).
This is a little tricky without allowing chroot escapes, so I suspect
we would want to express it in terms of mount namespace, or something
else, rather than chroot.

Then we have the primitives  we need to build sandboxes in a simple
way and we can add seccomp-bpf on top to do things such as open()
hooking (via SECCOMP_RET_TRAP) and to restrict the kernel attack
surface.

Julien

[1] https://code.google.com/p/chromium/wiki/LinuxSandboxing
