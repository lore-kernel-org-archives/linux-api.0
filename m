From: Kai Henningsen <kai.extern-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [patch 0/3] [RFC] kernel/glibc mismatch of "readlink" syscall?
Date: Fri, 31 Oct 2008 16:02:48 +0100
Message-ID: <20081031160248.2b95d0e8@desktop.khms.westfalen.de>
References: <20081023145054.998439866@marvin.suse.de>
	<cfd18e0f0810241553x77194611o11655a89871dc210@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cfd18e0f0810241553x77194611o11655a89871dc210-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org, Daniel Gollub <dgollub-l3A5Bk7waGM@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ltp-list-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, "A.E. Brouwer" <aeb-ek1Qb6IBo2Pz+pZb47iToQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am Fri, 24 Oct 2008 17:53:25 -0500
schrieb "Michael Kerrisk" <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>:

> Hi Daniel,
> 
> On Thu, Oct 23, 2008 at 9:50 AM, Daniel Gollub <dgollub-l3A5Bk7waGM@public.gmane.org>
> wrote:

> > EINVAL bufsiz is not positive.

> The EINVAL error was added to man-pages-1.18 in 1997 (even though, as
> you note, the type was "size_t").  I suspect (this was well before I
> had any association with man-pages) that was done to reflect kernel
> reality (since one could bypass glibc invoke the syscall directly),
> but obviously it is inconsistent with the prototype.

Actually, it's not inconsistent as described, though perhaps that is
unintentional. "Not positive" isn't the same as "negative", as zero
isn't positive either, and zero is certainly a possible value of an
unsigned type
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
