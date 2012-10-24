From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC PATCH v8 0/5] IPC: checkpoint/restore in userspace
 enhancements
Date: Wed, 24 Oct 2012 14:42:30 -0700
Message-ID: <20121024144230.a932f2e9.akpm@linux-foundation.org>
References: <20121024151555.5642.79086.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121024151555.5642.79086.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org, joe.korty-oXJCJecloQs@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 24 Oct 2012 19:34:51 +0400
Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:

> This respin of the patch set was significantly reworked. Most part of new API
> was replaced by sysctls (by one per messages, semaphores and shared memory),
> allowing to preset desired id for next new IPC object.
> 
> This patch set is aimed to provide additional functionality for all IPC
> objects, which is required for migration of these objects by user-space
> checkpoint/restore utils (CRIU).
> 
> The main problem here was impossibility to set up object id. This patch set
> solves the problem by adding new sysctls for preset of desired id for new IPC
> object.
> 
> Another problem was to peek messages from queues without deleting them.
> This was achived by introducing of new MSG_COPY flag for sys_msgrcv(). If
> MSG_COPY flag is set, then msgtyp is interpreted as message number.

OK, thanks, I grabbed these.  They're not the worst c/r patches I've
ever seen ;)

I'm not seeing any evidence that anyone else has reviewed or tested
these?
