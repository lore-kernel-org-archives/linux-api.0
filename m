From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: richacl(7) man page review comments
Date: Mon, 15 Feb 2016 15:15:27 +0100
Message-ID: <CAKgNAki53C7bZyWFSQMD1ArCD9w2V9RH0MozCk99G1=PuUUy1g@mail.gmail.com>
References: <56B770B6.7040803@gmail.com> <56B77262.7090107@gmail.com>
 <CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
 <56C0F150.60008@gmail.com> <CAHc6FU49uRb11HhO655jimn_CzLrDyGHAB2iDAv92cftCCXkEA@mail.gmail.com>
 <56C1A788.9020008@gmail.com> <CAHc6FU69k2uRXjSSS+9K0cXzFs74DPsz6DDv8GN=hmh7RpPA-Q@mail.gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHc6FU69k2uRXjSSS+9K0cXzFs74DPsz6DDv8GN=hmh7RpPA-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 15 February 2016 at 12:35, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, Feb 15, 2016 at 11:25 AM, Michael Kerrisk (man-pages)
> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> You're right. I was confusing with xattr(7). So, I think it might
>> make some sense to eventually move both of these into man-pages (for
>> richacl(7), at least, it's probably worth delaying this for a bit),
>> since  they're describing kernel-user-space interfaces.
>
> Well, the actual user-space interface is xattrs in both cases.

Yes, xattrs are the base of the framework, but I was using "interface"
in a very broad way: ACLs and RichACLs are exposing kernel-defined
policies and rules about file permissions to user space (much as say
chmod(2) and the file mode bits). That's why it seems to make some
sense to place those pages with the other pages that describe
kernel-user-spaces interfaces. Plus, they'd now and then get some
man-pages love :-).

>> I can see counter-arguments too, such as these pages are closely
>> related to the corresponding user-space libraries you maintain.
>> What do you think?
>
> I would keep the man-pages where they are right now, but I don't have
> a strong preference.

I'd be happy to see acl(5) and eventually richacl(7) in man pages, but
it's your call in the end, of course.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
