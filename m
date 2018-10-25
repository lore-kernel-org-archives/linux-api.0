From: Michael Sammler <msammler@mpi-sws.org>
Subject: Re: [PATCH] seccomp: Add pkru into seccomp_data
Date: Thu, 25 Oct 2018 10:39:17 +0200
Message-ID: <11a706bd-060f-41de-118b-bababfd83b3d@mpi-sws.org>
References: <20181024153523.10974-1-msammler@mpi-sws.org>
 <87zhv3nrr0.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <87zhv3nrr0.fsf@oldenburg.str.redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Florian Weimer <fweimer@redhat.com>
Cc: Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, linux-api@vger.kernel.org, Ram Pai <linuxram@us.ibm.com>, Andy Lutomirski <luto@amacapital.net>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

On 10/24/2018 08:06 PM, Florian Weimer wrote:

> * Michael Sammler:
>
>> Add the current value of the PKRU register to data available for
>> seccomp-bpf programs to work on. This allows filters based on the
>> currently enabled protection keys.
>> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
>> index 9efc0e73..e8b9ecfc 100644
>> --- a/include/uapi/linux/seccomp.h
>> +++ b/include/uapi/linux/seccomp.h
>> @@ -52,12 +52,16 @@
>>    * @instruction_pointer: at the time of the system call.
>>    * @args: up to 6 system call arguments always stored as 64-bit values
>>    *        regardless of the architecture.
>> + * @pkru: value of the pkru register
>> + * @reserved: pad the structure to a multiple of eight bytes
>>    */
>>   struct seccomp_data {
>>   	int nr;
>>   	__u32 arch;
>>   	__u64 instruction_pointer;
>>   	__u64 args[6];
>> +	__u32 pkru;
>> +	__u32 reserved;
>>   };
> This doesn't cover the POWER implementation.  Adding Cc:s.
>
> And I think the kernel shouldn't expose the number of protection keys in
> the ABI.
>
> Thanks,
> Florian
Thank you for the pointer about the POWER implementation. I am not 
familiar with POWER in general and its protection key feature at all. 
Would the AMR register be the correct register to expose here?

I understand your concern about exposing the number of protection keys 
in the ABI. One idea would be to state, that the pkru field (which 
should probably be renamed) contains an architecture specific value, 
which could then be the PKRU on x86 and AMR (or another register) on 
POWER. This new field should probably be extended to __u64 and the 
reserved field removed.

Another idea would be to not add a field in the seccomp_data structure, 
but instead provide a new BPF instruction, which reads the value of a 
specified protection key.

- Michael
