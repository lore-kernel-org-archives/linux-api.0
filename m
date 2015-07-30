From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] kdbus/samples: skip on CROSS_COMPILE
Date: Thu, 30 Jul 2015 13:00:18 -0400
Message-ID: <20150730170018.GH18685@windriver.com>
References: <1438272805-19029-1-git-send-email-dh.herrmann@gmail.com>
 <20150730163307.GA20048@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150730163307.GA20048@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Herrmann <dh.herrmann@gmail.com>, Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Daniel Mack <daniel@zonque.org>, Djalal Harouni <tixxdz@opendz.org>
List-Id: linux-api@vger.kernel.org

[Re: [PATCH] kdbus/samples: skip on CROSS_COMPILE] On 30/07/2015 (Thu 09:33) Greg Kroah-Hartman wrote:

> On Thu, Jul 30, 2015 at 06:13:25PM +0200, David Herrmann wrote:
> > Apparently we cannot rely on up-to-date kernel headers to be available
> > when cross-compiling, not even for HOSTCC. That's sad, but it's how it
> > is. Skip samples on cross-compiles as suggested by Paul, so allmodconfig
> > runs smoothly again.
> > 
> > Tested-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> > ---
> >  samples/kdbus/Makefile | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/samples/kdbus/Makefile b/samples/kdbus/Makefile
> > index 137f842..dbd9de8 100644
> > --- a/samples/kdbus/Makefile
> > +++ b/samples/kdbus/Makefile
> > @@ -1,9 +1,13 @@
> >  # kbuild trick to avoid linker error. Can be omitted if a module is built.
> >  obj- := dummy.o
> >  
> > +ifndef CROSS_COMPILE
> 
> This really feels like the wrong solution.
> 
> > +
> >  hostprogs-$(CONFIG_SAMPLE_KDBUS) += kdbus-workers
> >  
> >  always := $(hostprogs-y)
> >  
> >  HOSTCFLAGS_kdbus-workers.o += -I$(objtree)/usr/include
> >  HOSTLOADLIBES_kdbus-workers := -lrt
> > +
> > +endif
> 
> Shuah, how should we fix this "properly"?  How is this resolved for the
> kernel test scripts, it should have the same issue that the samples do.

If you guys want to reproduce it, in order to figure out what mips does
with its headers that no other arch does, it should be as simple as:

wget https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/x86_64-gcc-4.6.3-nolibc_mips-linux.tar.xz

<untar somewhere>
<add resulting bin dir to your $PATH>

export CROSS_COMPILE=mips-linux-
export ARCH=mips

cd kernel-source
make allmodconfig
make -j16 samples/

Paul.
--

> 
> thanks,
> 
> greg k-h
