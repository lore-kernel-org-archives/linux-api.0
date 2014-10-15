From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [RFC PATCH v2 3/3] i2c: show and change bus frequency via sysfs
Date: Wed, 15 Oct 2014 06:13:54 -0700
Message-ID: <543E7312.1020104@roeck-us.net>
References: <1413298094-9276-1-git-send-email-octavian.purdila@intel.com>	<1413298094-9276-4-git-send-email-octavian.purdila@intel.com>	<20141014154151.GB10067@roeck-us.net> <CAE1zotKpgEqAhtQvsFFee8xnX02MmhwrM0YU-6OHVZHcxiAi9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-i2c-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAE1zotKpgEqAhtQvsFFee8xnX02MmhwrM0YU-6OHVZHcxiAi9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-i2c-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Johan Hovold <johan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-i2c <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/15/2014 04:49 AM, Octavian Purdila wrote:
> On Tue, Oct 14, 2014 at 6:41 PM, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org> wrote:
>>
>> On Tue, Oct 14, 2014 at 05:48:14PM +0300, Octavian Purdila wrote:
>>> This patch adds three new sysfs files: bus_frequency,
>>> bus_min_frequency and bus_max_frequency which allows the user to view
>>> or change the bus frequency on a per bus level.
>>>
>
> <snip>
>
>>> +
>>> +static DEVICE_ATTR(bus_frequency, S_IRUGO, i2c_sysfs_freq_show,
>>> +                i2c_sysfs_freq_store);
>>
>> Consider using DEVICE_ATTR_RO here. Also, extra empty line.
>>
>
> Unfortunately that won't work because we must transform bus_frequency
> to a RW entry (via is_visible) if the bus can change the frequency. We

Ah yes, you are right.

> can't use DEVIE_ATTR_RW either, because transforming a RW entry to a
> RO entry with is visible is not possible:
>

Why not ?

is_visible returns the desired mode. Just like you can return mode | S_IWUSR,
you can return mode & ~S_IWUSR.

Am I missing something ?

Guenter
