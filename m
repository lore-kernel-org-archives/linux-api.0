From: syzbot <syzbot+92f32d4e21fb246d31a2@syzkaller.appspotmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference in mem16_serial_out
Date: Mon, 09 Dec 2019 17:38:01 -0800
Message-ID: <00000000000003cc8505994f9036@google.com>
References: <00000000000044a65205994a7e13@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000044a65205994a7e13@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, asierra@xes-inc.com, corbet@lwn.net, ext-kimmo.rautkoski@vaisala.com, gregkh@linuxfoundation.org, jslaby@suse.com, kai.heng.feng@canonical.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, mika.westerberg@linux.intel.com, paulburton@kernel.org, peter@hurleysoftware.com, sr@denx.de, syzkaller-bugs@googlegroups.com, yamada.masahiro@socionext.com, yegorslists@googlemail.com
List-Id: linux-api@vger.kernel.org

syzbot has bisected this bug to:

commit bd94c4077a0b2ecc35562c294f80f3659ecd8499
Author: Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Wed Oct 28 03:46:05 2015 +0000

     serial: support 16-bit register interface for console

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13723196e00000
start commit:   e42617b8 Linux 5.5-rc1
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=10f23196e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=17723196e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3754e2c78c1adb82
dashboard link: https://syzkaller.appspot.com/bug?extid=92f32d4e21fb246d31a2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=136f7e41e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112b7c82e00000

Reported-by: syzbot+92f32d4e21fb246d31a2@syzkaller.appspotmail.com
Fixes: bd94c4077a0b ("serial: support 16-bit register interface for  
console")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
