From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v3 1/2] clone3: add CLONE_CLEAR_SIGHAND
Date: Mon, 21 Oct 2019 17:12:55 +0200
Message-ID: <20191021151255.GA3459@redhat.com>
References: <20191014104538.3096-1-christian.brauner@ubuntu.com>
 <20191021144633.GA2720@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191021144633.GA2720@redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, libc-alpha@sourceware.org, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Elena Reshetova <elena.reshetova@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Roman Gushchin <guro@fb.com>, Andrea Arcangeli <aarcange@redhat.com>Al Viro <v>
List-Id: linux-api@vger.kernel.org

On 10/21, Oleg Nesterov wrote:
>
> On 10/14, Christian Brauner wrote:
> >
> > The child helper process on Linux posix_spawn must ensure that no signa=
l
> > handlers are enabled, so the signal disposition must be either SIG_DFL
> > or SIG_IGN. However, it requires a sigprocmask to obtain the current
> > signal mask and at least _NSIG sigaction calls to reset the signal
> > handlers for each posix_spawn call
>
> Plus the caller has to block/unblock all signals around clone(VM|VFORK).
       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

just in case... I meant that posix_spawn() has to block/unblock, not its
caller.

> Can this justify the new CLONE_ flag? Honestly, I have no idea. But the
> patch is simple and looks technically correct to me. FWIW,
>=20
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
