From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH V4] kernel, add bug_on_warn
Date: Tue, 28 Oct 2014 05:16:36 -0700
Message-ID: <20141028121636.GC3274@tassilo.jf.intel.com>
References: <1414155207-29839-1-git-send-email-prarit@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1414155207-29839-1-git-send-email-prarit@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Fabian Frederick <fabf@skynet.be>, vgoyal@redhat.com, isimatu.yasuaki@jp.fujitsu.com, linux-doc@vger.kernel.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, jason.wessel@windriver.com
List-Id: linux-api@vger.kernel.org

On Fri, Oct 24, 2014 at 08:53:27AM -0400, Prarit Bhargava wrote:
> There have been several times where I have had to rebuild a kernel to
> cause a panic when hitting a WARN() in the code in order to get a crash
> dump from a system.  Sometimes this is easy to do, other times (such as
> in the case of a remote admin) it is not trivial to send new images to the
> user.
> 
> A much easier method would be a switch to change the WARN() over to a
> BUG().  This makes debugging easier in that I can now test the actual
> image the WARN() was seen on and I do not have to engage in remote
> debugging.

IMHO this would be better and far more generically done with kdb. 
You would need two things:

- Extend the break point command to run another command on a break point.
- Add a command line (or possibly /proc) option to execute some kdb commands at
kernel boot.

Then just set a break point on the warn function and execute magic sysrq c
from kdb.

-Andi
