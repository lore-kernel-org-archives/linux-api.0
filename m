From: Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
Date: Tue, 15 Mar 2016 21:17:00 +0100
Message-ID: <20160315201700.GA22945@sernet.de>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
 <20160311140134.GA14808@infradead.org>
 <CAHc6FU4t3yisCM=MXrHRmCja_A8eZOpVa1smJ0gUhv+vuUAuXA@mail.gmail.com>
 <20160315071103.GC19747@infradead.org>
 <20160315154514.GB39038@jra3>
Reply-To: Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160315154514.GB39038@jra3>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cristoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, XFS Developers <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-ext4 <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 15, 2016 at 08:45:14AM -0700, Jeremy Allison wrote:
> On Tue, Mar 15, 2016 at 12:11:03AM -0700, Christoph Hellwig wrote:
> > People have long learned that we only have 'alloc' permissions.  Any
> > model that mixes allow and deny ACE is a mistake.
> 
> People can also learn and change though :-). One of the
> biggest complaints people deploying Samba on Linux have is the
> incompatible ACL models.

Just to confirm: I see this a lot in the field. NFSv4 ACLs, while not a
perfect match for NTFS ACLs are a lot closer much more usable to people
who want to serve Windows clients.

Also in the pure linux world there is a lot that you can not express
with just rwx, sgid, sticky bits and friends. If you want the additional
functionality of the richacl bits, I would call it a big mistake to
omit negative aces, if just for the reason not to create yet another
ACLs flavor.

> Whilst I have sympathy with your intense dislike of the
> Windows ACL model, this comes down to the core of "who
> do we serve ?"

The world has enough confusion around ACL semanics, please do not add
more to it by creating your own model of the day.

Volker
