From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 3/3] y2038: rusage: use __kernel_old_timeval for process times
Date: Mon, 27 Nov 2017 12:49:21 -0600
Message-ID: <87o9nnlfpq.fsf@xmission.com>
References: <20171127170121.634826-1-arnd@arndb.de>
        <20171127170121.634826-3-arnd@arndb.de>
        <34369a6e-e0ce-fe7b-65e3-9c4a33e4789a@cs.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <34369a6e-e0ce-fe7b-65e3-9c4a33e4789a@cs.ucla.edu> (Paul Eggert's
        message of "Mon, 27 Nov 2017 09:52:06 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Eggert <eggert@cs.ucla.edu>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, y2038@lists.linaro.org, libc-alpha@sourceware.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Albert ARIBAUD <albert.aribaud@3adev.fr>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Matt Turner <mattst88@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Deepa Dinamani <deepa.kernel@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Kirill Tkhai <ktkhai@virtuozzo.com>, linux-alpha@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Paul Eggert <eggert@cs.ucla.edu> writes:

> On 11/27/2017 09:00 AM, Arnd Bergmann wrote:
>> b) Extend the approach taken by the x32 ABI, and use the 64-bit
>>     native structure layout for rusage on all architectures with new
>>     system calls that is otherwise compatible. A possible problem here
>>     is that we end up with incompatible definitions of rusage between
>>     /usr/include/linux/resource.h and /usr/include/bits/resource.h
>>
>> c) Change the definition of struct rusage to be independent of
>>     time_t. This is the easiest change, as it does not involve new system
>>     call entry points, but it has the risk of introducing compile-time
>>     incompatibilities with user space sources that rely on the type
>>     of ru_utime and ru_stime.
>>
>> I'm picking approch c) for its simplicity, but I'd like to hear from
>> others whether they would prefer a different approach.
>
> (c) would break programs like GNU Emacs, which copy ru_utime and ru_stime
> members into struct timeval variables.
>
> All in all, (b) sounds like it would be better for programs using glibc, as it's
> more compatible with what POSIX apps expect. Though I'm not sure what problems
> are meant by "possible ... incompatible definitions"; perhaps you could
> elaborate.

getrusage is posix and I believe the use of struct timeval is posix as
well.

So getrusage(3) the libc definition and that defintion must struct
timeval or the implementation will be non-conforming and it won't be
just emacs we need to worry about.

The practical question is what do we provide to userspace so that it can
implement a conforming getrusage?

A 32bit time_t based struct timeval is good for durations up to 136 years
or so.  Which strongly suggests the range is large enough, except for
some crazy massively multi-threaded application.  And anything off the
charts cpu hungry at this point I expect will be 64bit.

It is possible to get a 128 way system with one thread on each core and
consume 100% of the core for a bit over a year to max out getrusage.  So
I do think in the long run we care about increasing the size of time_t
here.  Last I checked applications doing things like that were 64bit in
the year 2000.

Given that userspace is going to be seeing the larger struct rusage in
any event my inclination for long term maintainability would be to
introduce the new syscall and have the current one called oldgetrusage
on 32bit architectures.  Then we won't have to worry about what weird
things glibc will do when translating the data, and we can handle
applications with crazy (but possible) runtimes.  Which inclines me to
(b) as well.

As for (a) does anyone have a need for process acounting at nsec
granularity?  Unless we can get that for free that just seems like
overpromising and a waist to have so much fine granularity.

Eric
