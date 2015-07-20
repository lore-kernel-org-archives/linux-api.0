From: Azael Avalos <coproscefalo@gmail.com>
Subject: Re: [PATCH] toshiba_acpi: Add /dev/toshiba_acpi device
Date: Mon, 20 Jul 2015 15:55:19 -0600
Message-ID: <CAGdLNWEWyFkBeXbqN+A-CQtCwACFSfb5kYxFZehvGFdb+GkmYQ@mail.gmail.com>
References: <1437089564-4242-1-git-send-email-coproscefalo@gmail.com>
	<20150720213631.GA34611@vmdeb7>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <platform-driver-x86-owner@vger.kernel.org>
In-Reply-To: <20150720213631.GA34611@vmdeb7>
Sender: platform-driver-x86-owner@vger.kernel.org
To: Darren Hart <dvhart@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Jonathan Buzzard <jonathan@buzzard.org.uk>, linux-doc@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Darren,

2015-07-20 15:36 GMT-06:00 Darren Hart <dvhart@infradead.org>:
> On Thu, Jul 16, 2015 at 05:32:44PM -0600, Azael Avalos wrote:
>> There were previous attempts to "merge" the toshiba SMM module to the
>> toshiba_acpi one, they were trying to imitate what the old toshiba
>> module does, however, some models (TOS1900 devices) come with a
>> "crippled" implementation and do not provide all the "features" a
>> "genuine" Toshiba BIOS does.
>>
>> This patch adds a new device called toshiba_acpi, which aim is to
>> enable userspace to access the SMM on Toshiba laptops via ACPI calls.
>>
>> Creating a new convenience _IOWR command to access the SCI functions
>> by opening/closing the SCI internally to avoid buggy BIOS, while at
>> the same time providing backwards compatibility.
>>
>> Older programs who wish to access the SMM on newer models can do it
>> without much code change, as the toshiba.h header was modified to
>> reflect these changes as well as adds all the toshiba_acpi paths
>> and commands.
>
> To clarify, the newer models didn't work at all previously, so this is not
> changing the user:kernel interface, but rather enabling it on newer machines,
> and programs wishing to take advantage of that can do so with minimal change.
>
> Correct?

Yes, the only real (or new) change here is the introduction of the IOCTL
"TOSHIBA_ACPI_SCI", which was added to circumvent buggy or "incomplete"
BIOSes found (so far) on TOS1900 devices.

Any new (or old) program that want to access the SMM can do so by pointing
their path to /dev/toshiba_acpi instead of /dev/toshiba, however, it is strongly
recommended to use the new IOCTL for any SCI command to avoid any buggy
BIOS.

>
> --
> Darren Hart
> Intel Open Source Technology Center


Cheers
Azael


-- 
-- El mundo apesta y vosotros apestais tambien --
