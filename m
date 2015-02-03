From: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: Re: [Patch v3] firmware: dmi-sysfs: add SMBIOS entry point area raw
 attribute
Date: Tue, 03 Feb 2015 16:47:06 +0200
Message-ID: <54D0DF6A.1090503@linaro.org>
References: <1422448763-17583-1-git-send-email-ivan.khoronzhuk@linaro.org> <54C906A9.1050001@linaro.org> <20150203104953.GA6461@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150203104953.GA6461@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, grant.likely@linaro.org, matt.fleming@intel.com, linux-api@vger.kernel.org, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, dmidecode-devel@nongnu.org, leif.lindholm@linaro.org
List-Id: linux-api@vger.kernel.org


On 02/03/2015 12:49 PM, Matt Fleming wrote:
> On Wed, 28 Jan, at 05:56:25PM, Ivan Khoronzhuk wrote:
>>> diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
>>> index e0f1cb3..61b6a38 100644
>>> --- a/drivers/firmware/dmi-sysfs.c
>>> +++ b/drivers/firmware/dmi-sysfs.c
>>> @@ -29,6 +29,8 @@
>>>   #define MAX_ENTRY_TYPE 255 /* Most of these aren't used, but we consider
>>>   			      the top entry type is only 8 bits */
>>> +static const u8 *smbios_raw_header;
> There appears to be a mixture of u8 and unsigned char going on here, cf.
> 'smbios_header'.
>
> While I'm pretty sure all architectures typedef them to be equivalent,
> semantically, as a reviewer this makes me think there are type issues.
>
> Is there any way to use one data type for the SMBIOS header?

Let it be u8 in both cases.

>>> @@ -669,6 +699,18 @@ static int __init dmi_sysfs_init(void)
>>>   		goto err;
>>>   	}
>>> +	smbios_raw_header = dmi_get_smbios_entry_area(&size);
>>> +	if (!smbios_raw_header) {
>>> +		pr_debug("dmi-sysfs: SMBIOS raw data is not available.\n");
>>> +		error = -ENODATA;
>>> +		goto err;
> Perhaps this should be -EINVAL? -ENODATA implies that if you try again
> in the future data might be available, i.e. it's a temporary failure.
> That's not the case here since the header is invalid.
>

Yes, -EINVAL is better.
I'll send new patch soon.
Thanks!
