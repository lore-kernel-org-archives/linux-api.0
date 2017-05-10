From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
Date: Tue, 9 May 2017 23:53:01 -0700
Message-ID: <20170510065301.GC4115@infradead.org>
References: <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com>
 <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <20170509130250.GA11381@infradead.org>
 <20170509160322.GA15902@infradead.org>
 <20170510021118.GA390@ZenIV.linux.org.uk>
 <20170510024524.GB390@ZenIV.linux.org.uk>
 <20170510031254.GC390@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170510031254.GC390@ZenIV.linux.org.uk>
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

On Wed, May 10, 2017 at 04:12:54AM +0100, Al Viro wrote:
> What's the point?  What's wrong with having kernel_read()/kernel_readv()/=
etc.?
> You still have set_fs() in there; doing that one level up in call chain w=
ould
> be just fine...  IDGI.

The problem is that they modify the address limit, which the whole
subthread here wants to get rid of.

> Broken commit: "net: don't play with address limits in kernel_recvmsg".
> It would be OK if it was only about data.  Unfortunately, that's not
> true in one case: svc_udp_recvfrom() wants ->msg_control.

Dropped, but we'll need to fix that eventually.

> Another delicate place: you can't assume that write() always advances
> file position by its (positive) return value.  btrfs stuff is sensitive
> to that.

If we don't want to assume that we need to pass pointer to pos to
kernel_read/write.  Which might be a good idea in general.

> ashmem probably _is_ OK with demanding ->read_iter(), but I'm not sure
> about blind asma->file->f_pos +=3D ret.  That's=A0begging for races.  Act=
ually,
> scratch that - it *is* racy.

I think the proper fix is to not even bother to maintain f_pos of the
backing file, as we don't ever use it - all reads from it pass in
an explicit position anyway.
