From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v5 03/27] x86/fpu/xstate: Introduce XSAVES system states
Date: Wed, 17 Oct 2018 15:39:47 -0700
Message-ID: <32da559b-7958-60db-e328-f0eb316e668e@infradead.org>
References: <20181011151523.27101-1-yu-cheng.yu@intel.com>
 <20181011151523.27101-4-yu-cheng.yu@intel.com>
 <20181017104137.GE22535@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017104137.GE22535@zn.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>, Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@amacapital.net>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.amit@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Pa
List-Id: linux-api@vger.kernel.org

On 10/17/18 3:41 AM, Borislav Petkov wrote:

>> @@ -702,6 +703,7 @@ static int init_xstate_size(void)
>>   */
>>  static void fpu__init_disable_system_xstate(void)
>>  {
>> +	xfeatures_mask_all = 0;
>>  	xfeatures_mask_user = 0;
>>  	cr4_clear_bits(X86_CR4_OSXSAVE);
>>  	fpu__xstate_clear_all_cpu_caps();
>> @@ -717,6 +719,8 @@ void __init fpu__init_system_xstate(void)
>>  	static int on_boot_cpu __initdata = 1;
>>  	int err;
>>  	int i;
>> +	u64 cpu_user_xfeatures_mask;
>> +	u64 cpu_system_xfeatures_mask;
> 
> Please sort function local variables declaration in a reverse christmas
> tree order:
> 
> 	<type> longest_variable_name;
> 	<type> shorter_var_name;
> 	<type> even_shorter;
> 	<type> i;

Hi,

Would you mind explaining this request? (requirement?)
Other than to say that it is the preference of some maintainers,
please say Why it is preferred.

and since the <type>s above won't typically be the same length,
it's not for variable name alignment, right?

thanks,
-- 
~Randy
