From: =?UTF-8?Q?Ren=c3=a9_Nyffenegger?= <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>
Subject: Re: [PATCH] Use pid_t instead of int
Date: Mon, 9 May 2016 06:15:46 +0200
Message-ID: <57300EF2.7030303@renenyffenegger.ch>
References: <572F959A.7090209@renenyffenegger.ch>
 <CALCETrVyT6R6mYnVuv9vqmeCC7_TB2KZPCqfcmMyLvjbZPs+Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVyT6R6mYnVuv9vqmeCC7_TB2KZPCqfcmMyLvjbZPs+Ag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Steven Rostedt (Red Hat)" <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Somewhere else, pid_t is a typedef for an int.

Rene

On 09.05.2016 03:25, Andy Lutomirski wrote:
> On Sun, May 8, 2016 at 12:38 PM, Ren=C3=A9 Nyffenegger
> <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org> wrote:
>> Use pid_t instead of int in the declarations of sys_kill, sys_tgkill=
,
>> sys_tkill and sys_rt_sigqueueinfo in include/linux/syscalls.h
>=20
> The description is no good.  *Why* are you changing it?
>=20
> I checked tgkill and, indeed, tgkill takes pid_t parameters, so this
> fixes an incorrect declaration.  I'm wondering why the code compiles
> without warning.  Is SYSCALL_DEFINE too lenient for some reason?  Or
> is pid_t just defined as int.
>=20
> --Andy
>=20
