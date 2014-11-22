From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: RFC: renameat(): Add a RENAME_REMOVE flag to unlink hardlinks
Date: Sat, 22 Nov 2014 01:50:10 +0000
Message-ID: <20141122015010.GW7996@ZenIV.linux.org.uk>
References: <CALCETrXvVxvG+s39v+NMdvfkeb8YjbYjb6UXgDFg5ifYOjeKsA@mail.gmail.com>
 <546F86F5.6070305@draigBrady.com>
 <CALCETrVf_7g_njnFGQx=xFwn=FyY851nnp0vmKFSmV=TusSOkQ@mail.gmail.com>
 <546FA51F.40503@draigBrady.com>
 <546FAC18.5020200@redhat.com>
 <CALCETrUByDgug68FP=cnj-iwSXvbEEHp=S4a=WhQPFmuKc2pNw@mail.gmail.com>
 <546FBAC6.6020407@draigBrady.com>
 <20141121223018.GV7996@ZenIV.linux.org.uk>
 <CALCETrW0c1UzkVQgEE_je5BtVhdWRmNaYk4HCQk+t6AWvpC-FA@mail.gmail.com>
 <546FE6E1.7040703@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <546FE6E1.7040703-V8g9lnOeT5ydJdNcDFJN0w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Nov 22, 2014 at 01:29:05AM +0000, P=E1draig Brady wrote:

> > I assume that VFS can handle this correctly if it wants to.
>=20
> I was assuming there was a way to distinguish directory entries,
> and that's what should be checked first, which is what my
> psuedo code patch attempted to show.

There isn't, in general.  Sure, if you get the same struct dentry * fro=
m
both lookups, it's the same one.  But it's not guaranteed to be true on
every fs out there if those are non-directories (and for directories th=
ere's
no multiple hardlinks in the first place).
