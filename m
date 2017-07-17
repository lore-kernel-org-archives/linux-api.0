From: Michael Cree <mcree@orcon.net.nz>
Subject: Re: [PATCH 1/8] signal/alpha: Document a conflict with SI_USER for
 SIGTRAP
Date: Mon, 17 Jul 2017 20:14:38 +1200
Message-ID: <20170717081438.rdbwspz25bn6oz7h@tower>
References: <87efu22set.fsf@xmission.com>
 <20170630123906.8865-1-ebiederm@xmission.com>
 <20170702141320.GA32254@ls3530.fritz.box>
 <87fudz5lol.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87fudz5lol.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Helge Deller <deller@gmx.de>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>, Andrei Vagin <avagin@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>, Andrey Vagin <avagin@openvz.org>, Serge Hallyn <serge@hallyn.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Peter Zijlstra <peterz@infradead.org>, Willy Tarreau <w@1wt.eu>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Richard Henderson <rth@twiddle.net>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 14, 2017 at 05:59:06AM -0500, Eric W. Biederman wrote:
> in which cases the oddities will happen let alone test them.  Plus at
> least for ia64 and alpha those architectures don't appear to be
> receiving updates for new syscalls, and no new hardware is being built
> so I don't know how much longer they will last.
> 
> That is building for alpha gives:
> >   CALL    /home/eric/projects/linux/linux-exit-cleanups/scripts/checksyscalls.sh
> > <stdin>:1239:2: warning: #warning syscall seccomp not implemented [-Wcpp]
> > <stdin>:1248:2: warning: #warning syscall bpf not implemented [-Wcpp]
> > <stdin>:1299:2: warning: #warning syscall userfaultfd not implemented [-Wcpp]
> > <stdin>:1302:2: warning: #warning syscall membarrier not implemented [-Wcpp]
> > <stdin>:1305:2: warning: #warning syscall mlock2 not implemented [-Wcpp]
> > <stdin>:1308:2: warning: #warning syscall copy_file_range not implemented [-Wcpp]
> > <stdin>:1311:2: warning: #warning syscall preadv2 not implemented [-Wcpp]
> > <stdin>:1314:2: warning: #warning syscall pwritev2 not implemented [-Wcpp]
> > <stdin>:1317:2: warning: #warning syscall pkey_mprotect not implemented [-Wcpp]
> > <stdin>:1320:2: warning: #warning syscall pkey_alloc not implemented [-Wcpp]
> > <stdin>:1323:2: warning: #warning syscall pkey_free not implemented [-Wcpp]
> > <stdin>:1326:2: warning: #warning syscall statx not implemented [-Wcpp]

Patches to wire up most of those syscalls on Alpha was posted recently
along with others to fix module loading, etc., but unfortunately they
do not appear to have been applied during the merge window...

Cheers,
Michael.
