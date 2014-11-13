From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC PATCH 0/1] arm64: Fix /proc/cpuinfo
Date: Thu, 13 Nov 2014 17:48:00 +0000
Message-ID: <20141113174800.GD22361@e104818-lin.cambridge.arm.com>
References: <1414159000-27059-1-git-send-email-mark.rutland@arm.com>
 <20141106164311.GD19702@e104818-lin.cambridge.arm.com>
 <20141106165430.GH31605@arm.com>
 <20141106170548.GF19702@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141106170548.GF19702@e104818-lin.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <Will.Deacon@arm.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "ghackmann@google.com" <ghackmann@google.com>, "ijc@hellion.org.uk" <ijc@hellion.org.uk>, Serban Constantinescu <Serban.Constantinescu@arm.com>, "cross-distro@lists.linaro.org" <cross-distro@lists.linaro.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 06, 2014 at 05:05:48PM +0000, Catalin Marinas wrote:
> On Thu, Nov 06, 2014 at 04:54:31PM +0000, Will Deacon wrote:
> > On Thu, Nov 06, 2014 at 04:43:12PM +0000, Catalin Marinas wrote:
> > > On Fri, Oct 24, 2014 at 02:56:39PM +0100, Mark Rutland wrote:
> > > > [d] Print different hwcaps dependent on the personality.
> > > > 
> > > >     This would allow for 32-bit and 64-bit applications to function
> > > >     correctly, but for some 32-bit applications the personality would
> > > >     need to be set explicitly by the user.
> > > 
> > > Which makes this option actually in line with the uname -m behaviour. My
> > > vote goes for [d] with option [b] as a close alternative.
> > > 
> > > > [1] arm, v3.17, Versatile Express A15x2 A7x3 coretile
> > > > Features        : half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm 
> > > [...]
> > > > [2] arm64, v3.17, Juno platform
> > > > Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32 
> > > 
> > > As an exercise, I'm trying to see what option [b] would look like when
> > > CONFIG_COMPAT is enabled:
> > > 
> > > Features        : fp asimd evtstrm aes pmull sha1 sha2 crc32 half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae
> > > 
> > > The duplicate strings would only be listed once (evtstrm, aes, pmull,
> > > sha1, sha2, crc32). New AArch64 features that we may expect to be
> > > optional on AArch32 could be prefixed with "a64". If they are missing
> > > entirely from AArch32, (like asimd), no need for the prefix.
> > > 
> > > The advantage is that we don't need to check the personality but we have
> > > to assume that scripts would not search for substrings (sane people
> > > shouldn't do this anyway as the Features string can always be extended).
> > 
> > And a big disadvantage is that I can imagine AArch64 applications checking
> > for "neon" instead of "asimd", which will break if they're run under kernels
> > without COMPAT support enabled.
[...]
> > So I'm inclined to stick with Mark's patch as it is.
> 
> If we don't hear otherwise, I propose sometime next week we queue Mark's
> patch for -next.

As we haven't heard otherwise:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
