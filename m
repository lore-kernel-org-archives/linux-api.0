From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without
 removing from a queue (v2)
Date: Mon, 25 Feb 2013 14:37:28 -0800
Message-ID: <20130225143728.3ddb88fc.akpm@linux-foundation.org>
References: <1361786813-14652-1-git-send-email-avagin@openvz.org>
	<20130225141234.99b76738.akpm@linux-foundation.org>
	<CAKgNAkhoK4KQ-5PC+C=g1i+J7WQsdvOWFiJ9PiqD26EdCZW0OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkhoK4KQ-5PC+C=g1i+J7WQsdvOWFiJ9PiqD26EdCZW0OA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland McGrath <roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Pedro Alves <palves-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 25 Feb 2013 23:28:11 +0100
"Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> > Please, document the interface *completely* so that others can review
> > the design and can then check that the implementation matches that
> > design.  As it stands, we're reduced to mind-reading.
> 
> +1.

I suddenly feel less lonely.

> Andrey, please don't assume that people have read past mails. Even if
> they have, they're forgetful. Don't make people hunt down old mails to
> try to put the pieces together. The changelog should include a full
> description of the interface, and also the sample user-space code that
> you showed at some point in another mail.

If there's sample userspace code, there are all sorts of good reasons
for putting that into tools/testing/selftests/your-name-here/

> That may help you get better
> review, and it will certainly help make a better man page.
