From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kdbus: add documentation
Date: Sun, 30 Nov 2014 18:17:46 +0100
Message-ID: <CANq1E4TEw08C1sdgVxE0faGEDg3hD+K-XH1Ra=3+0LRPhx1bgQ@mail.gmail.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
	<1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
	<8761dxysl0.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8761dxysl0.fsf-ZqZwdwZz9NfTBotR3TxKnbNAH6kLmebB@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi

On Sun, Nov 30, 2014 at 9:56 AM, Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org> wrote:
> * Greg Kroah-Hartman:
>
>> +The focus of this document is an overview of the low-level, native kernel D-Bus
>> +transport called kdbus. Kdbus exposes its functionality via files in a
>> +filesystem called 'kdbusfs'. All communication between processes takes place
>> +via ioctls on files exposed through the mount point of a kdbusfs. The default
>> +mount point of kdbusfs is /sys/fs/kdbus.
>
> Does this mean the bus does not enforce the correctness of the D-Bus
> introspection metadata?  That's really unfortunate.  Classic D-Bus
> does not do this, either, and combined with the variety of approaches
> used to implement D-Bus endpoints, it makes it really difficult to
> figure out what D-Bus services, exactly, a process provides.

kdbus operates on the transport-level only. We never touch or look at
transferred data. As such, DBus introspection data as defined by
org.freedesktop.DBus.Introspectable is not verified by the transport
layer.

Thanks
David
