From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 03/20] asm-generic: Drop getrlimit and setrlimit syscalls
 from default list
Date: Tue, 20 Jun 2017 17:27:36 +0200
Message-ID: <CAK8P3a1rXfrXotJa=mZf3cJu+WVWHKWjTMk8FA16xnkGvU0MmQ@mail.gmail.com>
References: <20170619155003.13218-1-ynorov@caviumnetworks.com>
 <20170619155003.13218-4-ynorov@caviumnetworks.com>
 <20170619214223.GS6973@jhogan-linux.le.imgtec.org>
 <CAK8P3a0M2TkoUY4KBgmtnh3NDNj-oSNOpVagHVFuFBEYnAYp8Q@mail.gmail.com>
 <20170619221023.GT6973@jhogan-linux.le.imgtec.org>
 <20170620133714.j2e3z535xsmphusl@yury-thinkpad>
 <CAK8P3a0kSe_EcZ=5Dq=Pvtth4tTNiNaa=_=rCvaie4jzF58dNw@mail.gmail.com>
 <20170620145451.y72j77rbcni27dus@yury-thinkpad>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170620145451.y72j77rbcni27dus@yury-thinkpad>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: linux-doc@vger.kernel.org, szabolcs.nagy@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Chris Metcalf <cmetcalf@ezchip.com>, linux@lists.openrisc.net, linux-hexagon@vger.kernel.org, Philipp Tomsich <philipp.tomsich@theobroma-systems.com>, Joseph Myers <joseph@codesourcery.com>, linux-arch <linux-arch@vger.kernel.org>, Chen Liqin <liqin.linux@gmail.com>, zhouchengming1@huawei.com, Guan Xuetao <gxt@mprc.pku.edu.cn>, Steve Ellcey <sellcey@caviumnetworks.com>, linux-c6x-dev@linux-c6x.org, Yoshinori Sato <ysato@users.sourceforge.jp>, Prasun Kapoor <Prasun.Kapoor@caviumnetworks.com>, Andreas Schwab <schwab@suse.de>, Aurelien Jacquiot <a-jacquiot@ti.com>, Alexander Graf <agraf@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Lennox Wu <lennox.wu@gmail.com>, Mark Salter <msalter@redhat.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 20, 2017 at 4:54 PM, Yury Norov <ynorov@caviumnetworks.com> wrote:
> On Tue, Jun 20, 2017 at 04:20:43PM +0200, Arnd Bergmann wrote:
>> On Tue, Jun 20, 2017 at 3:37 PM, Yury Norov <ynorov@caviumnetworks.com> wrote:
>> > On Mon, Jun 19, 2017 at 11:10:23PM +0100, James Hogan wrote:
>> >> On Mon, Jun 19, 2017 at 11:58:41PM +0200, Arnd Bergmann wrote:

>> > I would also notice riscv people and welcome to the discussion.
>> >
>> > As there is more than 1 arch that goes to be added to linux soon,
>> > maybe it's better to upstream my ans James' patches separately
>> > from other ilp32 patches? Arnd?
>>
>> Do you mean upstream those two patches slightly later? That's
>> fine with me, I don't care much whether the old new stat is part
>> of the syscall table for arm64-ilp32 or not, I'd leave that up to
>> you, depending on whether you want to do the rework or not.
>
> I mean that if we want to deprecate rlimit and stat syscalls for
> architectures that are under development now, it's better to upstream
> patches that actually deprecate it as early as possible.

Makes sense.

>> I suppose the arm64-ilp32 could benefit from not having to support
>> the old arm32 stat structure, but doing the new syscalls based on
>> statx could delay the glibc port some more, as there are some open
>> questions about how that would best be integrated.
>
> OK. Let's leave things as is. But then I don't see any reason to
> add unxstat patch to ilp32 series if ilp32 will not disable it.

Right, that's what I meant: let's leave the rlimit patch in your series
as it matches the work you have already done, and is the right
thing to do, and let's do the unxstat patch separately so it doesn't
cause you extra work.

        Arnd
