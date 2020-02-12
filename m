From: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8 03/11] proc: move /proc/{self|thread-self} dentries to
 proc_fs_info
Date: Wed, 12 Feb 2020 16:00:38 +0100
Message-ID: <20200212150038.rr364l5kjcgbmr3g@comp-core-i7-2640m-0182e6>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
 <20200210150519.538333-4-gladkov.alexey@gmail.com>
 <CALCETrWGpRr86tVKJU-sEMcg+x0Yzp+TbiBhrAc71RaO8=DYGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWGpRr86tVKJU-sEMcg+x0Yzp+TbiBhrAc71RaO8=DYGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Security Module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Dmitry V . Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J . Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 10, 2020 at 10:23:23AM -0800, Andy Lutomirski wrote:
> On Mon, Feb 10, 2020 at 7:06 AM Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > This is a preparation patch that moves /proc/{self|thread-self} dentries
> > to be stored inside procfs fs_info struct instead of making them per pid
> > namespace. Since we want to support multiple procfs instances we need to
> > make sure that these dentries are also per-superblock instead of
> > per-pidns,
> 
> The changelog makes perfect sense so far...
> 
> > unmounting a private procfs won't clash with other procfs
> > mounts.
> 
> This doesn't parse as part of the previous sentence.  I'm also not
> convinced that this really involves unmounting per se.  Maybe just
> delete these words.

Sure. I will remove this part.

-- 
Rgrds, legion
