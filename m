From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv3] ARM64:Fix MINSIGSTKSZ and SIGSTKSZ
Date: Thu, 15 Oct 2015 14:44:05 +0200
Message-ID: <6205380.pxTZSIhjca@wuerfel>
References: <1444386580-10917-1-git-send-email-manjeet.p@samsung.com> <20151009103352.GK26278@arm.com> <20151015121241.GA26080@port70.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20151015121241.GA26080@port70.net>
Sender: linux-arch-owner@vger.kernel.org
To: Szabolcs Nagy <nsz@port70.net>
Cc: Will Deacon <will.deacon@arm.com>, Manjeet Pawar <manjeet.p@samsung.com>, catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, pankaj.m@samsung.com, Akhilesh Kumar <akhilesh.k@samsung.com>, Rohit Thapliyal <r.thapliyal@samsung.com>
List-Id: linux-api@vger.kernel.org

On Thursday 15 October 2015 14:12:41 Szabolcs Nagy wrote:
> * Will Deacon <will.deacon@arm.com> [2015-10-09 11:33:52 +0100]:
> 
> > On Fri, Oct 09, 2015 at 03:59:40PM +0530, Manjeet Pawar wrote:
> > > MINSIGSTKSZ and SIGSTKSZ for ARM64 are not correctly set in latest kernel.
> > > This patch fixes this issue.
> > > 
> > > This issue is reported in LTP (testcase: sigaltstack02.c).
> > > Testcase failed when sigaltstack() called with stack size "MINSIGSTKSZ - 1"
> > > Since in Glibc-2.22, MINSIGSTKSZ is set to 5120 but in kernel
> > > it is set to 2048 so testcase gets failed.
> > > 
> > > Testcase Output:
> > > sigaltstack02 1  TPASS  :  stgaltstack() fails, Invalid Flag value,errno:22
> > > sigaltstack02 2  TFAIL  :  sigaltstack() returned 0, expected -1,errno:12
> > 
> > I'm still unable to reproduce this failure. Is this with defconfig?
> > 
> > > Reported Issue in Glibc Bugzilla:
> > > Bugfix in Glibc-2.22: [Bug 16850]
> > > https://sourceware.org/bugzilla/show_bug.cgi?id=16850
> > > 
> > > Signed-off-by: Akhilesh Kumar <akhilesh.k@samsung.com>
> > > Signed-off-by: Manjeet Pawar <manjeet.p@samsung.com>
> > > Signed-off-by: Rohit Thapliyal <r.thapliyal@samsung.com>
> > > ---
> > > v1 -> Changes in uapi overall header
> > > v2 -> Changes done in arm64 headers
> > > v3 -> Changes done in both uapi & arm64 headers
> > > 
> > >  arch/arm64/include/uapi/asm/signal.h |    3 +++
> > >  include/uapi/asm-generic/signal.h    |    2 ++
> > >  2 files changed, 5 insertions(+)
> > 
> > Acked-by: Will Deacon <will.deacon@arm.com>
> > 
> > Arnd: are you planning to take this via asm-generic, or shall I queue it
> > on the arm64 fixes branch?
> > 
> 
> i just noticed this and wanted to note that an old
> glibc can fail on a new kernel with this patch if
> an application uses MINSIGSTKSZ altstack.

Well worth noting, but I think we should consider this intentional:

If an application built against an old glibc uses MINSIGSTKSZ, it
current gets random data corruption of a segmentation fault that
are both hard to track down, while a new kernel would result in
more sensible error code that is easier to debug.

	Arnd
