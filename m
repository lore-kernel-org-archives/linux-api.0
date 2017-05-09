From: Andy Lutomirski <luto@kernel.org>
Subject: Re: Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Tue, 9 May 2017 06:00:01 -0700
Message-ID: <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com> <20170509085659.GA32555@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-7778-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20170509085659.GA32555@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Greg KH <greg@kroah.com>, Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien>
List-Id: linux-api@vger.kernel.org

On Tue, May 9, 2017 at 1:56 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, May 09, 2017 at 08:45:22AM +0200, Ingo Molnar wrote:
>> We only have ~115 code blocks in the kernel that set/restore KERNEL_DS, it would
>> be a pity to add a runtime check to every system call ...
>
> I think we should simply strive to remove all of them that aren't
> in core scheduler / arch code.  Basically evetyytime we do the
>
>         oldfs = get_fs();
>         set_fs(KERNEL_DS);
>         ..
>         set_fs(oldfs);
>
> trick we're doing something wrong, and there should always be better
> ways to archive it.  E.g. using iov_iter with a ITER_KVEC type
> consistently would already remove most of them.

How about trying to remove all of them?  If we could actually get rid
of all of them, we could drop the arch support, and we'd get faster,
simpler, shorter uaccess code throughout the kernel.

The ones in kernel/compat.c are generally garbage.  They should be
using compat_alloc_user_space().  Ditto for kernel/power/user.c.

flush_module_icache() is a potentially silly arch thing.  Does the
code in kernel/module.c that uses set_fs() actually work?

kernel/signal.c's set_fs() is laziness.

__probe_kernel_read() and __probe_kernel_write() use set_fs(), but
that usage only matters on sane arches* like s390x.  We should
arguably have a set_uaccess_address_space() or similar for this
purpose that's a nop on normal arches like x86.

fs/splice.c has some, ahem, interesting uses that have been the source
of nasty exploits in the past.  Converting them to use iov_iter
properly would be really, really nice.  Christoph, I don't suppose
you'd like to do that?

The others seem to mostly be fixable, but I haven't looked that closely.

Overall, I suspect that a big part of why mitigations like the one
being discussed in this thread were developed is because addr_limit
used to be on the stack, making it (along with restart_block) a really
nice target.  This is fixed now on x86, arm64, and s390x, I believe,
and other arches can easily opt in to the fix.

* I'm strongly in favor of arches that have totally separate user and
kernel address spaces.  Sadly, the most common arches don't do this.
