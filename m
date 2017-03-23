From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v4 1/4] syscalls: Restore address limit after a syscall
Date: Thu, 23 Mar 2017 16:32:04 +0100
Message-ID: <20170323153204.4lxglq6jlvvxp6ev@pd.tnic>
References: <20170322203834.67556-1-thgarnie@google.com>
 <CALCETrV6K8iSfAwojMFyLrbb3CG2aF4k5hPWc7EDV4ErPDq64w@mail.gmail.com>
 <CAJcbSZGLAXmE_mFZMAZgioWExzm3A4vXBKLGJ7DZNAbJOcH8Zw@mail.gmail.com>
 <f0cf8766-4ee9-5386-5454-2301f429464c@zytor.com>
 <CAJcbSZEqeKVKbtUABzuhavxoH9KWCaVUBG3j5owAwyRhiw8Z7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJcbSZEqeKVKbtUABzuhavxoH9KWCaVUBG3j5owAwyRhiw8Z7g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Garnier <thgarnie@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, =?utf-8?B?UmVuw6k=?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 23, 2017 at 08:14:44AM -0700, Thomas Garnier wrote:
> Okay well then people are fine with a BUG_ON approach. I will do a
> next iteration tailored to that. I will also try to add the static
> inline suggestion from Peter.

Would it be possible, please, to refrain from top-posting when replying
on the ML?

You sometimes reply inline and after the text and sometimes at the top.
This subthread has both variants and it is really annoying to people
like me who try to follow the discussion.

Thanks.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
