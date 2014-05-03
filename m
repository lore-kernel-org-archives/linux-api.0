From: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>
Subject: Re: execve is not atomic, what is the exit state of the process when
 execve fails after throwing away the original process image?
Date: Sat, 03 May 2014 22:18:52 +0000 (GMT)
Message-ID: <faa0c9e9297ad.53656b4c@langara.bc.ca>
References: <faa2c0e82f8a8.536300c8@langara.bc.ca>
 <20140503174510.GA7720@debjann.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-disposition: inline
Content-language: en
In-reply-to: <20140503174510.GA7720-7cfQGs147y6a6lf8Wg2v7Z5kstrrjoWp@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Thank you Jann
Horn. http://lxr.free-electrons.com/source/fs/binfmt_elf.c#L740
answers my question.

On reflection, the kernel code makes sense. The process must either
exit with an error code or raise the SIGKILL signal because SIGKILL
and SIGSTOP are the only unblockable signals (of course, the kernel
has the privileges to do whatever it wants but it tries to be
consistent with userspace).

Strangely, in other places the SIGSEGV is sent when the ELF file is
incorrect in some places and I don't fully understand that part of the
code. Still, I understand enough to look at the code in more detail
later.

Thank you,
Steven Stewart-Gallus

P.S.

I'm CC'ing Michael because he wanted to know this case so could
document it.

----- Original Message -----
=46rom: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Date: Saturday, May 3, 2014 10:45 am
Subject: Re: execve is not atomic, what is the exit state of the proces=
s when
execve fails after throwing away the original process image?
To: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> On Fri, May 02, 2014 at 02:19:52AM +0000, Steven Stewart-Gallus wrote=
:
> > execve is not atomic, what is the exit state of the process when
> > execve fails after throwing away the original process image?
>=20
> See http://lxr.free-electrons.com/source/fs/binfmt_elf.c#L740 or
> so =96 as far as I know, the kernel sends a SIGKILL. Does that help?
>=20
