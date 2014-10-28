From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4] kernel, add bug_on_warn
Date: Tue, 28 Oct 2014 09:19:00 -0400
Message-ID: <544F97C4.8000203@redhat.com>
References: <1414155207-29839-1-git-send-email-prarit@redhat.com>
 <20141028121636.GC3274@tassilo.jf.intel.com> <544F8A78.9070008@redhat.com>
 <20141028122900.GA10632@redhat.com>
 <20141028124425.GD3274@tassilo.jf.intel.com> <544F90B1.1070102@redhat.com>
 <20141028125630.GF3274@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20141028125630.GF3274-KWJ+5VKanrL29G5dvP0v1laTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, jason.wessel-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 10/28/2014 08:56 AM, Andi Kleen wrote:
>>> If you have a command line option to execute kdb commands you still
>>> would only have a command line option, just a slightly longer one.
>>>
>>> kdb="on, bp warn_slowpath_common sr c, go" 
>>
>> KDB is not on all kernels.  This would require me to go to great lengths to
> 
> Repeating incorrect statements doesn't suddenly make them correct.

It does when you're introducing unnecessary complexity here Andi.  You're not
listening to the original statement: I do not want to provide a modified kernel
to an end user for this simple situation anymore.

> 
> Assuming KDB is compiled in the only setup needed would be the line above.

That's a HUGE assumption.  It isn't and I'm still stuck in the same mess of
explaining how to recompile a kernel and/or providing a modified kernel to an
end user.  That isn't a good solution.

P.

> 
> -Andi
> 
