From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [v12][PATCH 0/9] Implement eclone() syscall
Date: Thu, 19 Nov 2009 15:20:46 +0100
Message-ID: <200911191520.46445.arnd@arndb.de>
References: <20091111043440.GA9377@suka>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20091111043440.GA9377@suka>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/containers>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, matthltc-npbjlsIvGkV82hYKe6nXyg@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wednesday 11 November 2009, Sukadev Bhattiprolu wrote:
> Based on these requirements and constraints, we explored a couple of system
> call interfaces (in earlier versions of this patchset). Based on input from
> Arnd Bergmann and others, the new interface of the system call is: 
> 
>         struct clone_args {
>                 u64 clone_flags_high;
>                 u64 child_stack_base;
>                 u64 child_stack_size;
>                 u64 parent_tid_ptr;
>                 u64 child_tid_ptr;
>                 u32 nr_pids;
>                 u32 reserved0;
>                 u64 reserved1;
>         };
> 
>         sys_eclone(u32 flags_low, struct clone_args *cargs, int args_size,
>                         pid_t *pids)
 
Sorry if I'm beating a dead horse here, but having three methods for
possible extensions (flags, args_size and reserved fields) is going
a bit too far, as I think we've discussed a few times before.

The flags field seems necessary and the reserved fields are moderately
sensible if you don't have the args_size argument (a flag could still
express the same), but if you have args_size I see no point in reserving
space. I'd much prefer if you could get rid of the args_size, but if
other insist on keeping that, please loose the redundant reserved
fields at the end.

Alternatively, just keep my name out of it ;-)

	Arnd <><
