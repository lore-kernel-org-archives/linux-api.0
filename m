From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Wed, 10 May 2017 08:27:47 +0100
Message-ID: <20170510072746.GF390@ZenIV.linux.org.uk>
References: <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com>
 <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <20170509130250.GA11381@infradead.org>
 <20170509160322.GA15902@infradead.org>
 <20170510021118.GA390@ZenIV.linux.org.uk>
 <20170510024524.GB390@ZenIV.linux.org.uk>
 <20170510031254.GC390@ZenIV.linux.org.uk>
 <20170510065301.GC4115@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170510065301.GC4115@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>, Greg KH <greg@kroah.com>, Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Rik
List-Id: linux-api@vger.kernel.org

On Tue, May 09, 2017 at 11:53:01PM -0700, Christoph Hellwig wrote:
> On Wed, May 10, 2017 at 04:12:54AM +0100, Al Viro wrote:
> > What's the point?  What's wrong with having kernel_read()/kernel_readv()/etc.?
> > You still have set_fs() in there; doing that one level up in call chain would
> > be just fine...  IDGI.
> 
> The problem is that they modify the address limit, which the whole
> subthread here wants to get rid of.

And you *still* do the same.  Christoph, this is ridiculous - the worst
part of the area is not a couple of functions in fs/read_write.c, it's
a fucking lot of ->read() and ->write() instances in shitty driver code,
pardon the redundance.  And _that_ is still done under set_fs(KERNEL_DS).

Claiming that set_fs() done one function deeper in callchain (both in
fs/read_write.c) is somehow better because it reduces the amount of code
under that thing...  Get real, please - helpers that encapsulate those
set_fs() pairs (a-la kernel_read(), etc.) absolutely make sense and
converting their open-coded instances to calls of those helpers is clearly
a good thing.  However, we are not
	* getting rid of low-quality code run under KERNEL_DS
	* gettind rid of set_fs() itself
	* getting a generic kernel_read() variant that would really take
an iov_iter.

That's what I'm objecting to.  Centralized kernel_readv() et.al. - sure,
and fs/read_write.c is the right place for those.  No arguments here.
Conversion to those - absolutely; drivers have no fucking business touching
set_fs() at all.  But your primitives are trouble waiting to happen.
Let them take kvec arrays.  And let them, in case when there's no
->read_iter()/->write_iter(), do set_fs().  Statically, without this
if (iter->type & ITER_KVEC) ... stuff.

> > Another delicate place: you can't assume that write() always advances
> > file position by its (positive) return value.  btrfs stuff is sensitive
> > to that.
> 
> If we don't want to assume that we need to pass pointer to pos to
> kernel_read/write.  Which might be a good idea in general.

Yes.

> > ashmem probably _is_ OK with demanding ->read_iter(), but I'm not sure
> > about blind asma->file->f_pos += ret.  That's begging for races.  Actually,
> > scratch that - it *is* racy.
> 
> I think the proper fix is to not even bother to maintain f_pos of the
> backing file, as we don't ever use it - all reads from it pass in
> an explicit position anyway.

vfs_llseek() used by ashmem_llseek()...
