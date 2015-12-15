From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 0/2] Minor _OSC error handling improvements
Date: Mon, 14 Dec 2015 19:15:13 -0800
Message-ID: <CALCETrV53ZR6Yy0m4xWzNTZJaQWrk9X7cMf3__32H+fN1ya0=g@mail.gmail.com>
References: <cover.1447949171.git.luto@kernel.org> <20151203172900.GB17565@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151203172900.GB17565@localhost>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Rafael J. Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yijing Wang <wangyijing-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[cc: linux-acpi and Rafael -- whoops]

Rafael, do you want me to resend these?

--Andy

On Thu, Dec 3, 2015 at 9:29 AM, Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Thu, Nov 19, 2015 at 08:08:18AM -0800, Andy Lutomirski wrote:
>> This doesn't fix any bugs, but it makes the debugging output a
>> little more useful.
>>
>> Andy Lutomirski (2):
>>   acpi: Tidy up _OSC error spacing
>>   acpi: Show _OSC UUID when _OSC fails
>>
>>  drivers/acpi/bus.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> These both look fine to me.  If you want it:
>
> Acked-by: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>



-- 
Andy Lutomirski
AMA Capital Management, LLC
