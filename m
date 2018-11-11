From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Official Linux system wrapper library?
Date: Sun, 11 Nov 2018 11:53:54 +0100
Message-ID: <3664a508-ca74-4ff0-39a6-34543194a24e@gmail.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
 <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
 <20181111081725.GA30248@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181111081725.GA30248@1wt.eu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Willy Tarreau <w@1wt.eu>
Cc: mtk.manpages@gmail.com, Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Florian Weimer <fweimer@redhat.com>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On 11/11/18 9:17 AM, Willy Tarreau wrote:
> On Sun, Nov 11, 2018 at 07:55:30AM +0100, Michael Kerrisk (man-pages) wrote:
>> [1] https://sourceware.org/bugzilla/show_bug.cgi?id=6399 is a
>>     longstanding example.
> 
> This one was a sad read and shows that applications will continue to
> suffer from glibc's prehistorical view on operating systems and will
> continue to have to define their own syscall wrappers to exploit the
> full potential of the modern operating systems they execute on. This
> reminds me when one had to write their own spinlocks and atomics many
> years ago. Seeing comments suggesting an application should open
> /proc/$PID makes me really wonder if people actually want to use slow
> and insecure applications designed this way. Bah, after all, this
> wipes quite a bit of the shame I feel every time I do something to
> bypass it :-/
> 
> The sad thing is that the energy wasted arguing in the bug above could
> have been better spent designing and implementing a generic solution
> to expose syscalls without depending on glibc's politics anymore.

I'm not sure I'd view the glibc position quite so harshly (although 
it is disappointing to me that bug 6399 remains open). I think they
are simply short of people to work on this task. There was a lengthy
period where no syscall wrappers were being added (pretty much from
2.16 to 2.24, as far as I can tell), but that has changed.

And there is an expectation in some cases from the kernel side
that glibc will provide wrappers that build on (rather than just
wrap) some syscalls. And sometimes those wrappers are non-trivial.

A converse question that one could ask is: why did a culture
evolve whereby kernel developers don't take responsibility for
working with the major libc to ensure that wrappers are added as
part of the job of adding each new system call? Yes, I know, there
are some historical reasons (and even today, IMO, they do 
themselves no favors by requiring a CLA), but glibc really is 
a different place today, compared to where it was a few years 
ago.

Cheers,

Micahel

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
