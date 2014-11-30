From: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>
Subject: Re: kdbus: add documentation
Date: Sun, 30 Nov 2014 18:23:53 +0100
Message-ID: <87vblwtxee.fsf@mid.deneb.enyo.de>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
	<1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
	<871tolysbb.fsf@mid.deneb.enyo.de>
	<CANq1E4RjwCVEVT7031CeiKrNvRFkLBZc4-X1uKdrdzpf=EwJ+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANq1E4RjwCVEVT7031CeiKrNvRFkLBZc4-X1uKdrdzpf=EwJ+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(David Herrmann's message of "Sun, 30 Nov 2014 18:15:14 +0100")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

* David Herrmann:

> On Sun, Nov 30, 2014 at 10:02 AM, Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org> w=
rote:
>> * Greg Kroah-Hartman:
>>
>>> +7.4 Receiving messages

>> What happens if this is not possible because the file descriptor lim=
it
>> of the processes would be exceeded?  EMFILE, and the message will no=
t
>> be received?
>
> The message is returned without installing the FDs. This is signaled
> by EMFILE, but a valid pool offset.

Oh.  This is really surprising, so it needs documentation.  But it's
probably better than the alternative (return EMFILE and leave the
message stuck, so that you receive it immediately again=E2=80=94this be=
havior
makes non-blocking accept rather difficult to use correctly).
