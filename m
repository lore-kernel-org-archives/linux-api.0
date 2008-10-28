From: "Michael Kerrisk" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cleanup paccept
Date: Tue, 28 Oct 2008 15:10:44 -0500
Message-ID: <517f3f820810281310y2b02705fs8b402a5ca5117f51@mail.gmail.com>
References: <200810281909.m9SJ9pdj003624@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200810281909.m9SJ9pdj003624-sQhldQRnEDHy+ZiRM8QlFPXAX3CI6PSWQQ4Iyu8u01E@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 28, 2008 at 2:09 PM, Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> This patch doesn't change *any* functionality from what is currently
> in the upstream kernel.  There is no reason to start arguing again and
> for me to explain everything the way I did it months ago.  This is just
> a *cleanup patch*, nothing else.  If you want to know why this cleanup
> is needed read the discussions of
>
> commit 2d4c8266774188cda7f7e612e6dfb8ad12c579d5
> Author: Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
> Date:   Mon Sep 22 13:57:49 2008 -0700
>
>    sys_paccept: disable paccept() until API design is resolved
>
>
> For example, here:
>
> http://kerneltrap.org/mailarchive/linux-netdev/2008/9/16/3310534
>
>
> I don't agree with the change but I'm also tired arguing.  So just
> clean up the mess created by change initiated by the posting mentioned
> above.

Oh, please!  The "mess" arose because you refused to explain things in
a simple and coherent fashion, even when politely asked.

And now you compound the mess by running up two threads in the last 24
hours with versions of the patch (are they the same -- who knows?  You
give us no clue.)  So I'll repeat here, what I said in the other:

1. Please take the trouble to CC interested parties.  For example, the
people CCed in recent threads that discussed earlier versions of the
the patch.  This is basic LKML basic etiquette, since almost no one
reads all LKML, nor reads it hourly.  Doing this allows interested
parties to comment on the patch, and also avoids patches hitting the
kernel "under the radar".

2. Don't assume anyone has cached earlier discussions of the topic.
Write a clear, complete description of the patch that could be read by
someone new to the topic, something like a summary of
http://lwn.net/Articles/281965/ and http://udrepper.livejournal.com/20407.html

[If you had done this the first time round, then there'd be very
little work other than cut and paste this time round.]

3. Explain what changes have been made from earlier versions of the
patch, and why.
E.g., some discussion that summarizes this:
http://thread.gmane.org/gmane.linux.network/106071

4. CC linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on patches that are API changes.  This
requirement was added to SubmitChecklist in the last few weeks.

5. CC me or linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, so that something makes its way
into man-pages.

> The actual patch which is in the kernel is different from
> the patch in the mail: only the signal mask handling has been disabled.
> This is why this is only a cleanup patch.

And that does not explain to the world at large what this
to-be-enabled system call does, or why it's needed.

Cheers,

Michael
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
