From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: RFC: renameat(): Add a RENAME_REMOVE flag to unlink hardlinks
Date: Fri, 21 Nov 2014 22:30:18 +0000
Message-ID: <20141121223018.GV7996@ZenIV.linux.org.uk>
References: <546F4981.8080907@draigBrady.com>
 <CALCETrXvVxvG+s39v+NMdvfkeb8YjbYjb6UXgDFg5ifYOjeKsA@mail.gmail.com>
 <546F86F5.6070305@draigBrady.com>
 <CALCETrVf_7g_njnFGQx=xFwn=FyY851nnp0vmKFSmV=TusSOkQ@mail.gmail.com>
 <546FA51F.40503@draigBrady.com>
 <546FAC18.5020200@redhat.com>
 <CALCETrUByDgug68FP=cnj-iwSXvbEEHp=S4a=WhQPFmuKc2pNw@mail.gmail.com>
 <546FBAC6.6020407@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <546FBAC6.6020407-V8g9lnOeT5ydJdNcDFJN0w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 21, 2014 at 10:20:54PM +0000, P=E1draig Brady wrote:

> >> That said, would you still like me to take a stab at a proposal to=
 the
> >> POSIX folks that would relax the requirements to allow
> >> implementation-defined behavior when the two arguments to rename
> >> describe the same file but via different directory entries?
>=20
> I guess there is no point discussing in POSIX and adding extra
> implementation options if no implementations do/will act accordingly.
>=20
> Linux can decide to do that independently, if appropriate.
> This is one of those borderline cases where we balance
> accretion of cruft vs incompatibility.
> On consideration, I'm OK with keeping the existing
> rename() behavior for compat and adding the new flag.
> That said I still can't think of anything depending
> rename() doing nothing with hardlinked source and dest.

You do realize that it opens a very nasty can of worms for filesystems =
that
are e.g. case-insensitive to some extent?  How do you tell links from
alternative equivalent spellings of the name?
