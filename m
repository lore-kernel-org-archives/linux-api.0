From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH V4] kernel, add bug_on_warn
Date: Tue, 28 Oct 2014 05:59:27 -0700
Message-ID: <20141028125927.GG3274@tassilo.jf.intel.com>
References: <1414155207-29839-1-git-send-email-prarit@redhat.com>
 <20141028121636.GC3274@tassilo.jf.intel.com>
 <544F8A78.9070008@redhat.com>
 <20141028122900.GA10632@redhat.com>
 <20141028124425.GD3274@tassilo.jf.intel.com>
 <20141028125534.GC10632@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141028125534.GC10632@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Fabian Frederick <fabf@skynet.be>, isimatu.yasuaki@jp.fujitsu.com, linux-doc@vger.kernel.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, jason.wessel@windriver.com
List-Id: linux-api@vger.kernel.org

> > kdb="on, bp warn_slowpath_common sr c, go" 
> 
> So does it already work or proposal is to make something like this work
> with kdb?

It does not work today, the missing pieces are: 

- extending kdb= to execute a list of kdb commands
- extending bp to define a list of commands to execute

> 
> What about the case of enabling it post boot and using a /sys file for 
> that.

This would be another patch, add a sysfs file to run a list of kdb commands.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
