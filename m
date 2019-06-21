From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 2/2] arch: wire-up clone3() syscall
Date: Fri, 21 Jun 2019 11:37:50 +0200
Message-ID: <CAK8P3a2iV7=HkHBVL_puvCQN0DmdKEnVs2aG9MQV_8Q58JSfTA@mail.gmail.com>
References: <20190604160944.4058-1-christian@brauner.io> <20190604160944.4058-2-christian@brauner.io>
 <20190620184451.GA28543@roeck-us.net> <20190620221003.ciuov5fzqxrcaykp@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190620221003.ciuov5fzqxrcaykp@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Guenter Roeck <linux@roeck-us.net>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Florian Weimer <fweimer@redhat.com>, Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 21, 2019 at 12:10 AM Christian Brauner <christian@brauner.io> wrote:
> On Thu, Jun 20, 2019 at 11:44:51AM -0700, Guenter Roeck wrote:
> > On Tue, Jun 04, 2019 at 06:09:44PM +0200, Christian Brauner wrote:
>
> clone3() was placed under __ARCH_WANT_SYS_CLONE. Most architectures
> simply define __ARCH_WANT_SYS_CLONE and are done with it.
> Some however, such as nios2 and h8300 don't define it but instead
> provide a sys_clone stub of their own because of architectural
> requirements (or tweaks) and they are mostly written in assembly. (That
> should be left to arch maintainers for sys_clone3.)
>
> The build failures were on my radar already. I hadn't yet replied
> since I haven't pushed the fixup below.
> The solution is to define __ARCH_WANT_SYS_CLONE3 and add a
> cond_syscall(clone3) so we catch all architectures that do not yet
> provide clone3 with a ENOSYS until maintainers have added it.
>
> diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
> index 7a39e77984ef..aa35aa5d68dc 100644
> --- a/arch/arm/include/asm/unistd.h
> +++ b/arch/arm/include/asm/unistd.h
> @@ -40,6 +40,7 @@
>  #define __ARCH_WANT_SYS_FORK
>  #define __ARCH_WANT_SYS_VFORK
>  #define __ARCH_WANT_SYS_CLONE
> +#define __ARCH_WANT_SYS_CLONE3

I never really liked having __ARCH_WANT_SYS_CLONE here
because it was the only one that a new architecture needed to
set: all the other __ARCH_WANT_* are for system calls that
are already superseded by newer ones, so a new architecture
would start out with an empty list.

Since __ARCH_WANT_SYS_CLONE3 replaces
__ARCH_WANT_SYS_CLONE for new architectures, how about
leaving __ARCH_WANT_SYS_CLONE untouched but instead
coming up with the reverse for clone3 and mark the architectures
that specifically don't want it (if any)?

       Arnd
