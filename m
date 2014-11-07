From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v8] kernel, add panic_on_warn
Date: Fri, 7 Nov 2014 02:15:46 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1411070214220.32405@chino.kir.corp.google.com>
References: <1415187736-16242-1-git-send-email-prarit@redhat.com> <alpine.DEB.2.10.1411051357050.31575@chino.kir.corp.google.com> <545B733C.6080903@redhat.com> <alpine.DEB.2.10.1411061352440.1526@chino.kir.corp.google.com>
 <20141106220731.GA13590@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20141106220731.GA13590@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Fabian Frederick <fabf@skynet.be>, isimatu.yasuaki@jp.fujitsu.com, jbaron@akamai.com, linux-doc@vger.kernel.org, kexec@lists.infradead.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 6 Nov 2014, Vivek Goyal wrote:

> On Thu, Nov 06, 2014 at 01:57:36PM -0800, David Rientjes wrote:
> 
> [..]
> > You see that doing
> > 
> > 	if (panic_on_warn) {
> > 		panic_on_warn = 0;
> > 		panic(...);
> > 	}
> > 
> > is racy, I hope.  If two threads WARN() at the same time, then there's 
> > nothing preventing a double panic() because WARN() itself is not 
> > serialized against anything.  So both the current comment and your 
> > suggested revision comment are bogus.
> 
> panic() is serialized on panic_lock. So I guess it is fine to hit WARN()
> on multiple cpus. Do you see an issue there?
> 

No issue at all, what's completely mysterious is the panic_on_warn = 0 and 
the completely bogus comment that says "prevent further WARN()s from 
panicking the system" when that's racy.  There's no need to clear 
panic_on_warn at all.
