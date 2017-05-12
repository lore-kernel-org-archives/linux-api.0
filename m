From: Thomas Garnier <thgarnie@google.com>
Subject: Re: Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Fri, 12 May 2017 10:05:58 -0700
Message-ID: <CAJcbSZFyzanv6ji97+K2kQH1CFX6qeXWsGwRvjiK1Dk+f3niBA@mail.gmail.com>
References: <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <20170508075209.7aluvpwildw325rf@gmail.com>
 <1494256932.1167.1.camel@gmail.com> <CAGXu5jL61K0bRSEg9a_LswNyrt3K1J57REbWVcvAXT54zWwtMA@mail.gmail.com>
 <20170509065619.wmqa6z6w3n6xpvrw@gmail.com> <20170509111007.GA14702@kroah.com>
 <CAJcbSZFswDWZoK-1UK+xkRMJ4ttSYbtH2Y5WD5_aPR-8ru6t8A@mail.gmail.com>
 <CAJcbSZEoRyewUtBHvqmNZL9FtT_q42Vmmd-EuC50x-ZRASiHHg@mail.gmail.com>
 <CA+55aFwvQfs_X+paQF6Luc0Rq+W3J2fKuHRou7=ANcquDdXdDA@mail.gmail.com> <20170512065818.mw7yqcdck7alqlzi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kernel-hardening-return-7885-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170512065818.mw7yqcdck7alqlzi@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>, Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borisla
List-Id: linux-api@vger.kernel.org

On Thu, May 11, 2017 at 11:58 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> On Thu, May 11, 2017 at 4:17 PM, Thomas Garnier <thgarnie@google.com> wrote:
>> >
>> > Ingo: Do you want the change as-is? Would you like it to be optional?
>> > What do you think?
>>
>> I'm not ingo, but I don't like that patch. It's in the wrong place -
>> that system call return code is too timing-critical to add address
>> limit checks.
>>
>> Now what I think you *could* do is:
>>
>>  - make "set_fs()" actually set a work flag in the current thread flags
>>
>>  - do the test in the slow-path (syscall_return_slowpath).
>>
>> Yes, yes, that ends up being architecture-specific, but it's fairly simple.
>>
>> And it only slows down the system calls that actually use "set_fs()".
>> Sure, it will slow those down a fair amount, but they are hopefully a
>> small subset of all cases.
>>
>> How does that sound to people?  Thats' where we currently do that
>>
>>         if (IS_ENABLED(CONFIG_PROVE_LOCKING) &&
>>             WARN(irqs_disabled(), "syscall %ld left IRQs disabled",
>> regs->orig_ax))
>>                 local_irq_enable();
>>
>> check too, which is a fairly similar issue.
>
> I really like that idea and I'd be perfectly fine with that solution, because it
> puts the overhead where the problem comes from, and adds an extra incentive for
> code to move away from set_fs() facilities. Win-win.

Great, I will adapt the patch for that.

>
> Thanks,
>
>         Ingo



-- 
Thomas
