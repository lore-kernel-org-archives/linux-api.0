From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v4 1/4] syscalls: Restore address limit after a syscall
Date: Wed, 22 Mar 2017 13:49:51 -0700
Message-ID: <CAJcbSZGLAXmE_mFZMAZgioWExzm3A4vXBKLGJ7DZNAbJOcH8Zw@mail.gmail.com>
References: <20170322203834.67556-1-thgarnie@google.com> <CALCETrV6K8iSfAwojMFyLrbb3CG2aF4k5hPWc7EDV4ErPDq64w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-7068-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrV6K8iSfAwojMFyLrbb3CG2aF4k5hPWc7EDV4ErPDq64w@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 22, 2017 at 1:44 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Mar 22, 2017 at 1:38 PM, Thomas Garnier <thgarnie@google.com> wrote:
>> This patch ensures a syscall does not return to user-mode with a kernel
>> address limit. If that happened, a process can corrupt kernel-mode
>> memory and elevate privileges.
>>
>> For example, it would mitigation this bug:
>>
>> - https://bugs.chromium.org/p/project-zero/issues/detail?id=990
>>
>> If the CONFIG_BUG_ON_DATA_CORRUPTION option is enabled, an incorrect
>> state will result in a BUG_ON.
>
> I'm a bit confused about this choice of configurability.  I can see
> two sensible choices:
>
> 1. Enable this hardening feature: BUG if there's an exploitable bug.
>
> 2. Don't enable it at all.
>
> While it's possible that silently papering over the bug is slightly
> faster than BUGging, it will allow bugs to continue to exist
> undetected.

We can default to BUGging. I think my approach was avoiding doing a
BUG_ON just to avoid breaking people.

>
> --Andy



-- 
Thomas
