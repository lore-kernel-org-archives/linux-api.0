From: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [Qemu-devel] d_off field in struct dirent and 32-on-64 emulation
Date: Sat, 29 Dec 2018 00:12:27 +0000
Message-ID: <CAFEAcA8Yq=CEyAUer1TcaSzuzcdNi3OUi4c67B6e+OkhmcKvbg@mail.gmail.com>
References: <87bm56vqg4.fsf@mid.deneb.enyo.de> <CAFEAcA92m4vhzjJ+B=mP_o6Wfhx1XSKo3uWxah3osh=u5UXFuw@mail.gmail.com>
 <9C6A7D45-CF53-4C61-B5DD-12CA0D419972@dilger.ca> <CAFEAcA9W+JK7_TrtTnL1P2ES1knNPJX9wcUvhfLwxLq9augq1w@mail.gmail.com>
 <1EF1B31A-83D8-4642-BEBF-F56E45485223@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <libc-alpha-return-98852-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <1EF1B31A-83D8-4642-BEBF-F56E45485223@dilger.ca>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Florian Weimer <fw@deneb.enyo.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>, Eric Van Hensbergen <ericvh@gmail.com>, hpa@zytor.com, lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>, QEMU Developers <qemu-devel@nongnu.org>, rminnich@sandia.gov, v9fs-developer@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org

On Fri, 28 Dec 2018 at 23:16, Andreas Dilger <adilger@dilger.ca> wrot
> On Dec 28, 2018, at 4:18 AM, Peter Maydell <peter.maydell@linaro.org> wrote:
> > The problem is that there is no 32-bit API in some cases
> > (unless I have misunderstood the kernel code) -- not all
> > host architectures implement compat syscalls or allow them
> > to be called from 64-bit processes or implement all the older
> > syscall variants that had smaller offets. If there was a guaranteed
> > "this syscall always exists and always gives me 32-bit offsets"
> > we could use it.
>
> The "32bitapi" mount option would use 32-bit hash for seekdir
> and telldir, regardless of what kernel API was used.  That would
> just set the FMODE_32BITHASH flag in the file->f_mode for all files.

A mount option wouldn't be much use to QEMU -- we can't tell
our users how to mount their filesystems, which they're
often doing lots of other things with besides running QEMU.
(Otherwise we could just tell them "don't use ext4", which
would also solve the problem :-)) We need something we can
use at the individual-syscall level.

thanks
-- PMM
