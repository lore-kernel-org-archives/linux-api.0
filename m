From: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] xen: Implement ioctl to restrict privcmd to a specific
 domain
Date: Tue, 5 Aug 2014 14:45:34 +0100
Message-ID: <53E0DFFE.9090202@citrix.com>
References: <201407311317.s6VDHJV9013633@aserp1020.oracle.com> <20140804202633.GC6380@laptop.dumpdata.com> <1407229819.26842.4.camel@hamster.uk.xensource.com> <20140805134220.GD13057@laptop.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140805134220.GD13057-0iZWjJA6G8GSPmnEAIUT9EEOCMrvLtNR@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Frediano Ziglio <frediano.ziglio-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, xen-devel <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 05/08/14 14:42, Konrad Rzeszutek Wilk wrote:
> 
>  - Some of these hypercalls don't have an ABI so we can't depend
>    on them being stable. How do you want to handle that?

We are not going any further with this series because of this.

David
