From: "Ivan.khoronzhuk" <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Subject: Re: [dmidecode] [Patch v4] firmware: dmi-sysfs: add SMBIOS entry
 point area attribute
Date: Mon, 16 Mar 2015 23:02:29 +0200
Message-ID: <550744E5.3070504@globallogic.com>
References: <1423069563-26467-1-git-send-email-ivan.khoronzhuk@linaro.org>	 <20150226103622.09b9870a@endymion.delvare> <54F6FAE7.30801@globallogic.com>	 <1425978807.24849.22.camel@chaos.site> <1426162975.2784.31.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426162975.2784.31.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Cc: Ivan Khoronzhuk <ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 12.03.15 14:22, Matt Fleming wrote:
> On Tue, 2015-03-10 at 10:13 +0100, Jean Delvare wrote:
>>> If Matt is OK to get another version,
>>> Let it be smbios_entry_point.
>>> If it's more convenient, it should be changed while it's possible.
>> Great, thanks.
> Ivan, please go ahead and submit a new version, we've got time to get
> this right for v4.1.
>

Matt, I've sent new patch that replaces this one.
"[Patch] firmware: dmi_scan: split dmisubsystem from dmi-sysfs"
It can take a while to go via review.

-- 
Regards,
Ivan Khoronzhuk
