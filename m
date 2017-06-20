From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH 03/20] asm-generic: Drop getrlimit and setrlimit syscalls
 from default list
Date: Tue, 20 Jun 2017 17:36:35 +0300
Message-ID: <20170620143635.nb4iy6fwhedlshcz@yury-thinkpad>
References: <20170619155003.13218-1-ynorov@caviumnetworks.com>
 <20170619155003.13218-4-ynorov@caviumnetworks.com>
 <20170619214223.GS6973@jhogan-linux.le.imgtec.org>
 <CAK8P3a0M2TkoUY4KBgmtnh3NDNj-oSNOpVagHVFuFBEYnAYp8Q@mail.gmail.com>
 <20170619221023.GT6973@jhogan-linux.le.imgtec.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170619221023.GT6973@jhogan-linux.le.imgtec.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-doc@vger.kernel.org, szabolcs.nagy@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Chris Metcalf <cmetcalf@ezchip.com>, linux@lists.openrisc.net, linux-hexagon@vger.kernel.org, Philipp Tomsich <philipp.tomsich@theobroma-systems.com>, Joseph Myers <joseph@codesourcery.com>, linux-arch <linux-arch@vger.kernel.org>, Chen Liqin <liqin.linux@gmail.com>, zhouchengming1@huawei.com, Guan Xuetao <gxt@mprc.pku.edu.cn>, Steve Ellcey <sellcey@caviumnetworks.com>, linux-c6x-dev@linux-c6x.org, Yoshinori Sato <ysato@users.sourceforge.jp>, Prasun Kapoor <Prasun.Kapoor@caviumnetworks.com>, Andreas Schwab <schwab@suse.de>, Aurelien Jacquiot <a-jacquiot@ti.com>, Alexander Graf <agraf@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Lennox Wu <lennox.wu@gmail.com>, Mark Salter <msalter@redhat.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 19, 2017 at 11:10:23PM +0100, James Hogan wrote:
> On Mon, Jun 19, 2017 at 11:58:41PM +0200, Arnd Bergmann wrote:
> > On Mon, Jun 19, 2017 at 11:42 PM, James Hogan <james.hogan@imgtec.com> wrote:
> > > On Mon, Jun 19, 2017 at 06:49:46PM +0300, Yury Norov wrote:
> > > Subject: [PATCH] Deprecate stat syscalls superseded by statx
> > >
> > > Various stat system calls can now be implemented as userland wrappers
> > > around the new statx system call, so allow them to be removed from the
> > > kernel by default for new architectures / ABIs.
> > >
> > > This involves adding __ARCH_WANT_SYSCALL_UNXSTAT to each existing
> > > architecture, which enables the relevant stat system calls in the
> > > generic system call list (if used). It also conditionally defines the
> > > syscalls in fs/stat.c and struct stat / struct stat64 in
> > > asm-generic/stat.h.
> > >
> > > Signed-off-by: James Hogan <james.hogan@imgtec.com>
> > > Cc: David Howells <dhowells@redhat.com>
> > > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > Cc: linux-fsdevel@vger.kernel.org
> > > Cc: linux-arch@vger.kernel.org
> > > Cc: linux-api@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > 
> > Good idea:
> > 
> > Acked-by:  Arnd Bergmann <arnd@arndb.de>
> 
> Thanks,
> 
> > 
> > > +/* statx deprecates the un-extended stat syscalls which use struct stat[64] */
> > > +#ifdef __ARCH_WANT_SYSCALL_UNXSTAT
> > 
> > I'm glad you explain what 'UNXSTAT' means here, since I would not
> > have otherwise guessed it, but I also can't think of anything more
> > intuitive.
> 
> Yeh, I renamed that several times while playing around with this :-).
> 
> The stat syscalls remind me a bit of the Vicar of Dibley episode where
> the new road named "New Road" necessitates the renaming of the existing
> "New Road" to "Quite Old Road" and "Quite Old Road" to "Really Quite Old
> Road" and "Old Road" to "Very Old Road"!
> 
> Cheers
> James

(Add Palmer Dabbelt <palmer@dabbelt.com>)

The stat syscalls are full of hacks, and we have to pull that hacks
even to new architectures to deal with stat. So I'll be happy to drop
it in arm64/ilp32. But it means that I need some time to integrate
your patch and fix glibc accordingly. And it also means that we need
round 9 for ilp32... :(

Arnd, once before you told that generic unistd has some duplications
and legacy syscalls, and one day we'll have to deal with it. Do you
have the list or something on it?

I would also notice riscv people and welcome to the discussion.  

As there is more than 1 arch that goes to be added to linux soon,
maybe it's better to upstream my ans James' patches separately
from other ilp32 patches? Arnd?

Yury
