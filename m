From: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch v2] madvise.2: Add MADV_WIPEONFORK documentation
Date: Mon, 09 Oct 2017 15:08:44 -0400
Message-ID: <1507576124.21121.168.camel@redhat.com>
References: <20170914130040.6faabb18@cuia.usersys.redhat.com>
         <CAAF6GDdnY2AmzKx+t4ffCFxJ+RZS++4tmWvoazdVNVSYjra_WA@mail.gmail.com>
         <20170914150546.74ad3a9a@cuia.usersys.redhat.com>
         <a1715d1d-7a03-d2db-7a8a-8a2edceae5d1@gmail.com>
         <1505848907.5486.9.camel@redhat.com>
         <CAKgNAkg8QJHfPfdfYXBU2-eW=_FWY99UYi_6hQejE=q5+66u1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkg8QJHfPfdfYXBU2-eW=_FWY99UYi_6hQejE=q5+66u1g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Colm =?ISO-8859-1?Q?MacC=E1rthaigh?= <colm-ZXBCfW2eEe/k1uMJSBkQmQ@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 2017-10-09 at 21:06 +0200, Michael Kerrisk (man-pages) wrote:
> Hi Rik,
> 
> I have a follow-up question re wipe-on-fork. What are the semantics
> for this setting with respect to fork() and exec()? That is, in the
> child of a fork(), does the flag remain set for the specified address
> range? (My quick read of the source suggests yes, but I have not
> tested.) And, when we do an exec(), my assumption is that the flag is
> cleared for the address range, but it would be good to have
> confirmation.

Indeed, on exec() the flag is cleared, because all
memory regions get replaced on exec().

The flag remains across a fork(), so if a child task
were to fork, the memory would be empty of contents
again in its child. This seems to most closely match
the use case of discarding things like cryptographic
secrets at fork time.
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
