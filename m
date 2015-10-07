From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v8 00/41] Richacls
Date: Wed, 7 Oct 2015 10:15:19 -0500
Message-ID: <CAH2r5mt18-CQLCMz0RHnK_sXW5oOFpf2kMVeWJRvrD3Vw2MWLw@mail.gmail.com>
References: <1443391772-10171-1-git-send-email-agruenba@redhat.com>
 <20151004062313.GA20212@infradead.org> <CAHc6FU53mXg1k0KCNkWEjxyuC8iAUgWh-A76qX=C3Yth+qEyuQ@mail.gmail.com>
 <5612C85C.2060407@gmail.com> <20151006094935.GA14144@infradead.org>
 <CAHc6FU5aZJDC3N1iGyVeHfbqMyquM93ONJvUR-t0a9+AjmtAXQ@mail.gmail.com>
 <CF738526-0807-4CE5-A52B-413164D41AA9@dilger.ca> <20151007075053.GA8660@infradead.org>
 <CAHc6FU7TM5LDu_vVvDc3WPuzQN2mkGGp2AvCY+=qN0GvWuC=Ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHc6FU7TM5LDu_vVvDc3WPuzQN2mkGGp2AvCY+=qN0GvWuC=Ew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 7, 2015 at 8:38 AM, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, Oct 7, 2015 at 9:50 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>> On Tue, Oct 06, 2015 at 02:26:09PM -0600, Andreas Dilger wrote:
>>> And any disk filesystems that have their own non-POSIX ACLs, such as HFS, NTFS, ZFS would presumably also need to map the in-kernel Richacl format to their on-disk format.
>>
>> No, we did this mistake with Posix ACLs, and we're not going to repeat
>> it here.  Filesystems with their own slightly different ACLs must not
>> reuse the interface.
>
> Well, things may not be quite as clearly delineated. We currently have
> code in nfsd for mapping between NFSv4 ACLs on the wire and POSIX ACLs
> on local file systems. This mapping is problematic because of the
> semantic differences between NFSv4 ACLs and POSIX ACLs (different sets
> of permissions, access and default acl vs. inheritance flags,
> different permission check algorithm). I wish we could have avoided
> that.
>
> Richacls are designed to support NFSv4 ACLs on top of POSIX systems.
> This means that they should obviously be supported by the NFSv4 server
> and client (see the patches) and by the common local filesystems.
>
> ACLs on NTFS and ZFS mostly fit into the same model. The big remaining
> difference there is how users and groups are identified: NTFS used
> SIDs (https://en.wikipedia.org/wiki/Security_Identifier); ZFS could be
> said to use a hybrid UID / GID / SID model. Exposing those ACLs as
> richacls would make sense if we can find a clean way of handling this
> aspect.

Samba (e.g. winbind service) has mapping libraries for mapping SIDs to
UIDs (CIFS ACLs already have the same issue of SID to UID mapping
which we handle with upcalls) and Samba has various pluggable ways to
handle UID mapping and is easily extensible.  Similarly NFSv4 ACLs,
although closely related to CIFS/NTFS ACLs have to be map usernames to
uids.

-- 
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
