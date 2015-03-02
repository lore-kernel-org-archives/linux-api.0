From: Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>
Subject: Re: [GIT PULL] Kselftest updates for 3.20-rc1
Date: Mon, 2 Mar 2015 16:19:48 -0500
Message-ID: <20150302211947.GA2184@codemonkey.org.uk>
References: <54D8FE1C.5040303@osg.samsung.com>
 <1423528239.19657.3.camel@ellerman.id.au>
 <54D95271.7070708@osg.samsung.com>
 <1423529039.19657.6.camel@ellerman.id.au>
 <54D958A0.1020404@osg.samsung.com>
 <1423538165.19657.8.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1423538165.19657.8.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 10, 2015 at 02:16:05PM +1100, Michael Ellerman wrote:
 
 > > On 02/09/2015 05:43 PM, Michael Ellerman wrote:
 > > > On Mon, 2015-02-09 at 17:36 -0700, Shuah Khan wrote:
 > > >> On 02/09/2015 05:30 PM, Michael Ellerman wrote:
 > > >>> On Mon, 2015-02-09 at 11:36 -0700, Shuah Khan wrote:
 > > >>>> Hi Linus,
 > > >>>>
 > > >>>> Please pull the following Kselftest updates for 3.20-rc1
 > > >>>>
 > > >>>> thanks,
 > > >>>> -- Shuah
 > > >>>>
 > > >>> ...
 > > >>>
 > > >>> I don't understand why you insist on merging this series with the logic copied
 > > >>> 18 times.
 > > >>>
 > > >>> I'm happy to tweak my series that uses an include file, but I don't see the
 > > >>> point of merging this series first when almost every line will be removed when
 > > >>> my series goes in.
 > > >>
 > > >> Please work on the suggestions I made and rework the patches
 > > >> and resend. As I mentioned earlier, I want to enable this work
 > > >> and them make improvements.
 > > > 
 > > > Yes I would like install to work to. I'd also like it to work for the powerpc
 > > > tests you ignored. But I don't want it to involve copying the same logic into
 > > > every Makefile in the tree.
 > > 
 > > > My series was sent over a month ago, with plenty of time for you to merge it
 > > > instead of this cut-and-paste solution.
 > > 
 > > I asked you to re-work the patches based on my suggestions
 > > and resend. I didn't see any patches from you that addressed
 > > the comments. I can't merge the patches you sent without
 > > addressing the comments.
 > 
 > Your comments were "please rebase on my series", and as I explained that is
 > pointless because my series replaces your series.

Michael's series also has a bunch of features this pull doesn't.
I had started implementing some of these features myself before realizing
this stuff was in limbo. (Especially the ability to install to a
different directory: our use case involves packaging up the latest
selftests for use to be run against a long-term stable kernel).

What needs to happen to unblock this, given that nothing has been
merged so far.

Working on selftests is sort of frustrating with all this stuff pending
given the potential conflicts.

	Dave
