From: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 4/4] Documentation: ABI: /sys/firmware/devicetree/overlays
Date: Mon, 15 Jun 2015 08:42:57 -0500
Message-ID: <CAL_JsqLQ2fU1KgN=KprLJmGeJjGxcfX9CZfRpWwd-BUYr7g5qw@mail.gmail.com>
References: <1434137896-13806-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1434137896-13806-5-git-send-email-pantelis.antoniou@konsulko.com>
 <CAL_JsqKm9PtDKaabx22Y8WQRJ+RCxWE9Fj+kO2dCJ7_UzriyzA@mail.gmail.com> <B474B6B9-0C7C-4A46-B64F-BD76DA4B7F3B@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B474B6B9-0C7C-4A46-B64F-BD76DA4B7F3B-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Cc: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 15, 2015 at 8:26 AM, Pantelis Antoniou
<pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
> Hi Rob,
>
>> On Jun 15, 2015, at 16:24 , Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> On Fri, Jun 12, 2015 at 2:38 PM, Pantelis Antoniou
>> <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org> wrote:
>>> Documentation ABI entry for overlays sysfs entries.
>>>
>>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
>>> ---
>>> .../ABI/testing/sysfs-firmware-devicetree-overlays | 35 ++++++++++++++++++++++
>>> 1 file changed, 35 insertions(+)
>>> create mode 100644 Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
>>>
>>> diff --git a/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
>>> new file mode 100644
>>> index 0000000..be2d28b
>>> --- /dev/null
>>> +++ b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
>>> @@ -0,0 +1,35 @@

[...]

>>> +
>>> +               targets: A file containing the list of targets of each overlay
>>> +                        with each line containing a target.
>>
>> We have OF nodes in sysfs now. Would it be more useful if we created
>> links to the target nodes instead of having a list of names?
>>
>
> Probably, this interface is merely informational; things get complicated by
> the fact that there can be more than one target in each overlay.

Right, you would need 'targetN' or perhaps '<node name>' (with a '.N'
for duplicates) as the link names.

If it is informational, then perhaps debugfs should be used instead?

What else if anything do you envision adding here?

Rob
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
