From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Date: Tue, 13 Oct 2009 16:27:36 -0700
Message-ID: <20091013232736.GA24392@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com>
	<20091013205015.1ED524F7@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091013205015.1ED524F7-nL1rrgvulkc2UH6IwYuUx0EOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/containers>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Roland McGrath [roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org] wrote:
| Some userland debugging things and so forth like to look at the clone_flags
| argument, so that is kept simpler for them if it stays in a register
| (i.e. its own argument) rather than a user pointer fetch for that argument.
| Any problem with:
| 
| 	sys_clone3(unsigned long clone_flags,
| 		   struct clone_struct __user *cs, pid_t __user *pids)
| 
| ?

My only concern is the support of 64-bit clone flags on 32-bit architectures.
We would need an additional register/parameter, clone_flags_high ?  Also,
hopefully we won't need more than 64 flags, but if we do, the plan AFACIT,
was that we could use one of the reserved fields.

| 
| That also has the side benefit that instead of non-ia64 users forever
| asking, "Why is it clone3 when there is no clone2?" you can instead pretend
| that it follows the "clone3 because it takes three arguments" convention. ;-)
| 
| Btw, IMHO "struct foo_struct" is one of the lamest naming conventions ever.
| How about "struct clone_args"?

Sure :-) In earlier version of patches I had mixed up clone_struct and
clone_arg in comments/descriptions and cleaned up in this version. 
| 
| Also, if you were to replace:
| 
| 		u64 child_stack;
| 
| with:
| 
| 		u64 child_stack_base;
| 		u64 child_stack_size;
| 
| and use in sys_clone3 (for most arch's):
| 
| 	child_stack_ptr = kcs.child_stack_base + kcs.child_stack_size;
| 
| then the same clone3 interface would cover ia64 as well.

Ok

| 
| 
| Thanks,
| Roland
