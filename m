From: Pantelis Antoniou <panto-wVdstyuyKrO8r51toPun2/C9HSW9iNxf@public.gmane.org>
Subject: Re: [PATCH v3 4/4] Documentation: ABI: /sys/firmware/devicetree/overlays
Date: Mon, 27 Apr 2015 20:51:20 +0300
Message-ID: <C49CC7F9-C877-4590-AA63-F45D2D8E8CDC@antoniou-consulting.com>
References: <1429868744-19863-1-git-send-email-pantelis.antoniou@konsulko.com> <1429868744-19863-5-git-send-email-pantelis.antoniou@konsulko.com> <20150424203121.GB14970@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150424203121.GB14970-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Greg,

> On Apr 24, 2015, at 23:31 , Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
>=20
> On Fri, Apr 24, 2015 at 12:45:44PM +0300, Pantelis Antoniou wrote:
>> Documentation ABI entry for overlays sysfs entries.
>>=20
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
>> ---
>> .../ABI/testing/sysfs-firmware-devicetree-overlays | 23 ++++++++++++=
++++++++++
>> 1 file changed, 23 insertions(+)
>> create mode 100644 Documentation/ABI/testing/sysfs-firmware-devicetr=
ee-overlays
>>=20
>> diff --git a/Documentation/ABI/testing/sysfs-firmware-devicetree-ove=
rlays b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
>> new file mode 100644
>> index 0000000..6b81f1c
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-firmware-devicetree-overlays
>> @@ -0,0 +1,23 @@
>> +What:		/sys/firmware/devicetree/overlays/
>> +Date:		March 2015
>> +Contact:	Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
>> +Description:
>> +		This directory contains the applied device tree overlays of
>> +		the running system, as directories of the overlay id.
>=20
> "as"?
>=20
>> +
>> +		enable: The master enable switch, by default is 1, and when
>> +		        set to 0 it cannot be re-enabled for security reasons.
>=20
> What are those reasons?
>=20

There=E2=80=99s a whole subthread with Grant & Kees going over security=
 concerns.

http://comments.gmane.org/gmane.linux.drivers.devicetree/101871

> thanks,
>=20
> greg k-h

Regards

=E2=80=94 Pantelis

> --
> To unsubscribe from this list: send the line "unsubscribe devicetree"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
