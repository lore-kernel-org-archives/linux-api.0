From: Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>
Subject: Re: [PATCH 2/4] Convert epoll to a bitlock
Date: Wed, 4 Feb 2009 08:51:26 -0800 (PST)
Message-ID: <alpine.DEB.1.10.0902040849570.5477@alien.or.mcafeemobile.com>
References: <1233598811-6871-1-git-send-email-corbet@lwn.net> <1233598811-6871-3-git-send-email-corbet@lwn.net> <20090203133942.2ecec281.akpm@linux-foundation.org> <4988BD4E.8080206@cosmosbay.com> <20090203140543.6e915f97.akpm@linux-foundation.org>
 <1233699722.3243.127.camel@calx> <20090203153740.363d0a04@bike.lwn.net> <20090203145346.8df40277.akpm@linux-foundation.org> <20090203161931.4054a25e@bike.lwn.net> <20090204071320.GA19348@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090204071320.GA19348-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, dada1-fPLkHRcR87vqlBn2x/YWAg@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 4 Feb 2009, Christoph Hellwig wrote:

> On Tue, Feb 03, 2009 at 04:19:31PM -0700, Jonathan Corbet wrote:
> >  1) Use i_lock to protect accesses to f_flags.  This would enable some 
> >     BKL usage to be removed, but would not fix fasync.
> 
> What about just turning f_ep_lock into f_lock and using it?

Looks like a good idea.


- Davide


--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
