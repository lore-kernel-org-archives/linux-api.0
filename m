From: Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] xen: Implement ioctl to restrict privcmd to a
 specific domain
Date: Wed, 6 Aug 2014 11:52:46 +0100
Message-ID: <1407322366.15946.8.camel@hamster.uk.xensource.com>
References: <201407311317.s6VDHJV9013633@aserp1020.oracle.com>
	 <20140804202633.GC6380@laptop.dumpdata.com>
	 <1407229819.26842.4.camel@hamster.uk.xensource.com>
	 <20140805134220.GD13057@laptop.dumpdata.com> <53E0DFFE.9090202@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53E0DFFE.9090202-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, xen-devel <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2014-08-05 at 14:45 +0100, David Vrabel wrote:
> On 05/08/14 14:42, Konrad Rzeszutek Wilk wrote:
> > 
> >  - Some of these hypercalls don't have an ABI so we can't depend
> >    on them being stable. How do you want to handle that?
> 
> We are not going any further with this series because of this.
> 
> David

Well, this is partially true. We agree the patches as they are cannot be
accepted however in the long term we'd like to find a solution.

The current ABI from user-space to kernel defined by these patches is
perfectly fine (just two ioctl to restrict event channel/privcmd to a
specific domain).

For the implementation we were looking at different approaches:
- add an additional target field in vcpu structure to restrict to a
target for a particular vCPU with some additional hypercalls (like
multicall) that restrict contained hypercalls to a domain;
- an additional hypercall to do domctl but with restriction (this
probably require less changes to current patches);
- using flask. This looks easy to implement but currently code does not
deals well with vCPUs as labels are attached to domains.

Frediano
