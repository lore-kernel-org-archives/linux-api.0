From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: richacl(7) man page review comments
Date: Sun, 21 Feb 2016 22:01:25 +0100
Message-ID: <56CA25A5.2030100@gmail.com>
References: <56B770B6.7040803@gmail.com> <56B77262.7090107@gmail.com>
 <CAHc6FU5__xbKm4mg8+fK_ZW5ZYsDoQcYBBvQg573Eq4ERDsROw@mail.gmail.com>
 <56C0F23C.7030902@gmail.com>
 <CAHc6FU4CCrcrA6=oCiq2A5rGd9CCGELaTZq6tGpmd2jcV_Zp4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHc6FU4CCrcrA6=oCiq2A5rGd9CCGELaTZq6tGpmd2jcV_Zp4A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 02/20/2016 05:37 PM, Andreas Gruenbacher wrote:
> Hi Michael,
> 
> thanks again for all the feedback. I've followed all your suggestions;
> again, please see the github repo for the latest version:
> 
>   https://github.com/andreas-gruenbacher/richacl
> 
> On Sun, Feb 14, 2016 at 10:31 PM, Michael Kerrisk (man-pages)
> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi Andreas,
>>
>> Here's a few more comments on the current richacl(7) page
>> that I fetched from the git repo.
>>

[...]

>>> .HP
>>> .BR dir_inherit "\ (" d ):
>>> The entry is inheritable for directories.
>>
>> "When this flag appears in the ACL entry of a directory, then that entry is
>> inherited by new subdirectories created in the directory."
>>
>> Is that text that I propose correct?
> 
> It's not entirely wrong, but only a small part of the truth. Entries
> are inherited such that the permissions in file_inherit entries become
> effective for access checking for new files, and the permissions in
> dir_inherit entries become effective for access checking for new
> directories, recursively.
> 
> Your feedback prompted me to look into the inheritance flag
> computation more closely once again, and I found bugs. The steps of
> the algorithm are explained in the section "Permissions at
> file-creation time", by the way.

Hmmm... writing and refining documentation helps find code bugs. 
Who knew? :-)

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
