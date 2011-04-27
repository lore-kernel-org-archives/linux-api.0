From: Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] fadvise: introduce POSIX_FADV_DONTNEED_FS
Date: Wed, 27 Apr 2011 14:25:17 -0400
Message-ID: <BANLkTinG+ooNRH-VUjKdaHixbGCwk5XoXA@mail.gmail.com>
References: <1303928027-5100-1-git-send-email-andrea@betterlinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303928027-5100-1-git-send-email-andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 27, 2011 at 14:13, Andrea Righi wrote:
> Introduce a new fadvise flag to drop page cache pages of a single
> filesystem.
>
> At the moment it is possible to drop page cache pages via
> /proc/sys/vm/drop_pagecache or via posix_fadvise(POSIX_FADV_DONTNEED).
>
> The first method drops the whole page cache while the second can be used
> to drop page cache pages of a single file descriptor. However, there's
> not a simple way to drop all the pages of a filesystem (we could scan
> all the file descriptors and use posix_fadvise(POSIX_FADV_DONTNEED), but
> this solution obviously doesn't scale well).

what if you open the mount point and use POSIX_FADV_DONTNEED on that
dir handle ?  if you required write access for that level, it'd also
implicitly take care of the permission issue.  but maybe this is just
trying to fit existing code in the wrong way.
-mike
