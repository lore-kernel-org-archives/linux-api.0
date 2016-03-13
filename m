From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
Date: Mon, 14 Mar 2016 00:02:13 +0100
Message-ID: <CAHc6FU5Bq9afVdNogc9DQYyyXwLfUopXW5ZnSuct3N+NvKW4Rg@mail.gmail.com>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<20160311140134.GA14808@infradead.org>
	<CAHc6FU4t3yisCM=MXrHRmCja_A8eZOpVa1smJ0gUhv+vuUAuXA@mail.gmail.com>
	<CAH2r5mv3OTmPOQBV7xc-uZmB0gWxykXOCEVOcybx3tbHiViTZg@mail.gmail.com>
	<20160311230254.GG2792@jra3>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160311230254.GG2792@jra3>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 12, 2016 at 12:02 AM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, Mar 11, 2016 at 02:05:16PM -0600, Steve French wrote:
>> Sounds like I need to quickly rework the SMB3 ACL helper functions
>> for cifs.ko
>>
>> Also do you know where is the current version of the corresponding
>> vfs_richacl for
>> Samba which works with the current RichACL format?
>
> I have a patch for a new vfs_richacl somewhere. I remember
> sending it to Andreas for testing...

Ah, the patch was for testing, not resting ... how could I get that mixed up.

I've applied your patch to the latest master branch, made it compile
again, and fixed a few obvious problems. The results I get with
smbcacls look reasonable now.

The code is here:
  https://github.com/andreas-gruenbacher/samba richacl

I've used the following smb.conf:
  [richacl]
  comment = Richacl directory
  path = /mnt/ext4
  vfs objects = richacl
  writeable = yes
  browseable = yes

Is there a particular reason why you didn't make vfs_richacl a
dynamically loadable module?

Thanks,
Andreas
