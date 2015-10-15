From: Szabolcs Nagy <nsz@port70.net>
Subject: Re: [PATCHv3] ARM64:Fix MINSIGSTKSZ and SIGSTKSZ
Date: Thu, 15 Oct 2015 14:12:41 +0200
Message-ID: <20151015121241.GA26080@port70.net>
References: <1444386580-10917-1-git-send-email-manjeet.p@samsung.com>
 <20151009103352.GK26278@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151009103352.GK26278@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Manjeet Pawar <manjeet.p@samsung.com>, catalin.marinas@arm.com, arnd@arndb.de, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, pankaj.m@samsung.com, Akhilesh Kumar <akhilesh.k@samsung.com>, Rohit Thapliyal <r.thapliyal@samsung.com>
List-Id: linux-api@vger.kernel.org

* Will Deacon <will.deacon@arm.com> [2015-10-09 11:33:52 +0100]:

> On Fri, Oct 09, 2015 at 03:59:40PM +0530, Manjeet Pawar wrote:
> > MINSIGSTKSZ and SIGSTKSZ for ARM64 are not correctly set in latest kernel.
> > This patch fixes this issue.
> > 
> > This issue is reported in LTP (testcase: sigaltstack02.c).
> > Testcase failed when sigaltstack() called with stack size "MINSIGSTKSZ - 1"
> > Since in Glibc-2.22, MINSIGSTKSZ is set to 5120 but in kernel
> > it is set to 2048 so testcase gets failed.
> > 
> > Testcase Output:
> > sigaltstack02 1  TPASS  :  stgaltstack() fails, Invalid Flag value,errno:22
> > sigaltstack02 2  TFAIL  :  sigaltstack() returned 0, expected -1,errno:12
> 
> I'm still unable to reproduce this failure. Is this with defconfig?
> 
> > Reported Issue in Glibc Bugzilla:
> > Bugfix in Glibc-2.22: [Bug 16850]
> > https://sourceware.org/bugzilla/show_bug.cgi?id=16850
> > 
> > Signed-off-by: Akhilesh Kumar <akhilesh.k@samsung.com>
> > Signed-off-by: Manjeet Pawar <manjeet.p@samsung.com>
> > Signed-off-by: Rohit Thapliyal <r.thapliyal@samsung.com>
> > ---
> > v1 -> Changes in uapi overall header
> > v2 -> Changes done in arm64 headers
> > v3 -> Changes done in both uapi & arm64 headers
> > 
> >  arch/arm64/include/uapi/asm/signal.h |    3 +++
> >  include/uapi/asm-generic/signal.h    |    2 ++
> >  2 files changed, 5 insertions(+)
> 
> Acked-by: Will Deacon <will.deacon@arm.com>
> 
> Arnd: are you planning to take this via asm-generic, or shall I queue it
> on the arm64 fixes branch?
> 

i just noticed this and wanted to note that an old
glibc can fail on a new kernel with this patch if
an application uses MINSIGSTKSZ altstack.

(the specific LTP bug could have been fixed on the libc
side, checking against whatever the libc MINSIGSTKSZ is
as long as it is larger than the kernel value, which
makes sense as userspace may have additional overhead
the kernel is not aware of so please don't try to keep
this in sync with glibc.. hopefully there will not be
another change though).

> Will
> 
> > diff --git a/arch/arm64/include/uapi/asm/signal.h b/arch/arm64/include/uapi/asm/signal.h
> > index 8d1e723..991bf5d 100644
> > --- a/arch/arm64/include/uapi/asm/signal.h
> > +++ b/arch/arm64/include/uapi/asm/signal.h
> > @@ -19,6 +19,9 @@
> >  /* Required for AArch32 compatibility. */
> >  #define SA_RESTORER	0x04000000
> >  
> > +#define MINSIGSTKSZ 5120
> > +#define SIGSTKSZ    16384
> > +
> >  #include <asm-generic/signal.h>
> >  
> >  #endif
> > diff --git a/include/uapi/asm-generic/signal.h b/include/uapi/asm-generic/signal.h
> > index 9df61f1..b98b67b 100644
> > --- a/include/uapi/asm-generic/signal.h
> > +++ b/include/uapi/asm-generic/signal.h
> > @@ -80,8 +80,10 @@
> >   *	SA_RESTORER	0x04000000
> >   */
> >  
> > +#if !defined MINSIGSTKSZ || !defined SIGSTKSZ
> >  #define MINSIGSTKSZ	2048
> >  #define SIGSTKSZ	8192
> > +#endif
> >  
> >  #ifndef __ASSEMBLY__
> >  typedef struct {
> > -- 
> > 1.7.9.5
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
