From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: KASAN: slab-out-of-bounds Read in bitmap_ip_ext_cleanup
Date: Mon, 20 Jan 2020 20:46:15 +0300
Message-ID: <20200120174615.GE21151@kadam>
References: <000000000000bdb5b2059c865f5c@google.com>
 <000000000000c795fa059c884c21@google.com>
 <20200120131930.pbhbsrm4bk4lq3d7@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane-mx.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20200120131930.pbhbsrm4bk4lq3d7@wittgenstein>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane-mx.org@lists.infradead.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: mareklindner@neomailbox.ch, peterz@infradead.org, catalin.marinas@arm.com, a@unstable.cc, jcmvbkbc@gmail.com, syzbot <syzbot+6491ea8f6dddbf04930e@syzkaller.appspotmail.com>, hpa@zytor.com, will@kernel.org, elena.reshetova@intel.com, hare@suse.com, johannes.berg@intel.com, florent.fourcot@wifirst.fr, x86@kernel.org, linux@armlinux.org.uk, kadlec@netfilter.org, coreteam@netfilter.org, geert@linux-m68k.org, allison@lohutok.net, pablo@netfilter.org, linux-arm-kernel@lists.infradead.org, linux-xtensa@linux-xtensa.org, arnd@arndb.de, heiko.carstens@de.ibm.com, syzkaller-bugs@googlegroups.com, bp@alien8.de, viro@zeniv.linux.org.uk, tglx@linutronix.de, mingo@redhat.com, christian@brauner.io, axboe@kernel.dk, chris@zankel.net, jeremy@azazel.net, sw@simonwunderlich.de, linux-api@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org, fw@strlen.de, linux-kernel@vger.kernel.orgnetfilter
List-Id: linux-api@vger.kernel.org

On Mon, Jan 20, 2020 at 02:19:31PM +0100, Christian Brauner wrote:
> On Sun, Jan 19, 2020 at 05:35:01PM -0800, syzbot wrote:
> > syzbot has bisected this bug to:
> > =

> > commit d68dbb0c9ac8b1ff52eb09aa58ce6358400fa939
> > Author: Christian Brauner <christian@brauner.io>
> > Date:   Thu Jun 20 23:26:35 2019 +0000
> > =

> >     arch: handle arches who do not yet define clone3
> > =

> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D1456fed1=
e00000
> > start commit:   09d4f10a net: sched: act_ctinfo: fix memory leak
> > git tree:       net
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=3D1656fed1=
e00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1256fed1e00=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D7e89bd00623=
fe71e
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3D6491ea8f6dddb=
f04930e
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D141af959e=
00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1067fa85e00=
000
> > =

> > Reported-by: syzbot+6491ea8f6dddbf04930e@syzkaller.appspotmail.com
> > Fixes: d68dbb0c9ac8 ("arch: handle arches who do not yet define clone3")
> > =

> > For information about bisection process see: https://goo.gl/tpsmEJ#bise=
ction
> =

> This bisect seems bogus.
> =


Yeah.  J=F3zsef Kadlecsik already fixed the bug in a different thread.  It
was reported as seven different bugs so there was a bunch of threads for
it.

regards,
dan carpenter
