From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: kdbus: add header file
Date: Thu, 30 Oct 2014 13:03:44 +0100
Message-ID: <3334170.rJW8YMf1Nv@wuerfel>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <6078917.F7Y7rNpK9C@wuerfel> <5452269A.9050003@zonque.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5452269A.9050003@zonque.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Mack <daniel@zonque.org>
Cc: Tom Gundersen <teg@jklm.no>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>, David Herrmann <dh.herrmann@gmail.com>, Djalal Harouni <tixxdz@opendz.org>, Simon McVittie <simon.mcvittie@collabora.co.uk>, "alban.crequy" <alban.crequy@collabora.co.uk>, "javier.martinez" <javier.martinez@collabora.co.uk>
List-Id: linux-api@vger.kernel.org

On Thursday 30 October 2014 12:52:58 Daniel Mack wrote:
> On 10/30/2014 12:26 PM, Arnd Bergmann wrote:
> > On Thursday 30 October 2014 12:02:39 Tom Gundersen wrote:
> 
> >> The nice thing about enums is of course that it helps with debugging
> >> as gdb can show the string representation rather than the number,
> >> because in contrast to #defines, an enum is something the compliler
> >> knows about.
> > 
> > This doesn't get passed as an enum in user space though, and when debugging
> > the kernel it only helps within one function.
> 
> Hmm, this is the header exported to userspace, so having enums in would
> make our lives easier, right?

My point was that you never use the enum by type and the only place in
user space where it's referenced would be something like

	ret = ioctl(fd, KDBUS_CMD_BUS_MAKE, &make);

In the debugger, you will see the source line here. If you trace into the
glibc ioctl function, you no longer know the type because that just
has an 'int'.

> Hence, for now, I'd propose we keep it the way it is, and add new ioctls
> with defines once they are implemented. Are you okay with this? I'll add
> a comment to the file to give a heads-up.

It's certainly not a show-stopped, but I have yet to see a good reason
why it would help anyone.

	Arnd
