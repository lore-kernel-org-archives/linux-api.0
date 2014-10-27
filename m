From: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4] kernel, add bug_on_warn
Date: Mon, 27 Oct 2014 14:05:57 -0400
Message-ID: <544E8985.50203@akamai.com>
References: <1414155207-29839-1-git-send-email-prarit@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414155207-29839-1-git-send-email-prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Prarit,

On 10/24/2014 08:53 AM, Prarit Bhargava wrote:
> There have been several times where I have had to rebuild a kernel to
> cause a panic when hitting a WARN() in the code in order to get a crash
> dump from a system.  Sometimes this is easy to do, other times (such as
> in the case of a remote admin) it is not trivial to send new images to the
> user.panic_on_stackoverflow
>
> A much easier method would be a switch to change the WARN() over to a
> BUG().  This makes debugging easier in that I can now test the actual
> image the WARN() was seen on and I do not have to engage in remote
> debugging.
>
> This patch adds a bug_on_warn kernel parameter and
> /proc/sys/kernel/bug_on_warn calls BUG() in the warn_slowpath_common()
> path.  The function will still print out the location of the warning.
>
> An example of the bug_on_warn output:
>
> The first line below is from the WARN_ON() to output the WARN_ON()'s location.
> After that the new BUG() call is displayed.
>
>  WARNING: CPU: 27 PID: 3204 at
> /home/rhel7/redhat/debug/dummy-module/dummy-module.c:25 init_dummy+0x28/0x30
> [dummy_module]()
>  bug_on_warn set, calling BUG()...
>  ------------[ cut here ]------------
>  kernel BUG at kernel/panic.c:434!

Seems reasonable-I'm wondering why you just don't call panic() in this
case. The BUG() call at line '434' doesn't at anything since its just being
called from panic.c.

So something like 'panic_on_warn' would seem to be more appropriate
in keeping with things like 'panic_on_oops' or 'panic_on_stackoverflow'.

Thanks,

-Jason
