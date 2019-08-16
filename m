From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv6 28/36] posix-clocks: Add align for timens_offsets
Date: Fri, 16 Aug 2019 08:36:29 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1908160835130.1908@nanos.tec.linutronix.de>
References: <20190815163836.2927-1-dima@arista.com> <20190815163836.2927-29-dima@arista.com> <alpine.DEB.2.21.1908152010230.1908@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1908152010230.1908@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 15 Aug 2019, Thomas Gleixner wrote:
> So using struct timespec64 for the offset is wrong. You really need to open
> code that offset storage if you don't want to end up with weird workarounds
> for BE.
> 
> Something like this:
> 
> struct timens_offs {
> 	  time64_t	tv_sec;
> 	  s64		tv_nsec;

Actually that should use 'int' for the tv_nsec part.

Thanks,

	tglx
