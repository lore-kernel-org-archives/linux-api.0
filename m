From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCH 16/32] x86/vdso: Generate vdso{,32}-timens.lds
Date: Thu, 7 Feb 2019 16:11:59 +0000
Message-ID: <0ff2890b-b6f4-1fe6-bafb-1bdb7bd21d26@gmail.com>
References: <20190206001107.16488-1-dima@arista.com>
 <20190206001107.16488-17-dima@arista.com>
 <a2bbe610-7553-0ba6-b58b-1013e034b8f6@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a2bbe610-7553-0ba6-b58b-1013e034b8f6@rasmusvillemoes.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc: Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andrei Vagin <avagin@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andy Tucker <agtucker@google.com>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

Hi Rasmus,

On 2/7/19 8:31 AM, Rasmus Villemoes wrote:
> These (14-19, if I'm reading them right) seems to add quite a lot of
> complexity and fragility to the build, and other architectures would
> probably have to add something similar to their vdso builds.
> 
> I'm wondering why not make the rule be that a timens takes effect on
> next execve?

I believe, it would make setns() syscall much tricker than wanted:
At this moment the only exception is pidns which changes ns of the child
and not the process-callee.
If exec() would be required to join timens - it may be a challenging
problem for container systems: in order to enter it one needs to
exec("/proc/self/exe") and add some new arguments/options.
Furthermore, it seems to me that to enter container with this semantics,
one needs to enter timens before entering mountns.

IOW, I believe, this would move complexity from kernel build time to
userspace ABI. And I guess, it would require much more logic to
re-create possibly nested namespaces hierarchy.

Rather I've considered using some kind of dynamic patching on vdso_init():
o static_branch - it would add some nops to !timens vdso
o something new like static_retpoline which would put RET over call to
  clk_to_ns(), shouldn't be a rocket since.

But in my point of view, if something can be done in compile time
instead of patching code dynamically - than it reduces the complexity
(lesser depends on what compiler/toolchain does).

Thanks,
          Dmitry
