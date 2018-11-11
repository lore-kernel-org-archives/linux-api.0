From: Florian Weimer <fweimer@redhat.com>
Subject: Re: Official Linux system wrapper library?
Date: Sun, 11 Nov 2018 11:40:44 +0100
Message-ID: <87o9avx5g3.fsf@oldenburg.str.redhat.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
	<bbc12da5-830e-99a7-95e3-d9da42947dc9@gmail.com>
	<20181111081725.GA30248@1wt.eu>
	<CAKOZuesi79-4J8bXU2bTY4876DOtL0K4A_Sr=6XsDD8dESPQbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <libc-alpha-return-97133-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CAKOZuesi79-4J8bXU2bTY4876DOtL0K4A_Sr=6XsDD8dESPQbw@mail.gmail.com>
	(Daniel Colascione's message of "Sun, 11 Nov 2018 00:25:03 -0800")
To: Daniel Colascione <dancol@google.com>
Cc: Willy Tarreau <w@1wt.eu>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Carlos O'Donell <carlos@redhat.com>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Daniel Colascione:

> On Sun, Nov 11, 2018 at 12:17 AM, Willy Tarreau <w@1wt.eu> wrote:
>>
>> On Sun, Nov 11, 2018 at 07:55:30AM +0100, Michael Kerrisk (man-pages) wrote:
>> > [1] https://sourceware.org/
>>
>>
>> Bah, after all, this
>>
>> wipes quite a bit of the shame I feel every time I do something to
>>
>> bypass it :-/
>>
>>
>> The sad thing is that the energy wasted arguing in the bug above could
>>
>> have been better spent designing and implementing a generic solution
>>
>> to expose syscalls without depending on glibc's politics anymore.
>>
>>
>> Willy
>>
>> bugzilla/show_bug.cgi?id=6399 is a
>> >     longstanding example.
>>
>> This one was a sad read and shows that applications will continue to
>> suffer from glibc's prehistorical view on operating systems
>
> Yes. I'm really not sure what glibc's current policies are meant to
> accomplish. They don't serve any useful purpose. There seems to be
> this weird subtext that glibc has leverage to change OS design, and it
> really doesn't. It's a misplaced idealism and ends up just hurting
> everyone.

I'm not sure what this comment tries to accomplish.

glibc tries to serve many masters: Current and past Linux kernel
interfaces, current Hurd kernel interfaces, different versions of POSIX
and C (and even C++), current C/C++ programming practice, historic C
programming practice, current and historic Linux userspace programming,
various platform ABIs, just to name a few.

These requirements are often in conflict.

>> Seeing comments suggesting an application should open
>> /proc/$PID makes me really wonder if people actually want to use slow
>> and insecure applications designed this way.
>
> That's a separate point. Yes, gettid should have a wrapper, but *also*
> we should have an FD-based interface to processes, because outside
> specialized contexts (e.g., parent-child waiting), the traditional
> Unix process API really is impossible to use safely. But that's a
> separate ongoing discussion.

A descriptor-based API would not help glibc that much because there is
an expectation encoded into many C programs that the C library does not
keep permanently open descriptors for its own internal use.

Thanks,
Florian
