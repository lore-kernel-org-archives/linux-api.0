From: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/5] selftests: Add futex functional tests
Date: Tue, 12 May 2015 10:05:44 -0700
Message-ID: <20150512170544.GA30184@fury.dvhart.com>
References: <5550FB2C.1000403@osg.samsung.com>
 <D17653E0.CC29F%dvhart@linux.intel.com>
 <5551164E.5080409@osg.samsung.com>
 <D17670E1.CC354%dvhart@linux.intel.com>
 <55512B54.50304@osg.samsung.com>
 <55512B86.2040900@osg.samsung.com>
 <D1767EA1.CC3DA%dvhart@linux.intel.com>
 <20150512100256.GA5122@rei.suse.de>
 <D1777231.CC5D0%dvhart@linux.intel.com>
 <55522E92.8090609@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55522E92.8090609-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 12, 2015 at 10:47:14AM -0600, Shuah Khan wrote:
> On 05/12/2015 10:10 AM, Darren Hart wrote:
> > On 5/12/15, 3:02 AM, "Cyril Hrubis" <chrubis-AlSwsSmVLrQ@public.gmane.org> wrote:
> > 
> >> Hi!
> >>> I'm happy to do that, but I would like to make sure I'm doing the right
> >>> thing.
> >>
> >> The right thing here is to add -pthread to CFLAGS which sets both flags
> >> for preprocessor and linker (see man gcc).
> > 
> > Hi Cyril,
> > 
> > Thanks. I read that, and mentioned it, but my concern with -pthread in the
> > CFLAGS and LDFLAGS is that it is a non-standard compiler flag. I
> > understand we have a number of gcc-isms in our build - but do we want to
> > add more?
> > 
> > I'm also struggling to find any kind of prescribed documentation on this
> > beyond the short blurb in the gcc man page which describes what this
> > option does, but not when to use it. I'll need something concrete to
> > justify changes to testcase Makefiles to Shuah.
> > 
> > Unfortunately, all these options are functional for me, while some are not
> > for Shuah, so I'm currently having to rely on documentation which seems
> > pretty sparse.
> > 
> 
> Hi Daren,
> 
> My goals are really simple. make kselftest doesn't break. All tests
> compile and run and install or fail gracefully when dependencies aren't
> met. As long as the above are met, I don't really worry about what
> individual test Makefiles do.

Understood. Given the variability across distros/compiler versions, the
"doesn't break" part isn't as straight forward as it should be. I could fix
this so it builds for you and me, but I'm trying to build confidence that I'm
doing this "correctly" so it doesn't break in other scenarios - since I'm not
seeing any breakage on my systems.

Shuah, which distro and compiler version are you seeing the build failure on?
I'd like to at least reproduce that so I can be confident my next version will
at least build in your environment.

Currently, the only direction I have is gcc man page and Cyril's advocacy for
-pthread. Does the following work for you (it still does for me)?


>From 0b7284551d6419520d5ce8833e177ba5b8be2286 Mon Sep 17 00:00:00 2001
Message-Id: <0b7284551d6419520d5ce8833e177ba5b8be2286.1431449782.git.dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
From: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Date: Tue, 12 May 2015 09:54:39 -0700
Subject: [PATCH] selftests/futex: Add -pthread to CFLAGS and LDFLAGS

Certain environments fail to build with the "-lpthread -lrt" LDFLAGS.
Using "-pthread" instead of "-lpthread" resolves this and is the
documented mechanism in the gcc man page.

Signed-off-by: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 tools/testing/selftests/futex/functional/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index e64d43b..9d6b75e 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -1,6 +1,6 @@
 INCLUDES := -I../include -I../../
-CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE $(INCLUDES)
-LDFLAGS := $(LDFLAGS) -lpthread -lrt
+CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES)
+LDFLAGS := $(LDFLAGS) -pthread -lrt
 
 HEADERS := ../include/futextest.h
 TARGETS := \
-- 
2.1.4


-- 
Darren Hart
Intel Open Source Technology Center
