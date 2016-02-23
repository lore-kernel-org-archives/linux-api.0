From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: richacl(7) man page review comments
Date: Tue, 23 Feb 2016 20:01:20 +0100
Message-ID: <CAHc6FU4FR577X=sZAPUXhCL4SUfrRYTHw9_byehZqwYyBOhQiA@mail.gmail.com>
References: <56B770B6.7040803@gmail.com>
	<56B77262.7090107@gmail.com>
	<CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
	<56C0F23C.7030902@gmail.com>
	<CAHc6FU4CCrcrA6=oCiq2A5rGd9CCGELaTZq6tGpmd2jcV_Zp4A@mail.gmail.com>
	<56CA2EEB.9080504@gmail.com>
	<CAHc6FU46vO8NM3cvFH7b8X7U9R+m6wcYj8EQKVnSQkiY3Q051A@mail.gmail.com>
	<56CC3B4A.7070204@gmail.com>
	<CAHc6FU67LnV7-roofFe1y_uTfvgwonRZimyu7Wn1CDRzwHZJSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHc6FU67LnV7-roofFe1y_uTfvgwonRZimyu7Wn1CDRzwHZJSw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 23, 2016 at 4:09 PM, Andreas Gruenbacher
<agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi Michael,
>
> On Tue, Feb 23, 2016 at 11:58 AM, Michael Kerrisk (man-pages)
> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On 02/22/2016 03:46 PM, Andreas Gruenbacher wrote:
>>> On Sun, Feb 21, 2016 at 10:40 PM, Michael Kerrisk (man-pages) <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> I've once more pulled from the latest git; here's some more comments.
>>>
>>> thanks again. I've updated the repo with your changes.
>>
>> Next round :-). Just a few quick comments while I'm on a train ride.
>
> applied, thanks.

I've fixed the following additional problems:

> diff --git a/man/richacl.7 b/man/richacl.7
> index acdff31..1c82644 100644
> --- a/man/richacl.7
> +++ b/man/richacl.7
> @@ -30,10 +30,8 @@
>  .SH NAME
>  richacl \- Rich Access Control Lists
>  .SH DESCRIPTION
> -Rich Access Control Lists (RichACLs) are an extension of the POSIX file
> -permission model (see
> -.BR acl (5))
> -to support
> +Rich Access Control Lists (RichACLs) are an extension of the traditional POSIX
> +file permission model to support
>  .URL https://tools.ietf.org/rfc/rfc5661.txt "NFSv4 Access Control Lists"
>  on local and remote-mounted filesystems.

RichACLs are an extension of the traditional POSIX file permission
model, not of the POSIX ACL model.

Unfortunately, there doesn't seem to be a man-page covering POSIX File
Access Permissions as in Appendix A of
http://www.bestbits.at/richacl/draft-gruenbacher-nfsv4-acls-in-posix-00.html.

A lot of the gaps between paragraphs were wrong when rendered for printing.

The modification dates were outdated.

Andreas
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
