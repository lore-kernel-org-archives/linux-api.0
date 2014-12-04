From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v5] selftest: size: Add size test for Linux kernel
Date: Thu, 04 Dec 2014 11:08:27 +1100
Message-ID: <1417651707.9123.1.camel@concordia>
References: <547E854E.5060101@sonymobile.com>
	 <1417578191.16722.11.camel@concordia> <547F3A57.7000106@sonymobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <547F3A57.7000106-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2014-12-03 at 08:29 -0800, Tim Bird wrote:
> 
> On 12/02/2014 07:43 PM, Michael Ellerman wrote:
> > On Tue, 2014-12-02 at 19:36 -0800, Tim Bird wrote:
> >> This test shows the amount of memory used by the system.
> >> Note that this is dependent on the user-space that is loaded
> >> when this program runs.  Optimally, this program would be
> >> run as the init program itself.
> > 
> > Sorry to only chime in at v5.
> > 
> >> diff --git a/tools/testing/selftests/size/Makefile b/tools/testing/selftests/size/Makefile
> >> new file mode 100644
> >> index 0000000..47f8e9c
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/size/Makefile
> >> @@ -0,0 +1,15 @@
> >> +#ifndef CC
> >> +	CC = $(CROSS_COMPILE)gcc
> >> +#endif
> > 
> > I think the following is preferable:
> > 
> >   CC := $(CROSS_COMPILE)$(CC)
> > 
> > 
> > It allows optionally setting a custom CC, as well as optionally CROSS_COMPILE.
> 
> I'm not sure I follow this.
> 
> If CC is unset, you get only the CROSS_COMPILE prefix.

CC is never unset. The default value is 'cc'.

> If CC is set to e.g. 'gcc', then you get a nicely formatted toolchain string.

Right.

> But if CC already has the prefix applied, then this will result in
>   having it duplicated, which surely won't work correctly.

That's just PEBKAC. Don't specify CROSS_COMPILE and also a fully specified CC.
Try it with the kernel Makefile and see how well it works.

> CROSS_COMPILE prefix usage looks a bit uncoordinated in the tools directory, but most
> tests seem to be favoring $(CROSS_COMPILE)gcc.

That doesn't make it right :)

> 
>  $ cd tools ; mgrep CROSS
...
> ./testing/selftests/powerpc/Makefile:CC := $(CROSS_COMPILE)$(CC)

You can run git blame on that one if you like ;)

> I agree it's desirable not to hardcode gcc, but we seem to be doing it all over
> the place already.

If everyone jumped off a bridge ... :)

cheers
