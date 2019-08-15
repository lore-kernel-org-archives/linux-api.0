From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv6 03/36] posix-clocks: Rename the clock_get() into
 clock_get_timespec()
Date: Thu, 15 Aug 2019 19:24:21 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1908151922430.1908@nanos.tec.linutronix.de>
References: <20190815163836.2927-1-dima@arista.com> <20190815163836.2927-4-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190815163836.2927-4-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 15 Aug 2019, Dmitry Safonov wrote:

Just a nit vs. the subject line:

posix-clocks: Rename the clock_get() callback to clock_get_timespec()

> From: Andrei Vagin <avagin@gmail.com>
> 
> The upcoming support for time namespaces requires to have access to:
>  - The time in a task's time namespace for sys_clock_gettime()
>  - The time in the root name space for common_timer_get()
> 
> That adds a valid reason to finally implement a separate callback which
> returns the time in ktime_t format, rather than in (struct timespec).
> 
> Rename clock_get() callback into clock_get_timespec() as a preparation

s/clock_get()/the clock_get()/
s/into/to/

> for introducing clock_get_ktime().

Otherwise this looks fine.

Thanks,

	tglx
