From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Wed, 10 May 2017 09:08:41 +0100
Message-ID: <20170510080841.GG390@ZenIV.linux.org.uk>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com>
 <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <CAK8P3a2j6h2MAx3h2NCtadcFsNuFcf158F5OV1e2SK37acZRRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a2j6h2MAx3h2NCtadcFsNuFcf158F5OV1e2SK37acZRRg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>, Greg KH <greg@kroah.com>, Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, May 10, 2017 at 09:37:04AM +0200, Arnd Bergmann wrote:

> > How about trying to remove all of them?  If we could actually get rid
> > of all of them, we could drop the arch support, and we'd get faster,
> > simpler, shorter uaccess code throughout the kernel.

BTW, not all get_user() under KERNEL_DS are plain loads.  There is an
exception - probe_kernel_read().

> > The ones in kernel/compat.c are generally garbage.  They should be
> > using compat_alloc_user_space().  Ditto for kernel/power/user.c.
> 
> compat_alloc_user_space() has some problems too, it adds
> complexity to a rarely-tested code path and can add some noticeable
> overhead in cases where user space access is slow because of
> extra checks.
> 
> It's clearly better than set_fs(), but the way I prefer to convert the
> code is to avoid both and instead move compat handlers next to
> the native code, and splitting out the common code between native
> and compat mode into a helper that takes a regular kernel pointer.
> 
> I think that's what both Al has done in the past on compat_ioctl()
> and select() and what Christoph does in his latest series, but
> it seems worth pointing out for others that decide to help out here.

Folks, reducing the amount of places where we play with set_fs() is certainly
a good thing.  Getting rid of them completely is something entirely different;
I have tried to plot out patch series in this direction many times during the
last 5 years or so, but it's not going to be easy.  Tomorrow I can start
posting my notes in that direction (and there are tons of those, unfortunately
mixed with git grep results, highly unprintable personal comments, etc.);
just let me grab some sleep first...

BTW, slow userland access is not just due to extra checks; access_ok(),
in particular, is pretty much noise.  The real PITA comes from the things
like STAC/CLAC on recent x86.  Or hardware overhead of cross-address-space
block copy insn (e.g. on s390, where it's optimized for multi-cacheline
blocks).  Or things like uml, where it's a matter of walking the page
tables for each sodding __get_user().  It's not always just a matter of
address space limit...
