From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv4 07/28] posix-timers/timens: Take into account clock
 offsets
Date: Fri, 14 Jun 2019 15:42:33 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1906141538240.1722@nanos.tec.linutronix.de>
References: <20190612192628.23797-1-dima@arista.com> <20190612192628.23797-8-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190612192628.23797-8-dima@arista.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>
Cc: linux-kernel@vger.kernel.org, Andrei Vagin <avagin@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 12 Jun 2019, Dmitry Safonov wrote:

> Subject: posix-timers/timens: Take into account clock offsets

Please avoid that '/timens' appendix. It's not really a new subsystem or
subfunction of posix-timers.

posix-timers: Add time namespace support to common_timer_set()

> From: Andrei Vagin <avagin@gmail.com>
> 
> Wire timer_settime() syscall into time namespace virtualization.

Please explain why this only affects common_timer_set() and not any other
incarnation along with an explanation why only ABSTIME timers need to be
converted.

Thanks,

	tglx
