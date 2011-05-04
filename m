From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2] fadvise: introduce POSIX_FADV_DONTNEED_FS
Date: Wed, 4 May 2011 14:44:11 -0700
Message-ID: <20110504144411.7f32c00c.akpm@linux-foundation.org>
References: <1303928027-5100-1-git-send-email-andrea@betterlinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303928027-5100-1-git-send-email-andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 27 Apr 2011 20:13:47 +0200
Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org> wrote:

> Introduce a new fadvise flag to drop page cache pages of a single
> filesystem.

I'm going to object to this on general principle.  We shouldn't toss
new features into the kernel API just because we can.  Each feature
needs a really good argument to justify its inclusion, and I don't
believe that the case has been made for this feature.

IOW, who's going to die if we don't merge it?
