From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8] kernel, add panic_on_warn
Date: Fri, 07 Nov 2014 06:05:09 -0500
Message-ID: <545CA765.8010403@redhat.com>
References: <1415187736-16242-1-git-send-email-prarit@redhat.com>
 <alpine.DEB.2.10.1411051357050.31575@chino.kir.corp.google.com>
 <545B733C.6080903@redhat.com>
 <alpine.DEB.2.10.1411061352440.1526@chino.kir.corp.google.com>
 <20141106220731.GA13590@redhat.com>
 <alpine.DEB.2.10.1411070214220.32405@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1411070214220.32405-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On 11/07/2014 05:15 AM, David Rientjes wrote:
> On Thu, 6 Nov 2014, Vivek Goyal wrote:
> 
>> On Thu, Nov 06, 2014 at 01:57:36PM -0800, David Rientjes wrote:
>>
>> [..]
>>> You see that doing
>>>
>>> 	if (panic_on_warn) {
>>> 		panic_on_warn = 0;
>>> 		panic(...);
>>> 	}
>>>
>>> is racy, I hope.  If two threads WARN() at the same time, then there's 
>>> nothing preventing a double panic() because WARN() itself is not 
>>> serialized against anything.  So both the current comment and your 
>>> suggested revision comment are bogus.
>>
>> panic() is serialized on panic_lock. So I guess it is fine to hit WARN()
>> on multiple cpus. Do you see an issue there?
>>
> 
> No issue at all, what's completely mysterious is the panic_on_warn = 0 and 
> the completely bogus comment that says "prevent further WARN()s from 
> panicking the system" when that's racy.  There's no need to clear 
> panic_on_warn at all.

There very much is.  Consider a thread that hits a WARN() and then panics.  Then
somewhere in the panic code the thread hits another WARN() ... and then panics
again.  Previously this would have caused the system to "finish" panick'ing.
Now it makes the system hang.

P.
> 
