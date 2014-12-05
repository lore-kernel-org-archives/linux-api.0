From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Subject: Re: [PATCH v6 4/7] fs/fuse: support compiling out splice
Date: Fri, 5 Dec 2014 11:44:36 +0100
Message-ID: <CAJfpegu+NQQ_+af=6UXi2=fyTJK1CsQBZ2++Nysu4mume4UEOQ@mail.gmail.com>
References: <1417715473-24110-1-git-send-email-pieter@boesman.nl>
	<1417715473-24110-5-git-send-email-pieter@boesman.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417715473-24110-5-git-send-email-pieter-qeJ+1H9vRZbz+pZb47iToQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pieter Smith <pieter-qeJ+1H9vRZbz+pZb47iToQ@public.gmane.org>
Cc: Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:FUSE: FILESYSTEM..." <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Dec 4, 2014 at 6:50 PM, Pieter Smith <pieter-qeJ+1H9vRZbz+pZb47iToQ@public.gmane.org> wrote:
> To implement splice support, fs/fuse makes use of nosteal_pipe_buf_ops. This
> struct is exported by fs/splice. The goal of the larger patch set is to
> completely compile out fs/splice, so uses of the exported struct need to be
> compiled out along with fs/splice.
>
> This patch therefore compiles out splice support in fs/fuse when
> CONFIG_SYSCALL_SPLICE is undefined.
>
> Signed-off-by: Pieter Smith <pieter-qeJ+1H9vRZbz+pZb47iToQ@public.gmane.org>


In the future could you PLEASE PLEASE cut the fuse-devel Cc from the
non-fuse specific patches (and I guess that goes for any other
subsystem specific lists and persons as well)?

Otherwise:

Acked-by: Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>

Thanks,
Miklos
