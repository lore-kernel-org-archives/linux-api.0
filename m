From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] fs, proc: introduce CONFIG_PROC_CHILDREN
Date: Fri, 22 May 2015 18:37:05 +0300
Message-ID: <20150522153705.GI16716@uranus>
References: <20150521135703.22af370fdd0799101a6a1b91@linux-foundation.org>
 <1432298859-2059-1-git-send-email-iago@endocode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432298859-2059-1-git-send-email-iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Iago =?iso-8859-1?Q?L=F3pez?= Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, May 22, 2015 at 02:47:39PM +0200, Iago L=F3pez Galeiras wrote:
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1145,6 +1145,7 @@ endif # CGROUPS
> =20
>  config CHECKPOINT_RESTORE
>  	bool "Checkpoint/restore support" if EXPERT
> +	depends on PROC_CHILDREN
>  	default n
>  	help
>  	  Enables additional kernel features in a sake of checkpoint/restor=
e.

Maybe better select PROC_CHILDREN here? Also I must admit I don't under=
stand
why similar patch from Andy has not been merged earlier? Andy, there wa=
s
some problem I forgot about?

(to be clear, I don't mind enabling it since we use it in criu alot ;)
