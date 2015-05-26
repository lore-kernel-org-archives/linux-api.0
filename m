From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v5 00/11] Add simple NVMEM Framework via regmap.
Date: Tue, 26 May 2015 20:54:08 +0300
Message-ID: <F4E26B97-E90C-4C34-A106-D44C875BCEFB@konsulko.com>
References: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org> <1432226535-8640-1-git-send-email-srinivas.kandagatla@linaro.org> <E5772084-6CF5-41DE-B68B-073D9F75F0BC@konsulko.com> <556438FF.7020105@linaro.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <556438FF.7020105-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sascha Hauer <s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Srinivas,

> On May 26, 2015, at 12:12 , Srinivas Kandagatla <srinivas.kandagatla@=
linaro.org> wrote:
>=20
> Hi Pantelis,
>=20
> On 25/05/15 17:51, Pantelis Antoniou wrote:
>> Hi Srinivas,
>>=20
>>> On May 21, 2015, at 19:42 , Srinivas Kandagatla <srinivas.kandagatl=
a@linaro.org> wrote:
>>>=20
>>> Thankyou all for providing inputs and comments on previous versions=
 of this patchset.
>>> Here is the v5 of the patchset addressing all the issues raised as
>>> part of previous versions review.
>>>=20
>>=20
>>>=20
>>=20
>> [snip]
>>=20
>> I tried to use the updated patchset with my at24 & beaglebone capema=
nager patches.
> Thanks for trying it out and migrating at24 to it.
>=20

Don=E2=80=99t mention it=E2=80=A6

>>=20
>> I have a big problem with the removal of the raw of_* access APIs.
> Ok,
>>=20
>> Take for instance the case where you have multiple slot accessing di=
fferent EEPROMs.
>>=20
>>> slots {
>>> 	slot@0 {
>>> 		eeprom =3D <&cape0_data>;
>>> 	};
>>>=20
>>> 	slot@1 {
>>> 		eeprom =3D <&cape1_data>;
>>> 	};
>>> };
>=20
> Can I ask you why should the slots be in sub-nodes?
> Do you expect to have more properties associated with each slot in fu=
ture?
> Or is it just to get hold of eeprom data?
>=20

=46or now I don=E2=80=99t have any more properties besides the eeprom p=
handle.
I=E2=80=99ve reworked capemanager to work with the API as it is, but it=
=E2=80=99s not very intuitive IMHO.

The problem is that I have both the baseboard and the slot eeproms in a=
 single property list.

If more per-slot properties are required, I=E2=80=99ll have to add agai=
n the slots node and
then the nvmem eeprom handles would stick out like a sore thumb.

>>=20
>> In that case there is no per-device node mapping; it=E2=80=99s a per=
-sub node.
>>=20
>> For now I=E2=80=99m exporting the of_* accessors again, please consi=
der exposing the of_* API again.
> Sure, we can export of_nvmem_cell_get symbol for usecases like this.
>=20
> Having said that, I got one comment on the way the nvmem is used in y=
our case. You should try to use nvmem_device_get() and then use nvmem_d=
evice_read() apis, These apis are for consumers like this one. The adva=
ntage of this would be you do not need read and store all data in the d=
river and parse them internally. Basically your ee_field_get would just=
 do nvmem_device_read(); Does it make sense?
>=20

Hmm, good idea; I=E2=80=99ll give it a shot.

> We can work on how to get the of_*based once you decide to move to th=
is api.
>=20
>=20

OK, thanks a lot for taking the time to think about this Srinivas.

>=20
> --srini
>>=20

Regards

=E2=80=94 Pantelis

>>> --
>>> 1.9.1
>>>=20
>>=20
>> Regards
>>=20
>> =E2=80=94 Pantelis
>>=20
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
