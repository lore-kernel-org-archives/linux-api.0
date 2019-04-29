From: Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v3] moduleparam: Save information about built-in modules
 in separate file
Date: Mon, 29 Apr 2019 16:21:56 +0200
Message-ID: <20190429142156.GA31567@linux-8ccs>
References: <20190429090854.GU9023@dhcp129-178.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190429090854.GU9023@dhcp129-178.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, linux-api@vger.kernel.org, linux-modules@vger.kernel.org, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>, "Dmitry V. Levin" <ldv@altlinux.org>, Michal Marek <michal.lkml@markovi.net>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>, Lucas De Marchi <lucas.de.marchi@gmail.com>
List-Id: linux-api@vger.kernel.org

+++ Alexey Gladkov [29/04/19 11:08 +0200]:
>Problem:
>
>When a kernel module is compiled as a separate module, some important
>information about the kernel module is available via .modinfo section of
>the module.  In contrast, when the kernel module is compiled into the
>kernel, that information is not available.
>
>Information about built-in modules is necessary in the following cases:
>
>1. When it is necessary to find out what additional parameters can be
>passed to the kernel at boot time.
>
>2. When you need to know which module names and their aliases are in
>the kernel. This is very useful for creating an initrd image.
>
>Proposal:
>
>The proposed patch does not remove .modinfo section with module
>information from the vmlinux at the build time and saves it into a
>separate file after kernel linking. So, the kernel does not increase in
>size and no additional information remains in it. Information is stored
>in the same format as in the separate modules (null-terminated string
>array). Because the .modinfo section is already exported with a separate
>modules, we are not creating a new API.
>
>It can be easily read in the userspace:
>
>$ tr '\0' '\n' < kernel.builtin

s/kernel.builtin/modules.builtin.modinfo/

Otherwise, for module.h and moduleparam.h:

Acked-by: Jessica Yu <jeyu@kernel.org>

And it would be great if Lucas can confirm if the file format and name
would be OK for kmod.

Thanks!

Jessica
