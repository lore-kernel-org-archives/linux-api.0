From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH V4] kernel, add bug_on_warn
Date: Tue, 28 Oct 2014 08:29:00 -0400
Message-ID: <20141028122900.GA10632@redhat.com>
References: <1414155207-29839-1-git-send-email-prarit@redhat.com>
 <20141028121636.GC3274@tassilo.jf.intel.com>
 <544F8A78.9070008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <544F8A78.9070008@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Prarit Bhargava <prarit@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Fabian Frederick <fabf@skynet.be>, isimatu.yasuaki@jp.fujitsu.com, linux-doc@vger.kernel.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, jason.wessel@windriver.com
List-Id: linux-api@vger.kernel.org

On Tue, Oct 28, 2014 at 08:22:16AM -0400, Prarit Bhargava wrote:
> 
> 
> On 10/28/2014 08:16 AM, Andi Kleen wrote:
> > On Fri, Oct 24, 2014 at 08:53:27AM -0400, Prarit Bhargava wrote:
> >> There have been several times where I have had to rebuild a kernel to
> >> cause a panic when hitting a WARN() in the code in order to get a crash
> >> dump from a system.  Sometimes this is easy to do, other times (such as
> >> in the case of a remote admin) it is not trivial to send new images to the
> >> user.
> >>
> >> A much easier method would be a switch to change the WARN() over to a
> >> BUG().  This makes debugging easier in that I can now test the actual
> >> image the WARN() was seen on and I do not have to engage in remote
> >> debugging.
> > 
> > IMHO this would be better and far more generically done with kdb. 
> > You would need two things:
> > 
> > - Extend the break point command to run another command on a break point.
> > - Add a command line (or possibly /proc) option to execute some kdb commands at
> > kernel boot.
> 
> I suppose ... but that would mean I would have to explain to an end user the
> elaborate process of enabling kdb, inserting a break point, etc.  The whole
> purpose of this is to let an end user panic on WARN() easily.
> 
> Asking an end user to enable kdb is magnitudes worse than asking them to
> recompile a kernel.

Agreed. Asking a customer to setup and run kdb and put breakpoints is much
more pain than simply asking to reboot kernel with a command line option.

Thanks
Vivek
