From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v8] kernel, add panic_on_warn
Date: Sat, 08 Nov 2014 08:29:21 -0500
Message-ID: <545E1AB1.9030001@redhat.com>
References: <1415187736-16242-1-git-send-email-prarit@redhat.com>
 <alpine.DEB.2.10.1411051357050.31575@chino.kir.corp.google.com>
 <545B733C.6080903@redhat.com>
 <alpine.DEB.2.10.1411061352440.1526@chino.kir.corp.google.com>
 <20141106220731.GA13590@redhat.com>
 <alpine.DEB.2.10.1411070214220.32405@chino.kir.corp.google.com>
 <545CA765.8010403@redhat.com>
 <alpine.DEB.2.10.1411071306370.12192@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <alpine.DEB.2.10.1411071306370.12192-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
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



On 11/07/2014 04:09 PM, David Rientjes wrote:
> On Fri, 7 Nov 2014, Prarit Bhargava wrote:
> 
>> There very much is.  Consider a thread that hits a WARN() and then panics.  Then
>> somewhere in the panic code the thread hits another WARN() ... and then panics
>> again.  Previously this would have caused the system to "finish" panick'ing.
>> Now it makes the system hang.
>>
> 
> Then we're back to square one which is what is obviously the intent of 
> your patch and the comment that goes along with it: 

My original reply pointed out that the comment was wrong.

we want to clear
> panic_on_warn once and not allow multiple panic().  

On _this_ thread.  The multiple panic across threads cannot occur.

So why not just add
> the necessary synchronization to make sure that happens when WARN() 
> happens on two cpus simultaneously?

See above.

P.

> 
