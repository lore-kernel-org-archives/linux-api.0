From: Kees Cook <keescook@chromium.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Tue, 9 May 2017 09:30:02 -0700
Message-ID: <CAGXu5jL-qvFxLkJZSosAovK4qL5eLPOD7orpei42x6mK_tBXhw@mail.gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <20170508075209.7aluvpwildw325rf@gmail.com>
 <1494256932.1167.1.camel@gmail.com> <CAGXu5jL61K0bRSEg9a_LswNyrt3K1J57REbWVcvAXT54zWwtMA@mail.gmail.com>
 <20170509065619.wmqa6z6w3n6xpvrw@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170509065619.wmqa6z6w3n6xpvrw@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Daniel Micay <danielmicay@gmail.com>, Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.>
List-Id: linux-api@vger.kernel.org

On Mon, May 8, 2017 at 11:56 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> > There's the option of using GCC plugins now that the infrastructure was
>> > upstreamed from grsecurity. It can be used as part of the regular build
>> > process and as long as the analysis is pretty simple it shouldn't hurt compile
>> > time much.
>>
>> Well, and that the situation may arise due to memory corruption, not from
>> poorly-matched set_fs() calls, which static analysis won't help solve. We need
>> to catch this bad kernel state because it is a very bad state to run in.

[attempting some thread-merging]

> Ok, so that's CVE-2010-4258, where an oops with KERNEL_DS set was used to escalate
> privileges, due to the kernel's oops handler not cleaning up the KERNEL_DS. The
> exploit used another bug, a crash in a network protocol handler, to execute the
> oops handler with KERNEL_DS set.

Right, I didn't mean to suggest that vulnerability would be fixed by
this solution. I was trying to show how there can be some pretty
complex interaction with exceptions/interrupts/etc that would make
pure static analysis still miss things.

> If memory corruption corrupted the task state into having addr_limit set to
> KERNEL_DS then there's already a fair chance that it's game over: it could also
> have set *uid to 0, or changed a sensitive PF_ flag, or a number of other
> things...
>
> Furthermore, think about it: there's literally an infinite amount of corrupted
> task states that could be a security problem and that could be checked after every
> system call. Do we want to check every one of them?

Right, but this "slippery slope" argument isn't the best way to reject
security changes. Let me take a step back and describe the threat, and
where we should likely spend time:

The primary threat with addr_limit getting changed is that a
narrowly-scoped attack (traditionally stack exhaustion or
adjacent-stack large-index writes) could be leveraged into opening the
entire kernel to writes (by allowing all syscalls with a
copy_to_user() call to suddenly be able to write to kernel memory).
So, really, the flaw is having addr_limit at all. Removing set_fs()
should, I think, allow this to become a const (or at least should get
us a lot closer).

The main path to corrupting addr_limit has been via stack corruption.
On architectures with CONFIG_THREAD_INFO_IN_TASK, this risk is greatly
reduced already, but it's not universally available yet. (And as long
as we're talking about stack attacks, CONFIG_VMAP_STACK makes
cross-stack overflows go away, and cross-stack indexing harder, but
that's not really about addr_limit since currently nothing with
VMAP_STACK doesn't already have THREAD_INFO_IN_TASK.)

So, left with a still exploitable target in memory that allows such an
expansion of attack method, I still think it's worth keeping this
patch series, but if we can drop set_fs() I could probably be
convinced the benefit of the series doesn't exceed the cost on
THREAD_INFO_IN_TASK-architectures (x86, arm64, s390). But that means
at least currently keeping it on arm, for example. If we can make
addr_limit const, well, we don't need the series at all.

-Kees

-- 
Kees Cook
Pixel Security
