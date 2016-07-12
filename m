From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v23 17/22] richacl: Automatic Inheritance
Date: Tue, 12 Jul 2016 22:28:15 +0200
Message-ID: <CAHc6FU6k+eZ1Ozc8wofDBNOAHZzvXXWMAs1NJNTbd9Ntbqqsqw@mail.gmail.com>
References: <1467294433-3222-1-git-send-email-agruenba@redhat.com>
 <1467294433-3222-18-git-send-email-agruenba@redhat.com> <1468324560.7798.14.camel@redhat.com>
 <20160712191142.GE449@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160712191142.GE449-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 12, 2016 at 9:11 PM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:
> On Tue, Jul 12, 2016 at 07:56:00AM -0400, Jeff Layton wrote:
>> Barf. AI seems like a trainwreck waiting to happen. What are the
>> chances that userland is going to get this right?
>
> This is just taken from Windows, so presumably Samba should do the right
> thing (with one workaround required--see the discussion of PROTECTED in
> the changelog).
>
>> Still, I do applaud the fact that you're just doing the bare minimum in
>> kernel to support userland apps that want this. Thanks for not trying
>> to push the propagation of the changed ACEs into the kernel.
>
> Agreed.  But, again, this is just what Windows does.  (I wonder whether
> there's an OS that's actually tried do any sort of atomic propagation.)

NetWare's NSS filesystem did have automatic propagation, but I think
that was implemented by composing the permissions along the path to a
file at access time.

Andreas
