From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Add a pair of system calls to make extended file stats available [ver #3]
Date: Fri, 09 Jul 2010 14:59:06 +0100
Message-ID: <21105.1278683946@redhat.com>
References: <AANLkTikP-u1adVItGDgUZdee14Z13k8MLRC5V7UN-gpV@mail.gmail.com> <20100630233614.32422.97038.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <AANLkTikP-u1adVItGDgUZdee14Z13k8MLRC5V7UN-gpV@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Michael Kerrisk <mtk.manpages@gmail.com> wrote:

> > =A0 =A0 =A0 =A0struct xstat_parameters {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long long =A0 =A0 =A0reques=
t_mask;
>=20
> Poor name, since it's a value-result arg? Better maybe something like
> "field_mask"?

No.  The contents of xstat_parameters aren't changed.  request_mask is =
what
you're asking for, result_mask in the xstat struct is what you actually=
 got.

result_mask may be more or less than request_mask as the filesystem isn=
't
obliged to supply anything you didn't ask for, and may not be able to s=
upply
something you did ask for, and may give you stuff anyway that you didn'=
t ask
for if it's trivial to do so.

> There is no XSTAT_REQUEST__GET_ANYWAY, AFAICS. I guess here you meant
> XSTAT_REQUEST__EXTENDED_STATS? Or?

Yep.  I forgot to change that in the patch description.

> This case is almost certainly a user error, so why not simply return
> an error (-1 and ERANGE or E2BIG)? The above approach invites
> userspace errors of the form:
>=20
> if (xtat(...) < 0) { /* How users often check for error */
>     /* I'll handle the error */
> } else {
>     /* The call succeeded; I'm fine */
> }

I suppose.

> If you are looking for a way to inform the user about the required
> buffer size, I think it would be better to take a leaf from the
> getxattr(2) book: if 'buflen' is zero, then do nothing with the outpu=
t
> arg, but return the size that would be required.

That's reasonable.

David
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
