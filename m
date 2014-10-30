From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: kdbus: add code to gather metadata
Date: Thu, 30 Oct 2014 09:45:15 +0100
Message-ID: <5451FA9B.8070501@zonque.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <1414620056-6675-7-git-send-email-gregkh@linuxfoundation.org> <CALCETrWqbpxk83L0k0_78JZCO+ntZhx_hHMcRu=vxs6VE2f5JQ@mail.gmail.com> <CALCETrVkuKxMMEw3HBEOZoFUuw8PndXtB13+bLWmcp_E34SaFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVkuKxMMEw3HBEOZoFUuw8PndXtB13+bLWmcp_E34SaFw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, Simon McVittie <simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, Javier Martinez Canillas <javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/30/2014 01:13 AM, Andy Lutomirski wrote:
> On Wed, Oct 29, 2014 at 3:33 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman
>> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
>>> From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
>>>
>>> A connection chooses which metadata it wants to have attached to each
>>> message it receives with kdbus_cmd_hello.attach_flags. The metadata
>>> will be attached as items to the messages. All metadata refers to
>>> information about the sending task at sending time, unless otherwise
>>> stated. Also, the metadata is copied, not referenced, so even if the
>>> sending task doesn't exist anymore at the time the message is received,
>>> the information is still preserved.
>>>
> 
> Also, in general, the comments seem to talk about capturing metadata
> at the time that a connection is opened, but the actual code seems to
> capture metadata all over the place.  I think it needs to be very
> clear, both in the code and the interface, when metadata is captured.

Ok, so we should make that cleaner in the comments then.

To clarify, we currently take metadata at the following occasions:


1. At open() time, So we can tell peers (through KDBUS_CMD_CONN_INFO)
about the credentials a connection had when it was created with
KDBUS_CMD_HELLO.

2. When a new bus is created through KDBUS_CMD_BUS_MAKE, so peers can
later query the credentials of the owner of the bus they're connected to.

3. When we dispatch a KDBUS_CMD_MSG_SEND ioctl(), because we want to
attach the metadata that was authoritative when the message was sent.
IOW: We want metadata that actually matches the message payload.

4. We create faked metadata to pass around in messages in case the
connection was created 'on behalf' of another task. This case we need to
cover so we can implement a daemon in userspace that translates between
existing D-Bus clients and kdbus. In such cases, we want the receiving
peers to see the creds of the proxied task, rather than the proxy, so we
pass the small amount of reliably credential information that we can get
with SO_PEERCRED into the KDBUS_CMD_HELLO ioctl. In the kernel, we
create a metadata object out of that, so we can reuse when a message is
sent. This case, however, is an considered an exception and limited to
privileged clients.

In all such cases, we share some implementation in metadata.c, and we
operate on the same kdbus_metadata object, even though the origin of the
data varies in the individual cases. I agree that this should be better
documented, so I've put that on my TODO list.

> And the ns_eq stuff is too far buried (and not even contained in this
> patch!) to be easily verified as being correct, whatever correct means
> in that context.

I see that. As I explained earlier in my reply to Eric, we've chosen to
submit the patch set this way to keep the reply threading clean, so it
was some sort of a trade-off. Still, I think the best way to review it
is to pull in Greg's patches and look at the actual files.


Thanks,
Daniel
