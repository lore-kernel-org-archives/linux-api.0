From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v4 71/79] include/uapi/linux/fuse.h: use linux/types.h also in userspace
Date: Thu, 15 Oct 2015 20:59:30 +0200
Message-ID: <9560422.ZpOrhsmRxt@wuerfel>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi> <20151015174154.GZ6104@lakka.kapsi.fi> <CAJfpegtSK-ttDXN+vz+yzsU9P1m7fDCn2VwXfHyJuWL6-O-g3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJfpegtSK-ttDXN+vz+yzsU9P1m7fDCn2VwXfHyJuWL6-O-g3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thursday 15 October 2015 20:32:45 Miklos Szeredi wrote:
> > In my other patches I got review comments that kernel headers should not
> > use <stdint.h> and also Documentation/CodingStyle section 5 says:
> >
> >  (e) Types safe for use in userspace.
> >
> >      In certain structures which are visible to userspace, we cannot
> >      require C99 types and cannot use the 'u32' form above. Thus, we
> >      use __u32 and similar types in all structures which are shared
> >      with userspace.
> 
> Ok, if you cannot require C99, then the __uXX types are the way to go.
> But for the fuse API we *can* use C99 types, nothing preventing us
> from doing it.

What the sentence above means is that you should not rely on the
user including <stdint.h> before including a kernel header, and
that kernel headers are not allowed to include <stdint.h> themselves,
because that would break any pre-C99 user space that defines types
with the same names in their own headers and that relies on that
header not to be included implicitly.

It's possible that it has never been a problem for the fuse headers,
but it has been a problem for other headers in the past and what
Mikko is trying to achieve is to ensure that none of the kernel
headers do this so we can make it an error in 'make headers_install'.

	Arnd
