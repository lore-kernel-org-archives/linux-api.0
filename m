From: Thiago Macieira <thiago.macieira@intel.com>
Subject: Re: [PATCH v2 0/7] CLONE_FD: Task exit notification via file descriptor
Date: Fri, 29 May 2015 13:27:13 -0700
Message-ID: <1775865.3maNSqUW4u@tjmaciei-mobl4>
References: <cover.1426376419.git.josh@joshtriplett.org> <556818A7.3030804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <556818A7.3030804@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Friday 29 May 2015 09:43:35 Florian Weimer wrote:
> On 03/15/2015 08:59 AM, Josh Triplett wrote:
> > This patch series introduces a new clone flag, CLONE_FD, which lets the
> > caller receive child process exit notification via a file descriptor
> > rather than SIGCHLD.  CLONE_FD makes it possible for libraries to safely
> > launch and manage child processes on behalf of their caller, *without*
> > taking over process-wide SIGCHLD handling (either via signal handler or
> > signalfd).
> > 
> > Note that signalfd for SIGCHLD does not suffice here, because that still
> > receives notification for all child processes, and interferes with
> > process-wide signal handling.
> 
> It has been suggested (e.g.,
> <https://sourceware.org/bugzilla/show_bug.cgi?id=15661#c3>) that you can
> use the existing clone(2) without specifying SIGCHLD to create a new
> process.  The resulting child process is not supposed to show up in
> wait(2), only in a waitpid(2) (or similar) explicitly specifying the
> PID.  Is this not the case?

Hi Florian

That sounds orthogonal to what we're looking for. Our objective is to get 
notification of when the child exited without resorting to SIGCHLD. If we use 
the regular clone(2) without SIGCHLD and without CLONE_FD, we get no 
notification. The only way to know of the child's termination is by a blocking 
waitpid(2), like you indicated, which is counter productive to our needs.

We need something we can select(2)/poll(2) on.
-- 
Thiago Macieira - thiago.macieira (AT) intel.com
  Software Architect - Intel Open Source Technology Center

