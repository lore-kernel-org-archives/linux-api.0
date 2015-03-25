From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/5] MAINTAINERS: Pantelis Antoniou device tree overlay maintainer
Date: Wed, 25 Mar 2015 00:31:25 -0500
Message-ID: <CAL_Jsq+nNVjqS_hkxcMJLNMikJ4awMGgAqX25kL5hH=2ijxCJA@mail.gmail.com>
References: <1426624257-23003-1-git-send-email-pantelis.antoniou@konsulko.com> <1426624257-23003-6-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426624257-23003-6-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 17, 2015 at 3:30 PM, Pantelis Antoniou
<pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
> Add me as the device tree overlays maintainer.
>
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>

Applied. Thanks.

Rob

> ---
>  MAINTAINERS | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0e1abe8..24aa339 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7187,6 +7187,15 @@ F:       Documentation/devicetree/
>  F:     arch/*/boot/dts/
>  F:     include/dt-bindings/
>
> +OPEN FIRMWARE AND DEVICE TREE OVERLAYS
> +M:     Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> +L:     devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +S:     Maintained
> +F:     Documentation/devicetree/dynamic-resolution-notes.txt
> +F:     Documentation/devicetree/overlay-notes.txt
> +F:     drivers/of/overlay.c
> +F:     drivers/of/resolver.c
> +
>  OPENRISC ARCHITECTURE
>  M:     Jonas Bonn <jonas-A9uVI2HLR7kOP4wsBPIw7w@public.gmane.org>
>  W:     http://openrisc.net
> --
> 1.7.12
>
