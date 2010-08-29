From: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Minor error in mount(8) manpage
Date: Sun, 29 Aug 2010 07:45:36 +0200
Message-ID: <AANLkTikqNVd90JPhgy2hi1vMYC-MyWc3HEcvvW4aMso1@mail.gmail.com>
References: <20100818214210.GA27032@us.ibm.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100818214210.GA27032-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello Sukadev,

On Wed, Aug 18, 2010 at 11:42 PM, Sukadev Bhattiprolu
<sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
>
> The shared subtrees section of mount(8) points to
>
> =A0 =A0 =A0 =A0Documentation/sharedsubtree.txt
>
> for more information. It should instead point to:
>
> =A0 =A0 =A0 =A0Documentation/filesystems/sharedsubtree.txt

This man page is not in my set. See
http://www.kernel.org/doc/man-pages/man_pages_other.html
for details of how to find where to report the problem.

(Note also, that the correction only applies since kernel 2.6.25 --
before that, the old path was correct.)

Thanks,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
