From: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v6 3/4] of: overlay: add per overlay sysfs attributes
Date: Wed, 21 Oct 2015 16:52:58 -0500
Message-ID: <CAL_JsqJse8wyRRAf2dbVBYQ9QtxD6JL02kd8zGuFxK3gnY_0rQ@mail.gmail.com>
References: <1445368397-8732-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1445368397-8732-4-git-send-email-pantelis.antoniou@konsulko.com>
 <CAL_JsqKFJttTsTfwZdMBPEjzqo_OLV=GpHTYZrDGnsgBjF3Bzg@mail.gmail.com>
 <8A0C91DE-EDF8-449D-918C-95C9807A7616@konsulko.com> <CAL_JsqLeQC7x3fuUFRm=MqHHwvDSLFz6GFxvOTCUToO-=yA0Kg@mail.gmail.com>
 <1148C5AF-CA7C-44CE-9CBD-BCD949C6B5FD@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1148C5AF-CA7C-44CE-9CBD-BCD949C6B5FD@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Frank Rowand <frowand.list@gmail.com>, Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Guenter Roeck <linux@roeck-us.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 21, 2015 at 2:37 PM, Pantelis Antoniou
<pantelis.antoniou@konsulko.com> wrote:
> Hi Rob,
>
>> On Oct 21, 2015, at 00:54 , Rob Herring <robherring2@gmail.com> wrot=
e:
>>
>> On Tue, Oct 20, 2015 at 4:11 PM, Pantelis Antoniou
>> <pantelis.antoniou@konsulko.com> wrote:
>>> Hi Rob,
>>>
>>>> On Oct 21, 2015, at 00:04 , Rob Herring <robherring2@gmail.com> wr=
ote:
>>>>
>>>> On Tue, Oct 20, 2015 at 2:13 PM, Pantelis Antoniou
>>>> <pantelis.antoniou@konsulko.com> wrote:
>>>>> * A per overlay can_remove sysfs attribute that reports whether
>>>>> the overlay can be removed or not due to another overlapping over=
lay.
>>>>>
>>>>> * A target sysfs attribute listing the target of each fragment,
>>>>> in a group named after the name of the fragment.
>>
>> [...]
>>
>>>>> @@ -255,6 +278,17 @@ err_fail:
>>>>>       return -EINVAL;
>>>>> }
>>>>>
>>>>> +static ssize_t target_show(struct kobject *kobj,
>>>>> +               struct fragment_attribute *fattr, char *buf)
>>>>> +{
>>>>> +       struct of_overlay_info *ovinfo =3D fattr->ovinfo;
>>>>> +
>>>>> +       return snprintf(buf, PAGE_SIZE, "%s\n",
>>>>> +                       of_node_full_name(ovinfo->target));
>>>>
>>>> This can be a link to the node itself, can't it?
>>>>
>>>
>>> Yes. Do you want it like this?
>>
>> Yes, hence the suggestion. Unless you see some reason why not.
>>
>
> Nope, can=E2=80=99t be done. The sysfs API only allows linking one ko=
bj to another.
> The kobj is the overlay but the target is in the fragment attribute g=
roup.

Can't we make the fragments kobj's as well?

Rob
