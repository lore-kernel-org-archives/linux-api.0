From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/2] fs: Support compiling out sendfile
Date: Tue, 21 Oct 2014 00:51:54 -0700
Message-ID: <20141021075154.GB10020@infradead.org>
References: <1413841728-1313-1-git-send-email-pieter@boesman.nl>
 <1413841728-1313-2-git-send-email-pieter@boesman.nl>
 <20141020222421.GE8929@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141020222421.GE8929@cloud>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Cc: Pieter Smith <pieter-qeJ+1H9vRZbz+pZb47iToQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Turner <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, ????????? <zhenglong.cai-TJRtMXcVgQTM1kAEIRd3EQ@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>, Peter Foley <pefoley2-lY0TAiDIAFlBDgjK7y7TUQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 20, 2014 at 03:24:22PM -0700, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org wrote:
> On Mon, Oct 20, 2014 at 11:48:37PM +0200, Pieter Smith wrote:
> > Many embedded systems will not need this syscall, and omitting it
> > saves space.  Add a new EXPERT config option CONFIG_SENDFILE_SYSCALL
> > (default y) to support compiling it out.
> 
> Nice work, thanks!
> 
> If there are no objections, and nobody has a tree they'd rather carry
> this through, I'll take the series through the tiny tree when it's ready
> to merge.

I think it's rather pointless - there is very little sendfile code,
so you'd rather want to disable splice.
