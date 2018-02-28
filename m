From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] userfaultfd: non-cooperative: allow synchronous
 EVENT_REMOVE
Date: Wed, 28 Feb 2018 10:26:14 +0200
Message-ID: <20180228082613.GD15048@rapoport-lnx>
References: <1519719592-22668-1-git-send-email-rppt@linux.vnet.ibm.com>
 <1519719592-22668-4-git-send-email-rppt@linux.vnet.ibm.com>
 <1a2ed216-74ac-5fe2-abff-21d670eeb96d@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1a2ed216-74ac-5fe2-abff-21d670eeb96d@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, linux-mm <linux-mm@kvack.org>, linux-api <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, crml <criu@openvz.org>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 28, 2018 at 11:21:02AM +0300, Pavel Emelyanov wrote:
> 
> > @@ -52,6 +53,7 @@
> >  #define _UFFDIO_WAKE			(0x02)
> >  #define _UFFDIO_COPY			(0x03)
> >  #define _UFFDIO_ZEROPAGE		(0x04)
> > +#define _UFFDIO_WAKE_SYNC_EVENT		(0x05)
> 
> Excuse my ignorance, but what's the difference between UFFDIO_WAKE and UFFDIO_WAKE_SYNC_EVENT?

UFFDIO_WAKE is used when UFFDIO_COPY/UFFDIO_ZERO page are used with
UFFDIO_*_MODE_DONTWAKE flag set and it presumes 'struct uffdio_range'
argument to the ioctl(). Since waking up a non page fault event requires
different parameters I've add new ioctl to keep backwards compatibility.
 
> -- Pavel
> 

-- 
Sincerely yours,
Mike.
