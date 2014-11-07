From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v8] kernel, add panic_on_warn
Date: Fri, 7 Nov 2014 13:09:40 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1411071306370.12192@chino.kir.corp.google.com>
References: <1415187736-16242-1-git-send-email-prarit@redhat.com> <alpine.DEB.2.10.1411051357050.31575@chino.kir.corp.google.com> <545B733C.6080903@redhat.com> <alpine.DEB.2.10.1411061352440.1526@chino.kir.corp.google.com> <20141106220731.GA13590@redhat.com>
 <alpine.DEB.2.10.1411070214220.32405@chino.kir.corp.google.com> <545CA765.8010403@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <545CA765.8010403@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Prarit Bhargava <prarit@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Fabian Frederick <fabf@skynet.be>, isimatu.yasuaki@jp.fujitsu.com, jbaron@akamai.com, linux-doc@vger.kernel.org, kexec@lists.infradead.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 7 Nov 2014, Prarit Bhargava wrote:

> There very much is.  Consider a thread that hits a WARN() and then panics.  Then
> somewhere in the panic code the thread hits another WARN() ... and then panics
> again.  Previously this would have caused the system to "finish" panick'ing.
> Now it makes the system hang.
> 

Then we're back to square one which is what is obviously the intent of 
your patch and the comment that goes along with it: we want to clear 
panic_on_warn once and not allow multiple panic().  So why not just add 
the necessary synchronization to make sure that happens when WARN() 
happens on two cpus simultaneously?
