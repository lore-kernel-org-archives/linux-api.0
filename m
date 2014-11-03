From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] kernel, add panic_on_warn
Date: Mon, 3 Nov 2014 10:18:37 -0500
Message-ID: <20141103151837.GA22503@redhat.com>
References: <1414688627-5298-1-git-send-email-prarit@redhat.com>
 <20141031015843.GW9743@dangermouse.emea.sgi.com>
 <545783FA.4050508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <545783FA.4050508-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>, isimatu.yasuaki-+CUm20s59erQFUHtdCDX3A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 03, 2014 at 08:32:42AM -0500, Prarit Bhargava wrote:
> 
> 
> On 10/30/2014 09:58 PM, Hedi Berriche wrote:
> > On Thu, Oct 30, 2014 at 17:06 Prarit Bhargava wrote:
> > | There have been several times where I have had to rebuild a kernel to
> > | cause a panic when hitting a WARN() in the code in order to get a crash
> > | dump from a system.  Sometimes this is easy to do, other times (such as
> > | in the case of a remote admin) it is not trivial to send new images to the
> > | user.
> > | 
> > | A much easier method would be a switch to change the WARN() over to a
> > | panic.  This makes debugging easier in that I can now test the actual
> > | image the WARN() was seen on and I do not have to engage in remote
> > | debugging.
> > 
> > Do we want to leave it to usersspace[1] to ensure panic_on_warn is out
> > of the way in when the kdump kernel boots? or would a self-contained
> > approach be more preferable i.e. test whether we're a kdump kernel
> > before bothering with panic_on_warn?
> 
> Hmm ... this is a good point.  Vivek, do you have a preference?  I'm willing to
> code it either way.  I should be able to put in a is_kdump_kernel() check
> without any problems but I'm not sure if that is the right thing to do here.
> 

I think it will make sense to modify user space scripts to get rid of
panic_on_warn for kdump kernel.

Thanks
Vivek
