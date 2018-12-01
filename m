From: =?ISO-8859-1?Q?J=FCrg?= Billeter <j@bitron.ch>
Subject: Re: [PATCH v2 1/1] prctl: add PR_{GET,SET}_KILL_DESCENDANTS_ON_EXIT
Date: Sat, 01 Dec 2018 10:39:28 +0000
Message-ID: <e92ab3c06fe42fc9872261999623be19e2b0a294.camel@bitron.ch>
References: <20181127225408.7553-2-j@bitron.ch>
         <20181130080004.23635-1-j@bitron.ch> <20181130080004.23635-2-j@bitron.ch>
         <87bm66u1j5.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87bm66u1j5.fsf@oldenburg.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 2018-11-30 at 14:40 +0100, Florian Weimer wrote:
> * Jürg Billeter:
> 
> > This introduces a new thread group flag that can be set by calling
> > 
> >     prctl(PR_SET_KILL_DESCENDANTS_ON_EXIT, 1, 0, 0, 0)
> > 
> > When a thread group exits with this flag set, it will send SIGKILL to
> > all descendant processes.  This can be used to prevent stray child
> > processes.
> > 
> > This flag is cleared on privilege gaining execve(2) to ensure an
> > unprivileged process cannot get a privileged process to send SIGKILL.
> 
> So this is inherited across regular execve?  I'm not sure that's a good
> idea.

Yes, this matches PR_SET_CHILD_SUBREAPER (and other process
attributes). Besides consistency and allowing a parent to configure the
flag for a spawned process, this is also needed to prevent a process
from clearing the flag (in combination with a seccomp filter).

> 
> > Descendants that are orphaned and reparented to an ancestor of the
> > current process before the current process exits, will not be killed.
> > PR_SET_CHILD_SUBREAPER can be used to contain orphaned processes.
> 
> For double- or triple-forking daemons, the reparenting will be racy, if
> I understand things correctly.

Can you please elaborate, if you're concerned about a particular race?
As the commit message mentions, for containment this flag can be
combined with PR_SET_CHILD_SUBREAPER (and PR_SET_NO_NEW_PRIVS).

Jürg
