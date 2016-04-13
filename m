From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] vfs: Define new syscall getumask.
Date: Wed, 13 Apr 2016 15:40:34 +0300
Message-ID: <20160413124034.GI2000@uranus.lan>
References: <1460547786-16766-1-git-send-email-rjones@redhat.com>
 <1460547786-16766-2-git-send-email-rjones@redhat.com>
 <87inzlg0mo.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87inzlg0mo.fsf-ZqZwdwZz9NfTBotR3TxKnbNAH6kLmebB@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>, "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 13, 2016 at 02:21:35PM +0200, Florian Weimer wrote:
> * Richard W. M. Jones:
> 
> > +SYSCALL_DEFINE0(getumask)
> > +{
> > +	return current->fs->umask;
> > +}
> 
> The convention seems to be to call current_umask(), instead of
> inlining its contents.

Yes, please use existing.
