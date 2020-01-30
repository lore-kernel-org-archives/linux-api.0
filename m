From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: Add MREMAP_DONTUNMAP to mremap().
Date: Thu, 30 Jan 2020 13:19:39 +0100
Message-ID: <87eevh3zms.fsf@oldenburg2.str.redhat.com>
References: <20200123014627.71720-1-bgeffon@google.com>
        <20200124190625.257659-1-bgeffon@google.com>
        <87imkxxl5d.fsf@oldenburg2.str.redhat.com>
        <CADyq12xCpTzLpYC16FjnM60tHhCfnccNfg6JJuqcBd_6ACDGcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADyq12xCpTzLpYC16FjnM60tHhCfnccNfg6JJuqcBd_6ACDGcQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Brian Geffon's message of "Mon, 27 Jan 2020 14:33:44 -0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Michael S . Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sonny Rao <sonnyrao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jesse Barnes <jsbarnes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

* Brian Geffon:

> Hi Florian,
> copy_vma will make a copy of the existing VMA leaving the old VMA
> unchanged, so the source keeps its existing protections, this is what
> makes it very useful along with userfaultfd.

I see.  On the other hand, it's impossible to get the PROT_NONE behavior
by a subsequent mprotect call because the mremap has to fail in some
cases in vm.overcommit_memory=2 mode.  But maybe that other behavior can
be provided with a different flag if it turns out to be useful in the
future.

Thanks,
Florian
