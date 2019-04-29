From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v1 1/2] Add polling support to pidfd
Date: Mon, 29 Apr 2019 16:25:55 +0200
Message-ID: <20190429142555.GB17715@redhat.com>
References: <20190425190010.46489-1-joel@joelfernandes.org>
 <20190425222359.sqhboc4x4daznr6r@brauner.io>
 <20190428162405.GA6757@redhat.com>
 <20190429140245.GB233442@google.com>
 <20190429140743.GB173743@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190429140743.GB173743@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Christian Brauner <christian@brauner.io>, linux-kernel@vger.kernel.org, luto@amacapital.net, rostedt@goodmis.org, dancol@google.com, sspatil@google.com, jannh@google.com, surenb@google.com, timmurray@google.com, Jonathan Kowalski <bl0pbl33p@gmail.com>, torvalds@linux-foundation.org, kernel-team@android.com, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Jann Horn <jann@thejh.net>, linux-kselftest@vger.kernel.org, Michal Hocko <mhocko@suse.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Serge Hallyn <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Thomas Gleixner <tgl>
List-Id: linux-api@vger.kernel.org

On 04/29, Joel Fernandes wrote:
>
> On Mon, Apr 29, 2019 at 10:02:45AM -0400, Joel Fernandes wrote:
> > On Sun, Apr 28, 2019 at 06:24:06PM +0200, Oleg Nesterov wrote:
> [snip]
> > > > > +{
> > > > > +	struct pid *pid;
> > > > > +
> > > > > +	lockdep_assert_held(&tasklist_lock);
> > > > > +
> > > > > +	pid = get_task_pid(task, PIDTYPE_PID);
> > > > > +	wake_up_all(&pid->wait_pidfd);
> > > > > +	put_pid(pid);
> > >
> > > Why get/put?
> >
> > Yes, pid_task() should do it. Will update it. Thanks!
>
> I spoke too soon. We need the task's pid of type PIDTYPE_PID. How else can we
> get it? This does an atomic_inc on the pid->count, so we need to put_pid()
> after we are done with it. Did I miss something?

Just use task_pid(task);

Oleg.
