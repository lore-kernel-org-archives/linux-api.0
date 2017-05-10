From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Wed, 10 May 2017 04:12:54 +0100
Message-ID: <20170510031254.GC390@ZenIV.linux.org.uk>
References: <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com>
 <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <20170509130250.GA11381@infradead.org>
 <20170509160322.GA15902@infradead.org>
 <20170510021118.GA390@ZenIV.linux.org.uk>
 <20170510024524.GB390@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170510024524.GB390@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>, Greg KH <greg@kroah.com>, Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Rik
List-Id: linux-api@vger.kernel.org

On Wed, May 10, 2017 at 03:45:24AM +0100, Al Viro wrote:

> FWIW, some parts of that queue are obviously sane; it's the conversions of
> kernel_write() and friends to ->read_iter/->write_iter() that are non-starters.

Egads...  OK, I *have* misread what you are doing there.  Your vfs_iter_read()
works for files sans ->read_iter().  For strange values of "works" - you
hardwire "it's either iovec or kvec iterator" into its calling conventions,
which is a trouble waiting to happen.

What's the point?  What's wrong with having kernel_read()/kernel_readv()/etc.?
You still have set_fs() in there; doing that one level up in call chain would
be just fine...  IDGI.

Broken commit: "net: don't play with address limits in kernel_recvmsg".
It would be OK if it was only about data.  Unfortunately, that's not
true in one case: svc_udp_recvfrom() wants ->msg_control.

Another delicate place: you can't assume that write() always advances
file position by its (positive) return value.  btrfs stuff is sensitive
to that.

ashmem probably _is_ OK with demanding ->read_iter(), but I'm not sure
about blind asma->file->f_pos += ret.  That's begging for races.  Actually,
scratch that - it *is* racy.
