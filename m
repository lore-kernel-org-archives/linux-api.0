From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 03/20] asm-generic: Drop getrlimit and setrlimit syscalls
 from default list
Date: Mon, 19 Jun 2017 23:58:41 +0200
Message-ID: <CAK8P3a0M2TkoUY4KBgmtnh3NDNj-oSNOpVagHVFuFBEYnAYp8Q@mail.gmail.com>
References: <20170619155003.13218-1-ynorov@caviumnetworks.com>
 <20170619155003.13218-4-ynorov@caviumnetworks.com>
 <20170619214223.GS6973@jhogan-linux.le.imgtec.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170619214223.GS6973@jhogan-linux.le.imgtec.org>
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
Cc: linux-doc@vger.kernel.org, szabolcs.nagy@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Chris Metcalf <cmetcalf@ezchip.com>, Yury Norov <ynorov@caviumnetworks.com>, linux@lists.openrisc.net, linux-hexagon@vger.kernel.org, Philipp Tomsich <philipp.tomsich@theobroma-systems.com>, Joseph Myers <joseph@codesourcery.com>, linux-arch <linux-arch@vger.kernel.org>, Chen Liqin <liqin.linux@gmail.com>, zhouchengming1@huawei.com, Guan Xuetao <gxt@mprc.pku.edu.cn>, Steve Ellcey <sellcey@caviumnetworks.com>, linux-c6x-dev@linux-c6x.org, Yoshinori Sato <ysato@users.sourceforge.jp>, Prasun Kapoor <Prasun.Kapoor@caviumnetworks.com>, Andreas Schwab <schwab@suse.de>, Aurelien Jacquiot <a-jacquiot@ti.com>, Alexander Graf <agraf@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Lennox Wu <lennox.wu@gm>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 19, 2017 at 11:42 PM, James Hogan <james.hogan@imgtec.com> wrote:
> Hi Yury,
>
> On Mon, Jun 19, 2017 at 06:49:46PM +0300, Yury Norov wrote:
>> The newer prlimit64 syscall provides all the functionality provided by
>> the getrlimit and setrlimit syscalls and adds the pid of target process,
>> so future architectures won't need to include getrlimit and setrlimit.
>>
>> Therefore drop getrlimit and setrlimit syscalls from the generic syscall
>> list unless __ARCH_WANT_SET_GET_RLIMIT is defined by the architecture's
>> unistd.h prior to including asm-generic/unistd.h, and adjust all architectures
>> using the generic syscall list to define it so that no in-tree architectures
>> are affected.
>
> I have a similar experimental patch lying around for the stat system
> calls which are superseded by statx (see below). If it looks acceptable
> maybe you'd like to incorporate it (or something similar) into your
> series.
>
> Cheers
> James
>
> ---
> From: James Hogan <james.hogan@imgtec.com>
> Date: Fri, 2 Jun 2017 13:07:27 +0100
> Subject: [PATCH] Deprecate stat syscalls superseded by statx
>
> Various stat system calls can now be implemented as userland wrappers
> around the new statx system call, so allow them to be removed from the
> kernel by default for new architectures / ABIs.
>
> This involves adding __ARCH_WANT_SYSCALL_UNXSTAT to each existing
> architecture, which enables the relevant stat system calls in the
> generic system call list (if used). It also conditionally defines the
> syscalls in fs/stat.c and struct stat / struct stat64 in
> asm-generic/stat.h.
>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Cc: linux-api@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Good idea:

Acked-by:  Arnd Bergmann <arnd@arndb.de>

> +/* statx deprecates the un-extended stat syscalls which use struct stat[64] */
> +#ifdef __ARCH_WANT_SYSCALL_UNXSTAT

I'm glad you explain what 'UNXSTAT' means here, since I would not
have otherwise guessed it, but I also can't think of anything more
intuitive.

         Arnd
