From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [PATCH v4 10/79] via_drm.h: move struct via_file_private
 definition to drivers/gpu/drm/via/via_drv.h
Date: Wed, 21 Oct 2015 17:33:23 +0200
Message-ID: <20151021153323.GF16848@phenom.ffwll.local>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-11-git-send-email-mikko.rapeli@iki.fi>
 <CACvgo515FB4MSTWdR0dQdvNccYhMMhBD1bgL=heMLfrw7iqdmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACvgo515FB4MSTWdR0dQdvNccYhMMhBD1bgL=heMLfrw7iqdmA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ML dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 21, 2015 at 03:36:22PM +0100, Emil Velikov wrote:
> On 15 October 2015 at 06:55, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wrote:
> > Fixes userspace compile error since list_head is not exported to userspace
> > headers.
> >
> > Suggested by Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> at
> > https://lkml.org/lkml/2015/6/3/792
> >
> > Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> We're safe as the only users of the struct already include via_drv.h.
> 
> Reviewed-by: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Daniel can you pick this up (esp. since you added it with commit
> c828e20456301b0f5192a1f75e8bf8a6afd15551)

Dave already applied it.
-Daniel

> 
> Thanks
> Emil

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
