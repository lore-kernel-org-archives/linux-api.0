From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 00/29] y2038: add time64 syscalls
Date: Fri, 18 Jan 2019 09:45:18 -0800
Message-ID: <1547833518.2794.36.camel@HansenPartnership.com>
References: <20190118161835.2259170-1-arnd@arndb.de>
         <be3863ae-d903-8e9e-5e6c-e4a58fac189d@blastwave.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <be3863ae-d903-8e9e-5e6c-e4a58fac189d@blastwave.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dennis Clarke <dclarke@blastwave.org>, Arnd Bergmann <arnd@arndb.de>, y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mattst88@gmail.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, tony.luck@intel.com, fenghua.yu@intel.com, geert@linux-m68k.org, monstr@monstr.eu, paul.burton@mips.com, deller@gmx.de, benh@kernel.crashing.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, dalias@libc.org, davem@davemloft.net, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, jcmvbkbc@gmail.com, akpm@linux-foundation.org, deepa.kernel@gmail.com, ebiederm@xmission.com, firoz.khan@linaro.org, linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 2019-01-18 at 11:57 -0500, Dennis Clarke wrote:
> On 1/18/19 11:18 AM, Arnd Bergmann wrote:
> > This is a minor update of the patches I posted last week, I
> > would like to add this into linux-next now, but would still do
> > changes if there are concerns about the contents. The first
> > version did not see a lot of replies, which could mean that
> > either everyone is happy with it, or that it was largely ignored.
> > 
> > See also the article at https://lwn.net/Articles/776435/.
> 
> I would be happy to read "Approaching the kernel year-2038 end game"
> however it is behind a pay wall.  Perhaps it may be best to just
> host interesting articles about open source idea elsewhere.

Hey, this is an unfair characterization: lwn.net operates an early
access subscription model, so you can't read the above for 14 days
after publication without paying for an lwn.net subscription, but by
the time these patches are upstream there will be no paywall because it
will expire on 24 January and that URL will then be readable by all. 
That makes LWN.net a nice, reliable resource for us while still
supporting some business model to keep it going.

James
