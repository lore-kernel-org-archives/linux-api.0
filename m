From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv6 14/36] hrtimers: Prepare hrtimer_nanosleep() for time
 namespaces
Date: Thu, 15 Aug 2019 19:44:40 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1908151942080.1908@nanos.tec.linutronix.de>
References: <20190815163836.2927-1-dima@arista.com> <20190815163836.2927-15-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190815163836.2927-15-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 15 Aug 2019, Dmitry Safonov wrote:
> ---
>  include/linux/hrtimer.h   | 2 +-
>  kernel/time/hrtimer.c     | 8 ++++----
>  kernel/time/posix-stubs.c | 4 ++--

You forgot to convert the caller in posix-timers.c which breaks
bisectability. Please make sure, that every patch compiles and boots.

tools/perf/examples/bpf/5sec.c breaks as well.

Thnaks,

	tglx
