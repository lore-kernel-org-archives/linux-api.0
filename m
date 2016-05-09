From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] Use pid_t instead of int
Date: Sun, 8 May 2016 18:25:48 -0700
Message-ID: <CALCETrVyT6R6mYnVuv9vqmeCC7_TB2KZPCqfcmMyLvjbZPs+Ag@mail.gmail.com>
References: <572F959A.7090209@renenyffenegger.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <572F959A.7090209@renenyffenegger.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, Al Viro <viro@zeniv.linux.org.uk>, "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>, Zach Brown <zab@redhat.com>, Milosz Tanski <milosz@adfin.com>, Arnd Bergmann <arnd@arndb.de>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, May 8, 2016 at 12:38 PM, Ren=C3=A9 Nyffenegger
<mail@renenyffenegger.ch> wrote:
> Use pid_t instead of int in the declarations of sys_kill, sys_tgkill,
> sys_tkill and sys_rt_sigqueueinfo in include/linux/syscalls.h

The description is no good.  *Why* are you changing it?

I checked tgkill and, indeed, tgkill takes pid_t parameters, so this
fixes an incorrect declaration.  I'm wondering why the code compiles
without warning.  Is SYSCALL_DEFINE too lenient for some reason?  Or
is pid_t just defined as int.

--Andy
