From: "Michael Kerrisk" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: splice vs O_APPEND
Date: Fri, 10 Oct 2008 12:23:58 +0200
Message-ID: <517f3f820810100323l1cc4c361g25f17ebc1461b6bb@mail.gmail.com>
References: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu>
	 <alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org>
	 <E1Knxzm-0003y2-Jy@pomaz-ex.szeredi.hu>
	 <alpine.LFD.2.00.0810090908200.3210@nehalem.linux-foundation.org>
	 <E1KnyOw-00044y-K4@pomaz-ex.szeredi.hu>
	 <alpine.LFD.2.00.0810091218300.3210@nehalem.linux-foundation.org>
	 <E1Ko1Xu-0004vP-EX@pomaz-ex.szeredi.hu>
	 <alpine.LFD.2.00.0810091411520.3210@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.00.0810091411520.3210-nfNrOhbfy2R17+2ddN/4kux8cNe9sq/dYPYVAmT7z5s@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hey Linus,

On Thu, Oct 9, 2008 at 11:14 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
>
> On Thu, 9 Oct 2008, Miklos Szeredi wrote:
>>
>> The thing is, the append-only attribute is absolutely useless without
>> being able to depend on it.  So in that sense I think the IS_APPEND
>> issue is important, and I'm fine with your original proposal for that
>> (except we don't need the IS_IMMUTABLE check).
>
> Heh. In the meantime, I had grown to hate that more complex patch.
>
> So because I do see your point with IS_APPEND (being different from
> O_APPEND), but because I also think that O_APPEND itself is a gray and
> murky area, I just committed the following. I doubt anybody will ever even
> notice it, but while I think it's all debatable, we might as well debate
> it with this in place. I do agree that it's "safer" behaviour.

Please do CC linux-api@vger (and if you are kind, me, in case
something needs to go into man-pages) on interface changes.

Cheers,

Michael

> ---
> commit a05b4085484ac45558810e4c5928e5a291c20f65
> Author: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Date:   Thu Oct 9 14:04:54 2008 -0700
>
>    Don't allow splice() to files opened with O_APPEND
>
>    This is debatable, but while we're debating it, let's disallow the
>    combination of splice and an O_APPEND destination.
>
>    It's not entirely clear what the semantics of O_APPEND should be, and
>    POSIX apparently expects pwrite() to ignore O_APPEND, for example.  So
>    we could make up any semantics we want, including the old ones.
>
>    But Miklos convinced me that we should at least give it some thought,
>    and that accepting writes at arbitrary offsets is wrong at least for
>    IS_APPEND() files (which always have O_APPEND set, even if the reverse
>    isn't true: you can obviously have O_APPEND set on a regular file).
>
>    So disallow O_APPEND entirely for now.  I doubt anybody cares, and this
>    way we have one less gray area to worry about.
>
>    Reported-and-argued-for-by: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
>    Cc: Jens Axboe <ens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>    Signed-off-by: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>
> diff --git a/fs/splice.c b/fs/splice.c
> index 1bbc6f4..a1e701c 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -898,6 +898,9 @@ static long do_splice_from(struct pipe_inode_info *pipe, struct file *out,
>        if (unlikely(!(out->f_mode & FMODE_WRITE)))
>                return -EBADF;
>
> +       if (unlikely(out->f_flags & O_APPEND))
> +               return -EINVAL;
> +
>        ret = rw_verify_area(WRITE, out, ppos, len);
>        if (unlikely(ret < 0))
>                return ret;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/ Found a documentation bug?
http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
