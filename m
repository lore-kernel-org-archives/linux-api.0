From: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Subject: Re: [PATCH v2] fadvise: introduce POSIX_FADV_DONTNEED_FS
Date: Thu, 5 May 2011 00:09:22 +0200
Message-ID: <20110504220922.GA4811@linux.develer.com>
References: <1303928027-5100-1-git-send-email-andrea@betterlinux.com>
 <20110504144411.7f32c00c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110504144411.7f32c00c.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, May 04, 2011 at 02:44:11PM -0700, Andrew Morton wrote:
> On Wed, 27 Apr 2011 20:13:47 +0200
> Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org> wrote:
> 
> > Introduce a new fadvise flag to drop page cache pages of a single
> > filesystem.
> 
> I'm going to object to this on general principle.  We shouldn't toss
> new features into the kernel API just because we can.  Each feature
> needs a really good argument to justify its inclusion, and I don't
> believe that the case has been made for this feature.
> 
> IOW, who's going to die if we don't merge it?

OK. :)

-Andrea
