From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2] kernel, add bug_on_warn
Date: Mon, 03 Nov 2014 08:43:47 -0500
Message-ID: <54578693.1050401@redhat.com>
References: <1413910077-9464-1-git-send-email-prarit@redhat.com>
 <87bnp491b3.fsf@rustcorp.com.au> <54478367.7030505@redhat.com>
 <87ppd984qv.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <87ppd984qv.fsf-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Cc: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, hedi-sJ/iWh9BUns@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 10/30/2014 08:25 PM, Rusty Russell wrote:
> Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>> On 10/22/2014 12:27 AM, Rusty Russell wrote:
>>> Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>>>> There have been several times where I have had to rebuild a kernel to
>>>> cause a panic when hitting a WARN() in the code in order to get a crash
>>>> dump from a system.  Sometimes this is easy to do, other times (such as
>>>> in the case of a remote admin) it is not trivial to send new images to the
>>>> user.
>>>
>>> What about during early boot?
>>
>> Hi Rusty,
>>
>> I really don't have a use case for this in early boot.  The kernel boots, the
>> initramfs, and then we run whatever init (systemd in my case).  A systemd script
>> configures kexec for kdump and that point kdump is "armed".  Doing a bug_on_warn
>> before this will simply result in a panicked system.  I don't get any "new"
>> information FWIW as I get a stack trace, etc., in both the WARN() and BUG() cases.
>>
>>>
>>> I'd recommend you use core_param().  Less code, and can be set on
>>> commandline.

Yeah, I was just starting to do this and then I saw Hedi's comment about
disabling panic_on_warn during kdump to avoid a situation where the kdump kernel
bogus panics on a warn.

So that makes the setup function look like:

static int __init panic_on_warn_setup(char *s)
{
        /* Enabling this on a kdump kernel could cause a bogus panic. */
        if (!is_kdump_kernel())
                panic_on_warn = 1;
        return 0;
}
early_param("panic_on_warn", panic_on_warn_setup);

... so I dunno if core_param would work here :(.  It would have been nice if it did.

P.
