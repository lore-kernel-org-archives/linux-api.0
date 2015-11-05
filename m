From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v6 3/4] of: overlay: add per overlay sysfs attributes
Date: Thu, 5 Nov 2015 22:17:49 +0200
Message-ID: <0FEFA6E6-0AAD-4D53-ACAD-D3B30F59D4B7@konsulko.com>
References: <1445368397-8732-1-git-send-email-pantelis.antoniou@konsulko.com> <1445368397-8732-4-git-send-email-pantelis.antoniou@konsulko.com> <CAL_JsqKFJttTsTfwZdMBPEjzqo_OLV=GpHTYZrDGnsgBjF3Bzg@mail.gmail.com> <8A0C91DE-EDF8-449D-918C-95C9807A7616@konsulko.com> <CAL_JsqLeQC7x3fuUFRm=MqHHwvDSLFz6GFxvOTCUToO-=yA0Kg@mail.gmail.com> <1148C5AF-CA7C-44CE-9CBD-BCD949C6B5FD@konsulko.com> <CAL_JsqJse8wyRRAf2dbVBYQ9QtxD6JL02kd8zGuFxK3gnY_0rQ@mail.gmail.com> <FA84C326-4CE3-4695-9F04-4AEF7A897BE7@konsulko.com> <CAL_JsqL8+4HCrSFQf5oi1PdE0mQveL9OFPFPfVGT+xm-JeMO2g@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_JsqL8+4HCrSFQf5oi1PdE0mQveL9OFPFPfVGT+xm-JeMO2g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Rob,

> On Nov 5, 2015, at 21:52 , Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> On Thu, Oct 22, 2015 at 11:15 AM, Pantelis Antoniou
> <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
>> Hi Rob,
>>=20
>>> On Oct 22, 2015, at 00:52 , Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>>>=20
>>> On Wed, Oct 21, 2015 at 2:37 PM, Pantelis Antoniou
>>> <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
>>>> Hi Rob,
>>>>=20
>>>>> On Oct 21, 2015, at 00:54 , Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>>>>>=20
>>>>> On Tue, Oct 20, 2015 at 4:11 PM, Pantelis Antoniou
>>>>> <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
>>>>>> Hi Rob,
>>>>>>=20
>>>>>>> On Oct 21, 2015, at 00:04 , Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>=
 wrote:
>>>>>>>=20
>>>>>>> On Tue, Oct 20, 2015 at 2:13 PM, Pantelis Antoniou
>>>>>>> <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
>>>>>>>> * A per overlay can_remove sysfs attribute that reports whethe=
r
>>>>>>>> the overlay can be removed or not due to another overlapping o=
verlay.
>>>>>>>>=20
>>>>>>>> * A target sysfs attribute listing the target of each fragment=
,
>>>>>>>> in a group named after the name of the fragment.
>>>>>=20
>>>>> [...]
>>>>>=20
>>>>>>>> @@ -255,6 +278,17 @@ err_fail:
>>>>>>>>     return -EINVAL;
>>>>>>>> }
>>>>>>>>=20
>>>>>>>> +static ssize_t target_show(struct kobject *kobj,
>>>>>>>> +               struct fragment_attribute *fattr, char *buf)
>>>>>>>> +{
>>>>>>>> +       struct of_overlay_info *ovinfo =3D fattr->ovinfo;
>>>>>>>> +
>>>>>>>> +       return snprintf(buf, PAGE_SIZE, "%s\n",
>>>>>>>> +                       of_node_full_name(ovinfo->target));
>>>>>>>=20
>>>>>>> This can be a link to the node itself, can't it?
>>>>>>>=20
>>>>>>=20
>>>>>> Yes. Do you want it like this?
>>>>>=20
>>>>> Yes, hence the suggestion. Unless you see some reason why not.
>>>>>=20
>>>>=20
>>>> Nope, can=E2=80=99t be done. The sysfs API only allows linking one=
 kobj to another.
>>>> The kobj is the overlay but the target is in the fragment attribut=
e group.
>>>=20
>>> Can't we make the fragments kobj's as well?
>>>=20
>>=20
>> We could, but it break the mental model of what a kobj should repres=
ent.
>> An overlay is an object which can be address, a fragment is never di=
rectly
>> exposed.
>=20
> But you are exposing fragments as there is a directory for each one.
>=20
> Overlays are just logical collections of fragments. You could go as
> far to say overlays don't need to be exposed at all and only fragment=
s
> need to be (not that we should). We already have overlays and nodes a=
s
> kobjs, so I don't think fragments as kobjs breaks the mental model.
>=20

I disagree; fragments are merely an internal implementation detail, nam=
ely that an overlay
is comprised of a collection of fragments.

Being able to address fragments individually, which is what making a fr=
agment a kobj does,
conceptually, is not making sense.

We are being driven to consider having them as kobjs as a consequence o=
f the gaps in the
sysfs internal kernel API, that is that we can only make links between =
kobjs=E2=80=99 only not in
arbitrary points from one sysfs directory to another.

>> TBH a link attribute is indeed better than a path attribute, but mar=
ginally so.
>> It=E2=80=99s not worth the trouble IMO.
>=20
> It is just an ABI we have to support forever=E2=80=A6
>=20

I don=E2=80=99t think that=E2=80=99s that a big deal IMO. Following a l=
ink is no different than reading the path attribute.

> Rob

Regards


=E2=80=94 Pantelis

--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
