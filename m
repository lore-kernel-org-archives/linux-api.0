From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v2 1/4] syscalls: Restore address limit after a syscall
Date: Thu, 9 Mar 2017 07:53:54 -0800
Message-ID: <CAJcbSZH7xoBGsD7A4odpYrWopziWrc8sifAUiUgQmVnYkxwo4w@mail.gmail.com>
References: <20170309012456.5631-1-thgarnie@google.com> <c10289bb-e72b-b7b5-f02b-d8cab49f372c@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-6970-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <c10289bb-e72b-b7b5-f02b-d8cab49f372c@de.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "David S . Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
List-Id: linux-api@vger.kernel.org

> On Thu, Mar 9, 2017 at 4:32 AM, Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> Can you please disable that for s390?  (e.g. by setting
> CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE for s390)
> We have a separate address space for kernel/user so the logic will
> be slightly different and is already handled in
>
> commit b5a882fcf146c87cb6b67c6df353e1c042b8773d
> Author: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date:   Fri Feb 17 08:13:28 2017 +0100
>
>     s390: restore address space when returning to user space
>

No problem, I will add it on the next iteration of this change.

-- 
Thomas
