From: Jessica Yu <jeyu@redhat.com>
Subject: Re: livepatch: reuse module loader code to write relocations
Date: Mon, 21 Mar 2016 14:07:43 -0400
Message-ID: <20160321180742.GA12357@packer-debian-8-amd64.digitalocean.com>
References: <1458157628-8264-1-git-send-email-jeyu@redhat.com>
 <1458157628-8264-5-git-send-email-jeyu@redhat.com>
 <20160321163157.GG19401@pathway.suse.cz>
 <20160321164651.zautqklg7ng3jfbn@treble.redhat.com>
 <20160321173639.ooighgwwubuqv6le@treble.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160321173639.ooighgwwubuqv6le@treble.redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Petr Mladek <pmladek@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Jiri Kosina <jikos@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

+++ Josh Poimboeuf [21/03/16 12:36 -0500]:
>On Mon, Mar 21, 2016 at 11:46:51AM -0500, Josh Poimboeuf wrote:
>> On Mon, Mar 21, 2016 at 05:31:57PM +0100, Petr Mladek wrote:
>> > > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> > > index 780f00c..2aa20fa 100644
>> > > --- a/kernel/livepatch/core.c
>> > > +++ b/kernel/livepatch/core.c
>> > > +static int klp_resolve_symbols(Elf_Shdr *relasec, struct module *pmod)
>> > > +{
>> > > +	int i, cnt, vmlinux, ret;
>> > > +	struct klp_buf bufs = {0};
>> > > +	Elf_Rela *relas;
>> > > +	Elf_Sym *sym;
>> > > +	char *symname;
>> > > +	unsigned long sympos;
>> > > +
>> > > +	relas = (Elf_Rela *) relasec->sh_addr;
>> > > +	/* For each rela in this klp relocation section */
>> > > +	for (i = 0; i < relasec->sh_size / sizeof(Elf_Rela); i++) {
>> > > +		sym = pmod->core_kallsyms.symtab + ELF_R_SYM(relas[i].r_info);
>> > > +		if (sym->st_shndx != SHN_LIVEPATCH)
>> > > +			return -EINVAL;
>> > > +
>> > > +		klp_clear_buf(&bufs);
>> > > +
>> > > +		/* Format: .klp.sym.objname.symbol_name,sympos */
>> > > +		symname = pmod->core_kallsyms.strtab + sym->st_name;
>> > > +		cnt = sscanf(symname, ".klp.sym.%64[^.].%128[^,],%lu",
>> > > +			     bufs.objname, bufs.symname, &sympos);
>> >
>> > Note that MODULE_NAME_LEN even is not 64. It is defined by:
>> >
>> > #define MAX_PARAM_PREFIX_LEN (64 - sizeof(unsigned long))
>> >
>> > I strongly suggest to use the proposal from Josh.
>>
>> Hm, looks like my suggestion to use __stringify(MODULE_NAME_LEN) doesn't
>> work.  It results in the string "MODULE_NAME_LEN".  Which surprises me:
>> isn't is supposed to resolve the macro before applying the '#' operation
>> to it?
>
>Turns out I hadn't included module.h.  When I do so,
>__stringify(MODULE_NAME_LEN) becomes "(64 - sizeof(unsigned long))".
>Which is still not going to work :-/
>

Hm, we probably won't be able to make use of preprocessor tricks here,
since I don't think the preprocessor can even evaluate that expression
(esp. with that sizeof there). This might mean building the format
string at runtime, which may be more trouble than it's worth...

>> I was going to suggest another idea: hard-code it at 63 and then do
>> something like
>>
>>   BUILD_BUG_ON(MODULE_NAME_LEN != 64)
>>
>> But you're right... it's not even 64!
>>
>> Need to think on this some more...
>
>-- 
>Josh
