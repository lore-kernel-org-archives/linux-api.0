From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 10/10]: Document clone3() syscall
Date: Wed, 14 Oct 2009 11:39:16 -0700
Message-ID: <20091014183916.GA3515@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com>
	<20091013045556.GJ28435@us.ibm.com>
	<200910141426.35338.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <200910141426.35338.arnd-r2nGTMty4D4@public.gmane.org>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/containers>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Arnd Bergmann <arndbergmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Cc: randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Arnd Bergmann [arndbergmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org] wrote:
| On Tuesday 13 October 2009, Sukadev Bhattiprolu wrote:
| > +clone3(struct clone_struct * __user clone_args, pid_t * __user pids)
| > +
| > +       In addition to doing everything that clone() system call does,
| > +       the clone3() system call:
| > +
| > +               - allows additional clone flags (all 32 bits in the flags
| > +                 parameter to clone() are in use)
| > +
| > +               - allows user to specify a pid for the child process in its
| > +                 active and ancestor pid name spaces.
| 
| Someone (sorry, can't find the old mail) pointed out last time that
| the 'pid_t *__user tidptr' argument needs to be an independent pointer,
| in order to allow the same use patterns with CLONE_CHILD_SETTID and
| CLONE_CHILD_CLEARTID that you can do with the current clone
| implementation.

I think it was Oren Laadan.

| 
| Moving that argument from clone_struct into the argument list would
| also make this a three-argument syscall, which solves the naming problem.

How about we pull 'nr_pids' out of clone_args struct and make that
a separate parameter. It seems the odd man out and controls the pid_t
list parameter.
| 
| 	Arnd <><
