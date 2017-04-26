From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Revised statx(2) man page for review
Date: Wed, 26 Apr 2017 07:42:12 +0200
Message-ID: <864d7dbb-9fa7-deb2-e379-8d99a6e8c2aa@gmail.com>
References: <f3ef2be8-dfa5-e1dd-2315-d787a2a2acc3@gmail.com>
 <20170425200656.GA30045@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170425200656.GA30045-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 04/25/2017 10:06 PM, Dmitry V. Levin wrote:
> On Tue, Apr 25, 2017 at 01:14:26PM +0200, Michael Kerrisk (man-pages) wrote:
> [...]
>>        The file timestamps are structures of the following type:
>>
>>            struct statx_timestamp {
>>                __s64 tv_sec;    /* Seconds since the Epoch (UNIX time) */
>>                __s32 tv_nsec;   /* Nanoseconds before or since tv_sec */
>>            };
> 
> Nanoseconds since tv_sec.  The "before tv_sec" is not implemented yet
> and I hope nobody is going to implement it for the reasons I mentioned
> in https://marc.info/?i=20170422192743.GA17005%40altlinux.org

Thanks Dmitry. Fixed.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
