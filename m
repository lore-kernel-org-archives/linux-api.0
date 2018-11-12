From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Mon, 12 Nov 2018 20:11:17 +0100
Message-ID: <87lg5ym7qi.fsf@oldenburg.str.redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
        <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
        <877ehjx447.fsf@oldenburg.str.redhat.com>
        <CAKOZues5SEESpJU=6MDTrPXTA1KTZFGNQE4Lw4t0fO-WBTU62w@mail.gmail.com>
        <875zx2vhpd.fsf@oldenburg.str.redhat.com>
        <CAKOZuetdgk1QYhx1538-98rFpogMin=8DkPnCtU9_=ip23Vk7w@mail.gmail.com>
        <CAKCAbMiHC9r54h=XeW7CkBZ1Z5eHr9MPH3Rn7KTc9DjoHG=8UA@mail.gmail.com>
        <CAKOZuev7zqq+xpjyDA2mSdy-zwyNjECCzLsBELF6_v1rwar_mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuev7zqq+xpjyDA2mSdy-zwyNjECCzLsBELF6_v1rwar_mA@mail.gmail.com>
        (Daniel Colascione's message of "Mon, 12 Nov 2018 10:28:56 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Zack Weinberg <zackw@panix.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Willy Tarreau <w@1wt.eu>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, GNU C Library <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Daniel Colascione:

> What about off_t differences? Again, it doesn't matter. From the
> *kernel's* point of view, there's one width of offset parameter per
> system call per architecture. The library I'm proposing would expose
> this parameter literally.

Does this mean the application author needs to know when to split an
off_t argument into two, and when to pass it as a single argument, and
when to insert dummy arguments for alignment, depending on the
architecture?

>> And that means you wouldn't get as much
>> decoupling from the C and POSIX standards -- both of which specify at
>> least part of those semantics -- as you want, and we would still be
>> having these arguments.  For example, it would be every bit as
>> troublesome for liblinuxabi.so.1 to export set_robust_list as it would
>> be for libc.so.6 to do that.
>
> Why? Such an exported function would cause no trouble until called,
> and there are legitimate reasons for calling such a function. Not
> everyone, as mentioned, wants to write a program that relies on libc.

For that use case, a machine-readable system call ABI specification is
the only reasonable approach: Some people want inline system calls,
others want dedicated routines per system call.  The calling convention
for the dedicated functions will vary, and the way errors are handled as
well.  Some want connect calls to be handled by socketcall if possible,
others prefer the direct call.

The nice thing here is that once you settled for a particular approach,
the functions are really small and will not change, so there is no real
need for dynamic linking.  The challenge here is to come up with a
uniform description of the system call interface for all architectures,
and for application programmer's sanity, make sure that the kernel adds
generic system calls in a single version, across all architectures.

> This stance in the paragraph I've quoted is another example of glibc's
> misplaced idealism. As I've elaborated elsewhere, people use signals
> for many purposes today. The current signals API is extremely
> difficult to use correctly in a process in which multiple unrelated
> components want to take advantage of signal-handling functionality.
> Users deserve a cleaner, modern, and safe API. It's not productive
> withhold improvements to the signal API and gate them on unrelated
> features like process handles merely because, in the personal
> judgement of the glibc maintainers, developers should use signals for
> fewer things.

The two aren't unrelated.  If you take asynchronous signals out of the
picture, the design becomes simpler and easier to use.

Thanks,
Florian
