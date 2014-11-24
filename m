From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCHv10 2/5] x86: Hook up execveat system call.
Date: Mon, 24 Nov 2014 20:06:26 +0300
Message-ID: <20141124170626.GA5316@mwanda>
References: <1416830039-21952-1-git-send-email-drysdale@google.com>
 <1416830039-21952-3-git-send-email-drysdale@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1416830039-21952-3-git-send-email-drysdale@google.com>
Sender: sparclinux-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Oleg Nesterov <oleg@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>, Christoph Hellwig <hch@infradead.org>, x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 24, 2014 at 11:53:56AM +0000, David Drysdale wrote:
> Hook up x86-64, i386 and x32 ABIs.
>=20
> Signed-off-by: David Drysdale <drysdale@google.com>

This one has been breaking my linux-next build for the past week.  I'm
not sure what's going on.  I build with a script:

make allmodconfig

cat << EOF >> .config
CONFIG_DYNAMIC_DEBUG=3Dn
CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=3Dn
CONFIG_DYNAMIC_DEBUG=3Dy
EOF

make oldconfig

Here are the errors:

  CHK     include/generated/compile.h
  CHECK   arch/x86/ia32/audit.c
  CC      arch/x86/ia32/audit.o
arch/x86/ia32/audit.c: In function =E2=80=98ia32_classify_syscall=E2=80=
=99:
arch/x86/ia32/audit.c:38:7: error: =E2=80=98__NR_execveat=E2=80=99 unde=
clared (first use in this function)
arch/x86/ia32/audit.c:38:7: note: each undeclared identifier is reporte=
d only once for each function it appears in
make[2]: *** [arch/x86/ia32/audit.o] Error 1
make[2]: Target `__build' not remade because of errors.
make[1]: *** [arch/x86/ia32] Error 2
  CHECK   arch/x86/kernel/audit_64.c
  CHK     kernel/config_data.h
  CC      arch/x86/kernel/audit_64.o
arch/x86/kernel/audit_64.c: In function =E2=80=98audit_classify_syscall=
=E2=80=99:
arch/x86/kernel/audit_64.c:53:7: error: =E2=80=98__NR_execveat=E2=80=99=
 undeclared (first use in this function)
arch/x86/kernel/audit_64.c:53:7: note: each undeclared identifier is re=
ported only once for each function it appears in
make[2]: *** [arch/x86/kernel/audit_64.o] Error 1
make[2]: Target `__build' not remade because of errors.
make[1]: *** [arch/x86/kernel] Error 2
make[1]: Target `__build' not remade because of errors.

regards,
dan carpenter
--
To unsubscribe from this list: send the line "unsubscribe sparclinux" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
