From: Thiago Macieira <thiago.macieira@intel.com>
Subject: Re: [PATCH 6/6] clone4: Introduce new CLONE_FD flag to get task exit notification via fd
Date: Sat, 14 Mar 2015 15:26:05 -0700
Message-ID: <2340007.MPGOIEd6Rm@tjmaciei-mobl4>
References: <cover.1426180120.git.josh@joshtriplett.org> <20150314185424.GA6813@redhat.com> <20150314220307.GI22130@thin>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150314220307.GI22130@thin>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Saturday 14 March 2015 15:03:08 Josh Triplett wrote:
> I had to think about this for a while, but I think it makes sense now.
> wait should *not* ever return the PID of an autoreaped process, because
> that would introduce a race condition (the caller cannot safely do
> *anything* with the PID of an autoreaped process, since by the time it
> does, the process may be gone and the PID may be reused).  However, that
> doesn't mean wait cannot block on the process, and then subsequently
> wake up and return -ECHILD (or keep waiting on some other child process
> if there is one).  That's apparently the semantic used with SA_NOCLDWAIT
> or if you have SIGCHLD set to SIG_IGN, and matching that seems
> appropriate.
> 
> Thiago, could your QProcess implementation handle that modified autoreap
> semantic?  The downside there is that if your calling process has a
> process-wide loop that waits for all processes (and explicitly passes
> the Linux-specific __WCLONE or __WALL flag, since your processes
> launched with a 0 signal would count as "clone" children), they'd get
> back the processes you launch, too.  (That would happen with your
> userspace-emulated version too for calls *without* __WCLONE or __WALL.)
> You'd still get the exit status you need via the clonefd, without a
> race, and you wouldn't need to touch process-wide signal handling, so I
> think this should still work and avoid any races.

I don't see why QProcess would have a problem. We don't have such a process-
wide wait loop with __WCLONE or __WALL and I can't think of any reason why 
someone would do that and still expect NPTL to work. Or, put another way, if 
they are using clone/clone4 directly and bypassing NPTL, they're probably in a 
very specialised process that has no business running QProcess in the first 
place. I wouldn't be too worried.

Inside glibc itself, __WCLONE is used only in unit tests and __WALL is used in 
a loop in elf/pldd.c, which is an independent application. Bionic has __WCLONE 
in tests only too.

-- 
Thiago Macieira - thiago.macieira (AT) intel.com
  Software Architect - Intel Open Source Technology Center
