From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: Formal description of system call interface
Date: Mon, 21 Nov 2016 16:03:04 +0100
Message-ID: <CACT4Y+bq97OPqW9nUoQWDdVfeCv6oOYT0=GeFmOu2rosBz4s2Q@mail.gmail.com>
References: <CACT4Y+YYgs43nJnyg3B9cHWOue62iMW3ZgXQKiKG12A1NVMgtg@mail.gmail.com>
 <20161107002839.GN5749@port70.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161107002839.GN5749@port70.net>
Sender: linux-kernel-owner@vger.kernel.org
To: syzkaller <syzkaller@googlegroups.com>
Cc: linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Sasha Levin <levinsasha928@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, scientist@fb.com, Steven Rostedt <rostedt@goodmis.org>, Arnd Bergmann <arnd@arndb.de>, carlos@redhat.com, Kostya Serebryany <kcc@google.com>, Mike Frysinger <vapier@google.com>, Dave Jones <davej@codemonkey.org.uk>, Tavis Ormandy <taviso@google.com>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 7, 2016 at 1:28 AM, Szabolcs Nagy <nsz@port70.net> wrote:
> * Dmitry Vyukov <dvyukov@google.com> [2016-11-06 14:39:28 -0800]:
>> This is notes from the discussion we had at Linux Plumbers this week
>> regarding providing a formal description of system calls (user API).
> yes a database of the syscall abis would be useful
> ..depending on the level of detail it has.
>
> (right now there is not even spec about what registers
> the syscall entry point may clobber on the various abis
> which would be useful to know when making syscalls)

Hi Szabolcs,

Level of detail is discus-sable. I would say that a detail is worth
supporting if:
1. there is an intent to actually use in a foreseeable future
2. there is somebody who is ready to spend time describing the detail


>> Action points:
>>  - polish DSL for description (must be extensible)
>>  - write a parser for DSL
>>  - provide definition for mm syscalls (mm is reasonably simple
>>    and self-contained)
>>  - see if we can do validation of mm arguments
>
> for all abi variants? e.g. mmap offset range is abi dependent.

I don't think we draw exact line between what will be verified and will not.
There are simpler predicates (e.g. memory is addressable) and more complex
predicates (e.g. this flag can have this value iff that other flags is
specified and
a valid fd is passed in that field of a struct).


>> For the reference, current syzkaller descriptions are in txt files here:
>> https://github.com/google/syzkaller/tree/master/sys
> ...
>> Taking the opportunity, if you see that something is missing/wrong
>> in the descriptions of the subsystem you care about, or if it is not
>> described at all, fixes are welcome.
>
> abi variants are missing (abi variation makes a lot of
> syscall interface related work painful).


What exactly do you mean by "abi variants"? Is it architecture?
What exactly needs to be added to the descriptions support "abi variants?

Thanks
