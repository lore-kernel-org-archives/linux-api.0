From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCHv4 man-pages 3/3] open.2: describe O_BENEATH flag
Date: Fri, 14 Aug 2015 10:29:08 +0100
Message-ID: <CAHse=S9HdriyqKrQRj=x3CpEFftPgVFX7p8B9efu9_mQtEvJSA@mail.gmail.com>
References: <1439458366-8223-1-git-send-email-drysdale@google.com>
 <1439458366-8223-4-git-send-email-drysdale@google.com> <CALCETrWusE9CbQ6A1iqgBVjei-_JWL4o4ezS14JLEAbrGJmaNg@mail.gmail.com>
 <CAKgNAkj+fZJnzKbHb8UvZg-0kNfB7MQHQYoAz-dVhnkso0Uq2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgNAkj+fZJnzKbHb8UvZg-0kNfB7MQHQYoAz-dVhnkso0Uq2A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Meredydd Luff <meredydd@senatehouse.org>, Will Drewry <wad@chromium.org>, Jorge Lucangeli Obes <jorgelo@google.com>, Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>, Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>, James Morris <james.l.morris@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vge>
List-Id: linux-api@vger.kernel.org

On Fri, Aug 14, 2015 at 6:33 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> On 13 August 2015 at 19:38, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Thu, Aug 13, 2015 at 2:32 AM, David Drysdale <drysdale@google.com> wrote:
>>> Signed-off-by: David Drysdale <drysdale@google.com>
>>
>> What's the behavior wrt fcntl(F_GETFL, etc)?
>
> I would presume that O_BENEATH is one of the so-called "file creation
> flags". See this paragraph of the DESCRIPTION:
>
>        In addition, zero or more file creation  flags  and  file  status
>        flags  can be bitwise-or'd in flags.  The file creation flags are
>        O_CLOEXEC, O_CREAT, O_DIRECTORY,  O_EXCL,  O_NOCTTY,  O_NOFOLLOW,
>        O_TMPFILE,  O_TRUNC,  and  O_TTY_INIT.  The file status flags are
>        all of the remaining flags listed below.  The distinction between
>        these  two  groups  of flags is that the file status flags can be
>        retrieved and (in some cases) modified; see fcntl(2) for details.
>
> David, presuming this is correct (I can't see how O_BENEATH could be a
> "file *status* flag"), your patch should also add O_BENEATH to the
> list in that paragraph.

Yeah, O_BENEATH makes sense as a file creation flag; I'll add it
to that list -- thanks for spotting.

> Cheers,
>
> Michael
>
>
>
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/
