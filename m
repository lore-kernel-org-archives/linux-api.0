From: Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v5] selftest: size: Add size test for Linux kernel
Date: Wed, 3 Dec 2014 14:01:36 +0100
Message-ID: <20141203140136.12997331@free-electrons.com>
References: <547E854E.5060101@sonymobile.com>
	<1417578191.16722.11.camel@concordia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417578191.16722.11.camel@concordia>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Michael, Tim,

On Wed, 03 Dec 2014 14:43:11 +1100, Michael Ellerman wrote:

> > diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
> > new file mode 100644
> > index 0000000..47f8e9c
> > --- /dev/null
> > +++ b/tools/testing/selftests/size/Makefile
> > @@ -0,0 +1,15 @@
> > +#ifndef CC
> > +	CC = $(CROSS_COMPILE)gcc
> > +#endif
> 
> I think the following is preferable:
> 
>   CC := $(CROSS_COMPILE)$(CC)

It is even more necessary that #ifndef and #endif don't exist in make.
They are just comments, and therefore, ignored. Seems like Tim does too
much C :-)

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
