From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] kernel, add panic_on_warn
Date: Thu, 30 Oct 2014 10:24:19 -0700
Message-ID: <54527443.6030007@zytor.com>
References: <1414688627-5298-1-git-send-email-prarit@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <1414688627-5298-1-git-send-email-prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/30/2014 10:03 AM, Prarit Bhargava wrote:
> There have been several times where I have had to rebuild a kernel to
> cause a panic when hitting a WARN() in the code in order to get a crash
> dump from a system.  Sometimes this is easy to do, other times (such as
> in the case of a remote admin) it is not trivial to send new images to the
> user.
> 
> A much easier method would be a switch to change the WARN() over to a
> panic.  This makes debugging easier in that I can now test the actual
> image the WARN() was seen on and I do not have to engage in remote
> debugging.
> 
> This patch adds a panic_on_warn kernel parameter and
> /proc/sys/kernel/panic_on_warn calls panic() in the warn_slowpath_common()
> path.  The function will still print out the location of the warning.
> 
> An example of the panic_on_warn output:
> 
> The first line below is from the WARN_ON() to output the WARN_ON()'s location.
> After that the panic() output is displayed.
> 

There is another very valid use for this: many operators would rather a
machine shuts down than being potentially compromised either
functionally or security-wise.

	-hpa
