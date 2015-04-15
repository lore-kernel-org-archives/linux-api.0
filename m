From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 1/4] of: unittest: overlay: Keep track of created overlays
Date: Tue, 14 Apr 2015 20:29:14 -0500
Message-ID: <CAL_JsqJQjWpktxHx=U3L6jzxT6011EB6XoRmbVp0z0rw5oAPAg@mail.gmail.com>
References: <1428434632-13789-1-git-send-email-pantelis.antoniou@konsulko.com> <1428434632-13789-2-git-send-email-pantelis.antoniou@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428434632-13789-2-git-send-email-pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Apr 7, 2015 at 2:23 PM, Pantelis Antoniou
<pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
> During the course of the overlay selftests some of them remain
> applied. While this does not pose a real problem, make sure you track
> them and destroy them at the end of the test.
>
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>

I've applied this one. Patch 2 is okay, but the rest still needs some work.

Rob

> ---
>  drivers/of/unittest.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 62 insertions(+)
>
> diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
> index fdb5977..995cc73 100644
> --- a/drivers/of/unittest.c
> +++ b/drivers/of/unittest.c
> @@ -23,6 +23,8 @@
>  #include <linux/i2c.h>
>  #include <linux/i2c-mux.h>
>
> +#include <linux/bitops.h>
> +
>  #include "of_private.h"
>
>  static struct unittest_results {
> @@ -1095,6 +1097,59 @@ static const char *overlay_path(int nr)
>
>  static const char *bus_path = "/testcase-data/overlay-node/test-bus";
>
> +/* it is guaranteed that overlay ids are assigned in sequence */
> +#define MAX_UNITTEST_OVERLAYS  256
> +static unsigned long overlay_id_bits[BITS_TO_LONGS(MAX_UNITTEST_OVERLAYS)];
> +static int overlay_first_id = -1;
> +
> +static void of_unittest_track_overlay(int id)
> +{
> +       if (overlay_first_id < 0)
> +               overlay_first_id = id;
> +       id -= overlay_first_id;
> +
> +       /* we shouldn't need that many */
> +       BUG_ON(id >= MAX_UNITTEST_OVERLAYS);
> +       overlay_id_bits[BIT_WORD(id)] |= BIT_MASK(id);
> +}
> +
> +static void of_unittest_untrack_overlay(int id)
> +{
> +       if (overlay_first_id < 0)
> +               return;
> +       id -= overlay_first_id;
> +       BUG_ON(id >= MAX_UNITTEST_OVERLAYS);
> +       overlay_id_bits[BIT_WORD(id)] &= ~BIT_MASK(id);
> +}
> +
> +static void of_unittest_destroy_tracked_overlays(void)
> +{
> +       int id, ret, defers;
> +
> +       if (overlay_first_id < 0)
> +               return;
> +
> +       /* try until no defers */
> +       do {
> +               defers = 0;
> +               /* remove in reverse order */
> +               for (id = MAX_UNITTEST_OVERLAYS - 1; id >= 0; id--) {
> +                       if (!(overlay_id_bits[BIT_WORD(id)] & BIT_MASK(id)))
> +                               continue;
> +
> +                       ret = of_overlay_destroy(id + overlay_first_id);
> +                       if (ret != 0) {
> +                               defers++;
> +                               pr_warn("%s: overlay destroy failed for #%d\n",
> +                                       __func__, id + overlay_first_id);
> +                               continue;
> +                       }
> +
> +                       overlay_id_bits[BIT_WORD(id)] &= ~BIT_MASK(id);
> +               }
> +       } while (defers > 0);
> +}
> +
>  static int of_unittest_apply_overlay(int unittest_nr, int overlay_nr,
>                 int *overlay_id)
>  {
> @@ -1116,6 +1171,7 @@ static int of_unittest_apply_overlay(int unittest_nr, int overlay_nr,
>                 goto out;
>         }
>         id = ret;
> +       of_unittest_track_overlay(id);
>
>         ret = 0;
>
> @@ -1329,6 +1385,7 @@ static void of_unittest_overlay_6(void)
>                         return;
>                 }
>                 ov_id[i] = ret;
> +               of_unittest_track_overlay(ov_id[i]);
>         }
>
>         for (i = 0; i < 2; i++) {
> @@ -1353,6 +1410,7 @@ static void of_unittest_overlay_6(void)
>                                                 PDEV_OVERLAY));
>                         return;
>                 }
> +               of_unittest_untrack_overlay(ov_id[i]);
>         }
>
>         for (i = 0; i < 2; i++) {
> @@ -1397,6 +1455,7 @@ static void of_unittest_overlay_8(void)
>                         return;
>                 }
>                 ov_id[i] = ret;
> +               of_unittest_track_overlay(ov_id[i]);
>         }
>
>         /* now try to remove first overlay (it should fail) */
> @@ -1419,6 +1478,7 @@ static void of_unittest_overlay_8(void)
>                                                 PDEV_OVERLAY));
>                         return;
>                 }
> +               of_unittest_untrack_overlay(ov_id[i]);
>         }
>
>         unittest(1, "overlay test %d passed\n", 8);
> @@ -1841,6 +1901,8 @@ static void __init of_unittest_overlay(void)
>         of_unittest_overlay_i2c_cleanup();
>  #endif
>
> +       of_unittest_destroy_tracked_overlays();
> +
>  out:
>         of_node_put(bus_np);
>  }
> --
> 1.7.12
>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
