From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
Subject: Re: RFC: renameat(): Add a RENAME_REMOVE flag to unlink hardlinks
Date: Fri, 21 Nov 2014 18:39:49 +0000
Message-ID: <546F86F5.6070305@draigBrady.com>
References: <546F4981.8080907@draigBrady.com> <CALCETrXvVxvG+s39v+NMdvfkeb8YjbYjb6UXgDFg5ifYOjeKsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXvVxvG+s39v+NMdvfkeb8YjbYjb6UXgDFg5ifYOjeKsA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 21/11/14 18:09, Andy Lutomirski wrote:
> On Fri, Nov 21, 2014 at 6:17 AM, P=C3=A1draig Brady <P@draigbrady.com=
> wrote:
>> If 'a' and 'b' are hardlinks, then the command `mv a b & mv b a`
>> can result in both being removed as mv needs to emulate the
>> move with an unlink of the source file.  This can only be done
>> without races in the kernel and so mv was recently changed
>> to not allow this operation at all.  mv could safely reintroduce
>> this feature by leveraging a new flag for renameat() for which
>> an illustrative/untested patch is attached.
>=20
> ISTM the issue is that rename(2) does nothing if the source and dest
> are hardlinks to each other.  Is that intentional?  I don't see that
> behavior as required in the POSIX rename docs.

It's surprising and annoying that existing systems do this,
but they're conforming to the wording of POSIX I thinkg as
it says that rename() does nothing when the source and dest
_file_ is the same. What POSIX really meant I suppose was _file name_.
Eric, perhaps an adjustment could be proposed to POSIX, as I can't
see anything relying on the current behavior?

> If we indeed need to keep that behavior around for legacy reasons,
> then can we at least give RENAME_REMOVE a better name?

Definitely not attached to the name :)
Let's see if we can change it without a flag, though I guess
that would mean that mv on older systems would
silently do nothing in this case.

thanks,
P=C3=A1draig.
