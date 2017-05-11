From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Wed, 10 May 2017 17:18:33 -0700
Message-ID: <CALCETrX2Vi8vKk3Cee7EfiGxFUjS+Htn1gzyr_PQ+e9ktnAmTg@mail.gmail.com>
References: <20170428153213.137279-1-thgarnie@google.com> <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com> <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com> <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <CAK8P3a2j6h2MAx3h2NCtadcFsNuFcf158F5OV1e2SK37acZRRg@mail.gmail.com>
 <20170510080841.GG390@ZenIV.linux.org.uk> <20170510081431.GA16610@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170510081431.GA16610@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>, Greg KH <greg@kroah.com>, Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>Paolo Bonzini <p>
List-Id: linux-api@vger.kernel.org

On Wed, May 10, 2017 at 1:14 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, May 10, 2017 at 09:08:41AM +0100, Al Viro wrote:
>> On Wed, May 10, 2017 at 09:37:04AM +0200, Arnd Bergmann wrote:
>>
>> > > How about trying to remove all of them?  If we could actually get rid
>> > > of all of them, we could drop the arch support, and we'd get faster,
>> > > simpler, shorter uaccess code throughout the kernel.
>>
>> BTW, not all get_user() under KERNEL_DS are plain loads.  There is an
>> exception - probe_kernel_read().
>
> And various calls that looks like opencoded versions, e.g. drivers/dio
> or the ELF loader.
>
> But in the long run we'll just need a separate primitive for that,
> but that can wait until the set_fs calls outside the core code are
> gone.

I suspect that, on most arches, the primitive is called
__copy_from_user().  We could make the generic code do that except
where overridden.
