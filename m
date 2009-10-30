From: Ulrich Drepper <drepper@gmail.com>
Subject: Re: F_SETOWN_EX and F_GETLK64 conflict
Date: Thu, 29 Oct 2009 20:21:02 -0700
Message-ID: <a36005b50910292021y392075d5lddc620e3bdfc3ede@mail.gmail.com>
References: <Pine.LNX.4.64.0910041229300.20203@digraph.polyomino.org.uk>
	<1254691822.21044.9.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754965AbZJ3D2L@vger.kernel.org>
In-Reply-To: <1254691822.21044.9.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Joseph S. Myers" <joseph@codesourcery.com>, linux-api@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Oleg Nesterov <onestero@redhat.com>, Stephane Eranian <eranian@googlemail.com>, Michael Kerrisk <mtk.manpages@googlemail.com>, Roland McGrath <roland@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
List-Id: linux-api@vger.kernel.org

On Sun, Oct 4, 2009 at 14:30, Peter Zijlstra <a.p.zijlstra@chello.nl> w=
rote:
> =C2=A0arch/alpha/include/asm/fcntl.h | =C2=A0 =C2=A04 ++--
> =C2=A0include/asm-generic/fcntl.h =C2=A0 =C2=A0| =C2=A0 19 ++++++++++=
+--------
> =C2=A02 files changed, 13 insertions(+), 10 deletions(-)

This patch looks fine:

Acked-by: Ulrich Drepper <drepper@redhat.com>


Linus, can you please apply it in whatever form so that we know the
value of the constants?
