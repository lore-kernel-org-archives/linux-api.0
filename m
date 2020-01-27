From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: Add MREMAP_DONTUNMAP to mremap().
Date: Mon, 27 Jan 2020 11:13:02 +0100
Message-ID: <87imkxxl5d.fsf@oldenburg2.str.redhat.com>
References: <20200123014627.71720-1-bgeffon@google.com>
        <20200124190625.257659-1-bgeffon@google.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200124190625.257659-1-bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> (Brian Geffon's
        message of "Fri, 24 Jan 2020 11:06:25 -0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jesse Barnes <jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

* Brian Geffon:

> When remapping an anonymous, private mapping, if MREMAP_DONTUNMAP is
> set, the source mapping will not be removed. Instead it will be
> cleared as if a brand new anonymous, private mapping had been created
> atomically as part of the mremap() call.  If a userfaultfd was watching
> the source, it will continue to watch the new mapping.  For a mapping
> that is shared or not anonymous, MREMAP_DONTUNMAP will cause the
> mremap() call to fail. MREMAP_DONTUNMAP implies that MREMAP_FIXED is
> also used. The final result is two equally sized VMAs where the
> destination contains the PTEs of the source.

What will be the protection flags of the source mapping?  Will they
remain unchanged?  Or PROT_NONE?

Thanks,
Florian
