From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: Does it make sense to define a constant for openat and such that
 is guaranteed not to be used for special purposes later on?
Date: Mon, 30 Jun 2014 15:08:10 -0700
Message-ID: <CALCETrUp=UYKEnhN9qf2vYToCV7YsLfL3+UGS-p9aY=_zMQMJA@mail.gmail.com>
References: <fb54be9c497f.53af14a5@langara.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fb54be9c497f.53af14a5-BTv7Ps/Sm75C8prJL3GQQw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jun 28, 2014 at 12:16 PM, Steven Stewart-Gallus
<sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org> wrote:
> Hello,
>
> For system calls such as openat I might wish to use the value -1 for
> the directory file descriptor parameter to indicate that a path passed
> in must be an absolute path. However, it has occurred to me that such
> a usage isn't defined by POSIX and isn't safe for the future. In the
> future -1 may be taken to be used for some other special purpose. I
> would like a solution for that problem.
>
> It'd be nice if we could define a constant (maybe call it AT_FDNODIR)
> to maybe -1 that is set aside to mean that no directory is to be used
> and that will not ever be ever used for some other purpose in the
> future.

I like this.  Want to submit a patch?

--Andy
