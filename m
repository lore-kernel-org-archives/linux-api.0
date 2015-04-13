From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 4/4] timerfd.2: Add ioctl method description
Date: Mon, 13 Apr 2015 23:10:09 +0300
Message-ID: <20150413201009.GD4773@moon>
References: <20140715215451.499191426@openvz.org>
 <20140715215703.353177995@openvz.org>
 <552C1F64.30202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <552C1F64.30202-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 13, 2015 at 09:56:20PM +0200, Michael Kerrisk (man-pages) wrote:
> Hello Cyrill,
> 
> On 07/15/2014 11:54 PM, Cyrill Gorcunov wrote:
> > ioctl(2)
> > 	The following commands are supported: TFD_IOC_SET_TICKS to adjust
> > 	the number of the timer expirations that have occurred.
> > 	It take a pointer to nonzero 8-byte integer (uint64_t*) containing
> > 	new number of expirations. Once the number is set any waiter on
> > 	the timer is woken up. The only purpose of this command is to restore
> > 	the expirations in a sake of checkpoint/restore procedure.
> > 	It requires the kernel to be built with CONFIG_CHECKPOINT_RESTORE
> > 	support.
> 
> Late... but, patch applied. Thank you.

Sure thing! Ping me if anything else should be added.
