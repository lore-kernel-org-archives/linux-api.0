From: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Wed, 05 Nov 2014 15:34:48 +0100
Message-ID: <545A3588.2010903@zonque.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <CALCETrUBegZ4F1sKq3LxUgANX3=syYOrqOp9=F--g9pkVHHgUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUBegZ4F1sKq3LxUgANX3=syYOrqOp9=F--g9pkVHHgUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, Ryan Lortie <desrt-0xnayjDhYQY@public.gmane.org>, Bastien Nocera <hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/29/2014 11:19 PM, Andy Lutomirski wrote:
> I think that each piece of trustable metadata needs to be explicitly
> opted-in to by the sender at the time of capture.  Otherwise you're
> asking for lots of information leaks and privilege escalations.  This
> is especially important given that some of the items in the current
> list could be rather sensitive.

Alright, the above seems to pretty much sum up that end of our
discussion. To address this, We've now added the following functionality
for v2:

 * The attach_flags in kdbus_cmd_hello was split into two parts,
   attach_flags_send and attach_flags_recv, so each peer may chose what
   exactly it want to transmit or receive.

 * Metadata will only be attached to the final message in the
   receiver's pool if both the sender's attach_flags_send and the
   receiver's attach_flags_recv bit are set.

 * Consequently, the existing KDBUS_ITEM_ATTACH_FLAGS item type is
   split into KDBUS_ITEM_ATTACH_FLAGS_SEND and
   KDBUS_ITEM_ATTACH_FLAGS_RECV, so that both connection details can be
   separately updated through KDBUS_CMD_CONN_UPDATE.

 * To allow for use cases that require certain metadata to be attached
   on each message, we've added a negotiation mechanism to the HELLO
   ioctl: An optional metadata mask can be passed during the creation
   of buses, so bus owners may require certain bits in
   attach_flags_send to be set. That way, the creator of the bus will
   specify which metadata is required to fulfill the requirements of
   the specification of the role of the bus.


Thanks again for your input!

Daniel
