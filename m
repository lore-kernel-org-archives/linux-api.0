From: syzbot <syzbot+6491ea8f6dddbf04930e-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_ext_cleanup
Date: Sun, 19 Jan 2020 17:35:01 -0800
Message-ID: <000000000000c795fa059c884c21@google.com>
References: <000000000000bdb5b2059c865f5c@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000000000000bdb5b2059c865f5c-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: a@unstable.cc, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, allison-wcfNWazeolPR7s880joybQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, b.a.t.m.a.n-ZwoEplunGu2X36UT3dwllkB+6BGkLq7r@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org, coreteam-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, florent.fourcot-vJuzhzuFitlGWvitb5QawA@public.gmane.org, fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, hare-IBi9RG/b67k@public.gmane.org, heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, info-EcKl7qYKIbxeoWH0uzbU5w@public.gmane.org, jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jeremy-7nq0j9FNiFGsTnJN9+BGXg@public.gmane.org, johannes.berg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kadlec-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, mareklindner-rVWd3aGhH2z5bpWLKbzFeg@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, peterz@infradead.
List-Id: linux-api@vger.kernel.org

syzbot has bisected this bug to:

commit d68dbb0c9ac8b1ff52eb09aa58ce6358400fa939
Author: Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>
Date:   Thu Jun 20 23:26:35 2019 +0000

    arch: handle arches who do not yet define clone3

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1456fed1e00000
start commit:   09d4f10a net: sched: act_ctinfo: fix memory leak
git tree:       net
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1656fed1e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1256fed1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=6491ea8f6dddbf04930e
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141af959e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1067fa85e00000

Reported-by: syzbot+6491ea8f6dddbf04930e-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
Fixes: d68dbb0c9ac8 ("arch: handle arches who do not yet define clone3")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
