From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: kdbus: add documentation
Date: Sun, 30 Nov 2014 10:08:29 +0100
Message-ID: <87tx1hxdgy.fsf@mid.deneb.enyo.de>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
	<1416546149-24799-2-git-send-email-gregkh@linuxfoundation.org>
	<CALCETrWUekPq6pquuiVperBihQHgcvCF=WzVJTZziHhUJYsh4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWUekPq6pquuiVperBihQHgcvCF=WzVJTZziHhUJYsh4Q@mail.gmail.com>
	(Andy Lutomirski's message of "Fri, 21 Nov 2014 09:12:39 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daniel Mack <daniel@zonque.org>, David Herrmann <dh.herrmann@gmail.com>, Djalal Harouni <tixxdz@opendz.org>
List-Id: linux-api@vger.kernel.org

* Andy Lutomirski:

> At the risk of opening a can of worms, wouldn't this be much more
> useful if you could share a pool between multiple connections?

They would also be useful to reduce context switches when receiving
data from all kinds of descriptors.  At present, when polling, you
receive notification, and then you have to call into the kernel,
again, to actually fetch the data and associated information.  The
kernel could also queue the data for one specific recipient,
addressing the same issue that SO_REUSEPORT tries to solve (on poll
notification, the kernel does not know which recipient will eventually
retrieve the data, so it has to notify and wake up all of them).
