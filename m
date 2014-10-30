From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: kdbus: add header file
Date: Thu, 30 Oct 2014 12:52:58 +0100
Message-ID: <5452269A.9050003@zonque.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <3546486.lOZcZMmXYe@wuerfel> <CAG-2HqV_mXyARMs=9GOpbCBHPU+2XMkDcm=sGekYnnujNPAYqQ@mail.gmail.com> <6078917.F7Y7rNpK9C@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6078917.F7Y7rNpK9C@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, "alban.crequy" <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, "javier.martinez" <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/30/2014 12:26 PM, Arnd Bergmann wrote:
> On Thursday 30 October 2014 12:02:39 Tom Gundersen wrote:

>> The nice thing about enums is of course that it helps with debugging
>> as gdb can show the string representation rather than the number,
>> because in contrast to #defines, an enum is something the compliler
>> knows about.
> 
> This doesn't get passed as an enum in user space though, and when debugging
> the kernel it only helps within one function.

Hmm, this is the header exported to userspace, so having enums in would
make our lives easier, right?

Hence, for now, I'd propose we keep it the way it is, and add new ioctls
with defines once they are implemented. Are you okay with this? I'll add
a comment to the file to give a heads-up.


Thanks,
Daniel
