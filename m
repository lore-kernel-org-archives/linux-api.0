From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH V4] powerpc: add little endian flag to syscall_get_arch()
Date: Wed, 10 Dec 2014 13:20:15 +1100
Message-ID: <1418178015.30244.5.camel@concordia>
References: <24fcd2ea2c7633152e74a7a92abab1dd1782745d.1418157273.git.rgb@redhat.com>
	 <1557787.lOBez6GG22@sifl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1557787.lOBez6GG22@sifl>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, sgrubb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, tonyj-l3A5Bk7waGM@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2014-12-09 at 21:11 -0500, Paul Moore wrote:
> On Tuesday, December 09, 2014 03:37:07 PM Richard Guy Briggs wrote:
> > Since both ppc and ppc64 have LE variants which are now reported by uname,
> > add that flag (__AUDIT_ARCH_LE) to syscall_get_arch() and add
> > AUDIT_ARCH_PPC64LE variant.
> > 
> > Without this,  perf trace and auditctl fail.
> > 
> > Mainline kernel reports ppc64le (per a058801) but there is no matching
> > AUDIT_ARCH_PPC64LE.
> > 
> > Since 32-bit PPC LE is not supported by audit, don't advertise it in
> > AUDIT_ARCH_PPC* variants.
> > 
> > See:
> > 	https://www.redhat.com/archives/linux-audit/2014-August/msg00082.html
> > 	https://www.redhat.com/archives/linux-audit/2014-December/msg00004.html
> > 
> > Signed-off-by: Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  arch/powerpc/include/asm/syscall.h |    6 +++++-
> >  include/uapi/linux/audit.h         |    2 ++
> >  2 files changed, 7 insertions(+), 1 deletions(-)
> 
> The audit changes look fine to me, but as I mentioned earlier, this should go 
> in via the ppc tree and not the audit tree.
> 
> Acked-by: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>

Thanks.

Yep I'll take it via the powerpc tree, I'll CC stable as well as presumably we
want this to work in all versions that had LE support.

cheers
