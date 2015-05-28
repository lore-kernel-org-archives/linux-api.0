From: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] mei: fix up uuid matching
Date: Thu, 28 May 2015 22:11:29 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B3C4A3B53@hasmsx109.ger.corp.intel.com>
References: <1432741333-11889-1-git-send-email-tomas.winkler@intel.com>
	<20150527165054.GB3533@kroah.com>
	<5B8DA87D05A7694D9FA63FD143655C1B3C4A2C8C@hasmsx109.ger.corp.intel.com>
	<20150527172919.GA5525@kroah.com>
	<5B8DA87D05A7694D9FA63FD143655C1B3C4A2CDF@hasmsx109.ger.corp.intel.com>
	<20150527231420.GA29446@kroah.com>	<20150527232254.GA8737@kroah.com>
	<5B8DA87D05A7694D9FA63FD143655C1B3C4A3096@hasmsx109.ger.corp.intel.com>
	<20150528001727.GB2033@kroah.com> <20150529004045.63dbd39b@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150529004045.63dbd39b-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org]
> Sent: Thursday, May 28, 2015 17:41
> To: Greg KH
> Cc: Winkler, Tomas; Samuel Ortiz; arnd-r2nGTMty4D4@public.gmane.org; linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH] mei: fix up uuid matching
> 
> Hi Greg,
> 
> On Wed, 27 May 2015 17:17:27 -0700 Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG2l+swfVvueK@public.gmane.org'>
> wrote:
> >
> > From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> >
> > A previous commit, c93b76b34b4d ("mei: bus: report also uuid in module
> > alias") caused a build error as I missed applying a needed patch to add
> > some macros to uapi/linux/uuid.h.  Instead of those additional macros,
> > change the mei code to use the existing uuid structure directly.
> >
> > Fixes: c93b76b34b4d
> > Cc: Tomas Winkler <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Reported-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> 
> I added this to linux-next today (well, yesterday now :-)).

Currently I'm traveling so I cannot check the fix in runtime but it seems okay
Tomas 
