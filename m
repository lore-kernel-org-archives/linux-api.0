From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v9 1/4] syscalls: Verify address limit before returning to user-mode
Date: Mon, 8 May 2017 06:09:28 -0700
Message-ID: <CAGXu5jKZRESgGhZ6GEoO784Q1G8V0DPcwM1T2PpyTqvEAsrUdg@mail.gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170508073352.caqe3fqf7nuxypgi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.>
List-Id: linux-api@vger.kernel.org

On Mon, May 8, 2017 at 12:33 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> (added more Cc:s)
>
> * Thomas Garnier <thgarnie@google.com> wrote:
>
>> On Fri, Apr 28, 2017 at 8:32 AM, Thomas Garnier <thgarnie@google.com> wrote:
>> > Ensure that a syscall does not return to user-mode with a kernel address
>> > limit. If that happens, a process can corrupt kernel-mode memory and
>> > elevate privileges [1].
>> >
>> > The CONFIG_ADDR_LIMIT_CHECK option disables the generic check so each
>> > architecture can create optimized versions. This option is enabled by
>> > default on s390 because a similar feature already exists.
>> >
>> > [1] https://bugs.chromium.org/p/project-zero/issues/detail?id=990
>> >
>> > Signed-off-by: Thomas Garnier <thgarnie@google.com>
>> > Tested-by: Kees Cook <keescook@chromium.org>
>>
>> Ingo: Do you want to take the set?
>
> Yeah, so now I'm questioning the whole premise of the feature, sorry :-/
>
> A big disavantage is that the "security check" will add 2-5 instructions to the
> system call fast path. Every one of them, and essentially forever. Just to handle
> a CVE that was caused by a buggy touch-screen driver helper function leaking
> KERNEL_DS and which was fixed long ago ...
>
> And yes, I realize that there were other such bugs and that such bugs might occur
> in the future - but why not push the overhead of the security check to the kernel
> build phase? I.e. I'm wondering how well we could do static analysis during kernel
> build - would a limited mode of Sparse be good enough for that? Or we could add a
> new static checker to tools/, built from first principles and used primarily for
> extended syntactical checking.

Static analysis is just not going to cover all cases. We've had
vulnerabilities where interrupt handlers left KERNEL_DS set, for
example. If there are performance concerns, let's put this behind a
CONFIG. 2-5 instructions is not an issue for most people that want
this coverage.

> For example I'd consider it a good practice to mandate that if a kernel function
> sets KERNEL_DS then it must restore it as well. Any function that does not do
> that, or is too complex for the static analysis to prove correctness for sure
> should be considered buggy!
>
> Are there any common kernel APIs outside set_fs() that set KERNEL_DS
> intentionally? The overwhelming pattern ought to be:
>
>         orig_fs = get_fs();
>         set_fs(KERNEL_DS);
>         ...
>         set_fs(orig_fs);
>
> ... and even a relatively simple static analysis tool ought to be able to see
> through that.

This pattern was, in fact, what the interrupt handler bug escaped
from. We have to build proactive defenses, and this check has a clear
defensive advantage. It's a noble goal to improve the static analyzers
and simplify the source, but we have too much history to prove that
this just isn't enough. This instruction cost of this is extremely
small, too. Until we can eliminate set_fs(), we need to add this
check.


> I'd even suggest we do it not like Sparse builds are done today, but in a more
> integrated fashion: do static analysis as part of a typical kernel defconfig build
> and not tolerate warnings but go for a 'zero warnings' policy like Linus uses for
> modconfig builds.
>
> _That_ solution I'd feel very, very good about - it would be so much better than
> any runtime checks...

I'm not opposed to this, but there will be push-back on "making the
build slower", and it still won't catch everything. Bug-finding is
different from making a bug class just unexploitable at all. As we've
done before, it's the difference between trying to find format string
attacks vs just removing %n from the format parser.

> Not to mention that such an integrated static analysis facility would allow many
> other things to be checked during build time, which we couldn't possibly check
> runtime.

Absolutely! But it's orthogonal to proactive runtime exploit blocking.
We've got one that works and defends against an entire class of
vulnerability for very low cost. It it's truly too costly for default,
let's put it behind a CONFIG and see who wants it. (Most distros, I
suspect, will enable it, just like hardened usercopy which is much
more expensive than this.)

-Kees

-- 
Kees Cook
Pixel Security
