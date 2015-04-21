From: "Ivan.khoronzhuk" <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Subject: Re: [Patch v2 2/3] firmware: dmi_scan: add SBMIOS entry and DMI tables
Date: Tue, 21 Apr 2015 19:03:30 +0300
Message-ID: <553674D2.10407@globallogic.com>
References: <1429525187-3376-1-git-send-email-ivan.khoronzhuk@globallogic.com>	<1429525187-3376-3-git-send-email-ivan.khoronzhuk@globallogic.com> <20150421173613.6601da15@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150421173613.6601da15-R0o5gVi9kd7kN2dkZ6Wm7A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

Jean,

On 21.04.15 18:36, Jean Delvare wrote:
> Hi again Ivan,
>
> On Mon, 20 Apr 2015 13:19:46 +0300, Ivan Khoronzhuk wrote:
>> +	bin_attr_DMI.size = dmi_len;
>> +	bin_attr_DMI.private = dmi_table;
>> +	ret = sysfs_create_bin_file(tables_kobj, &bin_attr_DMI);
>> +	if (!ret)
>> +		return 0;
> I just found that more work is needed here for the SMBIOS v3 entry
> point case. These entry points do not specify the exact length of the
> table, but only its maximum. The real world sample I have access to
> indeed specifies a maximum length of 6419 bytes, but the actual table
> only spans over 2373 bytes. It is properly terminated with a type 127
> DMI structure, so the kernel table parser ignores the garbage after it.
> The garbage is however exported to user-space above.
>
> I taught dmidecode to ignore the garbage, but there are two problem
> left here. First problem is a waste of memory. Minor issue I suppose,
> who cares about a few kilobytes these days.
>
> Second problem is a security problem. We are leaking the contents of
> physical memory to user-space. In my case it's filled with 0xffs so no
> big deal. But what if actual data happens to be stored there? It
> definitely shouldn't go to user-space.
>
> So dmi_len needs to be trimmed to the actual table size before the
> attribute above is created. I have an idea how this could be
> implemented easily, let me give it a try.
>
> Maybe we should trim the length for previous implementations, too.
> There is no reason to walk past a type 127 structure anyway, ever.
>

It can happen of-cause, I've also thought about that sometime ago,
but forget...).
I've sent the updated series already.
Let me know when your fix will be ready and I will re-base the
series if it has conflicts.

-- 
Regards,
Ivan Khoronzhuk
