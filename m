From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in mem16_serial_out
Date: Fri, 13 Dec 2019 10:05:11 +0100
Message-ID: <CACT4Y+amUGgm178SkrDHef9As5WkNHAyx5U9OdjgkFd-wY2ZqA@mail.gmail.com>
References: <00000000000044a65205994a7e13@google.com> <00000000000003cc8505994f9036@google.com>
 <20191212105754.GC1476206@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191212105754.GC1476206@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: syzbot <syzbot+92f32d4e21fb246d31a2@syzkaller.appspotmail.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, asierra@xes-inc.com, Jonathan Corbet <corbet@lwn.net>, ext-kimmo.rautkoski@vaisala.com, Jiri Slaby <jslaby@suse.com>, kai heng feng <kai.heng.feng@canonical.com>, Linux API <linux-api@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-serial <linux-serial@vger.kernel.org>, mika.westerberg@linux.intel.com, paulburton@kernel.org, Peter Hurley <peter@hurleysoftware.com>, sr@denx.de, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, yegorslists@googlemail.com
List-Id: linux-api@vger.kernel.org

On Thu, Dec 12, 2019 at 11:57 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Dec 09, 2019 at 05:38:01PM -0800, syzbot wrote:
> > syzbot has bisected this bug to:
> >
> > commit bd94c4077a0b2ecc35562c294f80f3659ecd8499
> > Author: Masahiro Yamada <yamada.masahiro@socionext.com>
> > Date:   Wed Oct 28 03:46:05 2015 +0000
> >
> >     serial: support 16-bit register interface for console
>
> That would be because that is when this function was added to the kernel
> :)
>
> Again, you are asking the kernel to write to a bad place in memory, and
> then crash when that happens.  That sounds like the correct
> functionality to me...

This looks like:

#syz dup:
BUG: unable to handle kernel NULL pointer dereference in mem_serial_out

Let's continue in that thread.
