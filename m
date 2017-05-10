From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Wed, 10 May 2017 01:14:31 -0700
Message-ID: <20170510081431.GA16610@infradead.org>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com>
 <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <CAK8P3a2j6h2MAx3h2NCtadcFsNuFcf158F5OV1e2SK37acZRRg@mail.gmail.com>
 <20170510080841.GG390@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170510080841.GG390@ZenIV.linux.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mark Rutland <mark.rutland@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <greg@kroah.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-s390 <linux-s390@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Christoph Hellwig <hch@infradead.org>, Christian Borntraeger <borntraeger@de.ibm.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Catalin Marinas <catalin.marinas@arm.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@c>
List-Id: linux-api@vger.kernel.org

On Wed, May 10, 2017 at 09:08:41AM +0100, Al Viro wrote:
> On Wed, May 10, 2017 at 09:37:04AM +0200, Arnd Bergmann wrote:
> 
> > > How about trying to remove all of them?  If we could actually get rid
> > > of all of them, we could drop the arch support, and we'd get faster,
> > > simpler, shorter uaccess code throughout the kernel.
> 
> BTW, not all get_user() under KERNEL_DS are plain loads.  There is an
> exception - probe_kernel_read().

And various calls that looks like opencoded versions, e.g. drivers/dio
or the ELF loader.

But in the long run we'll just need a separate primitive for that,
but that can wait until the set_fs calls outside the core code are
gone.
