From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 0/2] Minor _OSC error handling improvements
Date: Tue, 15 Dec 2015 17:10:06 +0100
Message-ID: <56703B5E.7040601@intel.com>
References: <cover.1447949171.git.luto@kernel.org>
 <20151203172900.GB17565@localhost>
 <CALCETrV53ZR6Yy0m4xWzNTZJaQWrk9X7cMf3__32H+fN1ya0=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <CALCETrV53ZR6Yy0m4xWzNTZJaQWrk9X7cMf3__32H+fN1ya0=g@mail.gmail.com>
Sender: linux-pci-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Bjorn Helgaas <helgaas@kernel.org>, Linux API <linux-api@vger.kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>, Bjorn Helgaas <bhelgaas@google.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>
List-Id: linux-api@vger.kernel.org

On 12/15/2015 4:15 AM, Andy Lutomirski wrote:
> [cc: linux-acpi and Rafael -- whoops]
>
> Rafael, do you want me to resend these?

Yes, please.

Thanks,
Rafael


> On Thu, Dec 3, 2015 at 9:29 AM, Bjorn Helgaas <helgaas@kernel.org> wrote:
>> On Thu, Nov 19, 2015 at 08:08:18AM -0800, Andy Lutomirski wrote:
>>> This doesn't fix any bugs, but it makes the debugging output a
>>> little more useful.
>>>
>>> Andy Lutomirski (2):
>>>    acpi: Tidy up _OSC error spacing
>>>    acpi: Show _OSC UUID when _OSC fails
>>>
>>>   drivers/acpi/bus.c | 8 ++++----
>>>   1 file changed, 4 insertions(+), 4 deletions(-)
>> These both look fine to me.  If you want it:
>>
>> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>
>
