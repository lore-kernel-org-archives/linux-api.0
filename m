From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 2/3] kcmp: Add KCMP_EPOLL_TFD mode to compare epoll
 target files
Date: Mon, 13 Mar 2017 21:37:58 +0300
Message-ID: <20170313183758.GE6743@uranus.lan>
References: <20170310082146.103151106@openvz.org>
 <20170313173723.GA2855@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170313173723.GA2855-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kir-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 13, 2017 at 10:37:24AM -0700, Andrei Vagin wrote:
> 
> Here is one question inline.
> 
> Acked-by: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Thanks!

> > +
> > +	files = get_files_struct(task2);
> > +	if (!files)
> > +		return -EBADF;
> > +
> > +	spin_lock(&files->file_lock);
> > +	filp_epoll = fcheck_files(files, slot.efd);
> > +	if (filp_epoll)
> > +		get_file(filp_epoll);
> > +	else
> > +		filp_tgt = ERR_PTR(-EBADF);
> > +	spin_unlock(&files->file_lock);
> > +	put_files_struct(files);
> 
> Why can we not use fget here ^^^^ ?

Because it's not @current's file table but foreigner process.
So we make sure there is no expand_fdtable in progress and
we test for file descriptor which is being freed.
