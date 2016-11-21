From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: Formal description of system call interface
Date: Mon, 21 Nov 2016 16:17:43 +0100
Message-ID: <CACT4Y+YsiPfq28SD-_hUpJ=x6teqRkRieD_hPeHpxE9ke2-xUw@mail.gmail.com>
References: <CACT4Y+YYgs43nJnyg3B9cHWOue62iMW3ZgXQKiKG12A1NVMgtg@mail.gmail.com>
 <CALCETrVS_t+sHNSL=eDP_yRU0w78rKUT=JAXOxHd-J5=SwwQBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVS_t+sHNSL=eDP_yRU0w78rKUT=JAXOxHd-J5=SwwQBQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Sasha Levin <levinsasha928@gmail.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, scientist@fb.com, Steven Rostedt <rostedt@goodmis.org>, Arnd Bergmann <arnd@arndb.de>, Carlos O'Donell <carlos@redhat.com>, syzkaller <syzkaller@googlegroups.com>, Kostya Serebryany <kcc@google.com>, Mike Frysinger <vapier@google.com>, Dave Jones <davej@codemonkey.org.uk>, Tavis Ormandy <taviso@google.com>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 11, 2016 at 6:10 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Sun, Nov 6, 2016 at 2:39 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
>> Hello,
>>
>> This is notes from the discussion we had at Linux Plumbers this week
>> regarding providing a formal description of system calls (user API).
>>
>> The idea come up in the context of syzkaller, syscall fuzzer, which
>> has descriptions for 1000+ syscalls mostly concentrating on types of
>> arguments and return values. However, problems are that a small group
>> of people can't write descriptions for all syscalls; can't keep them
>> up-to-date and doesn't have necessary domain expertise to do correct
>> descriptions in some cases.
>>
>> We identified a surprisingly large number of potential users for such
>> descriptions:
>
> Let me add one more: consolidation of all the incompatible arch
> syscall tables.  A sufficiently descriptive format should be parseable
> at build time to generate the syscall tables.


Hi Andy,

What exactly info do we need for this?

Anything that just requires a bit of info per syscall looks like the
lowest hanging fruit
(as compared to info per every ioctl discrimination, and complete args
description).
