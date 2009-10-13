From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 7/10]: Check invalid clone flags
Date: Tue, 13 Oct 2009 16:38:50 -0700
Message-ID: <20091013233850.GB24392@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com>
	<20091013045234.GG28435@us.ibm.com> <4AD4C88D.7040008@librato.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AD4C88D.7040008-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/containers>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Cc: randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Oren Laadan [orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org] wrote:
| 
| 
| Sukadev Bhattiprolu wrote:
| > 
| > Subject: [RFC][v8][PATCH 7/10]: Check invalid clone flags
| > 
| > As pointed out by Oren Laadan, we want to ensure that unused bits in the
| > clone-flags remain unused and available for future. To ensure this, define
| > a mask of clone-flags and check the flags in the clone() system calls.
| > 
| > Changelog[v8]:
| > 	- New patch in set
| > 
| > Signed-off-by: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
| > 
| > ---
| >  include/linux/sched.h |   10 ++++++++++
| >  kernel/fork.c         |    3 +++
| >  2 files changed, 13 insertions(+)
| > 
| > Index: linux-2.6/include/linux/sched.h
| > ===================================================================
| > --- linux-2.6.orig/include/linux/sched.h	2009-10-02 18:53:55.000000000 -0700
| > +++ linux-2.6/include/linux/sched.h	2009-10-02 19:58:21.000000000 -0700
| > @@ -29,6 +29,16 @@
| >  #define CLONE_NEWNET		0x40000000	/* New network namespace */
| >  #define CLONE_IO		0x80000000	/* Clone io context */
| >  
| > +#define VALID_CLONE_FLAGS	(CSIGNAL | CLONE_VM | CLONE_FS | CLONE_FILES |\
| > +				 CLONE_SIGHAND | CLONE_PTRACE | CLONE_VFORK  |\
| > +				 CLONE_PARENT | CLONE_THREAD | CLONE_NEWNS   |\
| > +				 CLONE_SYSVSEM | CLONE_SETTLS                |\
| > +				 CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID  |\
| > +				 CLONE_DETACHED | CLONE_UNTRACED             |\
| > +				 CLONE_CHILD_SETTID | CLONE_STOPPED          |\
| > +				 CLONE_NEWUTS | CLONE_NEWIPC | CLONE_NEWUSER |\
| > +				 CLONE_NEWPID | CLONE_NEWNET| CLONE_IO)
| > +
| >  /*
| >   * Scheduling policies
| >   */
| > Index: linux-2.6/kernel/fork.c
| > ===================================================================
| > --- linux-2.6.orig/kernel/fork.c	2009-10-02 19:00:08.000000000 -0700
| > +++ linux-2.6/kernel/fork.c	2009-10-02 19:57:36.000000000 -0700
| > @@ -942,6 +942,9 @@ static struct task_struct *copy_process(
| >  	struct task_struct *p;
| >  	int cgroup_callbacks_done = 0;
| >  
| 
| We can safely apply these tests to clone3(), because it is a new syscall.
| 
| However, I don't know if applying it to clone() can break existing
| application that may already be (incorrectly) using invalid flags ?

Doing the check in copy_process() seems would apply to all architectures.

As for breaking an existing app, there is only one unused flag, 0x00001000
(bw CLONE_SIGHAND and CLONE_PTRACE). If an application could be using that
and we don't want to break it, maybe we can add following macro to the
VALID_CLONE_FLAGS list ?

	#define CLONE_UNUSED_BIT	0x00001000
