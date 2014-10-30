From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: kdbus: add header file
Date: Thu, 30 Oct 2014 12:26:58 +0100
Message-ID: <6078917.F7Y7rNpK9C@wuerfel>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <3546486.lOZcZMmXYe@wuerfel> <CAG-2HqV_mXyARMs=9GOpbCBHPU+2XMkDcm=sGekYnnujNPAYqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG-2HqV_mXyARMs=9GOpbCBHPU+2XMkDcm=sGekYnnujNPAYqQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Gundersen <teg@jklm.no>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>, David Herrmann <dh.herrmann@gmail.com>, Djalal Harouni <tixxdz@opendz.org>, Simon McVittie <simon.mcvittie@collabora.co.uk>, Daniel Mack <daniel@zonque.org>, "alban.crequy" <alban.crequy@collabora.co.uk>, "javier.martinez" <javier.martinez@collabora.co.uk>
List-Id: linux-api@vger.kernel.org

On Thursday 30 October 2014 12:02:39 Tom Gundersen wrote:
> On Thu, Oct 30, 2014 at 9:20 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > I think in general, using enum is great, but for ioctl command numbers,
> > we probably want to have defines so the user space implementation can
> > use #ifdef to see if the kernel version that it is being built for
> > knows a particular command.
> 
> Does that make sense for the first version? I agree that we should use
>  #define to allow #ifdef for when we add more ioctls in the future,
> but these ioctls will always exist...

It's mainly for consistency really.

> The nice thing about enums is of course that it helps with debugging
> as gdb can show the string representation rather than the number,
> because in contrast to #defines, an enum is something the compliler
> knows about.

This doesn't get passed as an enum in user space though, and when debugging
the kernel it only helps within one function.

	Arnd
