From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4 4/4] Documentation: ABI: /sys/firmware/devicetree/overlays
Date: Mon, 15 Jun 2015 16:26:57 +0300
Message-ID: <B474B6B9-0C7C-4A46-B64F-BD76DA4B7F3B@konsulko.com>
References: <1434137896-13806-1-git-send-email-pantelis.antoniou@konsulko.com> <1434137896-13806-5-git-send-email-pantelis.antoniou@konsulko.com> <CAL_JsqKm9PtDKaabx22Y8WQRJ+RCxWE9Fj+kO2dCJ7_UzriyzA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_JsqKm9PtDKaabx22Y8WQRJ+RCxWE9Fj+kO2dCJ7_UzriyzA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Rob,

> On Jun 15, 2015, at 16:24 , Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
>=20
> On Fri, Jun 12, 2015 at 2:38 PM, Pantelis Antoniou
> <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
>> Documentation ABI entry for overlays sysfs entries.
>>=20
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
>> ---
>> .../ABI/testing/sysfs-firmware-devicetree-overlays | 35 ++++++++++++=
++++++++++
>> 1 file changed, 35 insertions(+)
>> create mode 100644 Documentation/ABI/testing/sysfs-firmware-devicetr=
ee-overlays
>>=20
>> diff --git a/Documentation/ABI/testing/sysfs-firmware-devicetree-ove=
rlays b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
>> new file mode 100644
>> index 0000000..be2d28b
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
>> @@ -0,0 +1,35 @@
>> +What:          /sys/firmware/devicetree/overlays/
>> +Date:          March 2015
>> +Contact:       Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
>> +Description:
>> +               This directory contains the applied device tree over=
lays of
>> +               the running system, as directories of the overlay id=
=2E
>> +
>> +               enable: The master enable switch, by default is 1, a=
nd when
>> +                       set to 0 it cannot be re-enabled for securit=
y reasons.
>> +
>> +What:          /sys/firmware/devicetree/overlays/<id>
>> +Date:          March 2015
>> +Contact:       Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
>> +Description:
>> +               Each directory represents an applied overlay, contai=
ning
>> +               the following attribute files.
>> +
>> +               The discussion about this switch takes place in:
>> +               http://comments.gmane.org/gmane.linux.drivers.device=
tree/101871
>> +
>> +               Kees Cook:
>> +               "Coming from the perspective of drawing a bright lin=
e between
>> +               kernel and the root user (which tends to start with =
disabling
>> +               kernel module loading), I would say that there at le=
ast needs
>> +               to be a high-level one-way "off" switch for the inte=
rface so
>> +               that systems that have this interface can choose to =
turn it off
>> +               during initial boot, etc."
>=20
> Doesn't this below up above with "enable=E2=80=9D?

Ugh I guess so.

>=20

>> +
>> +               targets: A file containing the list of targets of ea=
ch overlay
>> +                        with each line containing a target.
>=20
> We have OF nodes in sysfs now. Would it be more useful if we created
> links to the target nodes instead of having a list of names?
>=20

Probably, this interface is merely informational; things get complicate=
d by
the fact that there can be more than one target in each overlay.

>> +
>> +               can_remove: The attribute set to 1 means that the ov=
erlay can
>> +                           be removed, while 0 means that the overl=
ay is being
>> +                           overlapped therefore removal is prohibit=
ed.
>> +
>> --
>> 1.7.12
>>=20

Regards

=E2=80=94 Pantelis
