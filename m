From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: Re: [PATCH 0/5] of: overlay: Assorted fixes
Date: Tue, 17 Mar 2015 22:39:48 +0200
Message-ID: <3161FC57-A73E-4B81-8B37-C12CB6009ABD@konsulko.com>
References: <1426624257-23003-1-git-send-email-pantelis.antoniou@konsulko.com> <CAL_Jsq+ingowTc_Seun2yHPfHYXQ0Lb+6Bewr9=8HG2teG7hdg@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL_Jsq+ingowTc_Seun2yHPfHYXQ0Lb+6Bewr9=8HG2teG7hdg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Andrew Morton <akpm@linux-foundation.org>, Matt Porter <matt.porter@linaro.org>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


> On Mar 17, 2015, at 22:37 , Rob Herring <robherring2@gmail.com> wrote=
:
>=20
> On Tue, Mar 17, 2015 at 3:30 PM, Pantelis Antoniou
> <pantelis.antoniou@konsulko.com> wrote:
>> The first patch makes sure that no overlays are being left over from
>> the unit tests.
>>=20
>> The second puts the overlays as objects in the sysfs in
>> /sys/firmware/devicetree/overlays while the next one adds a master
>> overlay enable switch (that once is set to disabled can't be re-enab=
led)
>>=20
>> The next updates the ABI docs and the final one adds me as the
>> maintainer for device tree overlays.
>=20
> You call this fixes, but it looks like new functionality to me. So
> this looks like 4.1 material.
>=20

Yep, they are not 4.0 material. They are not major functional changes t=
hough.

> Rob
>=20

Regards

=E2=80=94 Pantelis

>>=20
>> Pantelis Antoniou (5):
>>  of: unittest: overlay: Keep track of created overlays
>>  of: overlay: kobjectify overlay objects
>>  of: overlay: Master enable switch
>>  Documentation: ABI: /sys/firmware/devicetree/overlays
>>  MAINTAINERS: Pantelis Antoniou device tree overlay maintainer
>>=20
>> .../ABI/testing/sysfs-firmware-devicetree-overlays |   9 ++
>> MAINTAINERS                                        |   9 ++
>> drivers/of/base.c                                  |   5 +
>> drivers/of/of_private.h                            |   9 ++
>> drivers/of/overlay.c                               | 116 +++++++++++=
+++++++++-
>> drivers/of/unittest.c                              |  62 +++++++++++
>> 6 files changed, 208 insertions(+), 2 deletions(-)
>> create mode 100644 Documentation/ABI/testing/sysfs-firmware-devicetr=
ee-overlays
>>=20
>> --
>> 1.7.12
>>=20
