From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH V4] kernel, add bug_on_warn
Date: Tue, 28 Oct 2014 10:32:51 +0800
Message-ID: <20141028023251.GD3329@darkstar.nay.redhat.com>
References: <1414155207-29839-1-git-send-email-prarit@redhat.com>
 <544E8985.50203@akamai.com>
 <544E8BB8.8000707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <544E8BB8.8000707@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Prarit Bhargava <prarit@redhat.com>
Cc: Jason Baron <jbaron@akamai.com>, Andi Kleen <ak@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, kexec@lists.infradead.org, Rusty Russell <rusty@rustcorp.com.au>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Fabian Frederick <fabf@skynet.be>, isimatu.yasuaki@jp.fujitsu.com, "H. Peter Anvin" <hpa@zytor.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org, vgoyal@redhat.com
List-Id: linux-api@vger.kernel.org

> > Seems reasonable-I'm wondering why you just don't call panic() in this
> > case. The BUG() call at line '434' doesn't at anything since its just being
> > called from panic.c.
> 
> Hmm ... I didn't even think about that.
> 
> > 
> > So something like 'panic_on_warn' would seem to be more appropriate
> > in keeping with things like 'panic_on_oops' or 'panic_on_stackoverflow'.
> 
> I like it a lot better that way too :)  I'm changing it to panic_on_warn unless
> anyone has any strenuous objections.

I would vote for panic_on_warn, it will make more sense than bug_on_warn.

Thanks
Dave
