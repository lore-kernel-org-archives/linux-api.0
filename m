From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Tue, 9 May 2017 23:54:48 -0700
Message-ID: <20170510065448.GD4115@infradead.org>
References: <20170509064522.anusoikaalvlux3w@gmail.com>
 <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <20170509130250.GA11381@infradead.org>
 <20170509160322.GA15902@infradead.org>
 <20170510021118.GA390@ZenIV.linux.org.uk>
 <20170510024524.GB390@ZenIV.linux.org.uk>
 <20170510031254.GC390@ZenIV.linux.org.uk>
 <20170510032137.GD390@ZenIV.linux.org.uk>
 <20170510033911.GE390@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170510033911.GE390@ZenIV.linux.org.uk>
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

On Wed, May 10, 2017 at 04:39:12AM +0100, Al Viro wrote:
> fcntl stuff: I've decided not to put something similar into work.compat
> since I couldn't decide what to do with compat stuff - word-by-word copy
> from userland converting to struct flock + conversion to posix_lock +
> actual work + conversion to flock + word-by-word copy to userland...  Smells
> like we might be better off with compat_flock_to_posix_lock() et.al.
> I'm still not sure; played a bit one way and another and dediced to drop
> it for now.  Hell knows...

My version already is an improvement in lines of code alone.  Between
that and stopping to mess with the address limit I think it's a clear
winner.  But it's pretty independent of the rest, and I'll just run
it through Jeff and Bruce and ask them what they think.
