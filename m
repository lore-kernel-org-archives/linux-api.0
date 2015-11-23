From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH] tools, testing, add test for intel_pstate driver
Date: Mon, 23 Nov 2015 13:34:41 -0700
Message-ID: <56537861.2080601@osg.samsung.com>
References: <1447866288-8125-1-git-send-email-prarit@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447866288-8125-1-git-send-email-prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/18/2015 10:04 AM, Prarit Bhargava wrote:
> This test used the cpupower utility to set the cpu frequency from the
> maximum turbo value to the minimum supported value in steps of 100 MHz.
> 
> The results are displayed in a table which indicate the "Target" state,
> or the requested frequency in MHz, the Actual frequency, as read from
> /proc/cpuinfo, the difference between the Target and Actual frequencies,
> and the value of MSR 0x199 (MSR_IA32_PERF_CTL) which indicates what
> pstate the cpu is in, and the value of
> /sys/devices/system/cpu/intel_pstate/max_perf_pct X maximum turbo state
> 
> Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---

Thanks. Applied to linux-kselftest next for 4.5-rc1

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
