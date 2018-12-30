From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [Qemu-devel] d_off field in struct dirent and 32-on-64 emulation
Date: Sun, 30 Dec 2018 13:59:17 +0000
Message-ID: <CAFEAcA_gV734EAxDii8XBOPr82kLYtsZmW5jYfQnT_DEpGOkpQ@mail.gmail.com>
References: <87bm56vqg4.fsf@mid.deneb.enyo.de> <CAFEAcA92m4vhzjJ+B=mP_o6Wfhx1XSKo3uWxah3osh=u5UXFuw@mail.gmail.com>
 <9C6A7D45-CF53-4C61-B5DD-12CA0D419972@dilger.ca> <CAFEAcA9W+JK7_TrtTnL1P2ES1knNPJX9wcUvhfLwxLq9augq1w@mail.gmail.com>
 <1EF1B31A-83D8-4642-BEBF-F56E45485223@dilger.ca> <CAFEAcA8Yq=CEyAUer1TcaSzuzcdNi3OUi4c67B6e+OkhmcKvbg@mail.gmail.com>
 <20181229015453.GA6310@bombadil.infradead.org> <CALCETrUJn4cV+o3scP1EzYS=JA--5KUXvjuxZDbsnhXra1vrwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <libc-alpha-return-98868-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <CALCETrUJn4cV+o3scP1EzYS=JA--5KUXvjuxZDbsnhXra1vrwA@mail.gmail.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Andreas Dilger <adilger@dilger.ca>, Florian Weimer <fw@deneb.enyo.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, libc-alpha <libc-alpha@sourceware.org>, Arnd Bergmann <arnd@arndb.de>, Eric Van Hensbergen <ericvh@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, Ron Minnich <rminnich@sandia.gov>, V9FS Developers <v9fs-developer@lists.sourceforge.net>
List-Id: linux-api@vger.kernel.org

On Sat, 29 Dec 2018 at 16:49, Andy Lutomirski <luto@kernel.org> wrote:
> > Could you use a prctl to set whether you were running in 32 or 64 bit
> > mode?  Or do you change which kind of task you're emulating too often
> > to make this a good idea?

QEMU's linux-user mode always only runs the single process,
which is a fixed guest architecture. But it also wants to
make system calls on its own behalf, as well as the ones it
is passing through from the guest, and I suspect it would
confuse the host libc if we changed the semantics of those
under its feet.

> How would this work?  We already have the separate
> COMPAT_DEFINE_SYSCALL entries *and* in_compat_syscall(). Now we=E2=80=99d=
 have
> a third degree of freedom.
>
> Either the arches people care about should add reasonable ways to
> issue 32-bit syscalls from 64-bit mode or there should be an explicit
> way to ask for the 32-bit directory offsets.

The first of those is not sufficient for QEMU if done
as a per-architecture thing, because there may not even be
a 32-bit syscall interface on the host kernel. The second
sounds better -- there's nothing conceptually architecture
specific about what we want to do or which is tied to the
idea of whether there's a 32-bit compat mode in the host
architecture or not.

thanks
-- PMM
