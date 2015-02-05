From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH] coresight-stm: adding driver for CoreSight STM component
Date: Thu, 05 Feb 2015 17:28:12 +0100
Message-ID: <1423153692.27378.60.camel@x220>
References: <1423088550-15780-1-git-send-email-mathieu.poirier@linaro.org>
	 <1423135651.27378.32.camel@x220>
	 <CANLsYkx-XeiWAMxgMs=dAZc5oMf0NmF_2_6TzYXQtd1JdL5LrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANLsYkx-XeiWAMxgMs=dAZc5oMf0NmF_2_6TzYXQtd1JdL5LrA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: corbet@lwn.net, Pratik Patel <pratikp@codeaurora.org>, Al Grant <al.grant@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, Kaixu Xia <kaixu.xia@linaro.org>, Jeenu Viswambharan <jeenu.viswambharan@arm.com>, Greg KH <gregkh@linuxfoundation.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-api@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 2015-02-05 at 08:51 -0700, Mathieu Poirier wrote:
> On 5 February 2015 at 04:27, Paul Bolle <pebolle@tiscali.nl> wrote:
> > On Wed, 2015-02-04 at 15:22 -0700, mathieu.poirier@linaro.org wrote:
> >> @@ -58,4 +58,14 @@ config CORESIGHT_SOURCE_ETM3X
> >>         which allows tracing the instructions that a processor is executing
> >>         This is primarily useful for instruction level tracing.  Depending
> >>         the ETM version data tracing may also be available.
> >> +
> >> +config CORESIGHT_STM
> >> +     bool "CoreSight System Trace Macrocell driver"
> >> +     depends on (ARM && !(CPU_32v4 || CPU_32v4T)) || ARM64 || (64BIT && COMPILE_TEST)
> >
> > I'm _guessing_ that CPU_32v4 and CPU_32v4T are needed for the ldrd and
> > strd assembler instructions. If that's right a next _guess_ would be
> > that you also need to mention CPU_32v3 here.
> >
> > Furthermore, this file is only sourced by arch/arm/Kconfig.debug and
> > arch/arm64/Kconfig.debug. So 64BIT should always be equal to ARM64 and
> > the
> >      || (64BIT && COMPILE_TEST)
> >
> > part shouldn't be needed, isn't it?
> 
> Things have changed in the driver (and accessor functions) since I
> wrote this Kconfig condition - Let me think on the above 2 comments.

In the meantime it occurred to me that the current dependency could be
written as just
    !CPU_32v4 && !CPU_32v4T

That shouldn't change anything, neither for both ARM nor for ARM64.
(This is because exactly one of ARM and ARM64 will always be set.)
Anyhow, I'll see what you'll come up with.

> >> +     select CORESIGHT_LINKS_AND_SINKS
> >> +     help
> >> +       This driver provides support for hardware assisted software
> >> +       instrumentation based tracing. This is primarily used for
> >> +       logging useful software events or data coming from various entities
> >> +       in the system, possibly running different OSs
> >>  endif

> >> +static ssize_t entities_show(struct device *dev,
> >> +                          struct device_attribute *attr, char *buf)
> >> +{
> >> +     struct stm_drvdata *drvdata = dev_get_drvdata(dev->parent);
> >> +     ssize_t len;
> >> +
> >> +     len = bitmap_scnprintf(buf, PAGE_SIZE, drvdata->entities,
> >> +                            STM_ENTITY_MAX);
> >> +
> >
> > bitmap_scnprintf is gone in current linux-next. I changed it to
> >         len = scnprintf(buf, PAGE_SIZE, "%*pb", STM_ENTITY_MAX,
> >                         drvdata->entities);
> >
> > to get this file to compile. (On x86_64, that is, but please don't tell
> > anybody!)
> 
> I was not aware that "bitmap_scnprintf()" had disappeared - thanks for
> pointing this out.  Did you mean cross-compile from an x86_64 host or
> compile for a x86_64 target?  I don't get how you could have in the
> latter case.

I compiled for the x86_64 target! I used a hack, not sure where it's
documented, to build object files by bypassing most of the build
infrastructure:
     make drivers/coresight/coresight-stm.o

But, since in this case that doesn't handle <linux/coresight-stm.h>
correctly, I used an ever bigger hack:
    make EXTRA_CFLAGS="-DCONFIG_CORESIGHT_STM" drivers/coresight/coresight-stm.o

This only works as long as the code doesn't use stuff that can't
possibly be reached in x86_64 (eg, it doesn't use platform specific
headers). It's a quick and dirty way to test changes to files normally
not compiled for your target.


Paul Bolle
