From: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [fuse-devel] [PATCH v4] fuse: Add support for passthrough read/write
Date: Mon, 25 Jan 2016 12:49:00 -0800
Message-ID: <56A68A3C.601@codeaurora.org>
References: <56A0235E.8090205@codeaurora.org> <CA+6x0LUrBHPf7YyNgwoY4c3fxACBpspycM45Tj=XWQ6oKsRK-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+6x0LUrBHPf7YyNgwoY4c3fxACBpspycM45Tj=XWQ6oKsRK-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Shal <marfey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org>, sven.utcke-Mmb7MZpHnFY@public.gmane.org, Nikolaus Rath <nikolaus-BTH8mxji4b0@public.gmane.org>, Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri 22 Jan 2016 03:04:36 PM PST, Mike Shal wrote:
> On Wed, Jan 20, 2016 at 7:16 PM, Nikhilesh Reddy
> <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org <mailto:reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>> wrote:
>
>     diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>     @@ -569,6 +570,8 @@ ssize_t fuse_simple_request(struct fuse_conn
>     *fc, struct fuse_args *args)
>             if (!ret && args->out.argvar) {
>                     BUG_ON(args->out.numargs != 1);
>                     ret = req->out.args[0].size;
>     +               if (req->passthrough_filp != NULL)
>     +                       args->out.passthrough_filp =
>     req->passthrough_filp;
>             }
>             fuse_put_request(fc, req);
>
>
> Is it correct to only set passthrough_filp when args->out.argvar is
> set here? I tried to test your patch, but I'm still seeing read &
> write requests to my FUSE filesystem after setting the passthrough
> bit. As far as I can tell, args->out.argvar is only set in a few cases
> (like fuse_follow_link()) but not where you're using it in
> fuse_create_open() or fuse_send_open(). I changed the logic to this:
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 5cc5385..543c250 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -567,11 +567,14 @@ ssize_t fuse_simple_request(struct fuse_conn
> *fc, struct fuse_args *args)
>                args->out.numargs * sizeof(struct fuse_arg));
>         fuse_request_send(fc, req);
>         ret = req->out.h.error;
> +       if (!ret) {
> +               if (req->passthrough_filp != NULL) {
> +                       args->out.passthrough_filp =
> req->passthrough_filp;
> +               }
> +       }
>         if (!ret && args->out.argvar) {
>                 BUG_ON(args->out.numargs != 1);
>                 ret = req->out.args[0].size;
> -               if (req->passthrough_filp != NULL)
> -                       args->out.passthrough_filp =
> req->passthrough_filp;
>         }
>         fuse_put_request(fc, req);
>
> And then it worked as expected. The only read() calls I see in my FUSE
> filesystem after this change are from mmaped files, but it sounds like
> you're already working on that. The performance is much improved for
> large reads & writes, so thanks for working on this! I'm excited to
> see it finished.
>
> Note that I had to implement the libfuse side of things myself to test
> this, so it's possible I'm doing something wrong there to trigger this
> behavior. Maybe you could post your libfuse patches somewhere as well?
> Then I can make sure I'm testing the same thing that you are.
>
> Thanks,
> -Mike
>
>

Hi
Thank you so much Mike for testing it out and reporting the results.
I reviewed my code base again and it turns out i have other internal  
patches that allow my code to work.
But you are right i can fix up the code simliar to your suggestion in 
the next patch so it works no matter what.
I will wait one or two more days before sending out a new patch with 
the fix up as suggested. ( credit to you of course ) so that others 
have a chance to give more comments.
I hope you can help test it out then as well.

As for libfuse i currently testing using a proprietary version of a 
daemon that doesnt use libfuse so i dont have have a patch out yet. 
(the legal guys are to blame)
If you you have one ready can you please post it ? ( will save me the 
effort :)  and the bureaucracy i have to go through to post a patch ) 
otherwise will try to get my version out by end of the month


Again thanks for your help and support

--
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project.
