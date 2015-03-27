From: Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH 1/5] of: unittest: overlay: Keep track of created overlays
Date: Fri, 27 Mar 2015 11:24:41 -0700
Message-ID: <7F0EB945-5BA2-4BE4-BB22-C0BFE028046E@antoniou-consulting.com>
References: <1426624257-23003-1-git-send-email-pantelis.antoniou@konsulko.com> <1426624257-23003-2-git-send-email-pantelis.antoniou@konsulko.com> <CAL_JsqKjGb5coH9aDPoSm63YV+E7d+A_VpzgA8W2iSuQ4ViAaw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL_JsqKjGb5coH9aDPoSm63YV+E7d+A_VpzgA8W2iSuQ4ViAaw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Andrew Morton <akpm@linux-foundation.org>, Matt Porter <matt.porter@linaro.org>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Rob,

> On Mar 24, 2015, at 21:53 , Rob Herring <robherring2@gmail.com> wrote=
:
>=20
> On Tue, Mar 17, 2015 at 3:30 PM, Pantelis Antoniou
> <pantelis.antoniou@konsulko.com> wrote:
>> During the course of the overlay selftests some of them remain
>> applied. While this does not pose a real problem, make sure you trac=
k
>> them and destroy them at the end of the test.
>=20
> This is going to need to be rebased on my tree as there has been some
> selftest->unitest renaming.
>=20

Ok, will do so first thing next week.

> Rob
>=20

Regards

=E2=80=94 Pantelis

>>=20
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>> ---
>> drivers/of/unittest.c | 62 +++++++++++++++++++++++++++++++++++++++++=
++++++++++
>> 1 file changed, 62 insertions(+)
>>=20
>> diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
>> index 4e60682..c711534 100644
>> --- a/drivers/of/unittest.c
>> +++ b/drivers/of/unittest.c
>> @@ -23,6 +23,8 @@
>> #include <linux/i2c.h>
>> #include <linux/i2c-mux.h>
>>=20
>> +#include <linux/bitops.h>
>> +
>> #include "of_private.h"
>>=20
>> static struct selftest_results {
>> @@ -1115,6 +1117,59 @@ static const char *overlay_path(int nr)
>>=20
>> static const char *bus_path =3D "/testcase-data/overlay-node/test-bu=
s";
>>=20
>> +/* it is guaranteed that overlay ids are assigned in sequence */
>> +#define MAX_SELFTEST_OVERLAYS  256
>> +static unsigned long overlay_id_bits[BITS_TO_LONGS(MAX_SELFTEST_OVE=
RLAYS)];
>> +static int overlay_first_id =3D -1;
>> +
>> +static void of_selftest_track_overlay(int id)
>> +{
>> +       if (overlay_first_id < 0)
>> +               overlay_first_id =3D id;
>> +       id -=3D overlay_first_id;
>> +
>> +       /* we shouldn't need that many */
>> +       BUG_ON(id >=3D MAX_SELFTEST_OVERLAYS);
>> +       overlay_id_bits[BIT_WORD(id)] |=3D BIT_MASK(id);
>> +}
>> +
>> +static void of_selftest_untrack_overlay(int id)
>> +{
>> +       if (overlay_first_id < 0)
>> +               return;
>> +       id -=3D overlay_first_id;
>> +       BUG_ON(id >=3D MAX_SELFTEST_OVERLAYS);
>> +       overlay_id_bits[BIT_WORD(id)] &=3D ~BIT_MASK(id);
>> +}
>> +
>> +static void of_selftest_destroy_tracked_overlays(void)
>> +{
>> +       int id, ret, defers;
>> +
>> +       if (overlay_first_id < 0)
>> +               return;
>> +
>> +       /* try until no defers */
>> +       do {
>> +               defers =3D 0;
>> +               /* remove in reverse order */
>> +               for (id =3D MAX_SELFTEST_OVERLAYS - 1; id >=3D 0; id=
--) {
>> +                       if (!(overlay_id_bits[BIT_WORD(id)] & BIT_MA=
SK(id)))
>> +                               continue;
>> +
>> +                       ret =3D of_overlay_destroy(id + overlay_firs=
t_id);
>> +                       if (ret !=3D 0) {
>> +                               defers++;
>> +                               pr_warn("%s: overlay destroy failed =
for #%d\n",
>> +                                       __func__, id + overlay_first=
_id);
>> +                               continue;
>> +                       }
>> +
>> +                       overlay_id_bits[BIT_WORD(id)] &=3D ~BIT_MASK=
(id);
>> +               }
>> +       } while (defers > 0);
>> +}
>> +
>> static int of_selftest_apply_overlay(int selftest_nr, int overlay_nr=
,
>>                int *overlay_id)
>> {
>> @@ -1136,6 +1191,7 @@ static int of_selftest_apply_overlay(int selft=
est_nr, int overlay_nr,
>>                goto out;
>>        }
>>        id =3D ret;
>> +       of_selftest_track_overlay(id);
>>=20
>>        ret =3D 0;
>>=20
>> @@ -1349,6 +1405,7 @@ static void of_selftest_overlay_6(void)
>>                        return;
>>                }
>>                ov_id[i] =3D ret;
>> +               of_selftest_track_overlay(ov_id[i]);
>>        }
>>=20
>>        for (i =3D 0; i < 2; i++) {
>> @@ -1373,6 +1430,7 @@ static void of_selftest_overlay_6(void)
>>                                                PDEV_OVERLAY));
>>                        return;
>>                }
>> +               of_selftest_untrack_overlay(ov_id[i]);
>>        }
>>=20
>>        for (i =3D 0; i < 2; i++) {
>> @@ -1417,6 +1475,7 @@ static void of_selftest_overlay_8(void)
>>                        return;
>>                }
>>                ov_id[i] =3D ret;
>> +               of_selftest_track_overlay(ov_id[i]);
>>        }
>>=20
>>        /* now try to remove first overlay (it should fail) */
>> @@ -1439,6 +1498,7 @@ static void of_selftest_overlay_8(void)
>>                                                PDEV_OVERLAY));
>>                        return;
>>                }
>> +               of_selftest_untrack_overlay(ov_id[i]);
>>        }
>>=20
>>        selftest(1, "overlay test %d passed\n", 8);
>> @@ -1861,6 +1921,8 @@ static void __init of_selftest_overlay(void)
>>        of_selftest_overlay_i2c_cleanup();
>> #endif
>>=20
>> +       of_selftest_destroy_tracked_overlays();
>> +
>> out:
>>        of_node_put(bus_np);
>> }
>> --
>> 1.7.12
