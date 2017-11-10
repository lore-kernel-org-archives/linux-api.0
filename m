From: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC v3 6/7] proc: support new 'pids=all|ptraceable' mount
 option
Date: Fri, 10 Nov 2017 13:56:18 +1100 (AEDT)
Message-ID: <alpine.LFD.2.20.1711101356010.8844@localhost>
References: <1510244046-3256-1-git-send-email-tixxdz@gmail.com> <1510244046-3256-7-git-send-email-tixxdz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510244046-3256-7-git-send-email-tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, me-xzjC0nNlxno@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, bfields-uC3wQj2KruMpug/h7KTFAQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 9 Nov 2017, Djalal Harouni wrote:

> This patch introduces the new 'pids' mount option, as it was discussed
> and suggested by Andy Lutomirski [1].
> 
> * If 'pids=' is passed without 'newinstance' then it has no effect.
> 
> * If 'newinstance,pids=all' then all processes will be shown in proc.
> 
> * If 'newinstance,pids=ptraceable' then only ptraceable processes will be
> shown.
> 
> * 'pids=' takes precendence over 'hidepid=' since 'hidepid=' can be
>   ignored if "gid=" was set and caller has the "gid=" set in its groups.
>   We want to guarantee that LSM have a security path there that can not
>   be disabled with "gid=".
> 
> This allows to support lightweight sandboxes in Embedded Linux.
> 
> Later Yama LSM can be updated to check that processes are able only
> able to see their children inside /proc/, allowing to support more tight
> cases.
> 
> [1] https://lkml.org/lkml/2017/4/26/646
> 
> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> Suggested-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Alexey Gladkov <gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Reviewed-by: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>


-- 
James Morris
<james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
