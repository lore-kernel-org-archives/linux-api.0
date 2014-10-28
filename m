From: Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH V5] kernel, add panic_on_warn
Date: Tue, 28 Oct 2014 10:56:24 -0400
Message-ID: <544FAE98.6080901@akamai.com>
References: <1414499499-21952-1-git-send-email-prarit@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1414499499-21952-1-git-send-email-prarit@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Prarit Bhargava <prarit@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Fabian Frederick <fabf@skynet.be>, "vgoyal@redhat.com" <vgoyal@redhat.com>, "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kexec@lists.infradead.org" <kexec@lists.infradead.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 10/28/2014 08:31 AM, Prarit Bhargava wrote:
> There have been several times where I have had to rebuild a kernel to
> cause a panic when hitting a WARN() in the code in order to get a crash
> dump from a system.  Sometimes this is easy to do, other times (such as
> in the case of a remote admin) it is not trivial to send new images to the
> user.
> 

....

> diff --git a/kernel/sysctl_binary.c b/kernel/sysctl_binary.c
> index 9a4f750..c62d421 100644
> --- a/kernel/sysctl_binary.c
> +++ b/kernel/sysctl_binary.c
> @@ -137,6 +137,7 @@ static const struct bin_table bin_kern_table[] = {
>         { CTL_INT,      KERN_COMPAT_LOG,                "compat-log" },
>         { CTL_INT,      KERN_MAX_LOCK_DEPTH,            "max_lock_depth" },
>         { CTL_INT,      KERN_PANIC_ON_NMI,              "panic_on_unrecovered_nmi" },
> +       { CTL_INT,      KERN_BUG_ON_WARN,               "panic_on_warn" },
>         {}
>  };
> 


I think you meant KERN_PANIC_ON_WARN here.

Thanks,

-Jason


