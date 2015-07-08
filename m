From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH V3 2/5] mm: mlock: Add new mlock, munlock, and munlockall
 system calls
Date: Wed, 8 Jul 2015 09:02:25 +0200
Message-ID: <CAMuHMdUS72nYDo=chtcZMv-ZNVU0RhxvVLvMYvSFLtRk_wXrgw@mail.gmail.com>
References: <1436288623-13007-1-git-send-email-emunson@akamai.com>
	<1436288623-13007-3-git-send-email-emunson@akamai.com>
	<20150708064607.GB7079@osiris>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ia64-owner@vger.kernel.org>
In-Reply-To: <20150708064607.GB7079@osiris>
Sender: linux-ia64-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Eric B Munson <emunson@akamai.com>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Vlastimil Babka <vbabka@suse.cz>, alpha <linux-alpha@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "adi-buildroot-devel@lists.sourceforge.net" <adi-buildroot-devel@lists.sourceforge.net>, Cris <linux-cris-kernel@axis.com>, "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>, linux-m68k <linux-m68k@lists.linux-m68k.org>, Linux MIPS Mailing List <linux-mips@linux-mips.org>, "moderated list:PANASONIC MN10300..." <linux-am33-list@redhat.com>, Parisc List <linux-parisc@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, linux-s390 <linux-s390@vger.kernel.org>, Linux-sh list <linux-sh@vger.kernel.org>, sparclinux
List-Id: linux-api@vger.kernel.org

On Wed, Jul 8, 2015 at 8:46 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
>> diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
>> index 1acad02..f6d81d6 100644
>> --- a/arch/s390/kernel/syscalls.S
>> +++ b/arch/s390/kernel/syscalls.S
>> @@ -363,3 +363,6 @@ SYSCALL(sys_bpf,compat_sys_bpf)
>>  SYSCALL(sys_s390_pci_mmio_write,compat_sys_s390_pci_mmio_write)
>>  SYSCALL(sys_s390_pci_mmio_read,compat_sys_s390_pci_mmio_read)
>>  SYSCALL(sys_execveat,compat_sys_execveat)
>> +SYSCALL(sys_mlock2,compat_sys_mlock2)                        /* 355 */
>> +SYSCALL(sys_munlock2,compat_sys_munlock2)
>> +SYSCALL(sys_munlockall2,compat_sys_munlockall2)
>
> FWIW, you would also need to add matching lines to the two files
>
> arch/s390/include/uapi/asm/unistd.h
> arch/s390/kernel/compat_wrapper.c
>
> so that the system call would be wired up on s390.

Similar comment for m68k:

arch/m68k/include/asm/unistd.h
arch/m68k/include/uapi/asm/unistd.h

I think you best look at the last commits that added system calls, for all
architectures, to make sure you don't do partial updates.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
