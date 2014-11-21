From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: RFC: renameat(): Add a RENAME_REMOVE flag to unlink hardlinks
Date: Fri, 21 Nov 2014 10:09:21 -0800
Message-ID: <CALCETrXvVxvG+s39v+NMdvfkeb8YjbYjb6UXgDFg5ifYOjeKsA@mail.gmail.com>
References: <546F4981.8080907@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546F4981.8080907-V8g9lnOeT5ydJdNcDFJN0w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 21, 2014 at 6:17 AM, P=C3=A1draig Brady <P@draigbrady.com> =
wrote:
> If 'a' and 'b' are hardlinks, then the command `mv a b & mv b a`
> can result in both being removed as mv needs to emulate the
> move with an unlink of the source file.  This can only be done
> without races in the kernel and so mv was recently changed
> to not allow this operation at all.  mv could safely reintroduce
> this feature by leveraging a new flag for renameat() for which
> an illustrative/untested patch is attached.

ISTM the issue is that rename(2) does nothing if the source and dest
are hardlinks to each other.  Is that intentional?  I don't see that
behavior as required in the POSIX rename docs.

If we indeed need to keep that behavior around for legacy reasons,
then can we at least give RENAME_REMOVE a better name?

--Andy

>
> thanks,
> P=C3=A1draig.



--=20
Andy Lutomirski
AMA Capital Management, LLC
