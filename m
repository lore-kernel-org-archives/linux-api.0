From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: RFC: renameat(): Add a RENAME_REMOVE flag to unlink hardlinks
Date: Sat, 22 Nov 2014 01:57:03 +0000
Message-ID: <20141122015703.GX7996@ZenIV.linux.org.uk>
References: <CALCETrVf_7g_njnFGQx=xFwn=FyY851nnp0vmKFSmV=TusSOkQ@mail.gmail.com>
 <546FA51F.40503@draigBrady.com>
 <546FAC18.5020200@redhat.com>
 <CALCETrUByDgug68FP=cnj-iwSXvbEEHp=S4a=WhQPFmuKc2pNw@mail.gmail.com>
 <546FBAC6.6020407@draigBrady.com>
 <20141121223018.GV7996@ZenIV.linux.org.uk>
 <CALCETrW0c1UzkVQgEE_je5BtVhdWRmNaYk4HCQk+t6AWvpC-FA@mail.gmail.com>
 <546FE6E1.7040703@draigBrady.com>
 <20141122015010.GW7996@ZenIV.linux.org.uk>
 <CALCETrXBFysW3qnOUuhE8=SeiDVtgAkms7mDuHJTG06mK3=knw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXBFysW3qnOUuhE8=SeiDVtgAkms7mDuHJTG06mK3=knw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigbrady.com>, Eric Blake <eblake@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 21, 2014 at 05:51:23PM -0800, Andy Lutomirski wrote:
> On Fri, Nov 21, 2014 at 5:50 PM, Al Viro <viro@zeniv.linux.org.uk> wr=
ote:
> > On Sat, Nov 22, 2014 at 01:29:05AM +0000, P=E1draig Brady wrote:
> >
> >> > I assume that VFS can handle this correctly if it wants to.
> >>
> >> I was assuming there was a way to distinguish directory entries,
> >> and that's what should be checked first, which is what my
> >> psuedo code patch attempted to show.
> >
> > There isn't, in general.  Sure, if you get the same struct dentry *=
 from
> > both lookups, it's the same one.  But it's not guaranteed to be tru=
e on
> > every fs out there if those are non-directories (and for directorie=
s there's
> > no multiple hardlinks in the first place).
>=20
> Does that mean that the current behavior is inconsistent between file=
systems.

No.  You can always check that they point to the same inode.  Which is
precisely what "links to the same file" is about, and which is why rena=
me(2)
had that semantics since way back.  _That_ is easy condition to check.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
