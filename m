From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v6 4/4] Documentation: ABI: /sys/firmware/devicetree/overlays
Date: Wed, 21 Oct 2015 00:02:15 +0300
Message-ID: <235F6C23-4962-4114-BCB2-4279E775E23E@konsulko.com>
References: <1445368397-8732-1-git-send-email-pantelis.antoniou@konsulko.com> <1445368397-8732-5-git-send-email-pantelis.antoniou@konsulko.com> <CAL_JsqJ1nPp17bnp5b59i7Huov8f-qOByRG2dW6XBj5-4_fvSw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_JsqJ1nPp17bnp5b59i7Huov8f-qOByRG2dW6XBj5-4_fvSw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Rob,

> On Oct 20, 2015, at 23:56 , Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
>=20
> On Tue, Oct 20, 2015 at 2:13 PM, Pantelis Antoniou
> <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
>> Documentation ABI entry for overlays sysfs entries.
>>=20
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
>> ---
>> .../ABI/testing/sysfs-firmware-devicetree-overlays | 40 ++++++++++++=
++++++++++
>> 1 file changed, 40 insertions(+)
>> create mode 100644 Documentation/ABI/testing/sysfs-firmware-devicetr=
ee-overlays
>>=20
>> diff --git a/Documentation/ABI/testing/sysfs-firmware-devicetree-ove=
rlays b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
>> new file mode 100644
>> index 0000000..adc4068
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
>> @@ -0,0 +1,40 @@
>> +What:          /sys/firmware/devicetree/overlays/
>> +Date:          October 2015
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
>> +
>> +What:          /sys/firmware/devicetree/overlays/<id>
>> +Date:          October 2015
>> +Contact:       Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
>> +Description:
>> +               Each directory represents an applied overlay, contai=
ning
>> +               the following attribute files.
>> +
>> +               can_remove: The attribute set to 1 means that the ov=
erlay can
>> +                           be removed, while 0 means that the overl=
ay is being
>> +                           overlapped therefore removal is prohibit=
ed.
>> +
>> +What:          /sys/firmware/devicetree/overlays/<id>/<fragment-nam=
e>/
>> +Date:          October 2015
>> +Contact:       Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
>> +Description:
>> +               Each of these directories contain information about =
of the
>> +               particular overlay fragment.
>> +
>> +               target: The full-path of the target of the fragment
>> --
>=20
> What happened to attributes within the fragment dir?
>=20

There=E2=80=99s a single attribute named target that contains the targe=
t of the fragment.

At the moment this is the only attribute. I eventually intent to put th=
e full contents of the overlay fragment
there as /sysfs/firmware/devicetree/base does, but this would make thin=
gs quite complicated for now.

Should I add a What: line for that too?=20

> Rob

Regards

=E2=80=94 Pantelis
