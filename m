From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Sun, 11 Nov 2018 11:30:25 +0100
Message-ID: <87y39zx5xa.fsf@oldenburg.str.redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
        <bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
        <20181111081725.GA30248@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181111081725.GA30248@1wt.eu> (Willy Tarreau's message of "Sun,
        11 Nov 2018 09:17:25 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Willy Tarreau <w@1wt.eu>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Daniel Colascione <dancol@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Willy Tarreau:

> On Sun, Nov 11, 2018 at 07:55:30AM +0100, Michael Kerrisk (man-pages) wrote:
>> [1] https://sourceware.org/bugzilla/show_bug.cgi?id=6399 is a
>>     longstanding example.
>
> This one was a sad read and shows that applications will continue to
> suffer from glibc's prehistorical view on operating systems and will
> continue to have to define their own syscall wrappers to exploit the
> full potential of the modern operating systems they execute on.

What's modern about a 15-bit thread identifier?

I understand that using this interface is required in some cases (which
includes some system calls for which glibc does provide wrappers), but I
assumed that it was at least understood that these reusable IDs for
tasks were an extremely poor interface.  Aren't the resulting bugs
common knowledge?

> This reminds me when one had to write their own spinlocks and atomics
> many years ago. Seeing comments suggesting an application should open
> /proc/$PID makes me really wonder if people actually want to use slow
> and insecure applications designed this way.

I don't understand.  If you want a non-reusable identifier, you have to
go through the /proc interface anyway.  I think the recommendation is to
use the PID/start time combination to get a unique process identifier or
something like that.

I wanted to add gettid to glibc this cycle, but your comments suggest to
me that if we did this, we'd likely never get a proper non-reusable
thread identifier from the kernel.  So I'm not sure what do anymore.

Thanks,
Florian
