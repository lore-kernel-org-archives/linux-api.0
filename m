From: Tom Gundersen <teg@jklm.no>
Subject: Re: kdbus: add header file
Date: Thu, 30 Oct 2014 12:02:39 +0100
Message-ID: <CAG-2HqV_mXyARMs=9GOpbCBHPU+2XMkDcm=sGekYnnujNPAYqQ@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-3-git-send-email-gregkh@linuxfoundation.org> <3546486.lOZcZMmXYe@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3546486.lOZcZMmXYe@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>, Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>, David Herrmann <dh.herrmann@gmail.com>, Djalal Harouni <tixxdz@opendz.org>, Simon McVittie <simon.mcvittie@collabora.co.uk>, Daniel Mack <daniel@zonque.org>, "alban.crequy" <alban.crequy@collabora.co.uk>, "javier.martinez" <javier.martinez@collabora.co.uk>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 30, 2014 at 9:20 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> I think in general, using enum is great, but for ioctl command numbers,
> we probably want to have defines so the user space implementation can
> use #ifdef to see if the kernel version that it is being built for
> knows a particular command.

Does that make sense for the first version? I agree that we should use
 #define to allow #ifdef for when we add more ioctls in the future,
but these ioctls will always exist...

The nice thing about enums is of course that it helps with debugging
as gdb can show the string representation rather than the number,
because in contrast to #defines, an enum is something the compliler
knows about.

Cheers,

Tom
