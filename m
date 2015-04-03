From: "Ivan.khoronzhuk" <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Subject: Re: [Patch] firmware: dmi_scan: split dmisubsystem from dmi-sysfs
Date: Fri, 03 Apr 2015 10:21:11 +0300
Message-ID: <551E3F67.1050609@globallogic.com>
References: <1426539451-2119-1-git-send-email-ivan.khoronzhuk@globallogic.com>	 <1426779055.4267.1907.camel@chaos.site>	<550B08E6.5050200@globallogic.com>	 <20150320091620.04cf733a@endymion.delvare>	 <551D3DE4.8040409@globallogic.com> <1427987302.4281.309.camel@chaos.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427987302.4281.309.camel-H7Kp9ZFCxt/N0uC3ymp8PA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

+ Roy

On 02.04.15 18:08, Jean Delvare wrote:
> Le Thursday 02 April 2015 =C3=A0 16:02 +0300, Ivan.khoronzhuk a =C3=A9=
crit :
>> Hi Jean,
>> Sorry for the late reply.
>> I've send new series
>> "[Patch 0/3] firmware: dmi_scan: add SBMIOS entry point and DMI tabl=
es"
>> with all last propositions.
> Thanks Ivan, no problem. I'll look at it when I have time.
>
> Two related notes:
>
> * On week from April 13th to 17th, this is Hack Week 12 at SUSE. This
> time I decided to work on dmidecode. I plan to add full support for
> SMBIOS 3.0.0, including the new entry point format. Then I'll work on
> integrating your work (the sysfs interface.) Project page:
>
> https://hackweek.suse.com/12/projects/766
>
> If you or anyone else want to participate, you are very welcome. Idea=
lly
> we would release dmidecode 2.13 at the end of that week.
>
> * Do you know of any hardware already implementing SMBIOS 3.0 (either
> the new entry point format, or the new enumerated values, or both)?
> Having a real-world example would make testing much easier.
>
> Thanks,

--=20
Regards,
Ivan Khoronzhuk
