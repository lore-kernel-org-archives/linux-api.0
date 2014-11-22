From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
Subject: Re: RFC: renameat(): Add a RENAME_REMOVE flag to unlink hardlinks
Date: Sat, 22 Nov 2014 01:29:05 +0000
Message-ID: <546FE6E1.7040703@draigBrady.com>
References: <546F4981.8080907@draigBrady.com> <CALCETrXvVxvG+s39v+NMdvfkeb8YjbYjb6UXgDFg5ifYOjeKsA@mail.gmail.com> <546F86F5.6070305@draigBrady.com> <CALCETrVf_7g_njnFGQx=xFwn=FyY851nnp0vmKFSmV=TusSOkQ@mail.gmail.com> <546FA51F.40503@draigBrady.com> <546FAC18.5020200@redhat.com> <CALCETrUByDgug68FP=cnj-iwSXvbEEHp=S4a=WhQPFmuKc2pNw@mail.gmail.com> <546FBAC6.6020407@draigBrady.com> <20141121223018.GV7996@ZenIV.linux.org.uk> <CALCETrW0c1UzkVQgEE_je5BtVhdWRmNaYk4HCQk+t6AWvpC-FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrW0c1UzkVQgEE_je5BtVhdWRmNaYk4HCQk+t6AWvpC-FA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 21/11/14 22:40, Andy Lutomirski wrote:
> On Fri, Nov 21, 2014 at 2:30 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wr=
ote:
>> On Fri, Nov 21, 2014 at 10:20:54PM +0000, P=C3=A1draig Brady wrote:
>>
>>>>> That said, would you still like me to take a stab at a proposal t=
o the
>>>>> POSIX folks that would relax the requirements to allow
>>>>> implementation-defined behavior when the two arguments to rename
>>>>> describe the same file but via different directory entries?
>>>
>>> I guess there is no point discussing in POSIX and adding extra
>>> implementation options if no implementations do/will act accordingl=
y.
>>>
>>> Linux can decide to do that independently, if appropriate.
>>> This is one of those borderline cases where we balance
>>> accretion of cruft vs incompatibility.
>>> On consideration, I'm OK with keeping the existing
>>> rename() behavior for compat and adding the new flag.
>>> That said I still can't think of anything depending
>>> rename() doing nothing with hardlinked source and dest.
>>
>> You do realize that it opens a very nasty can of worms for filesyste=
ms that
>> are e.g. case-insensitive to some extent?  How do you tell links fro=
m
>> alternative equivalent spellings of the name?
>=20
> I assume that VFS can handle this correctly if it wants to.

I was assuming there was a way to distinguish directory entries,
and that's what should be checked first, which is what my
psuedo code patch attempted to show.

> OTOH, if someone does rename("foo", "Foo"), and foo, Foo, fOO, etc.
> are all valid spellings, then presumably they don't actually expect
> "foo" to go away.  They may, however, want the name shown in readdir
> to change, so maybe RENAME_HARDLINK should do that, too.

That's a separate case, though also useful for case retentive file syst=
ems.
If you did want to support that, i.e. when src and dst are the same dir=
ectory entry,
though spelled differently, then you might have another flag.
Or you could combine both functions to a RENAME_ALIAS flag?

thanks,
P=C3=A1draig.
