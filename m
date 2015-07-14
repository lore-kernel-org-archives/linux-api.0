From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: KDBUS breaks 'make installmandocs'
Date: Mon, 13 Jul 2015 17:39:25 -0700
Message-ID: <20150714003925.GA23746@kroah.com>
References: <20150712180846.GA32176@huvuddator>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150712180846.GA32176@huvuddator>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ulf Magnusson <ulfalizer.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Jul 12, 2015 at 08:08:46PM +0200, Ulf Magnusson wrote:
> Hello,
> 
> Tested with next-20150709.
> 
> Documentation/kdbus/Makefile lacks an 'installmandocs' target, causing
> problems for
> 
> %docs: scripts_basic FORCE
> 	$(Q)$(MAKE) $(build)=scripts build_docproc
> 	$(Q)$(MAKE) $(build)=Documentation/DocBook $@
> 	$(Q)$(MAKE) $(build)=Documentation/kdbus $@
> 
> from the top-level Makefile. It still works, but no KDBUS-related man
> pages are installed, and the final error isn't reassuring.

What's the final error?

> Documentation/DocBook/Makefile installs man pages into section 9, while
> KDBUS uses 7. I'm not familiar enough with KDBUS to know what the right
> thing to do here is.

I don't know either, perhaps someone on linux-api knows?

thanks,

greg k-h
