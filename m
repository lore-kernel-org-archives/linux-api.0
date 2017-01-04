From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC, PATCHv2 29/29] mm, x86: introduce RLIMIT_VADDR
Date: Wed, 04 Jan 2017 14:55:41 +0100
Message-ID: <5530270.v1BLsanhbo@wuerfel>
References: <20161227015413.187403-1-kirill.shutemov@linux.intel.com>
 <21511994.eBlbEPoKOz@wuerfel>
 <CALCETrXmdAnbgjsxw=qTbP2PhVCzE8v3y5XMt8DVa4P9DowsGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CALCETrXmdAnbgjsxw=qTbP2PhVCzE8v3y5XMt8DVa4P9DowsGA@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arch <linux-arch@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Dave Hansen <dave.hansen@intel.com>, Catalin Marinas <catalin.marinas@arm.com>, X86 ML <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Ingo Molnar <mingo@redhat.com>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Tuesday, January 3, 2017 2:09:16 PM CET Andy Lutomirski wrote:
> >
> >> When
> >> ADDR_LIMIT_EXPLICIT is in effect, prctl can set a 64-bit numeric
> >> limit.  If ADDR_LIMIT_EXPLICIT is cleared, the prctl value stops being
> >> settable and reading it via prctl returns whatever is implied by the
> >> other personality bits.
> >
> > I don't see anything wrong with it, but I'm a bit confused now
> > what this would be good for, compared to using just prctl.
> >
> > Is this about setuid clearing the personality but not the prctl,
> > or something else?
> 
> It's to avid ambiguity as to what happens if you set ADDR_LIMIT_32BIT
> and use the prctl.  ISTM it would be nice for the semantics to be
> fully defined in all cases.
> 

Ok, got it.

	Arnd
