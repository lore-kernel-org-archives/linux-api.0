From: Jessica Yu <jeyu@redhat.com>
Subject: Re: elf: add livepatch-specific elf constants
Date: Fri, 13 Nov 2015 01:49:51 -0500
Message-ID: <20151113064951.GD13513@packer-debian-8-amd64.digitalocean.com>
References: <1447130755-17383-1-git-send-email-jeyu@redhat.com>
 <1447130755-17383-2-git-send-email-jeyu@redhat.com>
 <20151112154506.GC4038@treble.hsd1.ky.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151112154506.GC4038@treble.hsd1.ky.comcast.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jikos@kernel.org>, Vojtech Pavlik <vojtech@suse.com>, Miroslav Benes <mbenes@suse.cz>, linux-api@vger.kernel.org, live-patching@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

+++ Josh Poimboeuf [12/11/15 09:45 -0600]:
>On Mon, Nov 09, 2015 at 11:45:51PM -0500, Jessica Yu wrote:
>> Add livepatch elf reloc section flag, livepatch symbol bind
>> and section index
>>
>> Signed-off-by: Jessica Yu <jeyu@redhat.com>
>> ---
>>  include/uapi/linux/elf.h | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
>> index 71e1d0e..967ce1b 100644
>> --- a/include/uapi/linux/elf.h
>> +++ b/include/uapi/linux/elf.h
>> @@ -118,6 +118,7 @@ typedef __s64	Elf64_Sxword;
>>  #define STB_LOCAL  0
>>  #define STB_GLOBAL 1
>>  #define STB_WEAK   2
>> +#define STB_LIVEPATCH_EXT 11
>>
>>  #define STT_NOTYPE  0
>>  #define STT_OBJECT  1
>> @@ -286,6 +287,7 @@ typedef struct elf64_phdr {
>>  #define SHF_ALLOC	0x2
>>  #define SHF_EXECINSTR	0x4
>>  #define SHF_MASKPROC	0xf0000000
>> +#define SHF_RELA_LIVEPATCH  0x4000000
>
>Writing the value with leading zeros (0x04000000) would it more
>readable.
>
>Also the OS-specific range mask (SHF_MASKOS) is 0x0ff00000.  Any reason
>you went with 0x04000000 as opposed to the first value in the range
>(0x00100000)?  I don't see anybody else using that value.

I don't have any particular reason, I think I just picked any value
and ran with it. I'll just change it to the first value in the range
since that makes more sense.

>>  /* special section indexes */
>>  #define SHN_UNDEF	0
>> @@ -295,6 +297,7 @@ typedef struct elf64_phdr {
>>  #define SHN_ABS		0xfff1
>>  #define SHN_COMMON	0xfff2
>>  #define SHN_HIRESERVE	0xffff
>> +#define SHN_LIVEPATCH 0xff21
>
>Similar question here, why not use 0xff20 (SHN_LOOS)?
>
>-- 
>Josh
