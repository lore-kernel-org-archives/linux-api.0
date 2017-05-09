From: Brian Gerst <brgerst@gmail.com>
Subject: Re: Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Tue, 9 May 2017 12:05:12 -0400
Message-ID: <CAMzpN2jmW3FmKXZmHNaK537oTdcrDvqatEYZk=aT2B7Qx=fEuA@mail.gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com> <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-hardening-return-7794-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>, Greg KH <greg@kroah.com>, Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@a>
List-Id: linux-api@vger.kernel.org

On Tue, May 9, 2017 at 9:00 AM, Andy Lutomirski <luto@kernel.org> wrote:
> On Tue, May 9, 2017 at 1:56 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Tue, May 09, 2017 at 08:45:22AM +0200, Ingo Molnar wrote:
>>> We only have ~115 code blocks in the kernel that set/restore KERNEL_DS, it would
>>> be a pity to add a runtime check to every system call ...
>>
>> I think we should simply strive to remove all of them that aren't
>> in core scheduler / arch code.  Basically evetyytime we do the
>>
>>         oldfs = get_fs();
>>         set_fs(KERNEL_DS);
>>         ..
>>         set_fs(oldfs);
>>
>> trick we're doing something wrong, and there should always be better
>> ways to archive it.  E.g. using iov_iter with a ITER_KVEC type
>> consistently would already remove most of them.
>
> How about trying to remove all of them?  If we could actually get rid
> of all of them, we could drop the arch support, and we'd get faster,
> simpler, shorter uaccess code throughout the kernel.
>
> The ones in kernel/compat.c are generally garbage.  They should be
> using compat_alloc_user_space().  Ditto for kernel/power/user.c.

compat_alloc_user_space() is a hack that should go away too.  It ends
up copying the data three times.

The more efficient solution to this is to have a core syscall function
that only accesses kernel memory, and then have two front-end
functions (native and compat) that do the actual reads and writes to
userspace, with conversion in the compat case.

--
Brian Gerst
