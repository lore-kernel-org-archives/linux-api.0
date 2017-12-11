From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: pkeys: Support setting access rights for signal handlers
Date: Mon, 11 Dec 2017 08:13:12 -0800
Message-ID: <aa4d127f-0315-3ac9-3fdf-1f0a89cf60b8@intel.com>
References: <5fee976a-42d4-d469-7058-b78ad8897219@redhat.com>
 <c034f693-95d1-65b8-2031-b969c2771fed@intel.com>
 <5965d682-61b2-d7da-c4d7-c223aa396fab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <5965d682-61b2-d7da-c4d7-c223aa396fab@redhat.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Florian Weimer <fweimer@redhat.com>, linux-mm <linux-mm@kvack.org>, x86@kernel.org, linux-arch <linux-arch@vger.kernel.org>, linux-x86_64@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, Ram Pai <linuxram@us.ibm.com>
List-Id: linux-api@vger.kernel.org

On 12/09/2017 10:42 PM, Florian Weimer wrote:
>> My only nit with this is whether it is the *right* interface.  The 
>> signal vs. XSAVE state thing is pretty x86 specific and I doubt
>> that this will be the last feature that we encounter that needs
>> special signal behavior.
> 
> The interface is not specific to XSAVE.  To generic code, only the
> two signal mask manipulation functions are exposed.  And I expect
> that we're going to need that for other (non-x86) implementations
> because they will have the same issue because the signal handler
> behavior will be identical.

Let's check with the other implementation...

Ram, this is a question about the signal handler behavior on POWER.  I
thought you ended up having different behavior in signal handlers than x86.

In any case, I think the question still stands: Do we want this to be
pkeys-only, or build it so that it can be used for MPX and any future
XSAVE features that need non-init values when entering a signal handler.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
