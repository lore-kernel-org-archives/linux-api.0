From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv7 00/33] kernel: Introduce Time Namespace
Date: Thu, 17 Oct 2019 11:24:45 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1910171122030.1824@nanos.tec.linutronix.de>
References: <20191011012341.846266-1-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191011012341.846266-1-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org, Andrei Vagin <avagin@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, 11 Oct 2019, Dmitry Safonov wrote:
> We wrote two small benchmarks. The first one gettime_perf.c calls
> clock_gettime() in a loop for 3 seconds. It shows us performance with
> a hot CPU cache (more clock_gettime() cycles - the better):
> 
>         | before    | CONFIG_TIME_NS=n | host      | inside timens
> --------------------------------------------------------------
>         | 153242367 | 153567617        | 150933203 | 139310914
>         | 153324800 | 153115132        | 150919828 | 139299761
>         | 153125401 | 153686868        | 150930471 | 139273917
>         | 153399355 | 153694866        | 151083410 | 139286081
>         | 153489417 | 153739716        | 150997262 | 139146403
>         | 153494270 | 153724332        | 150035651 | 138835612
> -----------------------------------------------------------
> avg     | 153345935 | 153588088        | 150816637 | 139192114
> diff %  | 100       | 100.1            | 98.3      | 90.7


That host 98.3% number is weird and does not match the tests I did with the
fallback code I provided you. On my limited testing that fallback hidden in
the slowpath did not show any difference to the TIME_NS=n case when not
inside a time namespace.

Thanks,

	tglx
