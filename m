From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 3/3] selftests/kcmp: Always try to build the test
Date: Tue, 02 Dec 2014 16:44:02 +1100
Message-ID: <1417499042.31336.8.camel@concordia>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
	 <1414040834-30209-3-git-send-email-mpe@ellerman.id.au>
	 <5448FD72.9040301@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5448FD72.9040301@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, shuahkh@osg.samsung.com, linux-api@vger.kernel.org, Andrew Morton <akpm@osdl.org>, gorcunov@openvz.org
List-Id: linux-api@vger.kernel.org

On Thu, 2014-10-23 at 09:06 -0400, Christopher Covington wrote:
> Hi Michael,
> 
> On 10/23/2014 01:07 AM, Michael Ellerman wrote:
> > Don't prevent the test building on non-x86. Just try and build it and
> > let the chips fall where they may.
> 
> As a user of kcmp via CRIU on arm and arm64, thanks!
> 
> > diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
> > index 4f00c0524501..cda9cc4004c9 100644
> > --- a/tools/testing/selftests/kcmp/Makefile
> > +++ b/tools/testing/selftests/kcmp/Makefile
> > @@ -1,21 +1,7 @@
> > -uname_M := $(shell uname -m 2>/dev/null || echo not)
> > -ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
> > -ifeq ($(ARCH),i386)
> > -        ARCH := x86
> > -	CFLAGS := -DCONFIG_X86_32 -D__i386__
> > -endif
> > -ifeq ($(ARCH),x86_64)
> > -	ARCH := x86
> > -	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
> > -endif
> >  CFLAGS += -I../../../../usr/include/
> >  
> >  all:
> > -ifeq ($(ARCH),x86)
> >  	gcc $(CFLAGS) kcmp_test.c -o kcmp_test
> 
> Not that this needs to be addressed in this patch, but this looks broken for
> cross compilation. It looks like some of the other selftests use:
> 
> CC = $(CROSS_COMPILE)gcc
> 
> But perhaps this should be set (and perhaps with ':=') once at the top level.

The best solution IMHO is:

  CC := $(CROSS_COMPILE)$(CC)

Because it allows cross compiling, but also allows overriding of CC.

Will resend with that change.

cheers
