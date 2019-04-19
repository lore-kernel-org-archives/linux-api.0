From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v2] moduleparam: Save information about built-in modules
 in separate file
Date: Fri, 19 Apr 2019 12:03:50 +0900
Message-ID: <CAK7LNARxT7a5-C4-ZuKYWOWyuDdMVzkd-n8C8vdO1MEw10TsJA@mail.gmail.com>
References: <20190406121447.GB4047@localhost.localdomain> <CAK7LNATfo0K6kzwobkAZ_u2KnWL3XycJzbr3KPtPF=ePziCuDg@mail.gmail.com>
 <20190418135238.GA5626@linux-8ccs> <CAK7LNARKHXLgniczKXY01JhxhBpL2p-X_hWg70AcsrXRaLyDSg@mail.gmail.com>
 <20190418153611.GB5626@linux-8ccs>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190418153611.GB5626@linux-8ccs>
Sender: linux-kernel-owner@vger.kernel.org
To: Jessica Yu <jeyu@kernel.org>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-api@vger.kernel.org, linux-modules@vger.kernel.org, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>, "Dmitry V. Levin" <ldv@altlinux.org>, Michal Marek <michal.lkml@markovi.net>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>, Lucas De Marchi <lucas.de.marchi@gmail.com>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 19, 2019 at 12:36 AM Jessica Yu <jeyu@kernel.org> wrote:
>
> +++ Masahiro Yamada [19/04/19 00:26 +0900]:
> >On Thu, Apr 18, 2019 at 10:52 PM Jessica Yu <jeyu@kernel.org> wrote:
> >>
> >> +++ Masahiro Yamada [18/04/19 20:10 +0900]:
> >> >On Sat, Apr 6, 2019 at 9:15 PM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
> >> >>
> >> >> Problem:
> >> >>
> >> >> When a kernel module is compiled as a separate module, some important
> >> >> information about the kernel module is available via .modinfo section of
> >> >> the module.  In contrast, when the kernel module is compiled into the
> >> >> kernel, that information is not available.
> >> >>
> >> >> Information about built-in modules is necessary in the following cases:
> >> >>
> >> >> 1. When it is necessary to find out what additional parameters can be
> >> >> passed to the kernel at boot time.
> >> >>
> >> >> 2. When you need to know which module names and their aliases are in
> >> >> the kernel. This is very useful for creating an initrd image.
> >> >>
> >> >> Proposal:
> >> >>
> >> >> The proposed patch does not remove .modinfo section with module
> >> >> information from the vmlinux at the build time and saves it into a
> >> >> separate file after kernel linking. So, the kernel does not increase in
> >> >> size and no additional information remains in it. Information is stored
> >> >> in the same format as in the separate modules (null-terminated string
> >> >> array). Because the .modinfo section is already exported with a separate
> >> >> modules, we are not creating a new API.
> >> >>
> >> >> It can be easily read in the userspace:
> >> >>
> >> >> $ tr '\0' '\n' < kernel.builtin
> >> >> ext4.softdep=pre: crc32c
> >> >> ext4.license=GPL
> >> >> ext4.description=Fourth Extended Filesystem
> >> >> ext4.author=Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others
> >> >> ext4.alias=fs-ext4
> >> >> ext4.alias=ext3
> >> >> ext4.alias=fs-ext3
> >> >> ext4.alias=ext2
> >> >> ext4.alias=fs-ext2
> >> >> md_mod.alias=block-major-9-*
> >> >> md_mod.alias=md
> >> >> md_mod.description=MD RAID framework
> >> >> md_mod.license=GPL
> >> >> md_mod.parmtype=create_on_open:bool
> >> >> md_mod.parmtype=start_dirty_degraded:int
> >> >> ...
> >> >>
> >> >> v2:
> >> >>  * Extract modinfo from vmlinux.o as suggested by Masahiro Yamada;
> >> >>  * Rename output file to kernel.builtin;
> >> >
> >> >Sorry, I do not get why you renamed
> >> >"kernel.builtin.modinfo" to "kernel.builtin".
> >> >
> >> >If you drop "modinfo", we do not understand
> >> >what kind information is contained in it.
> >> >
> >> >I think "kernel" and "builtin" have
> >> >a quite similar meaning here.
> >> >
> >> >How about "builtin.modinfo" for example?
> >> >
> >> >
> >> >It is shorter, and it is clear enough
> >> >that it contains module_info.
> >>
> >> I agree that the name kernel.builtin is unclear in what kind of
> >> information it contains. Apologies for not having clarified this in
> >> the previous review.
> >>
> >> Since kbuild already produces "modules.order" and "modules.builtin"
> >> files, why not just name it "modules.builtin.modinfo" to keep the
> >> names consistent with what is already there?
> >
> >
> >Is it consistent?
> >
> >If we had "modules.order" and "modules.builtin.order" there,
> >I would agree with "modules.builtin.modinfo",
> >and also "modules.alias" vs "modules.builtin.alias".
> >
> >
> >We already have "modules.builtin", and probably impossible
> >to rename it, so we cannot keep consistency in any way.
> >
> >
> >"modules.builtin" is a weird name since
> >it actually contains "order", but its extension
> >does not express what kind of information is in it.
> >Hence, I doubt "modules.builtin" is a good precedent.
> >
> >IMHO, "modules" and "builtin" are opposite
> >to each other. "modules.builtin" sounds iffy to me.
>
> I've always interpreted "modules.builtin" to mean "this is a list of
> modules that have been built-in into the kernel", no? So I thought the
> name made sense.

OK, I see.

> But you are the maintainer, so I do not have a strong
> opinion on this either way :-)

My idea was to use
'modules.<file-type>'  vs  'builtin.<file-type>'
instead of
'modules.<file-type>'  vs  'modules.builtin.<file-type>'

I am slightly in favor of the former
since it is shorter and
(I hope) still clear enough.

If this naming is not nice for external projects such as kmod,
please speak up.


(BTW, I am thinking of renaming 'modules.builtin' into 'builtin.order'
for kbuild internal. We cannot change that for the installation area, though.)

>
> Thanks,
>
> Jessica



-- 
Best Regards
Masahiro Yamada
