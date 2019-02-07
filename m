From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 16/32] x86/vdso: Generate vdso{,32}-timens.lds
Date: Thu, 7 Feb 2019 09:31:10 +0100
Message-ID: <a2bbe610-7553-0ba6-b58b-1013e034b8f6@rasmusvillemoes.dk>
References: <20190206001107.16488-1-dima@arista.com>
 <20190206001107.16488-17-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190206001107.16488-17-dima@arista.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc: Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andrei Vagin <avagin@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Dmitry Safonov <0x7f454c46@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On 06/02/2019 01.10, Dmitry Safonov wrote:
> As it has been discussed on timens RFC, adding a new conditional branch
> `if (inside_time_ns)` on VDSO for all processes is undesirable.
> It will add a penalty for everybody as branch predictor may mispredict
> the jump. Also there are instruction cache lines wasted on cmp/jmp.
> 
> Those effects of introducing time namespace are very much unwanted
> having in mind how much work have been spent on micro-optimisation
> vdso code.
> 
> Addressing those problems, there are two versions of VDSO's .so:
> for host tasks (without any penalty) and for processes inside of time
> namespace with clk_to_ns() that subtracts offsets from host's time.
> 
> Unfortunately, to allow changing VDSO VMA on a running process,
> the entry points to VDSO should have the same offsets (addresses).
> That's needed as i.e. application that calls setns() may have already
> resolved VDSO symbols in GOT/PLT.

These (14-19, if I'm reading them right) seems to add quite a lot of
complexity and fragility to the build, and other architectures would
probably have to add something similar to their vdso builds.

I'm wondering why not make the rule be that a timens takes effect on
next execve?

Rasmus
