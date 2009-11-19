From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [v12][PATCH 0/9] Implement eclone() syscall
Date: Thu, 19 Nov 2009 15:56:44 -0800
Message-ID: <20091119235644.GA18720@us.ibm.com>
References: <20091111043440.GA9377@suka> <200911191520.46445.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <200911191520.46445.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>, Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, matthltc-npbjlsIvGkV82hYKe6nXyg@public.gmane.org, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Arnd Bergmann [arnd-r2nGTMty4D4@public.gmane.org] wrote:
| On Wednesday 11 November 2009, Sukadev Bhattiprolu wrote:
| > Based on these requirements and constraints, we explored a couple of system
| > call interfaces (in earlier versions of this patchset). Based on input from
| > Arnd Bergmann and others, the new interface of the system call is: 
| > 
| >         struct clone_args {
| >                 u64 clone_flags_high;
| >                 u64 child_stack_base;
| >                 u64 child_stack_size;
| >                 u64 parent_tid_ptr;
| >                 u64 child_tid_ptr;
| >                 u32 nr_pids;
| >                 u32 reserved0;
| >                 u64 reserved1;
| >         };
| > 
| >         sys_eclone(u32 flags_low, struct clone_args *cargs, int args_size,
| >                         pid_t *pids)
| 
| Sorry if I'm beating a dead horse here, but having three methods for
| possible extensions (flags, args_size and reserved fields) is going
| a bit too far, as I think we've discussed a few times before.

Based on earlier discussions, it looked like using 'flags' to extend
the number of arguments or size of clone_args was not clean. But I 
agree with your point on the redundancy.

How about dropping ->reserved1 and leaving the 'u32 reserved0' so the
structure size is same on all architectures ?

Sukadev
