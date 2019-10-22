From: Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCHv7 00/33] kernel: Introduce Time Namespace
Date: Tue, 22 Oct 2019 01:45:23 -0700
Message-ID: <20191022084523.GA2923@gmail.com>
References: <20191011012341.846266-1-dima@arista.com>
 <alpine.DEB.2.21.1910171122030.1824@nanos.tec.linutronix.de>
 <20191017234748.GA26011@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191017234748.GA26011@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 17, 2019 at 04:47:48PM -0700, Andrei Vagin wrote:
> 
> In my table, the "before" column is actually for the upstream kernel
> with the 18-th patch. Here is the table with the real "before" column:
> 
>         | before    | with 18/33 | CONFIG_TIME_NS=n | host      | inside timens
> ------------------------------------------------------------------------------
> avg     | 150331408 | 153345935  | 153588088        | 150816637 | 139192114
> ------------------------------------------------------------------------------
> diff %  |       98  |      100   | 100.1            | 98.3      | 90.7
> ------------------------------------------------------------------------------
> stdev % |       0.3 |     0.09   | 0.15             | 0.25      | 0.13
> 
> If we compare numbers in "before", "host" and "inside timens" columns, we
> see the same results that you had. clock_gettime() works with the
> same performance in the host namespace and 7% slower in a time
> namespace.
> 

I played with this a bit more and I've found that we can speed up
clock_gettime on 5% more if we mark do_hres and do_coarse as
__always_inline.

With the unlikely hint in vdso_read_begin and noinline for
do_hres_timens and do_coarse_timens:
1..8
ok 1 host:      clock:  monotonic       cycles:  155278332
ok 2 host:      clock: monotonic-coarse cycles:  662067077
ok 3 host:      clock: monotonic-raw    cycles:  151218057
ok 4 host:      clock:   boottime       cycles:  154907635
ok 5 ns:        clock:  monotonic       cycles:  133100433
ok 6 host:      clock: monotonic-coarse cycles:  444170219
ok 7 host:      clock: monotonic-raw    cycles:  129550178
ok 8 ns:        clock:   boottime       cycles:  130167136


With __always_inline for do_hres and do_coarse:
1..8
ok 1 host:      clock:  monotonic       cycles:  163691015
ok 2 host:      clock: monotonic-coarse cycles:  641443397
ok 3 host:      clock: monotonic-raw    cycles:  163649270
ok 4 host:      clock:   boottime       cycles:  163682242
ok 5 ns:        clock:  monotonic       cycles:  138759212
ok 6 host:      clock: monotonic-coarse cycles:  486149502
ok 7 host:      clock: monotonic-raw    cycles:  134801053
ok 8 ns:        clock:   boottime       cycles:  138675460
# Pass 8 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0

With __always_inline for do_hres, do_coarse, do_hres_timens,
do_coarse_timens:
1..8
ok 1 host:	clock:  monotonic	cycles:	 158984538
ok 2 host:	clock: monotonic-coarse	cycles:	 594932695
ok 3 host:	clock: monotonic-raw	cycles:	 157834511
ok 4 host:	clock:   boottime	cycles:	 158297691
ok 5 ns:	clock:  monotonic	cycles:	 148559612
ok 6 host:	clock: monotonic-coarse	cycles:	 468505657
ok 7 host:	clock: monotonic-raw	cycles:	 146366575
ok 8 ns:	clock:   boottime	cycles:	 148573015
# Pass 8 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0

Thanks,
Andrei
