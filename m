From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: RFC: renameat(): Add a RENAME_REMOVE flag to unlink hardlinks
Date: Fri, 21 Nov 2014 14:40:37 -0800
Message-ID: <CALCETrW0c1UzkVQgEE_je5BtVhdWRmNaYk4HCQk+t6AWvpC-FA@mail.gmail.com>
References: <546F4981.8080907@draigBrady.com> <CALCETrXvVxvG+s39v+NMdvfkeb8YjbYjb6UXgDFg5ifYOjeKsA@mail.gmail.com>
 <546F86F5.6070305@draigBrady.com> <CALCETrVf_7g_njnFGQx=xFwn=FyY851nnp0vmKFSmV=TusSOkQ@mail.gmail.com>
 <546FA51F.40503@draigBrady.com> <546FAC18.5020200@redhat.com>
 <CALCETrUByDgug68FP=cnj-iwSXvbEEHp=S4a=WhQPFmuKc2pNw@mail.gmail.com>
 <546FBAC6.6020407@draigBrady.com> <20141121223018.GV7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20141121223018.GV7996@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>, Eric Blake <eblake@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 21, 2014 at 2:30 PM, Al Viro <viro@zeniv.linux.org.uk> wrot=
e:
> On Fri, Nov 21, 2014 at 10:20:54PM +0000, P=C3=A1draig Brady wrote:
>
>> >> That said, would you still like me to take a stab at a proposal t=
o the
>> >> POSIX folks that would relax the requirements to allow
>> >> implementation-defined behavior when the two arguments to rename
>> >> describe the same file but via different directory entries?
>>
>> I guess there is no point discussing in POSIX and adding extra
>> implementation options if no implementations do/will act accordingly=
=2E
>>
>> Linux can decide to do that independently, if appropriate.
>> This is one of those borderline cases where we balance
>> accretion of cruft vs incompatibility.
>> On consideration, I'm OK with keeping the existing
>> rename() behavior for compat and adding the new flag.
>> That said I still can't think of anything depending
>> rename() doing nothing with hardlinked source and dest.
>
> You do realize that it opens a very nasty can of worms for filesystem=
s that
> are e.g. case-insensitive to some extent?  How do you tell links from
> alternative equivalent spellings of the name?

I assume that VFS can handle this correctly if it wants to.

OTOH, if someone does rename("foo", "Foo"), and foo, Foo, fOO, etc.
are all valid spellings, then presumably they don't actually expect
"foo" to go away.  They may, however, want the name shown in readdir
to change, so maybe RENAME_HARDLINK should do that, too.

--Andy

--=20
Andy Lutomirski
AMA Capital Management, LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
