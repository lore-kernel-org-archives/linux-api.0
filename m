From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [GIT PULL] Kselftest updates for 3.20-rc1
Date: Tue, 10 Feb 2015 14:16:05 +1100
Message-ID: <1423538165.19657.8.camel@ellerman.id.au>
References: <54D8FE1C.5040303@osg.samsung.com>
	 <1423528239.19657.3.camel@ellerman.id.au>
	 <54D95271.7070708@osg.samsung.com>
	 <1423529039.19657.6.camel@ellerman.id.au>
	 <54D958A0.1020404@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54D958A0.1020404-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2015-02-09 at 18:02 -0700, Shuah Khan wrote:
> On 02/09/2015 05:43 PM, Michael Ellerman wrote:
> > On Mon, 2015-02-09 at 17:36 -0700, Shuah Khan wrote:
> >> On 02/09/2015 05:30 PM, Michael Ellerman wrote:
> >>> On Mon, 2015-02-09 at 11:36 -0700, Shuah Khan wrote:
> >>>> Hi Linus,
> >>>>
> >>>> Please pull the following Kselftest updates for 3.20-rc1
> >>>>
> >>>> thanks,
> >>>> -- Shuah
> >>>>
> >>>> The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:
> >>>>
> >>>>   Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)
> >>>>
> >>>> are available in the git repository at:
> >>>>
> >>>>   git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
> >>>> tags/linux-kselftest-3.20-rc1
> >>>>
> >>>> for you to fetch changes up to 6ddf898c23d62c974e148efd9e509731324a167a:
> >>>>
> >>>>   selftests/exec: Check if the syscall exists and bail if not
> >>>> (2015-02-04 10:17:35 -0700)
> >>>>
> >>>> ----------------------------------------------------------------
> >>>> Kselftest updates for 3.20-rc1
> >>>>
> >>>> This update adds:
> >>>> - Kselftest install target feature
> >>>> - Fix for selftests/exec test
> >>>>
> >>>> ----------------------------------------------------------------
> >>>> Michael Ellerman (1):
> >>>>       selftests/exec: Check if the syscall exists and bail if not
> >>>>
> >>>> Shuah Khan (20):
> >>>>       selftests/breakpoints: add install target to enable test install
> >>>>       selftests/cpu-hotplug: add install target to enable test install
> >>>>       selftests/efivarfs: add install target to enable test install
> >>>>       selftests/firmware: add install target to enable test install
> >>>>       selftests/ftrace: add install target to enable test install
> >>>>       selftests/ipc: add install target to enable test install
> >>>>       selftests/kcmp: add install target to enable test install
> >>>>       selftests/memfd: add install target to enable test install
> >>>>       selftests/memory-hotplug: add install target to enable test install
> >>>>       selftests/mount: add install target to enable test install
> >>>>       selftests/mqueue: add install target to enable test install
> >>>>       selftests/net: add install target to enable test install
> >>>>       selftests/ptrace: add install target to enable test install
> >>>>       selftests/size: add install target to enable test install
> >>>>       selftests/sysctl: add install target to enable test install
> >>>>       selftests/timers: add install target to enable test install
> >>>>       selftests/user: add install target to enable test install
> >>>>       selftests/vm: add install target to enable test install
> >>>>       selftests: add install target to enable test install
> >>>>       kbuild: add a new kselftest_install make target to install selftests
> >>>
> >>>
> >>> I don't understand why you insist on merging this series with the logic copied
> >>> 18 times.
> >>>
> >>> I'm happy to tweak my series that uses an include file, but I don't see the
> >>> point of merging this series first when almost every line will be removed when
> >>> my series goes in.
> >>
> >> Please work on the suggestions I made and rework the patches
> >> and resend. As I mentioned earlier, I want to enable this work
> >> and them make improvements.
> > 
> > Yes I would like install to work to. I'd also like it to work for the powerpc
> > tests you ignored. But I don't want it to involve copying the same logic into
> > every Makefile in the tree.
> 
> Michael,
> 
> powerpc tests aren't ignored. They are in the list to do as
> the next step.

They are ignored by this series, unlike my series.

> > My series was sent over a month ago, with plenty of time for you to merge it
> > instead of this cut-and-paste solution.
> 
> I asked you to re-work the patches based on my suggestions
> and resend. I didn't see any patches from you that addressed
> the comments. I can't merge the patches you sent without
> addressing the comments.

Your comments were "please rebase on my series", and as I explained that is
pointless because my series replaces your series.

cheers
