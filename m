From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v6] selftest: size: Add size test for Linux kernel
Date: Wed, 03 Dec 2014 17:50:11 -0700
Message-ID: <547FAFC3.40609@osg.samsung.com>
References: <547F598D.7030205@sonymobile.com> <20141204003653.GA5004@thin>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141204003653.GA5004@thin>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
Cc: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, "linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-embedded-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/03/2014 05:36 PM, Josh Triplett wrote:
> On Wed, Dec 03, 2014 at 10:42:21AM -0800, Tim Bird wrote:
>> This test shows the amount of memory used by the system.
>> Note that this is dependent on the user-space that is loaded
>> when this program runs.  Optimally, this program would be
>> run as the init program itself.
>>
>> The program is optimized for size itself, to avoid conflating
>> its own execution with that of the system software.
>> The code is compiled statically, with no stdlibs. On my x86_64 system,
>> this results in a statically linked binary of less than 5K.
>>
>> Signed-off-by: Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
> 
> v6 looks good to me.
> 
> Reviewed-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> 
> Should this go through the tinification tree or the selftests tree?
> 

Josh/Tim,

Thanks both. Yes v6 looks good. I will take this through kselftest
tree. I will apply this to kselftes fixes.

-- Shuah



-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
