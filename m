From: sathyanarayanan kuppuswamy
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [RFC PATCH 3/3] iio: derive the mounting matrix from ACPI _PLD
 objects
Date: Mon, 27 Apr 2015 14:57:07 -0700
Message-ID: <553EB0B3.5000707@linux.intel.com>
References: <1430146908-27919-1-git-send-email-octavian.purdila@intel.com>	<1430146908-27919-4-git-send-email-octavian.purdila@intel.com>	<64714.10.254.87.235.1430149342.squirrel@linux.intel.com> <CAE1zot+YKTPmVbG-_fNRy-E_VCcqq1VE78H3PMSMb5HvsBheQw@mail.gmail.com>
Reply-To: sathyanarayanan.kuppuswamy@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <CAE1zot+YKTPmVbG-_fNRy-E_VCcqq1VE78H3PMSMb5HvsBheQw@mail.gmail.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>, Robert Moore <robert.moore@intel.com>, Rafael J Wysocki <rafael.j.wysocki@intel.com>, lenb@kernel.org, linux-api@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi

On 04/27/2015 08:54 AM, Octavian Purdila wrote:
> On Mon, Apr 27, 2015 at 6:42 PM, Kuppuswamy Sathyanarayanan
> <sathyanarayanan.kuppuswamy@linux.intel.com> wrote:
>> Since Acpi framework already exports this info to user space, Why not do
>> this derivation in user space code ? Why do we need new ABI, if the same
>> can be derived from existing one.
>>
> The ABI was added in the previous patch so that we can present the
> sensor orientation information to userspace even in the case of device
> tree.
If the main reason for implementing a new ABI is to support DT 
platforms, Why not implement a version of _PLD for device tree ? Don't 
you think it would be much better than adding a new ABI to export 
redundant information ?

Also the location information of the device is not just specific to iio 
drivers. You should consider that we would have similar requirements for 
devices implemented as input or platform drivers.
>
> The purpose of this patch is to provide a consistent ABI to userspace,
> i.e. to avoid doing one thing in the ACPI case and another thing in
> the case of device tree.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Sathyanarayanan Kuppuswamy
Android kernel developer

