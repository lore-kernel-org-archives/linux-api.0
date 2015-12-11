From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] capabilities.7, prctl.2: Document ambient capabilities
Date: Fri, 11 Dec 2015 20:18:07 +0100
Message-ID: <566B216F.6060501@gmail.com>
References: <3721cd96525af4cb0a671e9a36ac6402c8e5379a.1446594067.git.luto@kernel.org> <5661AC50.3070300@gmail.com> <CALCETrXLDA3bPtZJjCa0P61jwZLYVzS5axfMRW82Yu-w1avPsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXLDA3bPtZJjCa0P61jwZLYVzS5axfMRW82Yu-w1avPsw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/04/2015 05:12 PM, Andy Lutomirski wrote:
> On Fri, Dec 4, 2015 at 7:08 AM, Michael Kerrisk (man-pages)
> <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi Andy,
>>
>> I have applied your patch (below). Thanks for writing it.
>> But I have a question or two and a request.
>>
>> =3D=3D=3D
>>
>> In the capabilities(7) page tehre is the longstanding text:
>>
>>        An  application  can use the following call to lock itself, a=
nd
>>        all of its descendants, into an environment where the only  w=
ay
>>        of  gaining capabilities is by executing a program with assoc=
i=E2=80=90
>>        ated file capabilities:
>>
>>            prctl(PR_SET_SECUREBITS,
>>                    SECBIT_KEEP_CAPS_LOCKED |
>>                    SECBIT_NO_SETUID_FIXUP |
>>                    SECBIT_NO_SETUID_FIXUP_LOCKED |
>>                    SECBIT_NOROOT |
>>                    SECBIT_NOROOT_LOCKED);
>>
>> As far as I can estimate, no changes are needed here to include
>> SECBIT_NO_CAP_AMBIENT_RAISE and SECBIT_NO_CAP_AMBIENT_RAISE_LOCKED
>> in the above prctl() call, but could you confirm please?
>=20
> Correct.  I'll probably write up a patch to suggest that doing this i=
s
> a poor idea on a conventional distro, though, and I'll explain why.  =
I
> suppose than deleting this would be an option, too.

Ping! :-)


>> =3D=3D=3D
>>
>> In the message for kernel commit
>> 58319057b7847667f0c9585b9de0e8932b0fdb08
>> you included this text:
>>
>> [[
>> Because capability inheritance is so
>> broken, setting KEEPCAPS, using setresuid to switch to nonroot uids,=
 and
>> then calling execve effectively drops capabilities.  Therefore,
>> setresuid from root to nonroot conditionally clears pA unless
>> SECBIT_NO_SETUID_FIXUP is set.  Processes that don't like this can
>> re-add bits to pA afterwards.
>> ]]
>>
>> I'm struggling to understand the significance of this text,
>> especially as your man-pages patch makes no mention of this point.
>>
>> The thing is, that text ("Therefore...") implies that there's
>> something special going on beyond the rules already documented
>> elsewhere. I mean, according to the rules aly documented elsewhere
>> in the page:
>=20
> Whoops, I forgot to add that to the manpage.
>=20
>>
>> (1) If a process with UIDs of 0 sets all its UIDs
>> nonzero, then, the permitted and effective sets are cleared
>> (that's the classical behavior), and because the permitted
>> set is cleared, then so is the ambient set.
>>
>> (2) And if we set SECBIT_NO_SETUID_FIXUP then
>> a UID 0 =3D=3D> nonzero transition doesn't clear permitted and
>> effective sets, and then of course the ambient set is not
>> cleared.
>>
>> So, what additional point were you meaning to convey in
>> the commit message? (Maybe it was just cruft in the commit
>> message, but if not, can you explain precisely the arguments
>> for setresuid() that are supposed to generate the special
>> behavior described by the above text.)
>=20
> It's case (1b), which is like (1) but with KEEPCAPS set.  The
> permitted set doesn't get cleared, but the ambient set is still
> cleared.
>=20
> I'll write a manpage patch.

Ping :-)

(Make these separate patches please.)

Thanks,

Michael


--=20
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
