From: Scott Wood <swood@redhat.com>
Subject: Re: [PATCH 03/17] fpga: dfl: fme: support 512bit data width PR
Date: Wed, 27 Mar 2019 01:10:31 -0500
Message-ID: <29827fcdcdd4fb46b680a6bd184b44fca638666e.camel@redhat.com>
References: <1553483264-5379-1-git-send-email-hao.wu@intel.com>
         <1553483264-5379-4-git-send-email-hao.wu@intel.com>
         <127a9356a7bf597d35dd361f2b16bf80460f0370.camel@redhat.com>
         <655bf2991a4f8bf6a473c91218d6dba7748520aa.camel@redhat.com>
         <CANk1AXSBHAudsLfNkSK1OuE6R9bogo6jW9bYmmZdvweTt3eCiA@mail.gmail.com>
         <580c6c604d3915c105f076fc7f22ab5da98598fc.camel@redhat.com>
         <20190327043743.GA20968@hao-dev>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327043743.GA20968@hao-dev>
Sender: linux-kernel-owner@vger.kernel.org
To: Wu Hao <hao.wu@intel.com>
Cc: Alan Tull <atull@kernel.org>, Moritz Fischer <mdf@kernel.org>, linux-fpga@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Ananda Ravuri <ananda.ravuri@intel.com>, Xu Yilun <yilun.xu@intel.com>
List-Id: linux-api@vger.kernel.org

On Wed, 2019-03-27 at 12:37 +0800, Wu Hao wrote:
> On Tue, Mar 26, 2019 at 04:22:34PM -0500, Scott Wood wrote:
> > On Tue, 2019-03-26 at 14:33 -0500, Alan Tull wrote:
> > > On Mon, Mar 25, 2019 at 5:58 PM Scott Wood <swood@redhat.com> wrote:
> > > > > 
> > > Hi Scott,
> > > 
> > > > On Mon, 2019-03-25 at 17:53 -0500, Scott Wood wrote:
> > > > > On Mon, 2019-03-25 at 11:07 +0800, Wu Hao wrote:
> > > > > > +#else
> > > > > > +static inline void copy512(void *src, void __iomem *dst)
> > > > > > +{
> > > > > > +   WARN_ON_ONCE(1);
> > > > > > +}
> > > > > > +#endif
> > > > > 
Likewise, this will be called if a revision 2 device is used on non-
> > > > > x86
> > > > > (or on x86 with an old binutils).  The driver should fall back to
> > > > > 32-
> > > > > bit
> > > > > in such cases.
> 
> Unfortunately revision 2 is only for integrated FPGA solution, and it
> doesn't
> support any fallback solution (original 32bit data partial reconfiguration
> is
> not supported any more), so driver has to WARN in such path.

>From the commit message it seemed like this was just an optimization, not
something necessary to support revision 2.

If there's no way to program the device without AVX512, then printing an
error message and returning an error to userspace would be better than
WARN_ON, since it's not actually a kernel bug.

-Scott
