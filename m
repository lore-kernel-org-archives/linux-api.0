From: "Michael Kerrisk" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cleanup paccept
Date: Tue, 28 Oct 2008 15:20:35 -0500
Message-ID: <517f3f820810281320l5ed1df3v3717584e4284a43f@mail.gmail.com>
References: <200810281909.m9SJ9pdj003624@hs20-bc2-1.build.redhat.com>
	 <517f3f820810281310y2b02705fs8b402a5ca5117f51@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <517f3f820810281310y2b02705fs8b402a5ca5117f51-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

>> The actual patch which is in the kernel is different from
>> the patch in the mail: only the signal mask handling has been disabled.
>> This is why this is only a cleanup patch.
>
> And that does not explain to the world at large what this
> to-be-enabled system call does, or why it's needed.

And one further point: what is the userspace interface going to look
like for this system call?

Are we to see a repeat of the unsafe userspace implementation of
pselect() that was present in glibc before the kernel finally added a
pselect() system call?

In other words: is the userspace interface for accept4() going to be
the thinnest of wrappers, or will glibc add an unsafe
paccept()-with-signal-mask in userspace?
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
