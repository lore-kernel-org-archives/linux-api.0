From: Oren Laadan <orenl-RdfvBDnrOixBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [v9][PATCH 8/9] Define clone3() syscall
Date: Sun, 25 Oct 2009 13:23:58 -0400
Message-ID: <4AE489AE.2090606@librato.com>
References: <20091025033508.GA20327@us.ibm.com> <20091025034023.GI20327@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091025034023.GI20327-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Andrew Morton <akpm-3NddpPZAyC0@public.gmane.org>, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org



Sukadev Bhattiprolu wrote:
> Subject: [v9][PATCH 8/9] Define clone3() syscall
> 
> Container restart requires that a task have the same pid it had when it was
> checkpointed. When containers are nested the tasks within the containers
> exist in multiple pid namespaces and hence have multiple pids to specify
> during restart.
> 
> clone3(), intended for use during restart, is the same as clone(), except
> that it takes a 'pids' paramter. This parameter lets caller choose
> specific pid numbers for the child process, in the process's active and
> ancestor pid namespaces. (Descendant pid namespaces in general don't matter
> since processes don't have pids in them anyway, but see comments in
> copy_target_pids() regarding CLONE_NEWPID).
> 
> Clone2() system call also attempts to address a second limitation of the
^^^^^^^^^^
s/Clone2/Clone3/

Acked-by: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
