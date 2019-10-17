From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 1/5] pidfd: verify task is alive when printing fdinfo
Date: Thu, 17 Oct 2019 10:54:14 +0200
Message-ID: <20191017085414.GC17513@redhat.com>
References: <20191015141332.4055-1-christian.brauner@ubuntu.com>
 <20191016153606.2326-1-christian.brauner@ubuntu.com>
 <20191016162408.GB31585@redhat.com>
 <20191016163107.5zwt6fmjyd5mkqqw@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191016163107.5zwt6fmjyd5mkqqw@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, akpm@linux-foundation.org, christian@kellner.me, cyphar@cyphar.com, elena.reshetova@intel.com, guro@fb.com, jannh@google.com, ldv@altlinux.org, linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org, mhocko@suse.com, mingo@kernel.org, peterz@infradead.org, shuah@kernel.org, tglx@linutronix.de, viro@zeniv.linux.org.uk
List-Id: linux-api@vger.kernel.org

On 10/16, Christian Brauner wrote:
>
> On Wed, Oct 16, 2019 at 06:24:09PM +0200, Oleg Nesterov wrote:
> >
> > And why task_ if it accepts pid+pid_type? May be pid_has_task() or
> > something like this...
>
> Given what I said above that might be a decent name.
>
> >
> > OK, since I can't suggest a better name I won't really argue. Feel free
> > to add my reviewed-by to this series.
>
> No, naming is important. Thanks for being picky about that too and I'll
> happily resend. :)

Thanks ;) May be pid_in_use() ? Up to you, anything which starts with pid_
looks better to me than task_alive().

Oleg.
