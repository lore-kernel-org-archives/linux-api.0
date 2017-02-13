From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v27 03/21] vfs: Add MAY_DELETE_SELF and MAY_DELETE_CHILD
 permission flags
Date: Mon, 13 Feb 2017 16:40:41 +0100
Message-ID: <CAHc6FU4h-LCH_4VPiybakGWUXothvr+KzjZGjRaH_kEjZhd=TQ@mail.gmail.com>
References: <1476190256-1677-1-git-send-email-agruenba@redhat.com>
 <1476190256-1677-4-git-send-email-agruenba@redhat.com> <CAELBmZCgttywPy3EtkFao7SPESaw8VB5K6x7PTRk7gwSk7sXqg@mail.gmail.com>
 <20161206201529.GA1203@fieldses.org> <20161206203347.GC4498@jra3> <CAJfpegsvoZfzUXyCJrxXAG6dxk8HMCGMEKA0E-6FzWNGkM17Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJfpegsvoZfzUXyCJrxXAG6dxk8HMCGMEKA0E-6FzWNGkM17Tw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 6, 2016 at 10:25 PM, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org> wrote:
> On Tue, Dec 6, 2016 at 10:13 PM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>> On Tue, Dec 06, 2016 at 03:15:29PM -0500, J. Bruce Fields wrote:
>>> On Fri, Dec 02, 2016 at 10:57:42AM +0100, Miklos Szeredi wrote:
>>> > On Tue, Oct 11, 2016 at 2:50 PM, Andreas Gruenbacher
>>> > <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> > > Normally, deleting a file requires MAY_WRITE access to the parent
>>> > > directory.  With richacls, a file may be deleted with MAY_DELETE_CHILD access
>>> > > to the parent directory or with MAY_DELETE_SELF access to the file.
>>> > >
>>> > > To support that, pass the MAY_DELETE_CHILD mask flag to inode_permission()
>>> > > when checking for delete access inside a directory, and MAY_DELETE_SELF
>>> > > when checking for delete access to a file itself.
>>> > >
>>> > > The MAY_DELETE_SELF permission overrides the sticky directory check.
>>> >
>>> > And MAY_DELETE_SELF seems totally inappropriate to any kind of rename,
>>> > since from the point of view of the inode we are not doing anything at
>>> > all.  The modifications are all in the parent(s), and that's where the
>>> > permission checks need to be.
>>>
>>> I'm having a hard time finding an authoritative reference here (Samba
>>> people might be able to help), but my understanding is that Windows
>>> gives this a meaning something like "may I delete a link to this file".
>>>
>>> (And not even "may I delete the *last* link to this file", which might
>>> also sound more logical.)
>>
>> I just did a recent patch here. In Samba we now check for
>> SEC_DIR_ADD_FILE/SEC_DIR_ADD_SUBDIR on the target directory
>> (depending on if the object being moved is a file or dir).
>
> And MAY_DELETE_SELF as well, for rename?  That's really counterintuitive for me.

Yes, MAY_DELETE_SELF applies to delete as well as rename; otherwise
rename() would behave different from link() + unlink(); when a user
has the appropriate permissions, the result should be the same though.

Thanks,
Andreas
