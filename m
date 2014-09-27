From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: Re: [PATCH v2] next: openrisc: Fix build
Date: Sat, 27 Sep 2014 07:13:36 +0300
Message-ID: <20140927041334.GA16373@chokladfabriken.org>
References: <1411747539-28308-1-git-send-email-linux@roeck-us.net>
	<5425A7B5.10209@southpole.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bounces@lists.openrisc.net>
Content-Disposition: inline
In-Reply-To: <5425A7B5.10209@southpole.se>
List-Unsubscribe: <http://lists.openrisc.net/options/linux>,
	<mailto:linux-request@lists.openrisc.net?subject=unsubscribe>
List-Archive: <http://lists.openrisc.net/pipermail/linux>
List-Post: <mailto:linux@lists.openrisc.net>
List-Help: <mailto:linux-request@lists.openrisc.net?subject=help>
List-Subscribe: <http://lists.openrisc.net/listinfo/linux>,
	<mailto:linux-request@lists.openrisc.net?subject=subscribe>
Sender: linux-bounces@lists.openrisc.net
Errors-To: linux-bounces@lists.openrisc.net
To: Jonas Bonn <jonas@southpole.se>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>, linux-next@vger.kernel.org, linux@lists.openrisc.net, Guenter Roeck <linux@roeck-us.net>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 26, 2014 at 07:51:49PM +0200, Jonas Bonn wrote:
> On 09/26/2014 06:05 PM, Guenter Roeck wrote:
> > openrisc:defconfig fails to build in next-20140926 with the following error.
> >
> > In file included from arch/openrisc/kernel/signal.c:31:0:
> > ./arch/openrisc/include/asm/syscall.h: In function 'syscall_get_arch':
> > ./arch/openrisc/include/asm/syscall.h:77:9: error: 'EM_OPENRISC' undeclared
> >
> > Fix by moving EM_OPENRISC to include/uapi/linux/elf-em.h.
> >
> > Fixes: ce5d112827e5 ("ARCH: AUDIT: implement syscall_get_arch for all arches")
> > Cc: Eric Paris <eparis@redhat.com>
> > Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > v2: Only move EM_OPENRISC.
> >
> > Another possible solution for the problem would be to include asm/elf.h
> > in arch/openrisc/kernel/signal.c. I had actually submitted a patch with
> > that fix back in August (maybe that is where I remembered the problem from).
> > Wonder what happened with that patch.
> >
> > Would it make sense to drop EM_OR32 and replace it with EM_OPENRISC where
> > it is used ? binutils seems to suggest that EM_OPENRISC is the "official"
> > definition.
> 
> Do we even use EM_OR32?  Will the kernel build with the old toolchain if
> we drop it?  If yes, drop it altogether... I don't recall the details as
> to why we kept that define around at all.  And really, why bother
> supporting the old toolchain at all... it's been at least two or three
> years since EM_OPENRISC was added, hopefully people have moved on.  If
> users want to upgrade their kernel, they can update the toolchain, too,
> at this point.
> 

EM_OPENRISC was added about ten years ago, and when the OR32 things in binutils
was removed in favour for OR1K earlier this year,
EM_OR1K was added as an alias to EM_OPENRISC.

With that said, I'm putting in a vote for removing EM_OR32 as well.

Stefan
