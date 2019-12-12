From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in
 mem16_serial_out
Date: Thu, 12 Dec 2019 11:57:54 +0100
Message-ID: <20191212105754.GC1476206@kroah.com>
References: <00000000000044a65205994a7e13@google.com>
 <00000000000003cc8505994f9036@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00000000000003cc8505994f9036@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+92f32d4e21fb246d31a2@syzkaller.appspotmail.com>
Cc: andriy.shevchenko@linux.intel.com, asierra@xes-inc.com, corbet@lwn.net, ext-kimmo.rautkoski@vaisala.com, jslaby@suse.com, kai.heng.feng@canonical.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, mika.westerberg@linux.intel.com, paulburton@kernel.org, peter@hurleysoftware.com, sr@denx.de, syzkaller-bugs@googlegroups.com, yamada.masahiro@socionext.com, yegorslists@googlemail.com
List-Id: linux-api@vger.kernel.org

On Mon, Dec 09, 2019 at 05:38:01PM -0800, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit bd94c4077a0b2ecc35562c294f80f3659ecd8499
> Author: Masahiro Yamada <yamada.masahiro@socionext.com>
> Date:   Wed Oct 28 03:46:05 2015 +0000
> 
>     serial: support 16-bit register interface for console

That would be because that is when this function was added to the kernel
:)

Again, you are asking the kernel to write to a bad place in memory, and
then crash when that happens.  That sounds like the correct
functionality to me...

thanks,

greg k-h
