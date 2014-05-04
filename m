From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: execve is not atomic, what is the exit state of the process when
 execve fails after throwing away the original process image?
Date: Sun, 04 May 2014 21:27:01 +0200
Message-ID: <53669485.3020007@gmail.com>
References: <faa2c0e82f8a8.536300c8@langara.bc.ca> <20140503174510.GA7720@debjann.fritz.box> <faa0c9e9297ad.53656b4c@langara.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <faa0c9e9297ad.53656b4c-BTv7Ps/Sm75C8prJL3GQQw@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[CC+=3DRich Felker, because the discussion started with a reference to
http://ewontfix.com/14/ ]

On 05/04/2014 12:18 AM, Steven Stewart-Gallus wrote:
>=20
> ----- Original Message -----
> From: Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>
> Date: Saturday, May 3, 2014 10:45 am
> Subject: Re: execve is not atomic, what is the exit state of the proc=
ess when
> execve fails after throwing away the original process image?
> To: Steven Stewart-Gallus <sstewartgallus00-QKvm5KDIoDa7M0a00MdBSQ@public.gmane.org>
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>=20
>> On Fri, May 02, 2014 at 02:19:52AM +0000, Steven Stewart-Gallus wrot=
e:
>>> execve is not atomic, what is the exit state of the process when
>>> execve fails after throwing away the original process image?
>>
>> See http://lxr.free-electrons.com/source/fs/binfmt_elf.c#L740 or
>> so =96 as far as I know, the kernel sends a SIGKILL. Does that help?
>
> Thank you Jann
> Horn. http://lxr.free-electrons.com/source/fs/binfmt_elf.c#L740
> answers my question.
>=20
> On reflection, the kernel code makes sense. The process must either
> exit with an error code or raise the SIGKILL signal because SIGKILL
> and SIGSTOP are the only unblockable signals (of course, the kernel
> has the privileges to do whatever it wants but it tries to be
> consistent with userspace).
>=20
> Strangely, in other places the SIGSEGV is sent when the ELF file is
> incorrect in some places and I don't fully understand that part of th=
e
> code. Still, I understand enough to look at the code in more detail
> later.
>=20
> Thank you,
> Steven Stewart-Gallus
>=20
> P.S.
>=20
> I'm CC'ing Michael because he wanted to know this case so could
> document it.

=46air enough. I plan to add the following text to the execve(2) man
page:

       In most cases where execve()  fails,  control  returns  to  the
       original  executable image, and the caller of execve() can then
       handle the error.  However, in (rare) cases  (typically  caused
       by resource exhaustion), failure may occur past the point of no
       return: the original exectable image has been  torn  down,  but
       the  new  image  could not be completely built.  In such cases,
       the kernel kills the process with a SIGKILL signal.

Comments?

Cheers,

Michael




--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
