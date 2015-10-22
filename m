From: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v6 3/4] of: overlay: add per overlay sysfs attributes
Date: Thu, 22 Oct 2015 19:15:43 +0300
Message-ID: <FA84C326-4CE3-4695-9F04-4AEF7A897BE7@konsulko.com>
References: <1445368397-8732-1-git-send-email-pantelis.antoniou@konsulko.com> <1445368397-8732-4-git-send-email-pantelis.antoniou@konsulko.com> <CAL_JsqKFJttTsTfwZdMBPEjzqo_OLV=GpHTYZrDGnsgBjF3Bzg@mail.gmail.com> <8A0C91DE-EDF8-449D-918C-95C9807A7616@konsulko.com> <CAL_JsqLeQC7x3fuUFRm=MqHHwvDSLFz6GFxvOTCUToO-=yA0Kg@mail.gmail.com> <1148C5AF-CA7C-44CE-9CBD-BCD949C6B5FD@konsulko.com> <CAL_JsqJse8wyRRAf2dbVBYQ9QtxD6JL02kd8zGuFxK3gnY_0rQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_JsqJse8wyRRAf2dbVBYQ9QtxD6JL02kd8zGuFxK3gnY_0rQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Rob,

> On Oct 22, 2015, at 00:52 , Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
>=20
> On Wed, Oct 21, 2015 at 2:37 PM, Pantelis Antoniou
> <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
>> Hi Rob,
>>=20
>>> On Oct 21, 2015, at 00:54 , Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>>>=20
>>> On Tue, Oct 20, 2015 at 4:11 PM, Pantelis Antoniou
>>> <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
>>>> Hi Rob,
>>>>=20
>>>>> On Oct 21, 2015, at 00:04 , Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> w=
rote:
>>>>>=20
>>>>> On Tue, Oct 20, 2015 at 2:13 PM, Pantelis Antoniou
>>>>> <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
>>>>>> * A per overlay can_remove sysfs attribute that reports whether
>>>>>> the overlay can be removed or not due to another overlapping ove=
rlay.
>>>>>>=20
>>>>>> * A target sysfs attribute listing the target of each fragment,
>>>>>> in a group named after the name of the fragment.
>>>=20
>>> [...]
>>>=20
>>>>>> @@ -255,6 +278,17 @@ err_fail:
>>>>>>      return -EINVAL;
>>>>>> }
>>>>>>=20
>>>>>> +static ssize_t target_show(struct kobject *kobj,
>>>>>> +               struct fragment_attribute *fattr, char *buf)
>>>>>> +{
>>>>>> +       struct of_overlay_info *ovinfo =3D fattr->ovinfo;
>>>>>> +
>>>>>> +       return snprintf(buf, PAGE_SIZE, "%s\n",
>>>>>> +                       of_node_full_name(ovinfo->target));
>>>>>=20
>>>>> This can be a link to the node itself, can't it?
>>>>>=20
>>>>=20
>>>> Yes. Do you want it like this?
>>>=20
>>> Yes, hence the suggestion. Unless you see some reason why not.
>>>=20
>>=20
>> Nope, can=E2=80=99t be done. The sysfs API only allows linking one k=
obj to another.
>> The kobj is the overlay but the target is in the fragment attribute =
group.
>=20
> Can't we make the fragments kobj's as well?
>=20

We could, but it break the mental model of what a kobj should represent=
=2E
An overlay is an object which can be address, a fragment is never direc=
tly
exposed.

TBH a link attribute is indeed better than a path attribute, but margin=
ally so.
It=E2=80=99s not worth the trouble IMO.
=20
> Rob

Regards

=E2=80=94 Pantelis

--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
