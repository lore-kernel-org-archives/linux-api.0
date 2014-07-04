From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: Does it make sense to define a constant for openat and such that
 is guaranteed not to be used for special purposes later on?
Date: Fri, 4 Jul 2014 10:20:40 -0700
Message-ID: <CALCETrXVjUrbJwwu9OyphG56Nr6n0igvUzGCFdFJo23NiJoFOw@mail.gmail.com>
References: <fb54be9c497f.53af14a5@langara.bc.ca> <CALCETrUp=UYKEnhN9qf2vYToCV7YsLfL3+UGS-p9aY=_zMQMJA@mail.gmail.com>
 <fb54f255442.53b36c26@langara.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fb54f255442.53b36c26-BTv7Ps/Sm75C8prJL3GQQw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Jul 1, 2014 7:19 PM, "Steven Stewart-Gallus"
<sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org> wrote:
>
> > I like this.  Want to submit a patch?
> >
> > --Andy
> >
>
> Sure I'd love to patch the documentation. So I can just submit a man pages patch
> for this and I don't have to coordinate with GLibc (or other liibcs like Musl)
> for this or modify any in kernel tree documentation?

I'd suggest adding it to whatever file defines AT_FDCWD.

--Andy
