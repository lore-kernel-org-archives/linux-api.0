From: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Mon, 11 Jan 2016 17:35:13 -0500
Message-ID: <20160111223513.GA10796@packer-debian-8-amd64.digitalocean.com>
References: <1452281304-28618-1-git-send-email-jeyu@redhat.com>
 <1452281304-28618-5-git-send-email-jeyu@redhat.com>
 <20160111213349.GB17874@treble.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160111213349.GB17874-8wJ5/zUtDR0XGNroddHbYwC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vojtech Pavlik <vojtech-IBi9RG/b67k@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

+++ Josh Poimboeuf [11/01/16 15:33 -0600]:
>On Fri, Jan 08, 2016 at 02:28:22PM -0500, Jessica Yu wrote:
>> Reuse module loader code to write relocations, thereby eliminating the need
>> for architecture specific relocation code in livepatch. Namely, we reuse
>> apply_relocate_add() in the module loader to write relocations instead of
>> duplicating functionality in livepatch's klp_write_module_reloc(). To apply
>> relocation sections, remaining SHN_LIVEPATCH symbols referenced by relocs
>> are resolved and then apply_relocate_add() is called to apply those
>> relocations.
>>
>> In addition, remove x86 livepatch relocation code. It is no longer needed
>> since symbol resolution and relocation work have been offloaded to module
>> loader.
>>
>> Signed-off-by: Jessica Yu <jeyu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  arch/x86/include/asm/livepatch.h |   2 -
>>  arch/x86/kernel/Makefile         |   1 -
>>  arch/x86/kernel/livepatch.c      |  70 ---------------------------
>>  include/linux/livepatch.h        |  33 +++++--------
>>  kernel/livepatch/core.c          | 101 +++++++++++++++++++--------------------
>>  5 files changed, 62 insertions(+), 145 deletions(-)
>>  delete mode 100644 arch/x86/kernel/livepatch.c
>>
>> diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
>> index 19c099a..7312e25 100644
>> --- a/arch/x86/include/asm/livepatch.h
>> +++ b/arch/x86/include/asm/livepatch.h
>> @@ -33,8 +33,6 @@ static inline int klp_check_compiler_support(void)
>>  #endif
>>  	return 0;
>>  }
>> -int klp_write_module_reloc(struct module *mod, unsigned long type,
>> -			   unsigned long loc, unsigned long value);
>>
>>  static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
>>  {
>> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
>> index b1b78ff..c5e9a5c 100644
>> --- a/arch/x86/kernel/Makefile
>> +++ b/arch/x86/kernel/Makefile
>> @@ -67,7 +67,6 @@ obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
>>  obj-y				+= apic/
>>  obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
>>  obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
>> -obj-$(CONFIG_LIVEPATCH)		+= livepatch.o
>>  obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
>>  obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
>>  obj-$(CONFIG_X86_TSC)		+= trace_clock.o
>> diff --git a/arch/x86/kernel/livepatch.c b/arch/x86/kernel/livepatch.c
>> deleted file mode 100644
>> index 92fc1a5..0000000
>> --- a/arch/x86/kernel/livepatch.c
>> +++ /dev/null
>> @@ -1,70 +0,0 @@
>> -/*
>> - * livepatch.c - x86-specific Kernel Live Patching Core
>> - *
>> - * Copyright (C) 2014 Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> - * Copyright (C) 2014 SUSE
>> - *
>> - * This program is free software; you can redistribute it and/or
>> - * modify it under the terms of the GNU General Public License
>> - * as published by the Free Software Foundation; either version 2
>> - * of the License, or (at your option) any later version.
>> - *
>> - * This program is distributed in the hope that it will be useful,
>> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> - * GNU General Public License for more details.
>> - *
>> - * You should have received a copy of the GNU General Public License
>> - * along with this program; if not, see <http://www.gnu.org/licenses/>.
>> - */
>> -
>> -#include <linux/module.h>
>> -#include <linux/uaccess.h>
>> -#include <asm/elf.h>
>> -#include <asm/livepatch.h>
>> -
>> -/**
>> - * klp_write_module_reloc() - write a relocation in a module
>> - * @mod:	module in which the section to be modified is found
>> - * @type:	ELF relocation type (see asm/elf.h)
>> - * @loc:	address that the relocation should be written to
>> - * @value:	relocation value (sym address + addend)
>> - *
>> - * This function writes a relocation to the specified location for
>> - * a particular module.
>> - */
>> -int klp_write_module_reloc(struct module *mod, unsigned long type,
>> -			   unsigned long loc, unsigned long value)
>> -{
>> -	size_t size = 4;
>> -	unsigned long val;
>> -	unsigned long core = (unsigned long)mod->core_layout.base;
>> -	unsigned long core_size = mod->core_layout.size;
>> -
>> -	switch (type) {
>> -	case R_X86_64_NONE:
>> -		return 0;
>> -	case R_X86_64_64:
>> -		val = value;
>> -		size = 8;
>> -		break;
>> -	case R_X86_64_32:
>> -		val = (u32)value;
>> -		break;
>> -	case R_X86_64_32S:
>> -		val = (s32)value;
>> -		break;
>> -	case R_X86_64_PC32:
>> -		val = (u32)(value - loc);
>> -		break;
>> -	default:
>> -		/* unsupported relocation type */
>> -		return -EINVAL;
>> -	}
>> -
>> -	if (loc < core || loc >= core + core_size)
>> -		/* loc does not point to any symbol inside the module */
>> -		return -EINVAL;
>> -
>> -	return probe_kernel_write((void *)loc, &val, size);
>> -}
>> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
>> index a882865..2f12ce7 100644
>> --- a/include/linux/livepatch.h
>> +++ b/include/linux/livepatch.h
>> @@ -65,27 +65,8 @@ struct klp_func {
>>  };
>>
>>  /**
>> - * struct klp_reloc - relocation structure for live patching
>> - * @loc:	address where the relocation will be written
>> - * @sympos:	position in kallsyms to disambiguate symbols (optional)
>> - * @type:	ELF relocation type
>> - * @name:	name of the referenced symbol (for lookup/verification)
>> - * @addend:	offset from the referenced symbol
>> - * @external:	symbol is either exported or within the live patch module itself
>> - */
>> -struct klp_reloc {
>> -	unsigned long loc;
>> -	unsigned long sympos;
>> -	unsigned long type;
>> -	const char *name;
>> -	int addend;
>> -	int external;
>> -};
>> -
>> -/**
>>   * struct klp_object - kernel object structure for live patching
>>   * @name:	module name (or NULL for vmlinux)
>> - * @relocs:	relocation entries to be applied at load time
>>   * @funcs:	function entries for functions to be patched in the object
>>   * @kobj:	kobject for sysfs resources
>>   * @mod:	kernel module associated with the patched object
>> @@ -95,7 +76,6 @@ struct klp_reloc {
>>  struct klp_object {
>>  	/* external */
>>  	const char *name;
>> -	struct klp_reloc *relocs;
>>  	struct klp_func *funcs;
>>
>>  	/* internal */
>> @@ -123,6 +103,19 @@ struct klp_patch {
>>  	enum klp_state state;
>>  };
>>
>> +/*
>> + * Livepatch-specific symbols and relocation
>> + * sections are prefixed with a tag:
>> + * .klp.rel. for relocation sections
>> + * .klp.sym. for livepatch symbols
>> + */
>> +#define KLP_TAG_LEN 9
>> +/*
>> + * Livepatch-specific bits for specifying symbol
>> + * positions in the Elf_Sym st_other field
>> + */
>> +#define KLP_SYMPOS(o) (o >> 2) & 0xff
>> +
>
>Can st_value be used instead?  I think we ended up deciding that would
>be better:
>
>  https://lkml.kernel.org/g/20151210213328.GA6553-N0bYjD2NfQ6k4hzjq3hgyGTy53QMssKEsp+A89P3RPuQWHG76I6BsA@public.gmane.org
>
>Because:
>
>- st_value is easily viewable in readelf
>- st_other has some arch-specific uses
>
>And another reason not previously discussed:
>
>- st_other is an unsigned char, which limits sympos to values < 64

I originally wanted to encode the symbol position in st_value, but
I've discovered that since st_value is overwritten once the
symbol is (first) resolved, we no longer have the symbol position if we
need to resolve the symbols again (so we wouldn't be able to resolve
them). This could happen when we patch a module that loads and
unloads more than once for example.

I chose st_other since it isn't touched in s390x kernel code nor in
x86 kernel code (it does get used in the x86 userspace reloc tool in
arch/x86/tools, which is why I left the first two bits alone for
ELF_ST_VISIBILITY, and the rest had undefined usage). However this
isn't the best approach and I'm afraid of stepping on other arch's
toes in future patches. Perhaps there is another field where we can
stuff the sympos in? st_size for instance doesn't seem to be touched
anywhere in the module loader. I don't know if I'd want to stuff
sympos in the sym name, there's enough going on there..

Jessica
