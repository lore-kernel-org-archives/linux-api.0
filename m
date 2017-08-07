From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v06 36/36] uapi linux/kfd_ioctl.h: use __u32 and __u64
 instead of uint32_t and uint64_t
Date: Mon, 7 Aug 2017 17:01:30 +0200
Message-ID: <CAK8P3a0JKTE2Gj1G6zALRj3bDfe7vRymkd3xrBuVwASSfO73cA@mail.gmail.com>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi> <20170806164428.2273-37-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170806164428.2273-37-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yair Shachar <yair.shachar-5C7GfCeVMHo@public.gmane.org>, Oded Gabbay <oded.gabbay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Lewycky <Andrew.Lewycky-5C7GfCeVMHo@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Aug 6, 2017 at 6:44 PM, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wrote:
> Include <drm/drm.h> instead of <linux/types.h> which on Linux includes
> <linux/types.h> and on non-Linux platforms defines __u32 etc types.
>
> Fixes user space compilation errors like:
>
> linux/kfd_ioctl.h:33:2: error: unknown type name =E2=80=98uint32_t=E2=80=
=99
>   uint32_t major_version; /* from KFD */
>   ^~~~~~~~
>
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> Cc: Yair Shachar <yair.shachar-5C7GfCeVMHo@public.gmane.org>
> Cc: Oded Gabbay <oded.gabbay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Andrew Lewycky <Andrew.Lewycky-5C7GfCeVMHo@public.gmane.org>

Looks good to me,

Acked-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
