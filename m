From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 2/5] firmware: Basic dmi-sysfs support
Date: Tue, 22 Feb 2011 15:31:02 -0800
Message-ID: <4D644736.9050109@google.com>
References: <20110217212754.3967.98648.stgit@mike.mtv.corp.google.com> <20110217212805.3967.47547.stgit@mike.mtv.corp.google.com> <20110217215608.GA2451@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110217215608.GA2451-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Olof Johansson <olofj-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Robert Lippert <rlippert-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jon Mayer <jonmayer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Duncan Laurie <dlaurie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Hendrix <dhendrix-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/17/11 13:56, Greg KH wrote:
> Overall, this looks great, just a few minor comments below:
>
> On Thu, Feb 17, 2011 at 01:28:05PM -0800, Mike Waychison wrote:
>> +config DMI_SYSFS
>> +	tristate "DMI table support in sysfs"
>> +	depends on SYSFS&&  DMI
>> +	default X86
>
> Huh?  Default should be 'N' for any new feature, unless it keeps your
> machine from booting.
>
> I think you want this option to depend on X86 though, right?

Looks to be supported on ia64 as well, though I don't have any hardware 
to test this code on for that arch.  Tony: I think this DMI exporting 
code should just work on ia64 as all it is using is dmi_walk() and 
parsing the entries as returned as dmi_headers in the callback.  Does 
this sound sane to you?

>
>> +	help
>> +	  Say Y or M here to enable the exporting of the raw DMI table
>> +	  data via sysfs.  This is useful for consuming the data without
>> +	  requiring any access to /dev/mem at all.  Tables are found
>> +	  under /sys/firmware/dmi when this option is enabled and
>> +	  loaded.
>
> I just realized (due to other work I'm doing on a laptop) that we have a
> bunch of entries today in /sys/class/dmi/id which is a pointer to the
> dmi "device".
>
> Now I think this really is different (these are the raw DMI tables), but
> this doesn't have anything to do with that code, right?

Ya, it is similar, though the primary goal I have is to export these raw 
bytes.  The data comes from the same place, however the dmi-id code is 
just exporting the in-kernel copies of the strings parsed at boot.

These could probably be better exported under 
/sys/firmware/dmi/entries/[0123]-*/ files imo.

Mike Waychison
