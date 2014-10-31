From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: kdbus: add header file
Date: Fri, 31 Oct 2014 11:03:34 +0100
Message-ID: <54535E76.9050208@zonque.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <6078917.F7Y7rNpK9C@wuerfel> <5452269A.9050003@zonque.org> <3334170.rJW8YMf1Nv@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3334170.rJW8YMf1Nv@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, "alban.crequy" <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, "javier.martinez" <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/30/2014 01:03 PM, Arnd Bergmann wrote:
> On Thursday 30 October 2014 12:52:58 Daniel Mack wrote:

>> Hmm, this is the header exported to userspace, so having enums in would
>> make our lives easier, right?
> 
> My point was that you never use the enum by type and the only place in
> user space where it's referenced would be something like
> 
> 	ret = ioctl(fd, KDBUS_CMD_BUS_MAKE, &make);
> 
> In the debugger, you will see the source line here. If you trace into the
> glibc ioctl function, you no longer know the type because that just
> has an 'int'.

Alright - I changed that to #defines now.


Thanks,
Daniel
