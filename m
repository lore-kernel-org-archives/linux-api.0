From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v11 21/48] ext4: Add richacl feature flag
Date: Mon, 19 Oct 2015 17:34:54 +0200
Message-ID: <CAHc6FU4CVQAn6TCQzC8r9m9URmqD_eHQBwhDK2o_o4eb3myW=A@mail.gmail.com>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
	<1445008706-15115-22-git-send-email-agruenba@redhat.com>
	<5621346E.5000500@gmail.com>
	<CAHc6FU7sR2zN-K3un74wCv+1NPnrqJ=LYiWo+YQ_2X0kopyoTQ@mail.gmail.com>
	<5624ED40.7040206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5624ED40.7040206-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 19, 2015 at 3:16 PM, Austin S Hemmelgarn
<ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 2015-10-16 13:41, Andreas Gruenbacher wrote:
>>
>> On Fri, Oct 16, 2015 at 7:31 PM, Austin S Hemmelgarn
>> <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>
>>> I would like to re-iterate, on both XFS and ext4, I _really_ think this
>>> should be a ro_compat flag, and not an incompat one.  If a person has the
>>> ability to mount the FS (even if it's a read-only mount), then they by
>>> definition have read access to the file or partition that the filesystem
>>> is contained in, which means that any ACL's stored on the filesystem are
>>> functionally irrelevant,
>>
>> It is unfortunately not safe to make such a file system accessible to
>> other users, so the feature is not strictly read-only compatible.
>>
> OK, seeing as I wasn't particularly clear as to why I object to this in my
> other e-mail, let's try this again.
>
> Can you please explain exactly why it isn't safe to make such a filesystem
> accessible to other users?

See here: http://www.spinics.net/lists/linux-ext4/msg49541.html

Andreas
