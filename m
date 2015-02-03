From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2] selftests/exec: Check if the syscall exists and bail
 if not
Date: Tue, 03 Feb 2015 08:32:43 -0700
Message-ID: <54D0EA1B.1000508@osg.samsung.com>
References: <1422935588-9973-1-git-send-email-mpe@ellerman.id.au> <CAHse=S9iLWK68mUSaVMEAwsaOEt4sTaM7XMBY-mv+ofk6sfT+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHse=S9iLWK68mUSaVMEAwsaOEt4sTaM7XMBY-mv+ofk6sfT+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 02/03/2015 12:58 AM, David Drysdale wrote:
> On Tue, Feb 3, 2015 at 3:53 AM, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
>> On systems which don't implement sys_execveat(), this test produces a
>> lot of output.
>>
>> Add a check at the beginning to see if the syscall is present, and if
>> not just note one error and return.
>>
>> When we run on a system that doesn't implement the syscall we will get
>> ENOSYS back from the kernel, so change the logic that handles
>> __NR_execveat not being defined to also use ENOSYS rather than -ENOSYS.
>>
>> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> 
> Acked-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thanks Michael, and David. I will queue this for 3.20

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
