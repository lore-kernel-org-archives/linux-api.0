From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCHv7 01/33] ns: Introduce Time Namespace
Date: Thu, 17 Oct 2019 10:47:36 +0100
Message-ID: <406b77c3-46c5-e0ff-c658-04cdb99200b4@arm.com>
References: <20191011012341.846266-1-dima@arista.com>
 <20191011012341.846266-2-dima@arista.com>
 <80af93da-d497-81de-2a2a-179bb3bc852d@arm.com>
 <alpine.DEB.2.21.1910161230070.2046@nanos.tec.linutronix.de>
 <20191016233342.GA3075@gmail.com>
 <alpine.DEB.2.21.1910171039500.1824@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1910171039500.1824@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Andrei Vagin <avagin@gmail.com>
Cc: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@openvz.org>, Adrian Reber <adrian@lisas.de>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On 10/17/19 10:20 AM, Thomas Gleixner wrote:

[...]

> The architectures which implement VDSO are:
> 
>     arm, arm64, mips, nds32, powerpc, riscv, s390, sparc, x86, um
> 
> arm64, mips, x86 use the generic VDSO. Patches for arm are floating
> around. UM is special as it just traps into the syscalls. No idea about the
> rest. Vincenzo might know.
> 

There a couple of cases: hexagon and csky that have vDSOs for signal trampolines
if I recall correctly, but they do not fall into the category we are exploring
at the moment.

> The bad news is that we have no information (except on arm which has a
> config switch for VDSO) whether an architecture provides VDSO support or
> not.
> 
> So unless you add something like
> 
>    config HAS_VDSO
>    	  bool
> 
> which is selected by all architectures which provide VDSO support, the only
> sane solution is to depend on GENERIC_VDSO_TIME_NS.
> 
> TBH, I would not even bother. The architectures which matter and are going
> to use time namespaces already support VDSO and they need to move to the
> generic implementation anyway as we discussed and agreed on in Vancouver.
> 
> Providing time name spaces for the non VDSO archs is a purely academic
> exercise.

I totally agree with this.

-- 
Regards,
Vincenzo
