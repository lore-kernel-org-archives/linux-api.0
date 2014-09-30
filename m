From: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 04/11] drivers: base: support cpu cache information
 interface to userspace via sysfs
Date: Tue, 30 Sep 2014 14:53:20 +0100
Message-ID: <542AB5D0.3080007@arm.com>
References: <1409763617-17074-1-git-send-email-sudeep.holla@arm.com> <1409763617-17074-5-git-send-email-sudeep.holla@arm.com> <5419C3F6.4050607@arm.com> <20140917190048.GA4063@kroah.com> <20140924063511.GA12929@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140924063511.GA12929-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Sudeep Holla <sudeep.holla-5wv7dgnIgG8@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Lorenzo Pieralisi <Lorenzo.Pieralisi-5wv7dgnIgG8@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux390-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <linux390-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org" <linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org>, "linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Greg,

On 24/09/14 07:35, Greg Kroah-Hartman wrote:
> On Wed, Sep 17, 2014 at 12:00:48PM -0700, Greg Kroah-Hartman wrote:
>> On Wed, Sep 17, 2014 at 06:25:10PM +0100, Sudeep Holla wrote:
>>> Hi Greg,
>>>
>>> On 03/09/14 18:00, Sudeep Holla wrote:

[...]
>>>
>>> Can you review the first 4 patches in this series please ?
>>
>> It's in my todo queue, which is really long at the moment due to me
>> going to conferences (at one right now...)  Will be working on this
>> soon, thanks for your patience.
>
> Based on the review comments, I think you are going to change at least
> the first patch, right?  Please resend the latest version of this
> series, with all of the accumulated tested-by and acked lines and
> resend.
>

I have posted the new version as you suggested. I was holding off
assuming the merge window would open this week and hence the delay.

Regards,
Sudeep
