From: David Drysdale <drysdale@google.com>
Subject: Re: [PATCHv10 2/5] x86: Hook up execveat system call.
Date: Mon, 24 Nov 2014 18:26:24 +0000
Message-ID: <CAHse=S-DS=NGC619Uhzkbd-EKa0D+HgBq3rE1czmLdoxAFswPg@mail.gmail.com>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
 <1416830039-21952-3-git-send-email-drysdale@google.com> <20141124170626.GA5316@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20141124170626.GA5316@mwanda>
Sender: sparclinux-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>, Christoph Hellwig <hch@infradead.org>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 24, 2014 at 5:06 PM, Dan Carpenter <dan.carpenter@oracle.co=
m> wrote:
> On Mon, Nov 24, 2014 at 11:53:56AM +0000, David Drysdale wrote:
>> Hook up x86-64, i386 and x32 ABIs.
>>
>> Signed-off-by: David Drysdale <drysdale@google.com>
>
> This one has been breaking my linux-next build for the past week.  I'=
m
> not sure what's going on.

Hi Dan,

Sorry if this has been causing you problems -- I've not had any
errors from the kbuild robots or my local builds.

> I build with a script:
>
> make allmodconfig
>
> cat << EOF >> .config
> CONFIG_DYNAMIC_DEBUG=3Dn
> CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=3Dn
> CONFIG_DYNAMIC_DEBUG=3Dy
> EOF
>
> make oldconfig
>
> Here are the errors:
>
>   CHK     include/generated/compile.h
>   CHECK   arch/x86/ia32/audit.c
>   CC      arch/x86/ia32/audit.o
> arch/x86/ia32/audit.c: In function =E2=80=98ia32_classify_syscall=E2=80=
=99:
> arch/x86/ia32/audit.c:38:7: error: =E2=80=98__NR_execveat=E2=80=99 un=
declared (first use in this function)
> arch/x86/ia32/audit.c:38:7: note: each undeclared identifier is repor=
ted only once for each function it appears in
> make[2]: *** [arch/x86/ia32/audit.o] Error 1
> make[2]: Target `__build' not remade because of errors.
> make[1]: *** [arch/x86/ia32] Error 2
>   CHECK   arch/x86/kernel/audit_64.c
>   CHK     kernel/config_data.h
>   CC      arch/x86/kernel/audit_64.o
> arch/x86/kernel/audit_64.c: In function =E2=80=98audit_classify_sysca=
ll=E2=80=99:
> arch/x86/kernel/audit_64.c:53:7: error: =E2=80=98__NR_execveat=E2=80=99=
 undeclared (first use in this function)
> arch/x86/kernel/audit_64.c:53:7: note: each undeclared identifier is =
reported only once for each function it appears in
> make[2]: *** [arch/x86/kernel/audit_64.o] Error 1
> make[2]: Target `__build' not remade because of errors.
> make[1]: *** [arch/x86/kernel] Error 2
> make[1]: Target `__build' not remade because of errors.

That seems odd -- the generic definition of __NR_execveat is in the fir=
st
patch in the series, and the various x86-specific definitions should ge=
t
generated from the table entries in the second patch in the series (at
least since the v9 set I sent on 19 Nov, which split out the x86 wiring
from the general implementation).

Are the syscall table generation steps happening in your build?  And do=
es
__NR_execveat appear in the various generated x86 unistd*.h headers?

As an aside, I've just built next-20141124 (a4cfa44aa26a) fine from
scratch with your config steps.   The build output included the header
generation steps:

  SYSTBL  arch/x86/syscalls/../include/generated/asm/syscalls_32.h
  SYSHDR  arch/x86/syscalls/../include/generated/asm/unistd_32_ia32.h
  SYSHDR  arch/x86/syscalls/../include/generated/asm/unistd_64_x32.h
  SYSTBL  arch/x86/syscalls/../include/generated/asm/syscalls_64.h
  SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_32.h
  HOSTCC  scripts/basic/bin2c
  SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_64.h
  SYSHDR  arch/x86/syscalls/../include/generated/uapi/asm/unistd_x32.h

and the resulting files did include the __NR_execveat constant:

  % grep execveat usr/include/asm*/*.h arch/x86/include/generated/uapi/=
asm/*.h
  usr/include/asm-generic/unistd.h:#define __NR_execveat 281
  usr/include/asm-generic/unistd.h:__SC_COMP(__NR_execveat,
sys_execveat, compat_sys_execveat)
  usr/include/asm/unistd_32.h:#define __NR_execveat 358
  usr/include/asm/unistd_64.h:#define __NR_execveat 322
  usr/include/asm/unistd_x32.h:#define __NR_execveat (__X32_SYSCALL_BIT=
 + 545)
  arch/x86/include/generated/uapi/asm/unistd_32.h:#define __NR_execveat=
 358
  arch/x86/include/generated/uapi/asm/unistd_64.h:#define __NR_execveat=
 322
  arch/x86/include/generated/uapi/asm/unistd_x32.h:#define
__NR_execveat (__X32_SYSCALL_BIT + 545)

So I can't (yet) reproduce your problem I'm afraid...

> regards,
> dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe sparclinux" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
