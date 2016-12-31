From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC, PATCHv2 29/29] mm, x86: introduce RLIMIT_VADDR
Date: Fri, 30 Dec 2016 18:08:27 -0800
Message-ID: <CALCETrVHf-JJGqFoX_kmx2qyLdj78SDUfbvD+VPsSpPfDbYk1Q@mail.gmail.com>
References: <20161227015413.187403-1-kirill.shutemov@linux.intel.com>
 <20161227015413.187403-30-kirill.shutemov@linux.intel.com>
 <CALCETrV+3rO=CuPjpoU9iKnKiJ2toW6QZAKXEqDW-QJJrX2EgQ@mail.gmail.com>
 <20161227022405.GA8780@node.shutemov.name> <3a168403-26f7-ac8d-3086-848178be6005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <3a168403-26f7-ac8d-3086-848178be6005@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Carlos O'Donell <carlos@redhat.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, linux-arch <linux-arch@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Dec 28, 2016 at 6:53 PM, Carlos O'Donell <carlos@redhat.com> wrote:
> On 12/26/2016 09:24 PM, Kirill A. Shutemov wrote:
>> On Mon, Dec 26, 2016 at 06:06:01PM -0800, Andy Lutomirski wrote:
>>> On Mon, Dec 26, 2016 at 5:54 PM, Kirill A. Shutemov
>>> <kirill.shutemov@linux.intel.com> wrote:
>>>> This patch introduces new rlimit resource to manage maximum virtual
>>>> address available to userspace to map.
>>>>
>>>> On x86, 5-level paging enables 56-bit userspace virtual address space.
>>>> Not all user space is ready to handle wide addresses. It's known that
>>>> at least some JIT compilers use high bit in pointers to encode their
>>>> information. It collides with valid pointers with 5-level paging and
>>>> leads to crashes.
>>>>
>>>> The patch aims to address this compatibility issue.
>>>>
>>>> MM would use min(RLIMIT_VADDR, TASK_SIZE) as upper limit of virtual
>>>> address available to map by userspace.
>>>>
>>>> The default hard limit will be RLIM_INFINITY, which basically means th=
at
>>>> TASK_SIZE limits available address space.
>>>>
>>>> The soft limit will also be RLIM_INFINITY everywhere, but the machine
>>>> with 5-level paging enabled. In this case, soft limit would be
>>>> (1UL << 47) - PAGE_SIZE. It=E2=80=99s current x86-64 TASK_SIZE_MAX wit=
h 4-level
>>>> paging which known to be safe
>>>>
>>>> New rlimit resource would follow usual semantics with regards to
>>>> inheritance: preserved on fork(2) and exec(2). This has potential to
>>>> break application if limits set too wide or too narrow, but this is no=
t
>>>> uncommon for other resources (consider RLIMIT_DATA or RLIMIT_AS).
>>>>
>>>> As with other resources you can set the limit lower than current usage=
.
>>>> It would affect only future virtual address space allocations.
>>>>
>>>> Use-cases for new rlimit:
>>>>
>>>>   - Bumping the soft limit to RLIM_INFINITY, allows current process al=
l
>>>>     its children to use addresses above 47-bits.
>>>>
>>>>   - Bumping the soft limit to RLIM_INFINITY after fork(2), but before
>>>>     exec(2) allows the child to use addresses above 47-bits.
>>>>
>>>>   - Lowering the hard limit to 47-bits would prevent current process a=
ll
>>>>     its children to use addresses above 47-bits, unless a process has
>>>>     CAP_SYS_RESOURCES.
>>>>
>>>>   - It=E2=80=99s also can be handy to lower hard or soft limit to arbi=
trary
>>>>     address. User-mode emulation in QEMU may lower the limit to 32-bit
>>>>     to emulate 32-bit machine on 64-bit host.
>>>
>>> I tend to think that this should be a personality or an ELF flag, not
>>> an rlimit.
>>
>> My plan was to implement ELF flag on top. Basically, ELF flag would mean
>> that we bump soft limit to hard limit on exec.
>
> Could you clarify what you mean by an "ELF flag?"

Some way to mark a binary as supporting a larger address space.  I
don't have a precise solution in mind, but an ELF note might be a good
way to go here.

--Andy

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
