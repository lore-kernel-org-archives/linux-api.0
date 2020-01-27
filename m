From: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v7 07/11] proc: flush task dcache entries from all procfs
 instances
Date: Tue, 28 Jan 2020 00:23:53 +0100
Message-ID: <20200127232352.s3mvvfkrta3i5h7w@comp-core-i7-2640m-0182e6>
References: <20200125130541.450409-1-gladkov.alexey@gmail.com>
 <20200125130541.450409-8-gladkov.alexey@gmail.com>
 <CAHk-=wiGNSQCA8TYa1Akp0_GRpe=ELKDPkDX5nzM5R=oDy1U+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wiGNSQCA8TYa1Akp0_GRpe=ELKDPkDX5nzM5R=oDy1U+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Security Module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Dmitry V . Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J . Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jan 25, 2020 at 10:45:25AM -0800, Linus Torvalds wrote:
> On Sat, Jan 25, 2020 at 5:06 AM Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > This allows to flush dcache entries of a task on multiple procfs mounts
> > per pid namespace.
> 
> From a quick read-through, this is the only one I really react negatively to.
> 
> The locking looks odd. It only seems to protect the new proc_mounts
> list, but then it's a whole big rwsem, and it's taken over all of
> proc_flush_task_mnt(), and the locking is exported to all over as a
> result of that - including the dummy functions for "there is no proc"
> case.
> 
> And proc_flush_task_mnt() itself should need no locking over any of
> it, so it's all just for the silly looping over the list.

Thank you, I will rework this part.

> So
> 
>  (a) this looks fishy and feels wrong - I get a very strong feeling
> that the locking is wrong to begin with, and could/should have been
> done differently
> 
>  (b) all the locking should have been internal to /proc, and those
> wrappers shouldn't exist in a common header file (and certainly not
> for the non-proc case).
> 
> Yes, (a) is just a feeling, and I don't have any great suggestions.
> Maybe make it an RCU list and use a spinlock for updating it?

I’m thinking, is it possible to get rid of proc_flush_task at all ?
Maybe we can try to flush dcache during readdir for example.

> But (b) is pretty much a non-starter in this form. Those wrappers
> shouldn't be in a globally exported core header file. No way.
> 
>                Linus
> 

-- 
Rgrds, legion
