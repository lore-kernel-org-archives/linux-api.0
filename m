From: Thorsten Glaser <tg-vpiyNrvJqjezQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] Use __unused0 instead of __unused for user visible struct
 member names
Date: Mon, 11 Nov 2013 14:59:12 +0000 (UTC)
Message-ID: <Pine.BSM.4.64L.1311111448490.23723__43621.1307337091$1384182717$gmane$org@herc.mirbsd.org>
References: <20120102024418.GA10483@gaara.hadrons.org>
 <20120102202243.GA31103@elie.hsd1.il.comcast.net> <20120103065659.GA32216@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120103065659.GA32216-OoSGOWW0KRunlFQ6Q1D1Y0B+6BGkLq7r@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sam Ravnborg <public-sam-uyr5N9Q2VtJg9hUCZPvPmw-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>
Cc: Jonathan Nieder <public-jrnieder-Re5JQEeQqe8AvxtiuMwx3w-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Guillem Jover <public-guillem-+FW4gsLVM0RAfugRpC6u6w-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, public-linux-kernel-u79uwXL29TY76Z2rM5mHXA-wOFGN7rlS/M9smdsby/KFg@public.gmane.org, public-linux-kbuild-u79uwXL29TY76Z2rM5mHXA-wOFGN7rlS/M9smdsby/KFg@public.gmane.org, public-linux-api-u79uwXL29TY76Z2rM5mHXA-wOFGN7rlS/M9smdsby/KFg@public.gmane.org, Michal Marek <public-mmarek-AlSwsSmVLrQ-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>, Justin Cormack <justin-7CuHE+YKekf/05JY2t+omGXnswh1EIUO@public.gmane.org>
List-Id: linux-api@vger.kernel.org




Sam Ravnborg dixit:

>> Guillem Jover wrote:

>> > On BSD systems __unused has traditionally been defined to mean the
>> > equivalent of gcc's __attribute__((__unused__)), some parts of the
[=E2=80=A6]
>^__ is reserved for libc internal stuff and there is no reason to
>name the unused/padding members "__unused".

Considering that glibc has seen the light=C2=B9 now too, can we please
do something about these now? The BSD tools (not just NetBSD=C2=AE) hav=
e
been using this for far longer after all=E2=80=A6


Currently (git pull --ff torvalds master), we have:

=E2=80=A2 2 occurrences of files *inside* the Linux kernel defining __u=
nused
  to=C2=B2 __attribute__((unused)) themselves

=E2=80=A2 68 struct members and function arguments called __unused

>So one or a set of patches that rename them all to something more
>sensible would be fine.

I think __unused0 is okay as it matches current __unused[0-9] in
use by other parts of the Linux kernel =E2=80=93 although glibc now use=
s
__glibc_reserved[0-9], I think this doesn=E2=80=99t look like the Linux
kernel should use it =E2=98=BB=E2=98=BA


=E2=91=A0 http://thread.gmane.org/gmane.comp.lib.glibc.alpha/36439

=E2=91=A1 I=E2=80=99ve recently come to the belief that this should be
  __attribute__((__unused__)) in all cases, i.e. all those
  attribute namings need double underscores before and after,
  as some software likes to #define printf to something else,
  lighttpd does #define bounded something else, so there=E2=80=99s
  probably software out there containing #define unused foo.
