From: Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 050/160] prctl: add PR_SET_PROCTITLE_AREA option for prctl()
Date: Mon, 08 Mar 2010 21:21:55 -0800
Message-ID: <4B95DAF3.5050605@redhat.com>
References: <201003052142.o25Lgbpg029522@imap1.linux-foundation.org> <20100306095705.GA26221@infradead.org> <20100309134105.7CDB.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100309134105.7CDB.A69D9226-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tss-X3B1VOXEql0@public.gmane.org, xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/08/2010 08:44 PM, KOSAKI Motohiro wrote:
> I don't think this is big matter. Does using syscall have any benefit=
?
> I don't have strong mention. merely, Timo's original proposal used
> prctl.

Syscalls don't have to go through the multiplexer in grab bag calls lik=
e
prctl, ioctl, etc.  And they are more reliably to test for at runtime.
An ENOSYS error is unmistakably clear.  An EINVAL error, as returned by
prctl when encountering an unknown function argument, could also mean
the argument isn't valid.  That's a common problem of most multiplexer
syscalls and a reason why they should be avoided.

- --=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro S=
t =E2=9E=A7 Mountain View, CA =E2=9D=96
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuV2vMACgkQ2ijCOnn/RHTRYgCeJd0O3O71jHtvGhvOG5Ax2oxP
I5UAnjujkQBlHxFzXqhsEMavsaVVsEBf
=3DPnMs
-----END PGP SIGNATURE-----
