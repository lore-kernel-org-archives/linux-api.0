From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: kdbus: add code to gather metadata
Date: Thu, 30 Oct 2014 07:07:57 -0700
Message-ID: <CALCETrWjOS0AHF33zN0Vy1NC1441To7AgNPge3sKCz8bn2d8gg@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com>
 <CALCETrVkuKxMMEw3HBEOZoFUuw8PndXtB13+bLWmcp_E34SaFw@mail.gmail.com> <5451FA9B.8070501@zonque.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5451FA9B.8070501-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, Javier Martinez Canillas <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 30, 2014 at 1:45 AM, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org> wrote:
>
> 1. At open() time, So we can tell peers (through KDBUS_CMD_CONN_INFO)
> about the credentials a connection had when it was created with
> KDBUS_CMD_HELLO.

Then the API that tells peers about this information needs to make
this very clear.

>
> 2. When a new bus is created through KDBUS_CMD_BUS_MAKE, so peers can
> later query the credentials of the owner of the bus they're connected to.
>

Ditto.  Although, why on earth should a bus have credentials?  This
sounds like a misdesign.  It seems to me that this type of policy
belongs all the way in userspace.  If you want a bus, you ask the
owner of the entire domain to make you a bus.  Or you make it yourself
and hand off references in some authenticated way.

> 3. When we dispatch a KDBUS_CMD_MSG_SEND ioctl(), because we want to
> attach the metadata that was authoritative when the message was sent.
> IOW: We want metadata that actually matches the message payload.
>

What does that "metadata that actually matches the message payload"
mean?  If I create an endpoint and delegate some processing to a less
privileged child, other things on the bus MUST NOT be able to detect
that delegation in any sensible design.  Otherwise everything will
appear to work in testing because other processes never checked the
problematic credential, but then it will randomly fail because someone
decided to do something daft and validate my unprivileged child's
argv[0], which is, of course, not what they expected.

I suspect that, if you make credential sending opt-in, you will
quickly discover that the current model for which credentials matter
makes no sense.

>> And the ns_eq stuff is too far buried (and not even contained in this
>> patch!) to be easily verified as being correct, whatever correct means
>> in that context.
>
> I see that. As I explained earlier in my reply to Eric, we've chosen to
> submit the patch set this way to keep the reply threading clean, so it
> was some sort of a trade-off. Still, I think the best way to review it
> is to pull in Greg's patches and look at the actual files.

This wasn't a comment about the threading.  The call, in the patches
in the git tree, is buried and very difficult to follow.

--Andy
