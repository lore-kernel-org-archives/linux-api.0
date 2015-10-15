From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Subject: Re: [PATCH v4 71/79] include/uapi/linux/fuse.h: use linux/types.h
 also in userspace
Date: Thu, 15 Oct 2015 20:32:45 +0200
Message-ID: <CAJfpegtSK-ttDXN+vz+yzsU9P1m7fDCn2VwXfHyJuWL6-O-g3g@mail.gmail.com>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
	<1444888618-4506-72-git-send-email-mikko.rapeli@iki.fi>
	<CAJfpegv2P0=FCsqriYteyZQ9Ldu4DE1JfNs=URW7Cd-9fpA=oQ@mail.gmail.com>
	<20151015174154.GZ6104@lakka.kapsi.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151015174154.GZ6104-dqH1CgrzRhOk/eJAJmRu5A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 15, 2015 at 7:41 PM, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wrote:
> On Thu, Oct 15, 2015 at 05:20:24PM +0200, Miklos Szeredi wrote:
>> On Thu, Oct 15, 2015 at 7:56 AM, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wrote:
>> > Kernel headers should not use stdint.h.
>>
>> Including <linux/types.h> breaks compile of library on non-Linux
>> archs.  Allowing this patch would mean having a different header in
>> the fuse lib as the one in the kernel.  This is useless complexity and
>> a source of bugs.  We've already been there, and much prefer the
>> current state.
>
> Hmm. Why should Linux uapi header care about non-Linux platforms?
>
> If fuse lib already has an embedded copy of this header, why should
> this change break anything fuse lib?

It has a copy, but that copy is often updated with new features taken
from the kernel.  There's no reason to have two different versions of
the header file for no good reason.

> In my other patches I got review comments that kernel headers should not
> use <stdint.h> and also Documentation/CodingStyle section 5 says:
>
>  (e) Types safe for use in userspace.
>
>      In certain structures which are visible to userspace, we cannot
>      require C99 types and cannot use the 'u32' form above. Thus, we
>      use __u32 and similar types in all structures which are shared
>      with userspace.

Ok, if you cannot require C99, then the __uXX types are the way to go.
But for the fuse API we *can* use C99 types, nothing preventing us
from doing it.

Thanks,
Miklos
