From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: RFC: renameat(): Add a RENAME_REMOVE flag to unlink hardlinks
Date: Fri, 21 Nov 2014 11:55:55 -0800
Message-ID: <CALCETrVf_7g_njnFGQx=xFwn=FyY851nnp0vmKFSmV=TusSOkQ@mail.gmail.com>
References: <546F4981.8080907@draigBrady.com> <CALCETrXvVxvG+s39v+NMdvfkeb8YjbYjb6UXgDFg5ifYOjeKsA@mail.gmail.com>
 <546F86F5.6070305@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <546F86F5.6070305@draigBrady.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 21, 2014 at 10:39 AM, P=C3=A1draig Brady <P@draigbrady.com>=
 wrote:
> On 21/11/14 18:09, Andy Lutomirski wrote:
>> On Fri, Nov 21, 2014 at 6:17 AM, P=C3=A1draig Brady <P@draigbrady.co=
m> wrote:
>>> If 'a' and 'b' are hardlinks, then the command `mv a b & mv b a`
>>> can result in both being removed as mv needs to emulate the
>>> move with an unlink of the source file.  This can only be done
>>> without races in the kernel and so mv was recently changed
>>> to not allow this operation at all.  mv could safely reintroduce
>>> this feature by leveraging a new flag for renameat() for which
>>> an illustrative/untested patch is attached.
>>
>> ISTM the issue is that rename(2) does nothing if the source and dest
>> are hardlinks to each other.  Is that intentional?  I don't see that
>> behavior as required in the POSIX rename docs.
>
> It's surprising and annoying that existing systems do this,
> but they're conforming to the wording of POSIX I thinkg as
> it says that rename() does nothing when the source and dest
> _file_ is the same. What POSIX really meant I suppose was _file name_=
=2E
> Eric, perhaps an adjustment could be proposed to POSIX, as I can't
> see anything relying on the current behavior?

Which Eric?

--Andy

>
>> If we indeed need to keep that behavior around for legacy reasons,
>> then can we at least give RENAME_REMOVE a better name?
>
> Definitely not attached to the name :)
> Let's see if we can change it without a flag, though I guess
> that would mean that mv on older systems would
> silently do nothing in this case.
>
> thanks,
> P=C3=A1draig.
>



--=20
Andy Lutomirski
AMA Capital Management, LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
