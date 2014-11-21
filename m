From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: RFC: renameat(): Add a RENAME_REMOVE flag to unlink hardlinks
Date: Fri, 21 Nov 2014 13:29:28 -0800
Message-ID: <CALCETrUByDgug68FP=cnj-iwSXvbEEHp=S4a=WhQPFmuKc2pNw@mail.gmail.com>
References: <546F4981.8080907@draigBrady.com> <CALCETrXvVxvG+s39v+NMdvfkeb8YjbYjb6UXgDFg5ifYOjeKsA@mail.gmail.com>
 <546F86F5.6070305@draigBrady.com> <CALCETrVf_7g_njnFGQx=xFwn=FyY851nnp0vmKFSmV=TusSOkQ@mail.gmail.com>
 <546FA51F.40503@draigBrady.com> <546FAC18.5020200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546FAC18.5020200-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 21, 2014 at 1:18 PM, Eric Blake <eblake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 11/21/2014 01:48 PM, P=C3=A1draig Brady wrote:
>> On 21/11/14 19:55, Andy Lutomirski wrote:
>>> On Fri, Nov 21, 2014 at 10:39 AM, P=C3=A1draig Brady <P@draigbrady.=
com> wrote:
>>>> On 21/11/14 18:09, Andy Lutomirski wrote:
>>>>> On Fri, Nov 21, 2014 at 6:17 AM, P=C3=A1draig Brady <P@draigbrady=
=2Ecom> wrote:
>>>>>> If 'a' and 'b' are hardlinks, then the command `mv a b & mv b a`
>>>>>> can result in both being removed as mv needs to emulate the
>>>>>> move with an unlink of the source file.  This can only be done
>>>>>> without races in the kernel and so mv was recently changed
>>>>>> to not allow this operation at all.  mv could safely reintroduce
>>>>>> this feature by leveraging a new flag for renameat() for which
>>>>>> an illustrative/untested patch is attached.
>>>>>
>>>>> ISTM the issue is that rename(2) does nothing if the source and d=
est
>>>>> are hardlinks to each other.  Is that intentional?  I don't see t=
hat
>>>>> behavior as required in the POSIX rename docs.
>
> Yes, POSIX unfortunately requires that behavior:
>
> http://pubs.opengroup.org/onlinepubs/9699919799/functions/rename.html
>
> "If the old argument and the new argument resolve to either the same
> existing directory entry or different directory entries for the same
> existing file, rename() shall return successfully and perform no othe=
r
> action."
>
>>>>
>>>> It's surprising and annoying that existing systems do this,
>>>> but they're conforming to the wording of POSIX I thinkg as
>>>> it says that rename() does nothing when the source and dest
>>>> _file_ is the same. What POSIX really meant I suppose was _file na=
me_.
>>>> Eric, perhaps an adjustment could be proposed to POSIX, as I can't
>>>> see anything relying on the current behavior?
>
> The POSIX wording describes existing practice of all implementations,
> and as annoying as it is, requiring all implementations to change wou=
ld
> be too invasive, and going against that wording without the use of an
> extension to renameat would catch software off-guard that is expectin=
g
> the baked-in POSIX semantics.
>
> That said, would you still like me to take a stab at a proposal to th=
e
> POSIX folks that would relax the requirements to allow
> implementation-defined behavior when the two arguments to rename
> describe the same file but via different directory entries?  Note tha=
t I
> am NOT proposing a change to rename("a", "a") which must always succe=
ed
> (true even when two spellings are different but still resolve to the
> same directory entry, as in rename("a", "./a")).  Rather, this is onl=
y a
> question about the behavior of rename("a", "b") when they are two
> different hardlinks resolving to the same file.
>
> At any rate, regardless of what POSIX says, I'm totally in favor of a
> renameat flag that gives us fine-tune control over the behavior; we c=
an
> implement it now as an extension, and once it hits mainline kernel, I
> would have no problems proposing that flag for POSIX standardization
> (the POSIX folks have a thing for preferring existing implementations=
,
> after all)

renameat has no flags -- this would be renameat2.  Standardizing that
might be quite nice (at least the RENAME_NOREPLACE part).

My two cents: the new flag could be RENAME_HARDLINKS.

--Andy

>
> --
> Eric Blake   eblake redhat com    +1-919-301-3266
> Libvirt virtualization library http://libvirt.org
>



--=20
Andy Lutomirski
AMA Capital Management, LLC
