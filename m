From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 2/5] clone: add CLONE_PIDFD
Date: Thu, 18 Apr 2019 16:10:20 +0200
Message-ID: <20190418141019.GD13701@redhat.com>
References: <20190418101841.4476-1-christian@brauner.io>
 <20190418101841.4476-3-christian@brauner.io>
 <20190418131206.GB13701@redhat.com>
 <20190418132822.untjt7erfvbbiz7a@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190418132822.untjt7erfvbbiz7a@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, jannh@google.com, dhowells@redhat.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, serge@hallyn.com, luto@kernel.org, arnd@arndb.de, ebiederm@xmission.com, keescook@chromium.org, tglx@linutronix.de, mtk.manpages@gmail.com, akpm@linux-foundation.org, cyphar@cyphar.com, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On 04/18, Christian Brauner wrote:
>
> On Thu, Apr 18, 2019 at 03:12:07PM +0200, Oleg Nesterov wrote:
> > Should we allow CLONE_THREAD | CLONE_PIDFD ?
>
> I think so, yes. I have thought about this.

OK, I won't insist. But let me explain why did I ask.

> Yes, due to CLONE_FILES |
> CLONE_VM you'd necessarily hand the pidfd to the child but threads are
> no security boundary in the first place.

No, no, I am not not worried about security. CLONE_PARENT | CLONE_PIDFD
looks more problematic to me, but I see nothing dangerous security-wise..

I agree that CLONE_THREAD | CLONE_PIDFD may be usefule, but I am not sure
we should allow this from the very begining, until we have a "real" use-case.

IIUC, we are going to make it pollable soon. OK, but proc_tgid_base_poll()
(which should be turned into pidfd_poll) simply can't work if pid_task() is
not a group leader. poll(pidfd) will hang forever if pidfd was created by
CLONE_THREAD | CLONE_PIDFD.

Sure, we can (should?) improve pidfd_poll() but this will need more nasty
changes in the core kernel code. Do we really need/want this? Right now it
is not clear to me. Instead, we can simply disallow CLONE_THREAD|CLONE_PIDFD
until we decide that yes, we want to poll sub-threads.

But again, I am fine with CLONE_THREAD | CLONE_PIDFD.

Oleg.
