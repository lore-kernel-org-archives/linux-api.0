From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: kdbus: add code to gather metadata
Date: Thu, 30 Oct 2014 14:01:50 -0700
Message-ID: <CALCETrV6MLYUQN6mqZbH=FrLyrETVoemtdC05po8+X=6SKQ70A@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com>
 <CALCETrVkuKxMMEw3HBEOZoFUuw8PndXtB13+bLWmcp_E34SaFw@mail.gmail.com>
 <5451FA9B.8070501@zonque.org> <CALCETrWjOS0AHF33zN0Vy1NC1441To7AgNPge3sKCz8bn2d8gg@mail.gmail.com>
 <54525F32.3040502@zonque.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54525F32.3040502-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, "alban.crequy" <alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Javier Martinez Canillas <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 30, 2014 at 8:54 AM, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org> wrote:
> On 10/30/2014 03:07 PM, Andy Lutomirski wrote:
>> On Thu, Oct 30, 2014 at 1:45 AM, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org> wrote:
>>> 2. When a new bus is created through KDBUS_CMD_BUS_MAKE, so peers can
>>> later query the credentials of the owner of the bus they're connected to.
>>
>> Ditto.  Although, why on earth should a bus have credentials?  This
>> sounds like a misdesign.  It seems to me that this type of policy
>> belongs all the way in userspace.  If you want a bus, you ask the
>> owner of the entire domain to make you a bus.  Or you make it yourself
>> and hand off references in some authenticated way.
>
> Yes, that's the way it works. However, the idea is that a bus stays
> alive as long as the file descriptor that was used to the create that
> bus remains open, and it is immediately shut down when the fd is closed.
> We merely allow user that are connected to a bus to query the
> credentials of the creator of the bus they're connected to.

Why do you allow this?  What purpose does it serve?  Is that idea that
each application will own one bus?  If so, what goes wrong if you only
capture the specific credentials that the creator of a given bus asks
to have captured?

[snip]

>
>> If I create an endpoint and delegate some processing to a less
>> privileged child, other things on the bus MUST NOT be able to detect
>> that delegation in any sensible design.  Otherwise everything will
>> appear to work in testing because other processes never checked the
>> problematic credential, but then it will randomly fail because someone
>> decided to do something daft and validate my unprivileged child's
>> argv[0], which is, of course, not what they expected.
>
> Not sure whether I got your point, but if a privileged service that
> takes action on behalf of unprivileged clients, it may well depend on
> certain credential information to be present along with the message, and
> refuse to take action otherwise.
>
> For example, if a privileged service can reboot the system, it checks
> whether the asking peer has CAP_SYS_BOOT set. If it checks for uid==0
> instead, and it works in your tests because you happen to test as root,
> that just a bug in the service, right? But I might have missed your point.

The issue is the following: if have the privilege needed to talk to
journald, I may want to enhance security by opening a connection to
journald (and capture that privilege) and then drop privilege.  I
should still be able to talk to journald.

Alternatively, if the privilege needed to reboot is CAP_SYS_BOOT, then
clients should send that capability bit.  Capturing extra information
to try to give daemons the flexibility to change their authorization
conditions later on just moves the problem if you need to change
policy down the line.

>
>> I suspect that, if you make credential sending opt-in, you will
>> quickly discover that the current model for which credentials matter
>> makes no sense.
>
> While for the example above, opting-in for creds items on the sender
> side might actually work (the asking service would be refused in his
> request to reboot the machine). However, for any sort of logging or
> system services, for example, allowing the sender to select which creds
> it wants to reveal is supporting a hide-and-seek game, and that's
> something that won't work.

What's the actual problem for logging?  I very much understand why a
logging service never wants to log an incorrect credential (and legacy
syslog has serious problems here because it doesn't even try to
capture credential), but what's wrong with having a log that shows the
uid for legit log messages and that reliably says "declined to state"
for messages that decline to state.

(Also, I presume that cmdline is for logging.  Keep in mind that the
cmdline is yanked from user memory and can be freely spoofed.)

A major benefit of opt-in credential passing is that it makes it very
difficult to convince another process to exercise its credential on
your behalf by accident.

>
> Thanks for sharing your thoughts on this - I appreciate this discussion
> stays on such technical grounds :)
>

My pleasure.  I have no desire to see this process devolve into random
flames (and I'm glad it hasn't).  That being said, I'll still continue
to object to credential and namespace issues that I think are
problematic. :)

--Andy
