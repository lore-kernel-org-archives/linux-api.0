From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH v9 00/24] ILP32 for ARM64
Date: Mon, 19 Nov 2018 21:29:01 +0000
Message-ID: <20181119212852.GA16961@yury-thinkpad>
References: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180516081910.10067-1-ynorov@caviumnetworks.com>
Content-Language: en-US
Content-ID: <EDA80B37E563BB4FBA8648C4DC453712@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Cc: Adam Borowski <kilobyte@angband.pl>, Alexander Graf <agraf@suse.de>, Alexey Klimov <klimov.linux@gmail.com>, Andreas Schwab <schwab@suse.de>, Andrew Pinski <pinskia@gmail.com>, Bamvor Zhangjian <bamv2005@gmail.com>, Chris Metcalf <cmetcalf@mellanox.com>, Christoph Muellner <christoph.muellner@theobroma-systems.com>, Dave Martin <Dave.Martin@arm.com>, "David S . Miller" <davem@davemloft.net>, Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, James Morse <james.morse@arm.com>, Joseph Myers <joseph@codesourcery.com>, Lin Yongting <linyongting@huawei.com>, Manuel Montezelo <manuel.montezelo@gmail.com>, Mark Brown <broonie@kernel.org>
List-Id: linux-api@vger.kernel.org

Hi all,

On Wed, May 16, 2018 at 11:18:45AM +0300, Yury Norov wrote:
> This series enables AARCH64 with ILP32 mode.
>=20
> As supporting work, it introduces ARCH_32BIT_OFF_T configuration
> option that is enabled for existing 32-bit architectures but disabled
> for new arches (so 64-bit off_t userspace type is used by new userspace).
> Also it deprecates getrlimit and setrlimit syscalls prior to prlimit64.
>=20
> Based on kernel v4.16. Tested with LTP, glibc testsuite, trinity, lmbench=
,
> CPUSpec.
>=20
> This series on github:=20
> https://github.com/norov/linux/tree/ilp32-4.16
> Linaro toolchain:
> http://snapshots.linaro.org/components/toolchain/binaries/7.3-2018.04-rc1=
/aarch64-linux-gnu_ilp32/
> Debian repo:
> http://people.linaro.org/~wookey/ilp32/
> OpenSUSE repo:
> https://build.opensuse.org/project/show/devel:ARM:Factory:Contrib:ILP32
>=20
> Changes:
> v3: https://lkml.org/lkml/2014/9/3/704
> v4: https://lkml.org/lkml/2015/4/13/691
> v5: https://lkml.org/lkml/2015/9/29/911
> v6: https://lkml.org/lkml/2016/5/23/661
> v7: https://lkml.org/lkml/2017/1/9/213
> v8: https://lkml.org/lkml/2017/6/19/624
> v9: - rebased on top of v4.16;
>     - signal subsystem reworked to avoid code duplication, as requested
>       by Dave Martin (patches 18 and 20);
>     - new files introduced in series use SPDX notation for license;
>     - linux-api and linux-arch CCed as the series changes kernel ABI;
>     - checkpatch and other minor fixes.
>     - Zhou Chengming's reported-by for patch 2 and signed-off-by for
>       patch 21 removed because his email became invalid. Zhou, please
>       share your new email.

This is the 4.19-based update:
https://github.com/norov/linux/tree/ilp32-4.19

Syscall machinery is rewritten in C in mainline kernel, ILP32 is aligned
with it. The following patches are mostly affected:

arm64: ilp32: introduce ilp32-specific sigframe and ucontext
arm64: signal32: move ilp32 and aarch32 common code to separated file
arm64: signal: share lp64 signal structures and routines to ilp32
arm64: ilp32: introduce syscall table for ILP32
arm64: ilp32: share aarch32 syscall handlers

4.18 branch from Catalin is here:
https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=3Dst=
aging/ilp32-4.18

Yury
