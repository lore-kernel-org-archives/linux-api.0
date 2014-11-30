From: David Herrmann <dh.herrmann@gmail.com>
Subject: Re: kdbus: add documentation
Date: Sun, 30 Nov 2014 18:12:39 +0100
Message-ID: <CANq1E4QJhbypbs1PueKdW7AmBPiiYEg1dN-fsAewDJap82feyg@mail.gmail.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
	<1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
	<CALCETrWUekPq6pquuiVperBihQHgcvCF=WzVJTZziHhUJYsh4Q@mail.gmail.com>
	<87tx1hxdgy.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87tx1hxdgy.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Andy Lutomirski <luto@amacapital.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daniel Mack <daniel@zonque.org>, Djalal Harouni <tixxdz@opendz.org>
List-Id: linux-api@vger.kernel.org

Hi

On Sun, Nov 30, 2014 at 10:08 AM, Florian Weimer <fw@deneb.enyo.de> wrote:
> * Andy Lutomirski:
>
>> At the risk of opening a can of worms, wouldn't this be much more
>> useful if you could share a pool between multiple connections?
>
> They would also be useful to reduce context switches when receiving
> data from all kinds of descriptors.  At present, when polling, you
> receive notification, and then you have to call into the kernel,
> again, to actually fetch the data and associated information.

poll(2) and friends cannot return data for changed descriptors. I
think a single trap for each KDBUS_CMD_MSG_RECV is acceptable. If this
turns out to be a bottleneck, we can provide bulk-operations in the
future. Anyway, I don't see how a _shared_ pool would change any of
this?

> kernel could also queue the data for one specific recipient,
> addressing the same issue that SO_REUSEPORT tries to solve (on poll
> notification, the kernel does not know which recipient will eventually
> retrieve the data, so it has to notify and wake up all of them).

We already queue data only for the addressed recipients. We *do* know
all recipients of a message at poll-notification time. We only wake up
recipients that actually got a message queued.

Not sure how this is related to SO_REUSEPORT. Can you elaborate on
your optimizations?

Thanks
David
