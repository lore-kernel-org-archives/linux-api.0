From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Thu, 6 Dec 2018 10:54:02 -0800
Message-ID: <CALCETrViXJ0gD34yVd8QpB-CSeKZzzncvkPHReycTiQin4r4WQ@mail.gmail.com>
References: <20181120105124.14733-1-christian@brauner.io> <87in0g5aqo.fsf@oldenburg.str.redhat.com>
 <746B7C49-CC7B-4040-A7EF-82491796D360@brauner.io> <20181202100304.labt63mzrlr5utdl@brauner.io>
 <8736rebl9s.fsf@oldenburg.str.redhat.com> <20181203180224.fkvw4kajtbvru2ku@brauner.io>
 <874lbtjvtd.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <874lbtjvtd.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

> On Dec 4, 2018, at 4:55 AM, Florian Weimer <fweimer@redhat.com> wrote:
>
> * Christian Brauner:
>
>>> On Mon, Dec 03, 2018 at 05:57:51PM +0100, Florian Weimer wrote:
>>> * Christian Brauner:
>>>
>>>> Ok, I finally have access to source code again. Scratch what I said ab=
ove!
>>>> I looked at the code and tested it. If the process has exited but not
>>>> yet waited upon aka is a zombie procfd_send_signal() will return 0. Th=
is
>>>> is identical to kill(2) behavior. It should've been sort-of obvious
>>>> since when a process is in zombie state /proc/<pid> will still be arou=
nd
>>>> which means that struct pid must still be around.
>>>
>>> Should we make this state more accessible, by providing a different
>>> error code?
>>
>> No, I don't think we want that. Imho, It's not really helpful. Signals
>> are still delivered to zombies. If zombie state were to always mean that
>> no-one is going to wait on this thread anymore then it would make sense
>> to me. But given that zombie can also mean that someone put a
>> sleep(1000) right before their wait() call in the parent it seems odd to
>> report back that it is a zombie.
>
> It allows for error checking that the recipient of a signal is still
> running.  It's obviously not reliable, but I think it could be helpful
> in the context of closely cooperating processes.
>
>>> Will the system call ever return ESRCH, given that you have a handle fo=
r
>>> the process?
>>
>> Yes, whenever you signal a process that has already been waited upon:
>> - get procfd handle referring to <proc>
>> - <proc> exits and is waited upon
>> - procfd_send_signal(procfd, ...) returns -1 with errno =3D=3D ESRCH
>
> I see, thanks.
>
>>> Do you want to land all this in one kernel release?  I wonder how
>>> applications are supposed to discover kernel support if functionality i=
s
>>> split across several kernel releases.  If you get EINVAL or EBADF, it
>>> may not be obvious what is going on.
>>
>> Sigh, I get that but I really don't want to have to land this in one big
>> chunk. I want this syscall to go in in a as soon as we can to fulfill
>> the most basic need: having a way that guarantees us that we signal the
>> process that we intended to signal.
>>
>> The thread case is easy to implement on top of it. But I suspect we will
>> quibble about the exact semantics for a long time. Even now we have been
>> on multiple - justified - detrous. That's all pefectly fine and
>> expected. But if we have the basic functionality in we have time to do
>> all of that. We might even land it in the same kernel release still. I
>> really don't want to come of as tea-party-kernel-conservative here but I
>> have time-and-time again seen that making something fancy and cover ever
>> interesting feature in one patchset takes a very very long time.
>>
>> If you care about userspace being able to detect that case I can return
>> EOPNOTSUPP when a tid descriptor is passed.
>
> I suppose that's fine.  Or alternatively, when thread group support is
> added, introduce a flag that applications have to use to enable it, so
> that they can probe for support by checking support for the flag.
>
> I wouldn't be opposed to a new system call like this either:
>
>  int procfd_open (pid_t thread_group, pid_t thread_id, unsigned flags);
>
> But I think this is frowned upon on the kernel side.

I have no problem with it, except that I think it shouldn=E2=80=99t return =
an
fd that can be used for proc filesystem access.
