From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: RFC: renameat(): Add a RENAME_REMOVE flag to unlink hardlinks
Date: Fri, 21 Nov 2014 17:51:23 -0800
Message-ID: <CALCETrXBFysW3qnOUuhE8=SeiDVtgAkms7mDuHJTG06mK3=knw@mail.gmail.com>
References: <CALCETrXvVxvG+s39v+NMdvfkeb8YjbYjb6UXgDFg5ifYOjeKsA@mail.gmail.com>
 <546F86F5.6070305@draigBrady.com> <CALCETrVf_7g_njnFGQx=xFwn=FyY851nnp0vmKFSmV=TusSOkQ@mail.gmail.com>
 <546FA51F.40503@draigBrady.com> <546FAC18.5020200@redhat.com>
 <CALCETrUByDgug68FP=cnj-iwSXvbEEHp=S4a=WhQPFmuKc2pNw@mail.gmail.com>
 <546FBAC6.6020407@draigBrady.com> <20141121223018.GV7996@ZenIV.linux.org.uk>
 <CALCETrW0c1UzkVQgEE_je5BtVhdWRmNaYk4HCQk+t6AWvpC-FA@mail.gmail.com>
 <546FE6E1.7040703@draigBrady.com> <20141122015010.GW7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141122015010.GW7996-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>, Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 21, 2014 at 5:50 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrot=
e:
> On Sat, Nov 22, 2014 at 01:29:05AM +0000, P=C3=A1draig Brady wrote:
>
>> > I assume that VFS can handle this correctly if it wants to.
>>
>> I was assuming there was a way to distinguish directory entries,
>> and that's what should be checked first, which is what my
>> psuedo code patch attempted to show.
>
> There isn't, in general.  Sure, if you get the same struct dentry * f=
rom
> both lookups, it's the same one.  But it's not guaranteed to be true =
on
> every fs out there if those are non-directories (and for directories =
there's
> no multiple hardlinks in the first place).

Does that mean that the current behavior is inconsistent between filesy=
stems.

--=20
Andy Lutomirski
AMA Capital Management, LLC
