From: Ulf Magnusson <ulfalizer.lkml@gmail.com>
Subject: Re: KDBUS breaks 'make installmandocs'
Date: Tue, 14 Jul 2015 04:00:40 +0200
Message-ID: <20150714020040.GA17955@huvuddator>
References: <20150712180846.GA32176@huvuddator>
 <20150714003925.GA23746@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150714003925.GA23746@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, daniel@zonque.org, dh.herrmann@googlemail.com, tixxdz@opendz.org
List-Id: linux-api@vger.kernel.org

On Mon, Jul 13, 2015 at 05:39:25PM -0700, Greg KH wrote:
> On Sun, Jul 12, 2015 at 08:08:46PM +0200, Ulf Magnusson wrote:
> > Hello,
> > 
> > Tested with next-20150709.
> > 
> > Documentation/kdbus/Makefile lacks an 'installmandocs' target, causing
> > problems for
> > 
> > %docs: scripts_basic FORCE
> > 	$(Q)$(MAKE) $(build)=scripts build_docproc
> > 	$(Q)$(MAKE) $(build)=Documentation/DocBook $@
> > 	$(Q)$(MAKE) $(build)=Documentation/kdbus $@
> > 
> > from the top-level Makefile. It still works, but no KDBUS-related man
> > pages are installed, and the final error isn't reassuring.
> 
> What's the final error?
> 

$ sudo make installmandocs
  GEN     Documentation/DocBook//v4l2.xml
find Documentation/DocBook/man -name '*.9' | xargs gzip -f
mkdir -p /usr/local/man/man9/
install Documentation/DocBook/man/*.9.gz /usr/local/man/man9/
make[1]: *** No rule to make target 'installmandocs'.  Stop.
Makefile:1359: recipe for target 'installmandocs' failed
make: *** [installmandocs] Error 2


The "*** No rule to make target 'installmandocs'. Stop." error is
generated for Documentation/kdbus/Makefile. The other man pages still
install fine.

(That "GEN     Documentation/DocBook//v4l2.xml" line might be an
unrelated issue. It's from the 'mandocs' prerequisite and shows up even
when the pages are already built.)

> > Documentation/DocBook/Makefile installs man pages into section 9, while
> > KDBUS uses 7. I'm not familiar enough with KDBUS to know what the right
> > thing to do here is.
> 
> I don't know either, perhaps someone on linux-api knows?
> 
> thanks,
> 
> greg k-h

Cheers,
Ulf
