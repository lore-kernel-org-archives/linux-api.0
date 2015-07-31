From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] kdbus/samples: skip on CROSS_COMPILE
Date: Fri, 31 Jul 2015 19:58:05 +0530
Message-ID: <20150731142805.GA22010@sudip-pc>
References: <1438272805-19029-1-git-send-email-dh.herrmann@gmail.com>
 <20150730163307.GA20048@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150730163307.GA20048@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Herrmann <dh.herrmann@gmail.com>, Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Gortmaker <paul.gortmaker@windriver.com>, Daniel Mack <daniel@zonque.org>, Djalal Harouni <tixxdz@opendz.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 30, 2015 at 09:33:07AM -0700, Greg Kroah-Hartman wrote:
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
I also faced the same problem while testing allmodconfig for mn10300.

regards
sudip
