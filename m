From: Markos Chandras <Markos.Chandras-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] MIPS,prctl: add PR_[GS]ET_FP_MODE prctl options for MIPS
Date: Fri, 16 Jan 2015 15:43:52 +0000
Message-ID: <54B931B8.5050903@imgtec.com>
References: <1420719457-690-1-git-send-email-paul.burton@imgtec.com> <54B519B6.5040604@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B519B6.5040604-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Burton <paul.burton-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
Cc: Matthew Fortune <matthew.fortune-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 01/13/2015 01:12 PM, Markos Chandras wrote:
> On 01/08/2015 12:17 PM, Paul Burton wrote:
>> Userland code may be built using an ABI which permits linking to objects
>> that have more restrictive floating point requirements. For example,
>> userland code may be built to target the O32 FPXX ABI. Such code may be
>> linked with other FPXX code, or code built for either one of the more
>> restrictive FP32 or FP64. When linking with more restrictive code, the
>> overall requirement of the process becomes that of the more restrictive
>> code. The kernel has no way to know in advance which mode the process
>> will need to be executed in, and indeed it may need to change during
>> execution. The dynamic loader is the only code which will know the
>> overall required mode, and so it needs to have a means to instruct the
>> kernel to switch the FP mode of the process.
>>
>> This patch introduces 2 new options to the prctl syscall which provide
>> such a capability. The FP mode of the process is represented as a
>> simple bitmask combining a number of mode bits mirroring those present
>> in the hardware. Userland can either retrieve the current FP mode of
>> the process:
>>
>>   mode = prctl(PR_GET_FP_MODE);
>> [...]
>> +int mips_set_process_fp_mode(struct task_struct *task, unsigned int value)
>> +{
>> +	const unsigned int known_bits = PR_FP_MODE_FR | PR_FP_MODE_FRE;
>> +	unsigned long switch_count;
>> +	struct task_struct *t;
>> +
>> +	/* Check the value is valid */
>> +	if (value & ~known_bits)
>> +		return -EOPNOTSUPP;
>> +
>> +	/* Avoid inadvertently triggering emulation */
>> +	if ((value & PR_FP_MODE_FR) && cpu_has_fpu &&
>> +	    !(current_cpu_data.fpu_id & MIPS_FPIR_F64))
>> +		return -EOPNOTSUPP;
>> +	if ((value & PR_FP_MODE_FRE) && !cpu_has_fre)
>> +		return -EOPNOTSUPP;
>> +

Hi Paul,

Do you think you can address this[1] suggestion by Matthew in this patch
since this hasn't been merged yet? Thanks

[1] http://www.linux-mips.org/archives/linux-mips/2015-01/msg00265.html

-- 
markos
