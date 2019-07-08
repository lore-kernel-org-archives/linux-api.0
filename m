From: shuah <shuah@kernel.org>
Subject: Re: [PATCH for 5.2] rseq/selftests: Fix Thumb mode build failure on
 arm32
Date: Mon, 8 Jul 2019 12:10:18 -0600
Message-ID: <bd970db6-e230-007c-8645-88866e6b3faf@kernel.org>
References: <20190630135613.19897-1-mathieu.desnoyers@efficios.com>
 <1154710388.12906.1562608719838.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1154710388.12906.1562608719838.JavaMail.zimbra@efficios.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Will Deacon <will.deacon@arm.com>, Linus Torvalds <torvalds@linux-foundation.org>, stable <stable@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Joel Fernandes <joelaf@google.com>, Catalin Marinas <catalin.marinas@arm.com>, Dave Watson <davejwatson@fb.com>, Andi Kleen <andi@firstfloor.org>, linux-kselftest <linux-kselftest@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Russell King <linux@arm.linux.org.uk>, Michael Kerrisk <mtk.manpages@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Paul Turner <pjt@google.com>, Boqun Feng <boqun.feng@gmail.com>, Josh Triplett <josh@joshtriplett.org>, rostedt <rostedt@goodmis.org>, Ben Maurer <bmaurer@fb.com>, linux-api <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On 7/8/19 11:58 AM, Mathieu Desnoyers wrote:
> ----- On Jun 30, 2019, at 9:56 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:
> 
>> Using ".arm .inst" for the arm signature introduces build issues for
>> programs compiled in Thumb mode because the assembler stays in the
>> arm mode for the rest of the inline assembly. Revert to using a ".word"
>> to express the signature as data instead.
>>
>> The choice of signature is a valid trap instruction on arm32 little
>> endian, where both code and data are little endian.
>>
>> ARMv6+ big endian (BE8) generates mixed endianness code vs data:
>> little-endian code and big-endian data. The data value of the signature
>> needs to have its byte order reversed to generate the trap instruction.
>>
>> Prior to ARMv6, -mbig-endian generates big-endian code and data
>> (which match), so the endianness of the data representation of the
>> signature should not be reversed. However, the choice between BE32
>> and BE8 is done by the linker, so we cannot know whether code and
>> data endianness will be mixed before the linker is invoked. So rather
>> than try to play tricks with the linker, the rseq signature is simply
>> data (not a trap instruction) prior to ARMv6 on big endian. This is
>> why the signature is expressed as data (.word) rather than as
>> instruction (.inst) in assembler.
>>
>> Because a ".word" is used to emit the signature, it will be interpreted
>> as a literal pool by a disassembler, not as an actual instruction.
>> Considering that the signature is not meant to be executed except in
>> scenarios where the program execution is completely bogus, this should
>> not be an issue.
> 
> Now that 5.2 is out before this patch has been merged, can we please
> integrate this patch through the kernel selftests or ARM tree so it
> can be merged into the stable 5.2 branch ?
> 

I will apply it to selftests and send it for 5.3-rc1 and mark it for
stable.

thanks,
-- Shuah
