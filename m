From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v5 00/30] ARM Scalable Vector Extension (SVE)
Date: Tue, 9 Jan 2018 19:51:20 +0300
Message-ID: <20180109165120.6ravt4stp3654374@yury-thinkpad>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
 <20180108144905.qu5qbmaaglcgwvwq@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180108144905.qu5qbmaaglcgwvwq@yury-thinkpad>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "H . J . Lu" <hjl.tools@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will.deacon@arm.com>, Oleg Nesterov <oleg@redhat.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Alan Hayward <alan.hayward@arm.com>, Thomas Gleixner <tglx@linutronix.de>, linux-api@vger.kernel.org, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, kvmarm@lists.cs.columbia.edu, Ch
List-Id: linux-api@vger.kernel.org

On Mon, Jan 08, 2018 at 05:49:05PM +0300, Yury Norov wrote:
> On Tue, Oct 31, 2017 at 03:50:52PM +0000, Dave Martin wrote:
> > This series implements Linux kernel support for the ARM Scalable Vector
> > Extension (SVE). [1]  It supersedes the previous v3: see [3] for link
> > and full cover letter.
> > 
> > This is a minor update to v4, but does contain a couple of important
> > fixes.
> > 
> > As in previous postings, the last two patches (here 29-30) are still
> > RFC and not proposed for merging at this time.
> > 
> > The patches apply on
> > git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git
> > for-next/core
> > d7b1d22d3821 ("arm64: uapi: Remove PSR_Q_BIT")
> > 
> > To reduce spam, some people may not been copied on the entire series.
> > For those who did not receive the whole series, it can be found in the
> > linux-arm-kernel archive. [2]
> > 
> > See the individual patches for details of changes.
> > 
> > For reviewer convenience, a git tree is available. [4]
> > 
> > Since there are some changes against already-reviewed patches, I've also
> > pushed an unsquashed fixes tree for people to take a look at if it
> > helps. [5]
> > 
> > 
> > Summary:
> > 
> >  * "regset: Add support for dynamically sized regsets" fixed to avoid
> >    x86 breakage;
> > 
> >  * one trival arm64 patch added to add asmlinkage annotations, and a
> >    corresponding minor change to the Core task context handling patch;
> > 
> >  * one new arm64 fix ("signal: Verify extra data is user-readable in
> >    sys_rt_sigreturn") to ensure that access_ok() checks are done for the
> >    whole extended signal frame, not just the base frame;
> > 
> >  * one minor fix to the SVE sigreturn code to return consistent
> >    intermediate error values (semantic correctness, non-functional
> >    change);
> > 
> >  * one minor change to call __copy_from_user() instead of
> >    copy_from_user() in a situation where there is already an access_ok()
> >    check;
> > 
> > 
> > [1] ARM Scalable Vector Extension
> > https://community.arm.com/groups/processors/blog/2016/08/22/technology-update-the-scalable-vector-extension-sve-for-the-armv8-a-architecture
> > 
> > [2] linux-arm-kernel October 2017 Archives by thread
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2017-October/thread.html
> > 
> > [3] [PATCH v4 00/28] ARM Scalable Vector Extension (SVE)
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2017-October/539414.html
> > 
> > [4] For review and testing only -- **do not pull**
> >     (This branch has review changelogs which should not form part of
> >     the final commits.)
> > 
> >     v5 series (this posting)
> > 
> >     http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve/v5
> >     git://linux-arm.org/linux-dm.git sve/v5
> > 
> > [5] For review and testing only -- **do not pull**
> >     (This branch has review changelogs which should not form part of
> >     the final commits.)
> > 
> >     v4 with unsquashed fixes
> > 
> >     http://linux-arm.org/git?p=linux-dm.git;a=shortlog;h=refs/heads/sve/v4%2Bfixes
> >     git://linux-arm.org/linux-dm.git sve/v4+fixes
> 
> Hi Dave,
> 
> During rebase of my ILP32 series on 4.15 kernel I found that 
> ILP32 needs to be enabled with SVE support, like you do for 
> LP64 in this series.
> 
> I did all rebase work on this draft branch:
> https://github.com/norov/linux/tree/ilp32-4.15-rc7
> 
> But any ILP32 program I tried crash, and the message in dmesg looks
> like this:
> [   39.510667] CPU: 0 PID: 1857 Comm: mytime Not tainted 4.15.0-rc7-00028-g45e0659df4d9 #41
> [   39.510712] Hardware name: linux,dummy-virt (DT)
> [   39.510829] pstate: 00000000 (nzcv daif -PAN -UAO)
> [   39.511101] pc : 0x33488e28
> [   39.511125] lr : 0x33488e28
> [   39.511138] sp : 00000000fffef670
> [   39.511158] x29: 000000005a536c33 x28: 0000000000000000 
> [   39.511211] x27: 0000000000000000 x26: 0000000000000000 
> [   39.511235] x25: 0000000000000000 x24: 0000000000000000 
> [   39.511257] x23: 0000000000466000 x22: 0000000000000000 
> [   39.511278] x21: 0000000000000000 x20: 000000000047f2a8 
> [   39.511300] x19: 0000000000000000 x18: 0000000000000001 
> [   39.511321] x17: 0000000000001000 x16: 0000000000001030 
> [   39.511342] x15: 0000000000554e47 x14: 0000000000000001 
> [   39.511364] x13: 0000000000000004 x12: 000000000000003c 
> [   39.511385] x11: 0000100000000000 x10: 0800000000000000 
> [   39.511406] x9 : 0fffffffffffffff x8 : 000000000000007c 
> [   39.511427] x7 : 0000000000000077 x6 : 0000000000000041 
> [   39.511448] x5 : 0000000000000411 x4 : 00000000fbad2488 
> [   39.511468] x3 : 0000000000000001 x2 : 0000000000497950 
> [   39.511489] x1 : 0000000000497550 x0 : 0000000000000001

Hi Dave,

I fixed the crash. It was my local problem.

Thanks,
Yury
