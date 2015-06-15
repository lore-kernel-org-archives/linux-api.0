From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: Re: [PATCH v4 4/4] Documentation: ABI: /sys/firmware/devicetree/overlays
Date: Mon, 15 Jun 2015 17:02:24 +0300
Message-ID: <8C477D79-68E9-4B10-BFC0-D967F257ED34@konsulko.com>
References: <1434137896-13806-1-git-send-email-pantelis.antoniou@konsulko.com> <1434137896-13806-5-git-send-email-pantelis.antoniou@konsulko.com> <CAL_JsqKm9PtDKaabx22Y8WQRJ+RCxWE9Fj+kO2dCJ7_UzriyzA@mail.gmail.com> <B474B6B9-0C7C-4A46-B64F-BD76DA4B7F3B@konsulko.com> <CAL_JsqLQ2fU1KgN=KprLJmGeJjGxcfX9CZfRpWwd-BUYr7g5qw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL_JsqLQ2fU1KgN=KprLJmGeJjGxcfX9CZfRpWwd-BUYr7g5qw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Andrew Morton <akpm@linux-foundation.org>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Rob,

> On Jun 15, 2015, at 16:42 , Rob Herring <robherring2@gmail.com> wrote=
:
>=20
> On Mon, Jun 15, 2015 at 8:26 AM, Pantelis Antoniou
> <pantelis.antoniou@konsulko.com> wrote:
>> Hi Rob,
>>=20
>>> On Jun 15, 2015, at 16:24 , Rob Herring <robherring2@gmail.com> wro=
te:
>>>=20
>>> On Fri, Jun 12, 2015 at 2:38 PM, Pantelis Antoniou
>>> <pantelis.antoniou@konsulko.com> wrote:
>>>> Documentation ABI entry for overlays sysfs entries.
>>>>=20
>>>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>>>> ---
>>>> .../ABI/testing/sysfs-firmware-devicetree-overlays | 35 ++++++++++=
++++++++++++
>>>> 1 file changed, 35 insertions(+)
>>>> create mode 100644 Documentation/ABI/testing/sysfs-firmware-device=
tree-overlays
>>>>=20
>>>> diff --git a/Documentation/ABI/testing/sysfs-firmware-devicetree-o=
verlays b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
>>>> new file mode 100644
>>>> index 0000000..be2d28b
>>>> --- /dev/null
>>>> +++ b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
>>>> @@ -0,0 +1,35 @@
>=20
> [...]
>=20
>>>> +
>>>> +               targets: A file containing the list of targets of =
each overlay
>>>> +                        with each line containing a target.
>>>=20
>>> We have OF nodes in sysfs now. Would it be more useful if we create=
d
>>> links to the target nodes instead of having a list of names?
>>>=20
>>=20
>> Probably, this interface is merely informational; things get complic=
ated by
>> the fact that there can be more than one target in each overlay.
>=20
> Right, you would need 'targetN' or perhaps '<node name>' (with a '.N'
> for duplicates) as the link names.
>=20
> If it is informational, then perhaps debugfs should be used instead?
>=20

I=E2=80=99d rather not pull in debugfs here. It=E2=80=99s informational=
, but not only for
debugging. I=E2=80=99ll see what I can do with the targets.

> What else if anything do you envision adding here?
>=20

As far as generic infrastructure properties, I hope nothing else.
However I do intend to use the kobj directory to make the overlay users
=E2=80=98hang=E2=80=99 properties relevant to their use.

=46or instance the beaglebone capemanager could put there the compatibl=
e
and the resource declaration properties. But that=E2=80=99s going to co=
me later.


> Rob
> =E2=80=94

Regards

=E2=80=94 Pantelis
