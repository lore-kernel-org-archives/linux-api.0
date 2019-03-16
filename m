From: syzbot <syzbot+2c49971e251e36216d1f@syzkaller.appspotmail.com>
Subject: Re: WARNING: bad usercopy in fanotify_read
Date: Sat, 16 Mar 2019 07:49:01 -0700
Message-ID: <0000000000008f302105843741ad@google.com>
References: <00000000000016f7d40583d79bd9@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000016f7d40583d79bd9@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, amir73il@gmail.com, cai@lca.pw, crecklin@redhat.com, jack@suse.cz, keescook@chromium.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
List-Id: linux-api@vger.kernel.org

syzbot has bisected this bug to:

commit a8b13aa20afb69161b5123b4f1acc7ea0a03d360
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Thu Jan 10 17:04:36 2019 +0000

     fanotify: enable FAN_REPORT_FID init flag

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11e78d6f200000
start commit:   a8b13aa2 fanotify: enable FAN_REPORT_FID init flag
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=13e78d6f200000
console output: https://syzkaller.appspot.com/x/log.txt?x=15e78d6f200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e9d91b7192a5e96e
dashboard link: https://syzkaller.appspot.com/bug?extid=2c49971e251e36216d1f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1287516f200000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ee410b200000

Reported-by: syzbot+2c49971e251e36216d1f@syzkaller.appspotmail.com
Fixes: a8b13aa2 ("fanotify: enable FAN_REPORT_FID init flag")
